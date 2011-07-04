package com.xingcloud.core
{
	import com.adobe.utils.Debug;
	import com.longame.commands.base.Command;
	import com.longame.commands.base.SerialCommand;
	import com.longame.commands.net.Remoting;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import com.xingcloud.language.*;
	import com.xingcloud.services.Service;
	import com.xingcloud.services.ServiceManager;
	import com.xingcloud.services.StatusManager;
	import com.xingcloud.socialize.*;
	import com.xingcloud.statistics.*;
	import com.xingcloud.users.AbstractUserProfile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;

	/**
	 *  <code>XingCloud</code> 类是行云SDK的核心，用于初始化和功能配置工作，同时提供了必要的功能接口。
	 */
	public class XingCloud
	{
		public static var onReady:Signal=new Signal();
		/**
		 * UserProfile模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */		
		public static const USERPROFILE_CLASS:String="model.user.UserProfile";
		/**
		 *多语言模块，作为函数<code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */		
		public static const LANGUAGE_CLASS:String="com.xingcloud.language.LanguageManager";
		
		/**
		 * 当前用户的UserProfile信息
		 * @see  com.xingcloud.users.AbstractUserProfile
		 */		
		public static var userprofile:AbstractUserProfile;
		/**
		 *由GDP提供的社交接口，用于提供SNS的相关特性，如好友列表等。
		 * @see  com.xingcloud.socialize.SocialManager
		 */		
		public static var social:SocialManager;
		/**
		 * 由GDP提供的统计接口，用于跟踪和统计数据和用户操作信息。
		 *@see com.xingcloud.statistics.StatisticsManager 
		 */		
		public static var statistics:StatisticsManager;

		/**
		 * 是否在和后台的交互中使用安全验证。
		 * @see com.xingcloud.tasks.net.Remoting
		 * @default true
		 */
		public static var needAuth:Boolean=true;
		/**
		 *是否在登录成功后自动加载用户物品的详情。
		 * @see com.xingcloud.items.owned.ItemsCollection#load()
		 * @default true
		 */
		public static var autoLoadItems:Boolean=true;
		/**
		 * 是否在初始化完成后自动登录用户。
		 * @see com.xingcloud.users.AbstractUserProfile#login()
		 * @default true
		 */
		public static var autoLogin:Boolean=true;
		/**
		 * 是否使用AuditChange模式和服务器进行交互。
		 *  @see com.xingcloud.users.auditchange.AuditChange
		 * @see com.xingcloud.users.auditchange.AuditChangeManager
		 *@default true
		 */
		public static var changeMode:Boolean=true;
		/**
		 *是否自动加载基本社交信息，包括用户信息和好友列表。
		 * @see com.xingcloud.socialize.SocialManager
		 *@default true
		 */	
		public static var autoLoadSocialInfo:Boolean=true;
		/**
		 * 默认远程通信方法，可以使用Remoting.POST和Remoting.AMF
		 *@default Remoting.AMF
		 */		
		public static var defaultRemoteMethod:String=Remoting.AMF;
		
		private static var _app:Sprite;
		private static var _configPath:String=null;

		public function XingCloud()
		{
		}
		/**
		 * 初始化行云，包括获取获取游戏基本信息和加载所需的服务。行云初始化完成后将会派发<code>ENGINE_INITED</code>事件。
		 * 多语言功能，GDP接口，统计接口，UserProfile均在事件派发之后才可以使用。
		 * @param app 程序根容器
		 * @param configPath 外部自定义配置文件url
		 */		
		public static function init(app:Sprite,configPath:String=null):void
		{
			Security.allowDomain("*");
			_app=app;
			_configPath=configPath;
			ElexProxy.instance.init(new ProxySession(_app.stage.loaderInfo.parameters["proxy_id"], _app.stage.loaderInfo.parameters["userId"]));
			social=SocialManager.instance;
			social.addEventListener(SocialManager.SOCIAL_READY, onSocialReady);
			social.init(autoLoadSocialInfo);
			statistics=StatisticsManager.instance;
		}

		private static function onSocialReady(e:Event):void
		{
			Config.init(SocialManager.instance.Config);
			if (!Config.getConfig("gateway") && !_configPath)
			{
				throw new Error("Basic confingration is needed ! Please check the gdp or get from conf.xml");
			}
			if (_configPath)
			{
				ResourceManager.instance.load(_configPath,onConfLoaded,onConfLoadedError);
			}
			else
			{
				StatusManager.init(initLoad);
			}
		}
		private static function onConfLoaded(r:Resource):void
		{
			Config.init(r.content);
			StatusManager.init(initLoad);
		}
		private static function onConfLoadedError(r:Resource):void
		{
			throw new Error("Load configuration error");
		}
		private static var initTask:SerialCommand;

		private static function initLoad():void
		{
//			onReady.dispatch();
			onResourceLoaded();
//			initTask=new SerialCommand();
//			initTask.onComplete.add(onResourceLoaded);
//			initTask.onError.add(onResourceLoadError);
//			initTask.onTotalProgress.add(oninitLoadProgress);
//			if (checkPlugIn(USERPROFILE))
//			{
//				ServiceManager.instance.addService(new Service(Service.ITEMS));
//			}
//			if (checkPlugIn(LANGUAGE))
//			{
//				ServiceManager.instance.addService(new Service(Service.LANGUAGE));
//				ServiceManager.instance.addService(new Service(Service.STYLE));
//				ServiceManager.instance.addService(new Service(Service.FONTS));
//			}
//			initTask.enqueue(ServiceManager.instance);
//			initTask.execute();
		}
		public static function get stage():Stage
		{
			if(_app==null) return null;
			return _app.stage;
		}
		public static function get inited():Boolean
		{
			return _app!=null;
		}
//		private static var _initProcess:int;

		/**
		 *获取初始化进度
		 * @return 返回一个整数p,加载进度为p/100
		 *
		 */
//		public static function get InitProcess():int
//		{
//			return _initProcess;
//		}
		/**
		 * 检测模块是否接入
		 * @param Module 定义在XingCloud中的模块名称
		 * @return 模块是否接入
		 * */
		xingcloud_internal static function checkPlugIn(Module:String):Boolean
		{
			try
			{
				getDefinitionByName(Module);
				return true;
			}
			catch (e:Error)
			{
				return false;
			}
			return false;
		}
		protected static function onResourceLoaded(cmd:Command=null):void
		{
			if (checkPlugIn(USERPROFILE_CLASS))
			{
				userprofile=new(getDefinitionByName(USERPROFILE_CLASS))(true);
				userprofile.addEventListener(XingCloudEvent.PROFILE_LOADED, onUserStatusEvent); //是否载入了用户信息
				userprofile.addEventListener(XingCloudEvent.LOGIN_ERROR, onUserStatusEvent);
				userprofile.addEventListener(XingCloudEvent.ITEMS_LOADED, onUserStatusEvent); //监听物品是否载入
				userprofile.addEventListener(XingCloudEvent.ITEMS_LOADED_ERROR, onUserStatusEvent);
			}
		}
		private static function onUserStatusEvent(e:XingCloudEvent):void
		{
//			dispatchEvent(e.clone());
			if(XingCloud.autoLoadItems){
				if(e.type==XingCloudEvent.ITEMS_LOADED){
					onReady.dispatch();
				}
			}else{
				if(e.type==XingCloudEvent.PROFILE_LOADED){
					onReady.dispatch();
				}
			}

		}

//		protected static function onResourceLoadError(cmd:Command,err:String):void
//		{
//			throw new Error("Init Progress " + cmd + ":" + err);
//		}
		
//		protected static function oninitLoadProgress(cmd:Command):void
//		{
//			_initProcess=initTask.completed * 100 / initTask.total;
//		}
	}
}