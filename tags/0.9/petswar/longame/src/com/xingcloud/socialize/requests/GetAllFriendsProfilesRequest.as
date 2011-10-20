package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetAllFriendsProfilesRequest extends AbstractElexRequest
	{
		public function GetAllFriendsProfilesRequest(resultListener:Function, failListener:Function=null)
		{
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_ALL_FRIENDS_PROFILES_REQUEST;
			this._failListener=failListener;
		}
	}
}