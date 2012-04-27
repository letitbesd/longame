package com.longame.resource
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.AbstractLoader;
	import com.longame.commands.net.AssetsLoader;
	import com.longame.commands.net.DataLoader;
	import com.longame.core.IPrioritizable;
	import com.longame.core.long_internal;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.StringParser;
	import com.longame.utils.UrlUtil;
	import com.longame.utils.XmlUtil;
	import com.longame.utils.getDefinitionNames;
	import com.xingcloud.core.Config;
	
	import flash.display.Bitmap;
	import flash.net.URLLoaderDataFormat;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
    use namespace long_internal
	public class Resource implements IPrioritizable
	{
		long_internal var _reference:uint=0;
		/**
		 * 默认的资源类型
		 * */
		public static const DEFAULT:String="default";
		public static const ITEMS:String="items";
		public static const LANGUAGE:String="language";
		public static const QUEST:String="quest";
		public static const FONT:String="font";
		public static const TUTORIAL:String="tutorial";
		/**
		 * 定义一个资源模型
		 * @param src: 可以是文件地址，当是二进制资源时，可以是一个唯一的id
		 * @param type:资源类型，default,items,language,font,quest,tutorial之一,默认是default
		 * default会根据文件后缀判断，如果文件后缀和文件格式不符，请用以下任何之一：xml,jpg,jpeg,png,swf,css,txt,ini,property
		 * @param isBynary: 是否以二进制形式加载文件
		 * */
		public function Resource(src:String,type:String=null,isBynary:Boolean=false)
		{
			this._src=src;
		    this._type=type;
			this._isBynary=isBynary;
			if((this._type==null)||(this._type.length==0)||(this._type=="default")){
				_type=UrlUtil.getExtension(_src);
			}
			//如果是excel表，二进制导入,todo
			if(UrlUtil.getExtension(_src)=="xls") this._isBynary=true;
		}
		/**
		 * 解析url，加上webbase基地址，版本号和语言转换
		 * */
		public static function parseURL(src:String):String
		{
			var fullPath:String=src;
			//如果不是全路径，试图加上webBase
			if(src.indexOf("http://")==-1){
				//todo,可能出//...
				fullPath= Config.webbase+src;
			}
			//如果设定了版本号，加上
			if(Config.appVersion){
				if(fullPath.indexOf("?")>-1){
					fullPath+="&version="+Config.appVersion;
				}else{
					fullPath+="?version="+Config.appVersion;	
				}
			}
			//如果url中有{lang}的特殊字符，自动替换成当前语言代码，表示这是多语言素材
			var langIndex:int=fullPath.indexOf("{lang}");
			if(langIndex>-1){
				fullPath=fullPath.replace("{lang}",Config.languageType);
			}
			return fullPath;
		}
		//资源地址
		private var _src:String;	
		
		public function get src():String
		{
			return _src;
		}
		private var _isBynary:Boolean;
		/**
		 * 原始数据是否二进制数据
		 * */
		public function get isBynary():Boolean
		{
			return _isBynary||(this.rawContent&&(this.rawContent is ByteArray));
		}
		protected var _type:String="default";
		/**
		 * 设置资源类型，default会根据文件后缀自动判断
		 * language是语言文件
		 * items是物品数据文件
		 * font是字体文件，嵌入字体的swf
		 * binary是二进制
		 * cbinary是压缩二进制
		 * */
		[Inspectable(enumeration="default,language,items,quest,font,tutorial")]
		public function get type():String
		{
			return _type;
		}
		private var _priority:int=0;
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * Change the priority. You only need to implement this if you want
		 * SimplePriorityHeap.reprioritize to work. Otherwise it can
		 * simply throw an Error.
		 */
		public function set priority(value:int):void
		{
			if(_priority==value) return;
			_priority=value;
			//to dispatch...
		}
		
		/**
		 * 从xml描述中解析
		 * */
		public static function fromXml(xml:XML):Resource
		{
			return new Resource(xml.@src,xml.@type,StringParser.toBoolean(xml.@isBinary));
		}
		
		/**
		 * 加载器
		 * */
		private var _loader:AbstractLoader;
		public function get loader():AbstractLoader
		{
			if(_loader!=null) return _loader;
			if(_isBynary){
				_loader=new DataLoader(src,URLLoaderDataFormat.BINARY);
			}else{
				switch(type){
					case "swf":
					case "jpg":
					case "jpeg":
					case "png":
					case "gif":
					case FONT:
						_loader=new AssetsLoader(src);
						break;
					case "xml":
					case ITEMS:
					case LANGUAGE:
					case QUEST:
					case TUTORIAL:
					case "txt":
					case "ini":
					case "property":
					case "css":	
						_loader=new DataLoader(src);
						break;
					default:
						throw new Error("The resource type: "+type+" is invalidate!");
				}				
			}
			return _loader;
		}
		long_internal var _content:*;
		/**
		 * 经过处理后的数据，如：
		 * 1. xml文件加载后会返回xml
		 * 2. css文件加载后会返回StyleSheet
		 * 3. 。。。
		 * */
		public function get content():*
		{
			if(_content==null) return this.rawContent;
			return _content;
		}
		long_internal var _rawContent:*;
		/**
		 * 加载进来的原始数据
		 * */
		public function get rawContent():*
		{
			if(_rawContent==null){
				if(_loader) _rawContent=_loader.content;
			}
			return _rawContent;
		}
		public var loaded:Boolean;
		public var failed:Boolean;
		/**
		 * 此资源当前被用到的次数,当引用为0的时候，销毁资源，主要是图片，其他的好像销毁不了
		 * */
		long_internal function get reference():uint
		{
			return _reference;
		}
		long_internal function set reference(value:uint):void
		{
			if(_reference==value) return;
			_reference=value;
			if(_reference<=0){
				_reference=0;
				loaded=false;
				failed=false;
				if(content is Bitmap) (content as Bitmap).bitmapData.dispose();
				_content=null;
				_rawContent=null;
				if(_loader){
					_loader.dispose();
					_loader=null;
				}
			}
		}
	}
}