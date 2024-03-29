package com.xingcloud.core
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getTimer;

	/**
	 * Some SecretData don't want to be seen easily.
	 * 此处修改通信加密认证Key
	 * */
	[SecretData(secret_key="wotamdyunsi")]
	
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
		 *多语言的字体服务
		 */
		public static const FONTS_SERVICE:String="locale.font.get";
		/**
		 * 物品数据服务
		 */
		public static const ITEMSDB_SERVICE:String="item.itemSpec.xml";
		/**
		 * 获取物品服务
		 */
		public static const ITEMSLOAD_SERVICE:String="user.user.getItems";
		/**
		 *多语言的文字服务
		 */
		public static const LANGUAGE_SERVICE:String="locale.text.getAll";
		/**
		 *任务接受
		 */
		public static const QUEST_ACCEPT_SERVICE:String="quest.quest.accept";
		/**
		 *任务服务
		 */
		public static const QUEST_GET_SERVICE:String="quest.quest.get";
		/**
		 *任务提交
		 */
		public static const QUEST_SUBMMIT_SERVICE:String="quest.quest.submit";
		/**
		 * 多语言的样式服务
		 */
		public static const STYLE_SERVICE:String="locale.style.get";
		/**
		 *教程完成
		 */
		public static const TUTORIAL_COMPLETE_SERVICE:String="tutorial.tutorial.complete";
		/**
		 *教程服务
		 */
		public static const TUTORIAL_GET_SERVICE:String="tutorial.tutorial.get";
		/**
		 *教程进入下一步
		 */
		public static const TUTORIAL_STEP_SERVICE:String="tutorial.tutorial.step";
		/**
		 *用户平台登陆
		 * */
		public static const PLATFORM_LOGIN_SERVICE:String="user.user.platformLogin";
		/**
		 *用户平台注册
		 * */
		public static const PLATFORM_REGISTER_SERVICE:String="user.user.platformRegister";
		/**
		 *用户登陆
		 */
		public static const LOGIN_SERVICE:String="user.user.login";
		/**
		 *用户注册
		 */
		public static const REGISTER_SERVICE:String="user.user.register";
		/**
		 *绑定平台
		 */
		public static const BIND_PLATFORM_SERVICE:String="user.user.bindPlatform";
		/**
		 *UserProfile服务
		 * */
		public static const USERPROFILE_SERVICE:String="user.user.get";


		/**
		 *行云的sfs扩展服务
		 */
		public static const XINGCLOUD_EXTENSION:String="service";

		/**
		 *多语言模块，作为函数<code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const LOCALE_MODULE:String="com.xingcloud.language.LanguageManager";
		/**
		 * 用户资料模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const USER_MODULE:String="com.xingcloud.model.users.AbstractUserProfile";
		/**
		 * 物品模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const ITEM_MODULE:String="com.xingcloud.model.items.ItemsParser";
		/**
		 * Action模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const ACTION_MODULE:String="com.xingcloud.actions.ActionManager";
		/**
		 * AuditChange模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const AUDITCHANGE_MODULE:String="com.xingcloud.auditchange.AuditChangeManager";
		/**
		 * SFS模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const SFS_MODULE:String="com.xingcloud.net.remote.SFSManager";
		/**
		 * AMF模块，作为函数 <code>checkPlugIn</code>的参数，用于检查此模块是否接入。
		 * @see #checkPlugIn()
		 */
		public static const AMF_MODULE:String="com.xingcloud.net.remote.connector.AMFConnector";

		private static const authMethod:String="HMAC-SHA1";
		private static const authVersion:String="1.0";
		private static const consumerKey:String="wotamdyunsi";

		private static var local:Dictionary=new Dictionary();
		private static var _serverTime:Number=0; //服务器时间
		private static var _syncTime:Number=0; //本地时间

		/**
		 * amf调用gateway地址
		 * */
		public static function get amfGateway():String
		{
			return gateWay + "/amf";
		}


		/**
		 *file调用gateway地址,应用于服务文件调用
		 * */
		public static function get fileGateway():String
		{
			return gateWay + "/file";
		}

		/**
		 * rest调用gateway地址
		 * */
		public static function get restGateway():String
		{
			return gateWay + "/rest";
		}

		/**
		 * 与后台通信的gateway,以"/"结尾
		 *
		 */
		public static function get gateWay():String
		{
			var url:String=Config.getConfig("gateway");
			if (url && url.lastIndexOf("/") == (url.length - 1))
			{
				url=url.substring(0, url.length - 1);
			}
			return url;
		}

		/**
		 * app信息，用于统计,xa_target/plateform_sig_api_key都是后台约定
		 * */
		public static function get appInfo():Object
		{
			return {gameUserId: XingCloud.uid, abtest: getConfig("xa_target"), platformUserId: platformUserId,
					 platformAppId: platformAppId, lang: languageType}
		}

		/**
		 *获取配置,优先获取通过Flashvar传入的外部配置
		 * @param name 参数名
		 */
		public static function getConfig(name:String):*
		{
			var value:Object;

			if (XingCloud.stage)
			{
				value=XingCloud.stage.loaderInfo.parameters[name];
			}
			if (value)
				return value;
			value=Config.local[name];
			if (value is Function)
			{
				return value();
			}
			return value;
		}

		/**
		 * 帮助页面地址
		 * */
		public static function get help():String
		{
			return Config.getConfig("help");
		}

		/**
		 * 当前语言版本类型，如"cn","en"
		 * */
		public static function get languageType():String
		{
			var lang:String=getConfig("lang");
			if(lang) return lang;
			return "cn";
		}

		/**
		 * 当前社交平台的代号
		 * */
		public static function get platformAppId():String
		{
			return Config.getConfig("platefrom_app_id");
		}

		/**
		 * 用户在社交平台上的uid
		 * */
		public static function get platformUserId():String
		{
			return Config.getConfig("sig_user");
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
		 *当前服务器时间
		 */
		public static function get systemTime():Number
		{
			return getTimer() - _syncTime + _serverTime;
		}

		/**
		 *
		 * @param time
		 */
		public static function set systemTime(time:Number):void
		{
			_serverTime=time;
			_syncTime=getTimer();
		}

		/**
		 * 对配置进行初始化
		 * @param config 自定义配置文件加载的路径
		 */
		public static function init(config:XML=null):void
		{
			if (config != null)
			{
				xingcloud_internal::parseFromXML(config);
			}
			//对需要保密的使用 ‘SecretData’元标签的数据解析
			var metadatas:XMLList=describeType(Config).factory.metadata.(@name == "SecretData").arg;
			var numSecrets:int=metadatas.length();
			for (var i:int=0; i < numSecrets; i++)
			{
				setConfig(metadatas[i].@key, String(metadatas[i].@value));
			}
			setConfig("consumerKey", consumerKey);
			setConfig("authMethod", authMethod);
			setConfig("authVersion", authVersion);
			setConfig("platefrom_app_id", "xingcloudDebug");
			setConfig("xa_target", "abtest");
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
		
		/*****************************************************************************/
		/**
		 * 游戏的版本，主要是为了在版本更换时加载资源，需要再发布时设置xml参数version
		 * */
		public static function get appVersion():String
		{
			return Config.getConfig("version");
		}
		/**
		 * 本地调试模式，不连服务器，意为着action等链接服务器的行为都会进入本地模式
		 * */
		public static function get localMode():Boolean
		{
			var inLocal:String=getConfig("localMode");
			return (inLocal!=null)&&((inLocal==true)||(inLocal=="true"));
		}
	}
}
