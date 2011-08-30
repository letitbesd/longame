package com.xingcloud.services
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.utils.Debug;
	import com.longame.commands.net.INetEntry;
	import com.longame.commands.net.Remoting;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.xingcloud_internal;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	use namespace xingcloud_internal;
	
	public class StatusManager extends EventDispatcher
	{
		private static var _serviceStatus:Object;
		private static var _callBack:Function;
		private static var _isReady:Boolean;//文件状态是否已经请求
		public function StatusManager()
		{
			super();
		}
		/**
		 *初始化状态管理器，获取状态和系统时间 
		 * @param readyCallback 获取成功后调用一个无参数的回调函数
		 */		
		xingcloud_internal static function init(readyCallback:Function):void
		{
			_callBack=readyCallback;
			var status:Remoting=new Remoting("status?lang="+Config.languageType,null,Remoting.GET, Config.getConfig("gateway"),false);
			status.onSuccess=onGetStatus;
			status.onFail=onStatusFail;
			status.execute();
		}
		/**
		 *获取网络加载项的状态信息 
		 * @param entry 加载项条目
		 * @return  返回状态信息
		 * 
		 */		
		public static function getStatus(entry:INetEntry):String
		{
			if(_serviceStatus&&(_serviceStatus.data[entry.uri])&&(_serviceStatus.data[entry.uri][entry.name]))
				return _serviceStatus.data[entry.uri][entry.name].timestamp;
			else
				return "";
		}
		/**
		 * 状态信息是否请求完毕
		 * 
		 */		
		public static function get statusReady():Boolean
		{
			return _isReady;
		}
		//获取成功
		private static function onGetStatus(result:Object):void
		{
			_isReady=true;
			_serviceStatus= result;
			if(_serviceStatus&&_serviceStatus.code!=200)
			{
				_serviceStatus=null;
				Debug.error("Get status failure!->request error"+_serviceStatus.code);
			}
			if(_serviceStatus)
			{
				Config.systemTime=Number(_serviceStatus.data.server_time)*1000;
			}
			_callBack();
		}
		//获取失败
		private static function onStatusFail(fault:String):void
		{
			_isReady=true;
			Debug.error("Get status failure!->network error");
			_callBack();
		}
	}
}