package com.xingcloud.core
{
	import flash.events.Event;

	public class XingCloudEvent extends Event
	{
		/**
		 * 社交平台对接好了
		 */
		public static const SOCIAL_INITED:String="social_inited";
		/**
		 *引擎初始化完毕，包括社交平台对接好，初始资源加载完毕
		 */
		public static const ENGINE_INITED:String="engine_inited";
		/**
		 * userprofile登录获取基本信息成功
		 */
		public static const PROFILE_LOADED:String="profile_loaded";
		/**
		 * userprofile登录失败
		 */
		public static const LOGIN_ERROR:String="login_error";
		/**
		 * userprofile的某组items加载完毕
		 */
		public static const ITEMS_LOADED:String="items_loaded";
		/**
		 *物品加载失败
		 */
		public static const ITEMS_LOADED_ERROR:String="items_loaded_error";
		/**
		 * userProfile开始track一个action
		 */
		public static const ACTION_TRACKING:String="action_tracking";
		/**
		 *服务版本获取完毕，可以开始加载
		 * */
		public static const SERVICE_STATUS_READY:String="service_status_ready";
		
		public function XingCloudEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=data;
			super(type, bubbles, cancelable);
		}
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}
		override public function clone():Event
		{
			return new XingCloudEvent(this.type,this.data,this.bubbles,this.cancelable);
		}
	}
}