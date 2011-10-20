package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetUidRequest extends AbstractElexRequest
	{
		public function GetUidRequest(resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_UID;
			this._failListener=failListener;
		}
	}
}