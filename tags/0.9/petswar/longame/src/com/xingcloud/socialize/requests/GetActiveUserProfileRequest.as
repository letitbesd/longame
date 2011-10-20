package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.ElexProxy;
	import com.xingcloud.socialize.MethodEnum;
	
	public class  GetActiveUserProfileRequest extends AbstractElexRequest
	{
		public function GetActiveUserProfileRequest(resultListener:Function, failListener:Function=null)
		{
			_method=MethodEnum.GET_ACTIVE_USER_PROFILE_REQUEST;
			_params=ElexProxy.instance.proxySession.userId;
			_resultListener=resultListener;
			_failListener=failListener;
		}
	}
}