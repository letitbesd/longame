package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.mode.XCTrackEventMode;
	
	public class XCTrackEventRequest extends AbstractElexRequest
	{
		public function XCTrackEventRequest(trackEventMode:XCTrackEventMode,resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=trackEventMode;
			this._resultListener=resultListener;
			this._method=MethodEnum.TRACK_EVENT_BYGG;
			this._failListener=failListener;
		}
	}
}