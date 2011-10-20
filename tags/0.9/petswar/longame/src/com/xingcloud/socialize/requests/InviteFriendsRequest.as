package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class InviteFriendsRequest extends AbstractElexRequest
	{
		public function InviteFriendsRequest(resultListener:Function, failListener:Function=null)
		{
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.INVITE_FRIENDS;
			this._failListener=failListener;
		}
	}
}