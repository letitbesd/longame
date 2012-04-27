package com.xingcloud.statistics
{
	import elex.socialize.ElexProxy;
	import elex.socialize.mode.GTrackEventMode;
	import elex.socialize.mode.XCTrackEventMode;
	import elex.socialize.requests.GTrackEventRequest;
	import elex.socialize.requests.XCTrackEventRequest;

	public class StatisticsManager
	{
		private static var _instance:StatisticsManager;

		public static function get instance():StatisticsManager
		{
			if (!_instance)
			{
				_instance=new StatisticsManager(new inlock);
			}
			return _instance;
		}

		public function StatisticsManager(lock:inlock)
		{
		}

		public function trackEventByGA(GtrackMode:GTrackEventMode, onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GTrackEventRequest(GtrackMode, onSuccess, onFail));
		}

		public function trackEventByXC(XCtrackMode:XCTrackEventMode, onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new XCTrackEventRequest(XCtrackMode, onSuccess, onFail));
		}
	}
}

internal class inlock
{
}
