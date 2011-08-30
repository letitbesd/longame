package com.xingcloud.core
{
	import com.adobe.utils.Debug;
	import com.longame.commands.net.Remoting;
	import com.xingcloud.users.AbstractUserProfile;
	import com.xingcloud.users.auditchange.AuditChangeManager;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getTimer;

	/**
	 * Some SecretData don't want to be seen easily.
	 * 此处修改通信加密认证Key
	 * */
	[SecretData(secret_key="#secret_key#")]
	/**
	 * 配合GDP,包含游戏所有基本配置。其中与GDP约定的几个参数为：
	 * 1.webbase：游戏主文件的存放目录；
	 * 2.gateway: 后台gateway地址；
	 * 3.lang:语言；
	 * 4.help:    游戏帮助页面地址；
	 * */
	public class Config
	{
		/**
		 * action 模式服务地址
		 * */
		public static const ACTION_SERVICE:String="action.action.execute";
		/**
		 *auditechange 模式服务地址 
		 */		
		public static const AUDIT_SERVICE:String="change.change.apply";
		/**
		 *UserProfile服务
		 * */
		public static var USERPROFILE_SERVICE:String="user.user.get";
		/**
		 *用户登录服务
		 * */
		public static var USERLOGIN_SERVICE:String="user.user.login";
		/**
		 *用户注册
		 * */
		public static var USERREGISTER_SERVICE:String="user.user.register";
		/**
		 * 获取物品服务
		 */		
		public static var ITEMSLOAD_SERVICE:String="user.user.getItems";
		/**
		 *教程服务 
		 */		
		public static var TUTORIAL_GET_SERVICE:String="tutorial.tutorial.get";
		/**
		 *教程完成 
		 */		
		public static var TUTORIAL_COMPLETE_SERVICE:String="tutorial.tutorial.complete";
		/**
		 *教程进入下一步 
		 */		
		public static var TUTORIAL_STEP_SERVICE:String="tutorial.tutorial.step";
		/**
		 *多语言的文字服务 
		 */		
		public static var LANGUAGE_SERVICE:String="locale.text.getAll";
		/**
		 * 多语言的样式服务
		 */		
		public static var STYLE_SERVICE:String="locale.style.get";
		/**
		 *多语言的字体服务 
		 */		
		public static var FONTS_SERVICE:String="locale.font.get";
		/**
		 * 物品数据服务
		 */		
		public static var ITEMSDB_SERVICE:String="item.itemSpec.xml";
		/**
		 *任务服务 
		 */		
		public static var QUEST_GET_SERVICE:String="quest.quest.get";
		/**
		 *任务接受 
		 */		
		public static var QUEST_ACCEPT_SERVICE:String="quest.quest.accept";
		/**
		 *任务提交 
		 */		
		public static var QUEST_SUBMMIT_SERVICE:String="quest.quest.submit";

		private static var local:Dictionary=new Dictionary();
		private static var consumerKey:String="#consumer_key#";
		private static var authMethod:String="HMAC-SHA1";
		/**
		 * 对配置进行初始化
		 * @param config 自定义配置文件加载的路径
		 */
		public static function init(config:XML=null):void
		{
			//对需要保密的使用 ‘SecretData’元标签的数据解析
			var metadatas:XMLList=describeType(Config).factory.metadata.(@name == "SecretData").arg;
			var numSecrets:int=metadatas.length();
			for (var i:int=0; i < numSecrets; i++)
			{
				setConfig(metadatas[i].@key, String(metadatas[i].@value));
			}
			setConfig("consumerKey",consumerKey);
			setConfig("authMethod",authMethod);
			if (config != null)
			{
				xingcloud_internal::parseFromXML(config);
			}
			//初始化gateway
			var gateway:String=getConfig("gateway");
			if (gateway == null)
				Debug.error("A gateway must be set to communite with backend!");
			//初始化ActionManager
			AuditChangeManager.init(Config.AUDIT_SERVICE);
		}

		/**
		 *获取配置
		 * @param name 参数名
		 */
		public static function getConfig(name:String):*
		{
			var str:*;

			if (XingCloud.stage)
			{
				str=XingCloud.stage.loaderInfo.parameters[name];
			}
			if (str)
				return str;
			var s:*=Config.local[name];
			if (s is Function)
			{
				return s();
			}
			return s;
		}

		/**
		 *设置参数
		 * @param name 参数名
		 * @param value 参数值
		 *
		 */
		public static function setConfig(name:String, value:*):void
		{
			Config.local[name]=value;
		}

		/**
		 * 游戏放置的根目录
		 * */
		public static function get webbase():String
		{
			var _webbase:String=Config.getConfig("webbase");
			if (!_webbase)
				_webbase="";
				//如果没有以“/”结尾，加上，防止拼凑全路径时出错
				if ((_webbase.length) && (_webbase.lastIndexOf("/") != 0))
					_webbase+="/";
			return _webbase;
		}

		/**
		 * amf调用gateway地址
		 * */
		public static function get amfGateway():String
		{
			var url:String=Config.getConfig("gateway");
			if(url.lastIndexOf("/") != 0)
			{
				url+="/";
			}
			return url+"amf";
		}

		/**
		 * rest调用gateway地址
		 * */
		public static function get restGateway():String
		{
			var url:String=Config.getConfig("gateway");
			if(url.lastIndexOf("/") != 0)
			{
				url+="/";
			}
			return url+ "rest";
		}

		/**
		 *file调用gateway地址,应用于服务文件调用
		 * */
		public static function get fileGateway():String
		{
			var url:String=Config.getConfig("gateway");
			if(url.lastIndexOf("/") != 0)
			{
				url+="/";
			}
			return url+ "file";
		}

		/**
		 * 当前语言版本类型，如"cn","en"
		 * */
		public static function get languageType():String
		{
			return getConfig("lang");
		}
		/**
		 * 本地调试模式，不连服务器，意为着action等链接服务器的行为都会进入本地模式
		 * */
        public static function get localMode():Boolean
		{
			var inLocal:String=getConfig("localMode");
			return (inLocal!=null)&&((inLocal==true)||(inLocal=="true"));
		}
		/**
		 * 帮助页面地址
		 * */
		public static function get help():String
		{
			return Config.getConfig("help");
		}
		/**
		 * 游戏的版本，主要是为了在版本更换时加载资源，需要再发布时设置xml参数version
		 * */
		public static function get appVersion():String
		{
			return Config.getConfig("version");
		}

		/**
		 * app信息，用于统计,xa_target/plateform_sig_api_key都是后台约定
		 * */
		public static function get appInfo():Object
		{
			//ABTest参数
			var targetName:String=Config.getConfig("xa_target");
			//平台参数
			var publishID:String=Config.getConfig("plateform_sig_api_key");
			return {userID: XingCloud.userprofile.uid, XA_targname: targetName, publishID: publishID};
		}
		/**
		 * 当前社交平台的代号
		 * */
		public static function get platform_uid():String
		{
			return Config.getConfig("platefrom_app_id");
		}

		/**
		 * 用户在社交平台上的uid
		 * */
		public static function get platform_user_uid():String
		{
			return Config.getConfig("sig_user");
		}


		private static var _syncTime:Number=0; //本地时间
		private static var _serverTime:Number=0; //服务器时间

		/**
		 *当前服务器时间
		 */
		public static function get systemTime():Number
		{
			return getTimer() - _syncTime + _serverTime;
		}

		public static function set systemTime(time:Number):void
		{
			_serverTime=time;
			_syncTime=getTimer();
		}
		/**
		 * smartfoxServer的服务配置
		 * */
		private static var _sfs:SFS;
		/**
		 *@private 
		 * @return 
		 * 
		 */		
		public static function get sfs():SFS
		{
			if (_sfs)
				return _sfs;
			var sfsService:String=Config.getConfig("sfs");
			if ((sfsService == null) || sfsService.length == 0)
				return null;
			var arr:Array=sfsService.split(":");
			_sfs.url=arr[0];
			_sfs.port=arr[1];
			_sfs.zone=Config.getConfig("sfszone");
			return _sfs;
		}

		//从对象解析配置,不覆盖已存在属性
		xingcloud_internal static function parseFromObject(objConfig:Object):void
		{
			for (var conf:String in objConfig)
			{
				if (!getConfig(conf))
					setConfig(conf, objConfig[conf]);
			}
		}

		//从xml解析配置,不覆盖已存在属性
		xingcloud_internal static function parseFromXML(xmlConfig:XML):void
		{
			for each (var conf:XML in xmlConfig.children())
			{
				if (!getConfig(conf.localName()))
					setConfig(conf.localName(), conf.toString());
			}
		}

	}
}