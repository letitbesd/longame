package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.mode.GTrackEventMode;
	public class GTrackEventRequest extends AbstractElexRequest
	{
		public function GTrackEventRequest(trackEventMode:GTrackEventMode,resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=trackEventMode;
			this._resultListener=resultListener;
			this._method=MethodEnum.TRACK_EVENT_BYGG;
			this._failListener=failListener;
		}
	}
}