
package com.xingcloud.socialize
{
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.socialize.mode.FeedObject;
	import com.xingcloud.socialize.mode.GTrackEventMode;
	import com.xingcloud.socialize.mode.IUserInfo;
	import com.xingcloud.socialize.mode.RequestResponder;
	import com.xingcloud.socialize.mode.UserInfo;
	import com.xingcloud.socialize.mode.XCTrackEventMode;
	import com.xingcloud.socialize.requests.*;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Security;

	use namespace xingcloud_internal;
	
	public class SocialManager extends EventDispatcher
	{
		public static const SOCIAL_READY:String="socail_ready";

		private static var _instance:SocialManager;
		private var baseConfig:XML;
		private var _userInfo:IUserInfo;
		private var _friendsList:Vector.<IUserInfo>;
		private var _numReady:int;
		
		public function SocialManager(lock:inlock)
		{
		}

		public static function get instance():SocialManager
		{
			if (!_instance)
			{
				_instance=new SocialManager(new inlock);
			}
			return _instance;
		}
		
		public function init(autoLoad:Boolean=true):void
		{
			_numReady=1;
			callbackNum=0;
			if (autoLoad)
			{
				_numReady+=2;
				getUserInfo(onUserInfoSuccess, onUserInfoError);
				getAppFriendsInfo(onFriendsSuccess, onFriendsError);
			
			}
			ElexProxy.instance.sendRequest(new GetConfigXmlRequest(getConfigCallBack, getConfigError));
		}
		private var callbackNum:int;
		private function getConfigCallBack(res:RequestResponder):void
		{
			callbackNum++;
			try
			{
				var conf:XML=new XML(res.data.toString());
				baseConfig=conf;
			}
			catch (e:Error)
			{
				baseConfig=null;
			}
			finally
			{
				if(callbackNum==_numReady)
					_instance.dispatchEvent(new Event(SOCIAL_READY));
			}
		}

		private function getConfigError(res:RequestResponder):void
		{
			callbackNum++;
			baseConfig=null;
			if(callbackNum==_numReady)
				_instance.dispatchEvent(new Event(SOCIAL_READY));
		}

		private function onUserInfoSuccess(res:RequestResponder):void
		{
			callbackNum++;
			_userInfo=res.data as UserInfo;
			if(_userInfo&&XingCloud.checkPlugIn(XingCloud.USERPROFILE_CLASS))
			{
				XingCloud.userprofile.username=_userInfo.userName;
				XingCloud.userprofile.uid=_userInfo.userId;
				XingCloud.userprofile.gender=_userInfo.gender;
				XingCloud.userprofile.imageUrl=_userInfo.headerImgUrl;
			}
			if(callbackNum==_numReady)
				_instance.dispatchEvent(new Event(SOCIAL_READY));
		}

		private function onUserInfoError(res:RequestResponder):void
		{
			callbackNum++;
			if(callbackNum==_numReady)
				_instance.dispatchEvent(new Event(SOCIAL_READY));
		}

		private function onFriendsSuccess(res:RequestResponder):void
		{
			callbackNum++;
			while (res.data.length != 0)
			{
				_friendsList.push(res.data.pop());
			}
			if(callbackNum==_numReady)
				_instance.dispatchEvent(new Event(SOCIAL_READY));
		}

		private function onFriendsError(res:RequestResponder):void
		{
			callbackNum++;
			if(callbackNum==_numReady)
				_instance.dispatchEvent(new Event(SOCIAL_READY));
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
		public function postMessage(uid:String, title:String, msg:String, onSuccess:Function, onFail:Function, templateId:String="1"):void
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
		public function getUid(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetUidRequest(onSuccess, onFail));
		}

		public function getSnsType(onSuccess:Function, onFail:Function):void
		{
			ElexProxy.instance.sendRequest(new GetSnsTypeRequest(onSuccess, onFail));
		}

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

		public function get userInfo():IUserInfo
		{
			return _userInfo;
		}
		public function get friendsList():Vector.<IUserInfo>
		{
			return _friendsList;
		}
	}
}

internal class inlock
{
}