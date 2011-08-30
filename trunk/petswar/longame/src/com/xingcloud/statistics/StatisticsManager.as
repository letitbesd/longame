package com.xingcloud.statistics
{
	import com.xingcloud.socialize.ElexProxy;
	import com.xingcloud.socialize.mode.GTrackEventMode;
	import com.xingcloud.socialize.mode.XCTrackEventMode;
	import com.xingcloud.socialize.requests.GTrackEventRequest;
	import com.xingcloud.socialize.requests.XCTrackEventRequest;

	public class StatisticsManager
	{
		private static var _instance:StatisticsManager;
		public function StatisticsManager(lock:inlock)
		{
		}
		public static function get instance():StatisticsManager
		{
			if (!_instance)
			{
				_instance=new StatisticsManager(new inlock);
			}
			return _instance;
		}
		public function trackEventByGA(GtrackMode:GTrackEventMode,onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GTrackEventRequest(GtrackMode, onSuccess, onFail));
		}
		
		public function trackEventByXC(XCtrackMode:XCTrackEventMode,onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new XCTrackEventRequest(XCtrackMode, onSuccess, onFail));
		}
	}
}
internal class inlock
{
}