package com.longame.commands.net {	import com.longame.commands.base.Command;	import com.longame.core.long_internal;	import com.longame.managers.AssetsLibrary;	import com.longame.utils.debug.Logger;		import flash.display.DisplayObject;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.events.ErrorEvent;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLRequest;	import flash.system.ApplicationDomain;	import flash.system.LoaderContext;	import flash.system.SecurityDomain;	import flash.utils.getTimer;
	    use namespace long_internal;	/**	 * <code>AssetsLoader</code> 用于加载SWF,IMAGE等可视资源	 * 	 * @author longyangxi	 */	public class AssetsLoader extends AbstractLoader{		protected var _loader : Loader;		protected var _domain:ApplicationDomain;		protected var _context : LoaderContext;		/**		 * @param urlOrRequest 文件地址或者UrlRequest		 * @param domain 指定文件加载域，如果想要通过getDefinitionByName可以获取资源，请用ApplicationDomain.currentDomain		 */		public function AssetsLoader(urlOrRequest : *, domain:ApplicationDomain=null) {				super(urlOrRequest);			_loader = new Loader();			_context =this.getContext(domain);			this._domain=_context.applicationDomain;		}		public function get domain():ApplicationDomain		{			return this._domain;		}		/**		 * 获取指定的加载域，如果没有指定，则用ApplicationDomain.currentDomain，则通过getDefinitionByName可以获取资源		 * */		private function getContext(d:ApplicationDomain=null):LoaderContext		{			var c:LoaderContext = new LoaderContext();			c.applicationDomain = d ? d :null; //ApplicationDomain.currentDomain;			if(Engine.inWeb) c.securityDomain=SecurityDomain.currentDomain;			return c;		}		override protected function doLoad():void		{						_loader.load(_urlRequest, _context);		}		override protected function doCancel():void		{			try {				_loader.close();			}			catch(e : Error) {			}					}		override protected function removeListeners() : void {			if(_loader && _loader.contentLoaderInfo) {				this.removeLoaderEventListeners(_loader.contentLoaderInfo);			}		}		override protected function addListeners():void		{			if(_loader && _loader.contentLoaderInfo) {				this.addLoaderEventListeners(_loader.contentLoaderInfo);			}					}        override protected function onLoadComplete(event:Event):void		{            addNewDomain();			super.onLoadComplete(event);		}		/**		 * 将新的ApplicationDomain添加到ELEX的domains队列里，方便获取各个domain里的资源		 * */		private function addNewDomain():void		{			if(this._domain==null) this._domain=_loader.contentLoaderInfo.applicationDomain;			AssetsLibrary.addDomain(_domain);		}		/**		 * dispose the <code>AssetsLoader</code>. <code>AssetsLoader</code> internally uses the flash event model 		 * without weak references so don't forget to finalize the loader, otherwise it will kept in memory.		 * 		 * @inheritDoc		 */		override public function dispose() : void {			super.dispose();			_loader = null;			_context=null;		}				/**		 * The LoaderInfo class provides information about the loaded content. Most of the information		 * is availible after the content is loaded completely.		 * 		 * @see flash.display.LoaderInfo		 * 		 * @return an <code>LoaderInfo</code> object		 */		public function getContentLoaderInfo() : LoaderInfo {			return _loader.contentLoaderInfo;		}		/**		 * 加载完成的显示对象，对于图象加载，返回的是Bitmap，SWF加载返回的是MovieClip		 * 		 * @return the loaded <code>DisplayObject</code>		 * @throws Error if content has not been loaded successfully		 */		override public function get content() : * {			return _loader.content;				}	}}