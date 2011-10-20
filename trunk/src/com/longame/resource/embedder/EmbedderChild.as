package com.longame.resource.embedder
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.getQualifiedSuperclassName;
	import mx.core.FontAsset;
	import mx.core.MovieClipLoaderAsset;
	
	/**
	 * Embed されたものを準備するクラス。
	 * @author jc at bk-zen.com
	 */
	public class EmbedderChild extends EventDispatcher
	{
		
		protected var _clazz: Class;
		private var _className: String;
		private var _classObj: * ;
		private var loaderInfo: LoaderInfo;
		
		public function EmbedderChild(clazz: Class, className: String) 
		{
			_clazz = clazz;
			_className = className;
		}
		
		public function init(): void
		{
			_classObj = new clazz();
			switch (getQualifiedSuperclassName(_classObj))
			{
				case "mx.core::ByteArrayAsset":
					dispatchEvent(new Event(Event.COMPLETE));
				break;
				case "mx.core::BitmapAsset":
					dispatchEvent(new Event(Event.COMPLETE));
				break;
				case "mx.core::SpriteAsset":
					dispatchEvent(new Event(Event.COMPLETE));
				break;
				case "mx.core::SoundAsset":
					dispatchEvent(new Event(Event.COMPLETE));
				break;
				case "mx.core::FontAsset":
					dispatchEvent(new Event(Event.COMPLETE));
					_classObj = FontAsset(_classObj);
				break;
				case "mx.core::MovieClipLoaderAsset":
					var mc: MovieClipLoaderAsset = (_classObj);
					loaderInfo = Loader(mc.getChildAt(0)).contentLoaderInfo;
					loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loaderInfo.addEventListener(Event.INIT, mcInit);
				break;
				default:
					dispatchEvent(new Event(Event.COMPLETE));
				break;
			}
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace("e : " + e);
		}
		
		public function reInit(): void
		{
			if (classObj) 
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			if (loaderInfo) 
			{
				loaderInfo.removeEventListener(Event.INIT, mcInit);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loaderInfo = null;
			}
			init();
		}
		
		
		
		public function clear(): void
		{
			_clazz = null;
			_className = null;
			_classObj = null;
			if (loaderInfo) 
			{
				loaderInfo.removeEventListener(Event.INIT, mcInit);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			loaderInfo = null;
		}
		
		
		
		
		private function mcInit(e: Event): void 
		{
			if (loaderInfo)
			{
				loaderInfo.removeEventListener(Event.INIT, mcInit);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loaderInfo = null;
			}
			if (e.target.content is MovieClip) 
			{
				_classObj = MovieClip(e.target.content);
			}
			else if (e.target.content is Sprite)
			{
				_classObj = Sprite(e.target.content)
			}
			else 
			{
				_classObj = e.target.content;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get className(): String { return _className; }
		
		public function get classObj(): *  { return _classObj; }
		
		public function get clazz(): Class { return _clazz; }
	}
	
}