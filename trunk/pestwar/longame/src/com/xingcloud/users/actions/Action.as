package com.xingcloud.users.actions
{
	import com.longame.commands.net.Remoting;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	
	use namespace xingcloud_internal;
    
	public class Action implements IAction
	{
		private static var nextID:int=-1;

		protected var _dependency:IAction;
		protected var _validated:Boolean=false;
		protected var _params:Object;
		protected var _name:String;
		protected var _id:String;
		
		protected var _success:Function;
		protected var _fail:Function;
		
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
		final public function execute():void
		{
			if(this.validate()) {
				if(Config.localMode){
					this.simulateInLocal();
				}else{
					this.sendToServer();
				}
			}
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
				this.doWhenSuccess(data);
			}else{
				doWhenFail(data);
			}
		}
		protected function doWhenFail(data:Object):void
		{
			if(_fail!=null) _fail(data);
			this.showFailMessage(((data is String)?String(data):data.message));
		}
		protected function showFailMessage(msg:String):void
		{
			Logger.error(this,"doWhenFail",name+" executed error: "+msg);
		}
		protected function doWhenSuccess(data:Object):void
		{
			if(_success!=null) _success(data);
		}
	}
}