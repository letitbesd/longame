package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.mode.FeedObject;
	
	public class PostFeedRequest extends AbstractElexRequest
	{
		public function PostFeedRequest(_feedId:String,_feedObj:FeedObject,resultListener:Function, failListener:Function=null)
		{
			this._params={templateId:_feedId,feedObj:_feedObj};
			this._resultListener=resultListener;
			this._method=MethodEnum.POST_FEED_REQUEST;
			this._failListener=failListener;
		}
	}
}