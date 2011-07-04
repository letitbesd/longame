package com.longame.resource
{
	import com.longame.commands.base.Command;
	import com.longame.commands.base.SerialCommand;
	import com.longame.commands.net.AbstractLoader;
	import com.longame.commands.net.AssetsLoader;
	import com.longame.commands.net.DataLoader;
	import com.longame.core.long_internal;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.debug.Logger;
	import com.longame.utils.getDefinitionNames;
	import com.xingcloud.core.Config;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.language.LanguageManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.events.StyleEvent;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;
	/**
	 * Resource的全局缓存和管理，目前是一个url对应一个Resource，不重复加载，但遇到特殊情况如：加载一个swf或图片，这个对象会被直接添加到舞台，如果一个场景中同时有两个
	 * 以上需要用到同一个swf或图片，这个时候会出现问题，就是只显示最后一个，解决办法是load时，设置forceReload为true
	 * */
	public class ResourceManager extends SerialCommand
	{
		/**
		 * 开始任何一个加载时，分发信号,Boolean表示这个加载是否真实加载
		 * true的话表示可以显示loading，false的话代表这批加载完全是重复的强制加载，从缓存中读取，不要显示loading
		 * */
		public var onLoadStart:Signal=new Signal(Boolean);
		
		private static var _instance:ResourceManager;
		
		private var _needShowLoading:Boolean;
		
		public function ResourceManager(singleton:lock):void
		{
			
		}
		public static function get instance():ResourceManager
		{
			if(_instance==null){
				_instance=new ResourceManager(new lock);
			}
			return _instance;
		}
		private var _resources:Dictionary=new Dictionary();
		
		public function addResource(r:Resource,forceReLoad:Boolean=false):void
		{
			if(this.total==0) _needShowLoading=false;
			if(r.src==null){
				throw new Error("The src of the resource is null!");
				return;				
			}
			if(getResource(r.src)!=null){
				if(!forceReLoad){
					Logger.warn(this,"addResource","The resource with url: "+r.src+" has existed!");
					return;
				}else{
					_needShowLoading=_needShowLoading||false;
				}
			}else{
				_needShowLoading=_needShowLoading||true;
			}
			//由于可能加入了webbase，所以不能是r.src做索引
			this._resources[r._src]=r;
			this.enqueue(r.loader);
			r.reference++;
		}
		public function addFile(url:String,forceReLoad:Boolean=false,type:String=null,isBynary:Boolean=false):Resource
		{
//			var r:Resource=getResource(url);
//			if((r!=null)&&(!forceReLoad)){
//				return r;
//			}else{
//				r=new Resource(url,type,isBynary);
//			}
//            this.addResource(r,forceReLoad);
//			return r;
			
			if(this.total==0) _needShowLoading=false;
			if(url==null){
				throw new Error("The url of the resource is null!");
				return null;				
			}
			var r:Resource=getResource(url);
			if(r!=null){
				if(!forceReLoad){
					return r;
				}else{
					_resources[url]=null;
					delete _resources[url];
					_needShowLoading=_needShowLoading||false;
				}
			}else{
				_needShowLoading=_needShowLoading||true;
			}
			r=new Resource(url,type,isBynary);
			//由于可能加入了webbase，所以不能是r.src做索引
			this._resources[url]=r;
			this.enqueue(r.loader);
			r.reference++;
			return r;
		}
		public function getResource(url:String):Resource
		{
			return _resources[url];
		}
		/**
		 * 单独加载一个文件，在加载swf或图片，加载后需要将其作为显示对象添加到显示列表，在同时有多个需要引用的情况下，注意用forceReload=true
		 * @param url :文件地址
		 * @param successHandler：成功回调，传参数Resource
		 * @parma failHandler:失败回调，传参数Resource
		 * @param type：数据类型，见Resource.SpecialTypes，null情况下，会根据文件后缀自动判断
		 * @param isBynary:文件是否二进制或是否采用用二进制形式加载
		 * @param forceReload：如果文件已经加载或加载失败了，是否重新加载，特别在加载swf或图片后作为显示对象使用时，同时使用需要true，否则只能看到一个
		 * */
		public function load(url:String,successHandler:Function=null,failHandler:Function=null,type:String=null,isBynary:Boolean=false,forceReLoad:Boolean=false):Resource
		{
			var resource:Resource=this.addFile(url,forceReLoad,type,isBynary);
			if(resource&&resource.loaded){
				if(resource.failed){
					if(failHandler!=null)   ProcessManager.callLater(failHandler,[resource]);
				}else{
					if(successHandler!=null) ProcessManager.callLater(successHandler,[resource]);
					resource.reference++;
				}
				return resource;
			}
//			var resource:Resource=getResource(url);
//			if(resource){
//				if(forceReLoad){
//					_resources[url]=null;
//					delete _resources[url];
//					resource=null;
//				}else if(resource.loaded){
//					if(resource.failed){
//						if(failHandler!=null)   ProcessManager.callLater(failHandler,[resource]);
//					}else{
//						if(successHandler!=null) ProcessManager.callLater(successHandler,[resource]);
//						resource.reference++;
//					}
//					return resource;
//				}
//			}
//			if(resource==null){
//				resource=addFile(url,forceReLoad,type,isBynary);
//			}
			if(successHandler!=null) resource.loader.onComplete.add(function(cmd:Command):void{successHandler(resource)});
			if(failHandler!=null) resource.loader.onError.add(function(cmd:Command,msg:String):void{failHandler(resource)});;
			this.execute();
			return resource;
		}
		public function unload(url:String):void
		{
			var resource:Resource=getResource(url);
			if(resource){
				resource.reference--;
				if(resource.reference<1) {
					delete _resources[url];
				}
			}
		}
		override protected function doExecute():void
		{
			this.onLoadStart.dispatch(_needShowLoading);
			super.doExecute();
		}
		override public function onCommandComplete(cmd:Command):void
		{
			var url:String=(cmd as AbstractLoader).url;
			//去掉webbase前缀
			url=url.slice(Config.webbase.length);
			this.handleResult(_resources[url]);
			super.onCommandComplete(cmd);
		}
		override public function onCommandError(cmd:Command, msg:String):void
		{
			var url:String=(cmd as AbstractLoader).url;
			//去掉webbase前缀
			url=url.slice(Config.webbase.length);
			if(_resources[url]){
				_resources[url].failed=true;
				_resources[url].loaded=true;
			}
			super.onCommandError(cmd,msg);
		}
		private function handleResult(r:Resource):void
		{
			r.loaded=true;
			r.failed=false;
			var rawContent:*=r.rawContent;
			if(rawContent==null) return;
			//如果是二进制数据，自动尝试解压之
			if(rawContent is ByteArray){
				try{
					(rawContent as ByteArray).uncompress();
				}catch(e:Error){
					//do nothing
				}
			}
			switch(r.type){
				case "xml":
				case "items":
				case "language":
					r._content=new XML(rawContent);
					if(r.type=="items")    ItemDatabase.addXmlSource(r._content as XML);
					if(r.type=="language") LanguageManager.languageSource=r._content as XML;
					break;
				case "css":
					var s:StyleSheet=new StyleSheet();
					s.parseCSS(rawContent);
					r._content=s;
					LanguageManager.styleSheet=s;
					break;
				case "font":
					this.registerFonts(r.loader as AssetsLoader);
					break;
//				case "txt":
//				case "ini":
//				case "property":
			}
		}
		private function registerFonts(loader:AssetsLoader):void
		{
			//获取字体文件里所有可能的字体元件定义，并注册之
			var fontNames:Array=getDefinitionNames(loader.getContentLoaderInfo(),false,true);
			for each(var fontName:String in fontNames){
				var fontClass:Class=AssetsLibrary.getClass(fontName);
				if(fontClass==null) continue;
				try{
					Font.registerFont(fontClass);
				}catch(e:Error){
					
				}
			}
		}
	}
}
internal class lock
{
	
}

