package com.xingcloud.services
{
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.event.ServiceEvent;
	import com.xingcloud.event.XingCloudEvent;
	import com.xingcloud.model.users.AbstractUserProfile;
	import com.xingcloud.net.connector.Connector;
	import com.xingcloud.net.connector.MessageResult;
	import com.xingcloud.tasks.SimpleTask;
	import com.xingcloud.tasks.Task;
	import com.xingcloud.tasks.TaskEvent;

	/**
	 * 平台登陆服务，并在登陆成功后获取登陆用户的UserProfile
	 *
	 */
	public class PlatformLoginService extends Service
	{
		public function PlatformLoginService(onSuccess:Function=null, onFail:Function=null)
		{
			super(onSuccess, onFail);

		}

		private var _task:SimpleTask;
		private var _loginState:String;
		private var _loginCount:int;
		private var _userprofile:AbstractUserProfile;

		override public function get executor():Task
		{
			if (!_task)
			{
				_task=new SimpleTask();
				_task.addExecute(doLogin, null, this);
			}
			return _task;
		}

		/**
		 *用户档案，在登陆成功的事件派发后方可取得
		 * @return 登陆用户的档案
		 *
		 */
		public function get userprofile():AbstractUserProfile
		{
			return _userprofile;
		}

		private function doLogin():void
		{
			_loginState="login";
			_loginCount++;
			var connector:Connector=new XingCloud.defaultConnector(Config.PLATFORM_LOGIN_SERVICE,
				{},
				XingCloud.needAuth);
			connector.addEventListener(TaskEvent.TASK_COMPLETE, loginSuccessHandler);
			connector.addEventListener(TaskEvent.TASK_ERROR, loginFailHandler);
			connector.execute();
		}

		private function doRegister():void
		{
			_loginState="register";
			var connector:Connector=new XingCloud.defaultConnector(Config.PLATFORM_REGISTER_SERVICE,
				{userInfo: {}},
				XingCloud.needAuth);
			connector.addEventListener(TaskEvent.TASK_COMPLETE, loginSuccessHandler);
			connector.addEventListener(TaskEvent.TASK_ERROR, loginFailHandler);
			connector.execute();
		}

		private function loginFailHandler(event:TaskEvent):void
		{
			_result=event.target.data;
			if (_onFail != null)
				_onFail(this);
			ServiceManager.instance.dispatchEvent(new ServiceEvent(ServiceEvent.LOGIN_ERROR, this));
			_task.taskError();
		}

		private function loginSuccessHandler(event:TaskEvent):void
		{
			var result:MessageResult=(event.task as Connector).data;
			if (result.data)
			{
				_result=result;
				XingCloud.uid=result.data.uid;
				_userprofile=new XingCloud.profileClass() as AbstractUserProfile;
				_userprofile.parseFromObject(result.data);
				if (_onSuccess != null)
					_onSuccess(this);
				ServiceManager.instance.dispatchEvent(new ServiceEvent(ServiceEvent.LOGIN_SUCCESS, this));
				_task.taskComplete();
			}
			else
			{
				if (_loginState == "login")
				{
					if (_loginCount < 3)
					{
						doLogin();
					}
					else
					{
						doRegister();
					}
				}
				else
				{
					_result=result;
					if (_onFail != null)
						_onFail(this);
					ServiceManager.instance.dispatchEvent(new ServiceEvent(ServiceEvent.LOGIN_ERROR, this));
					_task.taskError();
				}
			}
		}
	}
}
