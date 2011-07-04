package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetAppFriendsProfilesRequest extends AbstractElexRequest
	{
		public function GetAppFriendsProfilesRequest(resultListener:Function, failListener:Function=null)
		{
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_APP_FRIENDS_PROFILES_REQUEST;
			this._failListener=failListener;
		}
	}
}