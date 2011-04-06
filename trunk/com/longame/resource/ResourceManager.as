package com.longame.resource
{
	import com.longame.commands.base.Command;
	import com.longame.commands.base.SerialCommand;
	import com.longame.commands.net.AbstractLoader;
	import com.longame.commands.net.AssetsLoader;
	import com.longame.commands.net.CSSLoader;
	import com.longame.commands.net.DataLoader;
	import com.longame.commands.net.XmlLoader;
	import com.longame.core.long_internal;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.database.ItemDatabase;
	import com.longame.utils.debug.Logger;
	import com.longame.utils.getDefinitionNames;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	use namespace long_internal;
	public class ResourceManager extends SerialCommand
	{
		private static var _instance:ResourceManager;
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
		
		public function addResource(r:Resource):void
		{
			if(r.src==null){
				Logger.error(this,"addEntry","The resource entry has no src!");
				return;				
			}
			if(getResource(r.src)!=null){
				Logger.warn(this,"addEntry","The resource entry with url: "+r.src+" has existed!");
				return;
			}
			this._resources[r.src]=r;
			this.enqueue(r.loader);
		}
		public function addFile(url:String,type:String=null):Resource
		{
			var r:Resource=getResource(url);
			if(r!=null){
				return r;
			}else{
				r=new Resource(url,type);
			}
            this.addResource(r);
			return r;
		}
		public function getResource(url:String):Resource
		{
			return _resources[url];
		}
		/**
		 * 单独加载一个文件
		 * @param url :文件地址
		 * @param successHandler：成功回调，传参数Resource
		 * @parma failHandler:失败回调，传参数Resource
		 * @param type：数据类型，见Resource.SpecialTypes，default情况下，会根据文件后缀自动判断
		 * @param forceReload：如果文件已经加载，是否重新加载
		 * */
		public function load(url:String,successHandler:Function=null,failHandler:Function=null,type:String="default",forceReLoad:Boolean=false):Resource
		{
			var resource:Resource=getResource(url);
			if(resource){
				if(resource.loaded){
					if(!forceReLoad) {
						if(successHandler!=null) successHandler(resource);
						resource.reference++;
						return resource;
					}
				}
			}else{
				resource=addFile(url,type);
				resource.reference++;
			}
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
				if(resource.reference<1) delete _resources[url];
			}
		}
		
		override public function onCommandComplete(cmd:Command):void
		{
			var url:String=(cmd as AbstractLoader).url;
			this.handleResult(_resources[url]);
			super.onCommandComplete(cmd);
		}
		override public function onCommandError(cmd:Command, msg:String):void
		{
			var url:String=(cmd as AbstractLoader).url
		    _resources[url].failed=true;
			_resources[url].loaded=true;
			super.onCommandError(cmd,msg);
		}
		private function handleResult(r:Resource):void
		{
			r.loaded=true;
			r.failed=false;
			switch(r.type){
				case "items":
					ItemDatabase.addXmlSource((r.loader as XmlLoader).xml);
					break;
				case "language":
					//handle language
					break;
				case "font":
					this.registerFonts(r.loader as AssetsLoader);
					break;
				case "cbinary":
					(r.loader.content as ByteArray).uncompress();
					break;
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

