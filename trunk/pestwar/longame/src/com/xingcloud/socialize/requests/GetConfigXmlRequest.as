package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetConfigXmlRequest extends AbstractElexRequest
	{
		public function GetConfigXmlRequest(resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_CONFIG
			this._failListener=failListener;
		}
	}
}