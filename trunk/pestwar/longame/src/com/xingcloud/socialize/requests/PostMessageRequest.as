package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.mode.FeedObject;
	
	public class PostMessageRequest extends AbstractElexRequest
	{
		public function PostMessageRequest(_messageId:String,_feedObj:FeedObject,resultListener:Function, failListener:Function=null)
		{
			this._params={templateId:_messageId,messageObj:_feedObj};
			this._resultListener=resultListener;
			this._method=MethodEnum.POST_MESSAGE_REQUEST;
			this._failListener=failListener;
		}
	}
}