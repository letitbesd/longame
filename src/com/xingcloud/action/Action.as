package com.xingcloud.action
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.AMFConnecter;
	import com.longame.display.BusyCursor;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	
	import org.osflash.signals.Signal;

	/**
	 * Action基类，用于创建相应的动作逻辑和后台进行通信完成相应操作。
	 */
	public class Action extends Command //implements IPackableRequest
	{
		public static const LOAD_USER:String="LoadUser";
		public static const LOAD_ITMES:String="LoadItems";
		/**
		 * 定义一个一般的action
		 * @param params  传到后台的参数
		 * */
		public function Action(params:Object=null,success:Function=null,fail:Function=null,name:String=null)
		{
			this._name=name;
			this._params=params;
			if(this._params==null) this._params={};
			this._params.action=this.name;
			trace(JSON.stringify(this._params));
			data={name: name, params: params}
			_success=success;
			_fail=fail;
			super();
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
		override public function get name():String
		{
			if (_name==null)
				_name=Reflection.tinyClassName(this);
			return _name;
		}
		/**
		 * 本地模拟action数据,子类覆盖
		 * **/
		protected function simulateInLocal(localData:*=null):void
		{
			ProcessManager.callLater(this.doWhenSuccess,[localData]);
		}
		override protected function doExecute():void
		{
			super.doExecute();
			if(Config.localMode){
				this.simulateInLocal();
			}else{
				BusyCursor.show();
				var amf:AMFConnecter=new AMFConnecter("ActionCenter.execute",this.params);
				amf.onSuccess=this.onActionBack;
				amf.onFail=this.onActionError;
				amf.execute();
			}
		}
		/**
		 * 处理成功后回调函数，需覆盖编写具体逻辑
		 * @param result
		 *
		 */
		private function onActionBack(result:Object):void
		{
			data=result.data;
			if(result.success){
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
			}else{
				this.doWhenFail(result.msg);
			}
		}

		/**
		 * 处理失败后回调函数，需覆盖编写具体逻辑
		 * @param result
		 *
		 */
		private function onActionError(result:Object):void
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
		
		protected function doWhenFail(data:Object):void
		{
			if(_fail!=null) _fail(data);
			var msg:String=(data is String)?String(data):data.message;
			this.showFailMessage(msg);
			this.notifyError(msg);
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
			this.complete();
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
	}
}
