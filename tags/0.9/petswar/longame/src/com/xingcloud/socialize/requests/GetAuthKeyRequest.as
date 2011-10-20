package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetAuthKeyRequest extends AbstractElexRequest
	{
		public function GetAuthKeyRequest(resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_AUTH_KEY;
			this._failListener=failListener;
		}
	}
}