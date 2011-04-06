package com.longame.managers
{
	import com.longame.core.long_internal;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
    use namespace long_internal
	public class AssetsLibrary
	{
		private static var _domains:Vector.<ApplicationDomain>=new Vector.<ApplicationDomain>();
		public static function get domains():Vector.<ApplicationDomain>
		{
			return _domains;
		}
		long_internal static function addDomain(d:ApplicationDomain):Boolean
		{
			if(d==null) return false;
			if(_domains.indexOf(d)>-1) return false;
			_domains.push(d);
			return true;
		}
		public static function getClass(name:String):Class
		{
			name=name.replace("::",".");
			if(ApplicationDomain.currentDomain.hasDefinition(name)) return ApplicationDomain.currentDomain.getDefinition(name) as Class;
			var len:int=_domains.length;
			for(var i:int=0;i<len;i++){
				var domain:ApplicationDomain=_domains[i];
				if(domain==null)continue;
				if(domain.hasDefinition(name)){
					return domain.getDefinition(name) as Class;
				}
			}
			Logger.warn("Engine","getClass","unknown class with name: "+name);
			return null;			
		}
		public static function getInstance(name:String):Object
		{
			var cls:Class=getClass(name);
			if(cls==null) return null;
			return new cls();
		}
		public static function getMovieClip(name:String):MovieClip
		{
			return getInstance(name) as MovieClip;
		}
		public static function getSimpleButton(name:String):SimpleButton
		{
			return getInstance(name) as SimpleButton;
		}		
		private static var _loader:Loader;
		/**
		 * 添加一个二进制素材
		 * */
		public static function addBinary(bytes:ByteArray,onLoaded:Function=null):void
		{
			if(_loader==null) _loader=new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(evt:Event):void{if(onLoaded!=null) onLoaded()},false,0,true);
			_loader.loadBytes(bytes);
			
		}
	}
}