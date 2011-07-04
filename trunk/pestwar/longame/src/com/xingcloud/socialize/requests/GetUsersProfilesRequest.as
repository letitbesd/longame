package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class GetUsersProfilesRequest extends AbstractElexRequest
	{
		public function GetUsersProfilesRequest(uids:Array,resultListener:Function, failListener:Function=null)
		{
			this._params=uids;
			this._resultListener=resultListener;
			this._method=MethodEnum.GET_USERS_PROFILES_REQUEST;
			this._failListener=failListener;
		}
	}
}