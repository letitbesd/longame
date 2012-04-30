
package com.xingcloud.socialize
{
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.tasks.SimpleTask;
	import elex.socialize.ElexProxy;
	import elex.socialize.mode.FeedObject;
	import elex.socialize.mode.RequestResponder;
	import elex.socialize.requests.GetActiveUserProfileRequest;
	import elex.socialize.requests.GetAllFriendsProfilesRequest;
	import elex.socialize.requests.GetAppFriendsProfilesRequest;
	import elex.socialize.requests.GetConfigXmlRequest;
	import elex.socialize.requests.GetUsersProfilesRequest;
	import elex.socialize.requests.InviteFriendsRequest;
	import elex.socialize.requests.PostFeedRequest;
	import elex.socialize.requests.PostMessageRequest;
	import elex.socialize.requests.ReloadGameRequest;
	import elex.socialize.requests.ShowPaymentRequest;

	use namespace xingcloud_internal;

	public class SocialManager
	{
		private static var _instance:SocialManager;

		public static function get instance():SocialManager
		{
			if (!_instance)
			{
				_instance=new SocialManager(new inlock);
			}
			return _instance;
		}

		public function SocialManager(lock:inlock)
		{
			executor=new SimpleTask();
			ElexProxy.instance.init(XingCloud.stage);
			executor.addExecute(getGameConfig, [getConfigCallBack, getConfigError], this);
		}

		public var executor:SimpleTask;

		private var baseConfig:XML;

		public function getGameConfig(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetConfigXmlRequest(onSuccess, onFail));
		}

		/**
		 * 获取所有好友信息
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function getAllFriendsInfo(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetAllFriendsProfilesRequest(onSuccess, onFail));
		}

		/**
		 * 获取当前游戏好友信息
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function getAppFriendsInfo(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetAppFriendsProfilesRequest(onSuccess, onFail));
		}

		/**
		 * "获取自己的信息
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function getUserInfo(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetActiveUserProfileRequest(onSuccess, onFail));
		}

		/**
		 * 获取多个用户的信息
		 * @param uidList 查询用户的uid的列表
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function getUsersInfo(uidList:Array, onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetUsersProfilesRequest(uidList, onSuccess, onFail));
		}

		/**
		 *
		 * @param fo feed信息
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 * @param templateId feed模版id
		 *
		 */
		public function sendFeed(fo:FeedObject, onSuccess:Function, onFail:Function, templateId:String="1"):void
		{
			ElexProxy.instance.sendRequest(new PostFeedRequest(templateId, fo, onSuccess, onFail));
		}

		/**
		 * 显示支付页面
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function showPayments(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new ShowPaymentRequest(onSuccess, onFail));
		}

		/**
		 *邀请朋友
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
		public function inviteFriends(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new InviteFriendsRequest(onSuccess, onFail));
		}

		/**
		 *发送消息
		 * @param uid 接受方的uid
		 * @param title 消息标题
		 * @param msg 消息内容
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 * @param templateId 模版id
		 *
		 */
		public function postMessage(uid:String,
			title:String,
			msg:String,
			onSuccess:Function,
			onFail:Function,
			templateId:String="1"):void
		{
			var feedObj:FeedObject=new FeedObject([title], [msg], uid);
			ElexProxy.instance.sendRequest(new PostMessageRequest(templateId, feedObj, onSuccess, onFail));
		}

		/**
		 *获取用户uid
		 * @param onSuccess(result:RequestResponder)
		 * @param onFail(error:RequestResponder)
		 *
		 */
//		public function getUid(onSuccess:Function, onFail:Function):void
//		{
//			ElexProxy.instance.sendRequest(new GetUidRequest(onSuccess, onFail));
//		}
//
//		public function getSnsType(onSuccess:Function, onFail:Function):void
//		{
//			ElexProxy.instance.sendRequest(new GetSnsTypeRequest(onSuccess, onFail));
//		}

		public function reLoadGame():void
		{
			ElexProxy.instance.sendRequest(new ReloadGameRequest());
		}

		/**
		 *配置信息
		 * @return
		 *
		 */
		public function get Config():XML
		{
			return baseConfig;
		}

		public function get sns():String
		{
			return ElexProxy.instance.sns;
		}

		public function get uid():String
		{
			return ElexProxy.instance.uid;
		}

		private function getConfigCallBack(res:RequestResponder):void
		{
			try
			{
				var conf:XML=new XML(res.data.toString());
				baseConfig=conf;
			}
			catch (e:Error)
			{
				baseConfig=null;
			}
			executor.taskComplete();
		}

		private function getConfigError(res:RequestResponder):void
		{
			baseConfig=null;
			executor.taskError();
		}
	}
}

internal class inlock
{
}
