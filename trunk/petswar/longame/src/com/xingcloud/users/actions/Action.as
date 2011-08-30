package com.xingcloud.users.actions
{
	import com.longame.commands.net.Remoting;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	
	import org.osflash.signals.Signal;
	
	use namespace xingcloud_internal;
    
	public class Action implements IAction
	{
		public static var onComplete:Signal=new Signal(Action,Object);
		public static var onError:Signal=new Signal(Action);
		//当action触发某个任务完成某一步时,{id:任务id,step:完成的步骤,isCompleted:整个任务是否完成}
		public static var onQuestStep:Signal=new Signal(Object);
		//当某个行为触发奖励时，发布之
		public static var onGetAward:Signal=new Signal(Object);
		
		private static var nextID:int=-1;
		
		protected var _dependency:IAction;
		protected var _validated:Boolean=false;
		protected var _params:Object;
		protected var _name:String;
		protected var _id:String;
		
		protected var _success:Function;
		protected var _fail:Function;
		
		protected var _onComplete:Signal=new Signal(Action,Object);
		protected var _onError:Signal=new Signal(Action);
		
		/**
		 * 定义一个一般的action
		 * @param params  传到后台的参数
		 * */
		public function Action(params:Object=null,success:Function=null,fail:Function=null)
		{
			this._params=params;
			nextID++;
			_success=success;
			_fail=fail;
			_name=Reflection.tinyClassName(this);
		}
		/**
		 *获取参数 
		 * @return 
		 * 
		 */		
		public function get params():Object
		{
			return this._params;
		}
		/**
		 *action名称 
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return _name;
		}
		/**
		 *合法性验证 ,to be inherited
		 * @return 
		 * 
		 */		
		public function validate():Boolean
		{
			return true;
		}
		final public function execute():Boolean
		{
			if(this.validate()) {
				if(Config.localMode){
					this.simulateInLocal();
				}else{
					this.sendToServer();
				}
				return true;
			}
			return false;
		}
		/**
		 * 本地模拟action数据,子类覆盖
		 * **/
		protected function simulateInLocal(localData:*=null):void
		{
			ProcessManager.callLater(this.doWhenSuccess,[localData]);
		}
		/**
		 * 发送到服务器
		 * */
		protected function sendToServer():void
		{
			var msg:Object={id:_id , info:Config.appInfo , data: [{name:name , params:params}] };
			var amf:Remoting=new Remoting(Config.ACTION_SERVICE,msg,XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			amf.onSuccess=onSuccess;
			amf.onFail=doWhenFail;
			amf.execute();
		}
		private function onSuccess(data:Object):void
		{
			data=data.results[0].result;
			if(data.code==200){
				data=data.data;
				//如果有任务完成，发布之
				if(data.quest){
					Action.onQuestStep.dispatch(data.quest);
				}
				//如果有奖励，发布之
				if(data.award){
					this.awardToUser(data.award);
					Action.onGetAward.dispatch(data.award);
				}
				this.doWhenSuccess(data);
			}else{
				doWhenFail(data);
			}
		}
		protected function doWhenFail(data:Object):void
		{
			if(_fail!=null) _fail(data);
			this.showFailMessage(((data is String)?String(data):data.message));
			this._onError.dispatch(this);
			Action.onError.dispatch(this);
		}
		protected function showFailMessage(msg:String):void
		{
			Logger.error(this,"doWhenFail",name+" executed error: "+msg);
			//to be inherited
		}
		protected function doWhenSuccess(data:Object):void
		{
			if(_success!=null) _success(data);
			this._onComplete.dispatch(this,data);
			Action.onComplete.dispatch(this,data);
		}
		protected function awardToUser(award:Object):void
		{
			//如果奖励有新物品，则添加之
			if(award.newItem){
				//添加新物品
				XingCloud.userprofile.addItemFromObject(award.newItem);
				//可能需要显示一下，事件??
				delete award.newItem;
			}
			//改变属性值
			for(var prop:String in award){
				XingCloud.userprofile[prop]+=Number(award[prop]);
			}
		}
		
		public function get onComplete():Signal
		{
			return _onComplete;
		}
		public function get onError():Signal
		{
			return _onError;
		}
	}
}