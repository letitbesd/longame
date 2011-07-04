package com.xingcloud.services
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.INetEntry;
	import com.longame.commands.net.Remoting;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.Reflection;
	import com.longame.utils.getDefinitionNames;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.items.ItemsParser;
	import com.xingcloud.language.LanguageManager;
	import com.xingcloud.users.actions.ActionResult;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	
	import mx.effects.IAbstractEffect;

	use namespace xingcloud_internal;

	/**
	 * 服务条目
	 * */
	public class Service implements INetEntry
	{
		public static const LANGUAGE:String="language";
		public static const STYLE:String="style";
		public static const ITEMS:String="items";
		public static const FONTS:String="fonts";
		public static const QUEST:String="quest";
		/**
		 * 设置服务类型
		 * language是语言文件
		 * items是物品数据文件
		 * font是字体文件，嵌入字体的swf
		 * */
		[Inspectable(enumeration="language,style,items,fonts,quest")]
		public var type:String;
		/**
		 * 调用服务的方式，见Remoting，默认为get
		 * */
		[Inspectable(enumeration="amf,get,post")]
		public var method:String;
		/**
		 * 各个服务对应的地址
		 * */
		private static const commandsMap:Object={language: Config.LANGUAGE_SERVICE, style: Config.STYLE_SERVICE, items: Config.ITEMSDB_SERVICE, fonts: Config.FONTS_SERVICE, quest: Config.QUEST_GET_SERVICE};
		/**
		 * 各个服务对应发送数据类型
		 * */
		private static const methodsMap:Object={language: Remoting.POST, style: Remoting.POST, items: Remoting.POST, fonts: Remoting.POST, quest: Remoting.AMF};
		/**
		 * 各个服务对应的返回数据类型
		 * */
		private static const dataformatMap:Object={language: URLLoaderDataFormat.TEXT, style: URLLoaderDataFormat.TEXT, items: URLLoaderDataFormat.TEXT, fonts: URLLoaderDataFormat.BINARY, quest: URLLoaderDataFormat.TEXT};
		private var serviceExecutor:Remoting;
		/**
		 * 成功回调函数,function onSuccess(e:TaskEvent):void;
		 * */
		public var onSuccess:Function;
		/**
		 * 失败回调函数,function onFail(e:TaskEvent):void;
		 * */
		public var onFail:Function;
		public var timestamp:String="";

		public function Service(type:String=null, onSuccess:Function=null, onFail:Function=null)
		{
			this.type=type;
			if (this.method == null)
				this.method=methodsMap[type];
			this.onSuccess=onSuccess;
			this.onFail=onFail;
			super();
		}

		public function execute():void
		{
			executor.execute();
		}

		public function get executor():Remoting
		{
			if (serviceExecutor == null)
			{
				var gate:String=(this.method == "amf") ? Config.amfGateway : Config.fileGateway;
				serviceExecutor=new Remoting(commandsMap[type] + "?timestamp=" + StatusManager.getStatus(this), this.getParams(), method, gate, XingCloud.needAuth);
				serviceExecutor.dataFormat=dataformatMap[type];
				serviceExecutor.onComplete.add(onExecuted);
				serviceExecutor.onError.add(onExecutedError);
			}
			return serviceExecutor;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get uri():String
		{
			var cmd:String=commandsMap[type];
			return cmd.substring(0, cmd.lastIndexOf("."));
		}

		public function get name():String
		{
			var cmd:String=commandsMap[type];
			return cmd.substring(cmd.lastIndexOf(".") + 1);
		}

		protected function onExecuted(cmd:Command):void
		{
				this.handleResult()
				if (this.onSuccess != null)
					this.onSuccess(cmd);
		}

		protected function onExecutedError(cmd:Command,error:String):void
		{
			if (this.onFail != null)
				this.onFail(error);
//			trace("service error: "+event.task.data.message);
		}

		private function handleResult():void
		{
			if (this.type == Service.ITEMS)
			{
				try
				{
					ItemDatabase.addXmlSource(new XML(executor.data as String));
				}
				catch (e:Error)
				{
					this.onFail("The items data from server is invalidated!");
				}
			}
			if (this.type == Service.FONTS)
			{
				var loader:Loader=new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, registeFonts);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFontsError);
				loader.loadBytes(executor.data as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			else if (this.type == Service.LANGUAGE)
			{
				try
				{
					LanguageManager.languageSource=new XML(executor.data as String);
				}
				catch (e:Error)
				{
					this.onFail("The language data from server is invalidated!");
				}
			}
			else if (this.type == Service.STYLE)
			{
				var style:StyleSheet=new StyleSheet();
				style.parseCSS(executor.data as String);
				LanguageManager.styleSheet=style;
			}
//				else if(this.type==Service.QUEST){
//					QuestManager.handleDataFromServer(executor.data);
//				}
		}

		private function registeFonts(e:Event):void
		{
			var l:LoaderInfo=e.currentTarget as LoaderInfo;
			//获取字体文件里所有可能的字体元件定义，并注册之
			var fontNames:Array=getDefinitionNames(l, false, true);
			for each (var fontName:String in fontNames)
			{
				var fontClass:Class=AssetsLibrary.getClass(fontName);
				if (fontClass == null)
					continue;
				try
				{
					Font.registerFont(fontClass);
				}
				catch (e:Error)
				{
				}
			}
		}

		private function onLoadFontsError(e:IOErrorEvent):void
		{
			trace(e.text);
		}

		private function getParams():*
		{
			if (type == Service.QUEST)
				return {user_uid: XingCloud.userprofile.uid};
			return {lang: Config.languageType};
		}
	}
}