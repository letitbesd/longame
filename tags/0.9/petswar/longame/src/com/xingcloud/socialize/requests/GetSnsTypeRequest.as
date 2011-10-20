package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetSnsTypeRequest extends AbstractElexRequest
	{
		public function GetSnsTypeRequest(resultListener:Function, failListener:Function=null)
		{
			super();
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_SNS_TYPE;
			this._failListener=failListener;
		}
	}
}