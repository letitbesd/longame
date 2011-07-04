package com.longame.resource
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.AbstractLoader;
	import com.longame.commands.net.AssetsLoader;
	import com.longame.commands.net.DataLoader;
	import com.longame.core.IPrioritizable;
	import com.longame.core.long_internal;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.UrlUtil;
	import com.longame.utils.XmlUtil;
	import com.longame.utils.getDefinitionNames;
	import com.xingcloud.core.Config;
	import com.xingcloud.items.ItemDatabase;
	
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
		 * 除了以文件后缀来决定类型外，还有些特定的类型，决定他们用特定的加载器
		 * */
		public static const SpecialTypes:Array=["items","language","font"]
		/**
		 * 定义一个资源模型
		 * @param src: 可以是文件地址，当是二进制资源时，可以是一个唯一的id
		 * @param type:资源类型，default,items,language,font之一,
		 * default会根据文件后缀判断，如果文件后缀和文件格式不符，请用以下任何之一：xml,jpg,jpeg,png,swf,css,txt,ini,property
		 * @param isBynary: 是否以二进制形式加载文件
		 * */
		public function Resource(src:String=null,type:String=null,isBynary:Boolean=false)
		{
			if(src) this.src=src;
		    if(type) this.type=type;
			this._isBynary=isBynary;
		}
		//资源地址
		long_internal var _src:String;	
		
		public function get src():String
		{
			//如果不是全路径，试图加上webBase
			if(_src.indexOf("http://")==-1){
				return Config.webbase+_src;
			}
			return _src;
		}
		public function set src(s:String):void
		{
			_src=s;
		}
		private var _isBynary:Boolean;
		/**
		 * 是否二进制数据
		 * */
		public function get isBynary():Boolean
		{
			return _isBynary;
		}
		/**
		 * 设置资源类型，default会根据文件后缀自动判断
		 * language是语言文件
		 * items是物品数据文件
		 * font是字体文件，嵌入字体的swf
		 * binary是二进制
		 * cbinary是压缩二进制
		 * */
		[Inspectable(enumeration="default,language,items,font")]
		public var type:String="default";
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
			return new Resource(xml.@src,xml.@type);
		}
		
		/**
		 * 加载器
		 * */
		private var _loader:AbstractLoader;
		public function get loader():AbstractLoader
		{
			if(_loader!=null) return _loader;
			if((this.type==null)||(this.type.length==0)||(this.type=="default")){
				type=UrlUtil.getExtension(_src);
			}
			if(_isBynary){
				_loader=new DataLoader(src,URLLoaderDataFormat.BINARY);
			}else{
				switch(type){
					case "swf":
					case "jpg":
					case "jpeg":
					case "png":
					case "font":
						_loader=new AssetsLoader(src);
						break;
					case "xml":
					case "items":
					case "language":
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
		/**
		 * 加载进来的原始数据
		 * */
		public function get rawContent():*
		{
			if(_loader==null) return null;
			return _loader.content;
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
				_loader.dispose();
				_loader=null;
			}
		}
	}
}