package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.mode.IframeMode;
	
	public class ShowIframeRequest extends AbstractElexRequest
	{
		public function ShowIframeRequest(iframe:IframeMode,resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=iframe;
			this._resultListener=resultListener;
			this._method=MethodEnum.SHOW_IFRAME;
			this._failListener=failListener;
		}
	}
}