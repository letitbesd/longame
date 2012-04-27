package com.xingcloud.action
{
	import com.longame.display.BusyCursor;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.net.IPackableRequest;
	import com.xingcloud.util.Reflection;
	
	import org.osflash.signals.Signal;

	/**
	 * Action基类，用于创建相应的动作逻辑和后台进行通信完成相应操作。
	 *
	 */
	public class Action implements IPackableRequest
	{
		/**
		 * 定义一个一般的action
		 * @param params  传到后台的参数
		 * @param name action的名称，如果不设置此参数，则名称默认为此Action类名，如果后台Action进行的分层，Action不在默认的
		 * 根路径下，则需要设置此参数为Action从其根目录开始完整的子路径，如shop.BuyAction
		 * */
		public function Action(params:Object=null,success:Function=null,fail:Function=null,name:String=null)
		{
			this._params=params;
			_name=name;
			_success=success;
			_fail=fail;
		}

		protected var _params:Object;
		protected var _name:String;

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
			if (!_name)
				_name=Reflection.tinyClassName(this);
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
		/**
		 * 本地模拟action数据,子类覆盖
		 * **/
		protected function simulateInLocal(localData:*=null):void
		{
			ProcessManager.callLater(this.doWhenSuccess,[localData]);
		}
		public function execute(immediately:Boolean=true):Boolean
		{
			if(this.validate()) {
				if(Config.localMode){
					this.simulateInLocal();
				}else{
					this.sendToServer(immediately);
				}
				return true;
			}
			return false;
		}
		public function handleDataBack(result:Object):void
		{
			if (result.code == 200)
			{
				onSuccess(result);
			}
			else
			{
				onFail(result);
			}
		}

		public function get data():Object
		{
			return {name: name, params: params};
		}

		/**
		 * 处理成功后回调函数，需覆盖编写具体逻辑
		 * @param result
		 *
		 */
		private function onSuccess(data:Object):void
		{
			data=data.data;
			try{
				//如果有任务完成，发布之
				if(data.quest){
					Action.onQuestStep.dispatch(data.quest);
				}
				//如果有奖励，发布之
				if(data.awards){
					for each(var award:Object in data.awards){
						this.awardToUser(award);
					}
					Action.onGetAward.dispatch(data.awards);
				}
			}catch(e:Error){
				
			}
			this.doWhenSuccess(data);
		}

		/**
		 * 处理失败后回调函数，需覆盖编写具体逻辑
		 * @param result
		 *
		 */
		private function onFail(result:Object):void
		{
			this.doWhenFail(result);
		}
		
		/*******************************************************************************************************************/
		public static var onComplete:Signal=new Signal(Action,Object);
		public static var onError:Signal=new Signal(Action);
		//当action触发某个任务完成某一步时,{id:任务id,step:完成的步骤,isCompleted:整个任务是否完成}
		public static var onQuestStep:Signal=new Signal(Object);
		//当某个行为触发奖励时，发布之
		public static var onGetAward:Signal=new Signal(Array);
		
		protected var _success:Function;
		protected var _fail:Function;
		
		protected function sendToServer(immediately:Boolean):void
		{
			ActionManager.instance.addAction(this);
			if(immediately) {
				ActionManager.instance.send();
				BusyCursor.show();
			}
		}
		
		protected function doWhenFail(data:Object):void
		{
			if(_fail!=null) _fail(data);
			this.showFailMessage(((data is String)?String(data):data.message));
			this._onError.dispatch(this);
			Action.onError.dispatch(this);
			BusyCursor.hide();
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
			BusyCursor.hide();
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
		protected var _onComplete:Signal=new Signal(Action,Object);
		protected var _onError:Signal=new Signal(Action);
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
