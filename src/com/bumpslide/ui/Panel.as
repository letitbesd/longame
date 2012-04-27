﻿/** * This code is part of the Bumpslide Library by David Knape * http://bumpslide.com/ *  * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc. *  * Released under the open-source MIT license. * http://www.opensource.org/licenses/mit-license.php * see LICENSE.txt for full license terms */  package com.bumpslide.ui {	import com.bumpslide.data.type.Padding;	import com.bumpslide.ui.Component;	import com.bumpslide.ui.IResizable;		import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.geom.Rectangle;
	/**	 * Simple Container with Background box and padding.	 * 	 * This is a core base class for the scroll panels and grids	 * 	 * This component can be instantiated via code, or it can be created 	 * inside a FLA.  Missing pieces will be dynamically added to the 	 * display list. Background is now transparent by default.  We still 	 * need it for absorbing certain mouse events in various child components.	 *   	 * @author David Knape	 */	public class Panel extends Component {		// children		public var background:DisplayObject;				public var viewrect:Sprite; // avatar on stage to determine content padding				protected var _content:DisplayObject;		protected var _holder:Sprite;					// content and scrollbar padding in relationship to background		protected var _padding:Padding; 		public static var DEFAULT_PADDING:Number = 5;		public static var DEFAULT_BACKGROUND_COLOR:Number = 0xdddddd;		protected var _autoSizeHeight:Boolean=false;				public function Panel():void		{			super();		}		/**		 * init		 */		override protected function addChildren() : void 		{						//debugEnabled = true;									updateDelay = 0;			initPadding();			initBackground();			initContent();					}		override protected function doDestroy():void {			destroyChild( content );			super.doDestroy();		}		/**		 * Uses viewrect on stage to determine appropriate padding		 * By default, the _defaultPadding value is used		 */		protected function initPadding():void {			// define viewrect					if(viewrect==null) {				if(_padding==null) _padding = new Padding( DEFAULT_PADDING );			} else {				var b:Rectangle = viewrect.getBounds(this);								_padding = new Padding(b.y, width - b.right, height-b.bottom, b.x );				removeChild( viewrect );			}		}		/**		 * Create background if there wasn't one on stage		 */		protected function initBackground() : void {			if(background==null) {				background = new SolidBox(DEFAULT_BACKGROUND_COLOR, _width, _height );				background.alpha = 0;				addChild( background );			}			}				/**		 * Initializes content holder and scrollrect		 */		protected function initContent():void {			// create content holder						_holder = new Sprite();			addChild( _holder);		}						/**		 * Layout components and adjust the content.scrollRect dimensions		 */					override protected function draw () : void {				drawContent();						drawBackground();			super.draw();		}						/**		 * Draws the background		 */		protected function drawBackground() : void {			background.height = height;			background.width = width;			if(autoSizeHeight) {				scrollRectSet('height', height-padding.height);				}		}				/**		 * Positions holder and sizes scroll rect for no scrollbar 		 */		protected function drawContent() : void {			positionContent();									setContentSize( contentWidth, contentHeight );			if(autoSizeHeight && content!=null && content is Component) {				(content as Component).updateNow();			}		}				protected function positionContent() : void {			_holder.x = _padding.left;			_holder.y = _padding.top;		}				protected function setContentSize(w:Number, h:Number) : void {			scrollRectSet('width', w);						if(autoSizeHeight) {				if(content) content.width = contentWidth;			} else {								scrollRectSet('height', h);						if(content is IResizable) {					(content as IResizable).setSize( w, h );				}			}		}		protected function scrollRectSet( prop:String, value:Number ) : void {			if(_holder==null) return;			if(_holder.scrollRect==null) _holder.scrollRect = new Rectangle();			var rect:Rectangle = _holder.scrollRect;			rect[prop] = Math.round(value);			_holder.scrollRect = rect;		}				//-------------------		// GETTERS/SETTERS		//-------------------				/**		 * The content being scrolled		 */			public function set content ( c:DisplayObject ) : void {				// if we had old content, remove it			if(_content!=null && _holder.contains( _content ) ){				_holder.removeChild( _content );			}			// add to stage inside holder						if(c!=null) _holder.addChild( c );										_content = c;				invalidate();		}				public function get content () : DisplayObject {			return _content;		}				public function get contentWidth () : Number {			return _width - _padding.width;		}				public function get contentHeight () : Number {			return _height - _padding.height;		}				public function set padding ( p:* ) : void {			if(p is Padding) _padding = (p as Padding).clone();			else _padding = new Padding( Number(p) );			invalidate();		}						public function get padding () : Padding {			return _padding; //.clone();		}				public function get backgroundBox() : SolidBox {			if(background is SolidBox) {				return background as SolidBox;			} else {				return null;			}		}				public function get autoSizeHeight():Boolean {			return _autoSizeHeight;		}				public function set autoSizeHeight(autoSize:Boolean):void {			_autoSizeHeight = autoSize;			invalidate();		}				override public function get height() : Number {			var ch:Number = content ? (content is Component ? (content as Component).actualHeight : content.height) : 0;			return (autoSizeHeight) ? ch + padding.height : super.height;		}	}}