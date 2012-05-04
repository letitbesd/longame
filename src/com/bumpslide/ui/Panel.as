﻿/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.ui 

	 * Update 2010-10: Background is now drawn with skin. 
	 * 
		static public var DefaultSkinClass:Class = DefaultPanelSkin;

		private var _handlingChildSizeChange:Boolean=false;
				
		private var _contentVisible:Boolean = true;
		
		private var _title:String;
		
		function Panel( content:DisplayObject = null, padding:*=  null, background_color:uint = NaN, background_alpha:Number = NaN):void 
			//trace(this+' CTOR');
			_holder = add( Sprite );
			super.postConstruct();
			
			initDefaultSkin();
		}


		protected function initDefaultSkin():void
		{
			// init default skin if there is none set (and there was no background on stage)
			if(background == null && skin == null && skinClass==null) {
				skinClass = DefaultSkinClass;
			}
		}

			super.initSize();
		}
		
		
		override protected function initSkinParts() : void
		{
			super.initSkinParts();
			
			// wire up the close button if it's here
			var closeButton:DisplayObject = getSkinPart('closeButton');
			if(closeButton)
			closeButton.addEventListener( MouseEvent.CLICK, function (e:Event):void {
				contentVisible = !contentVisible;
			} );
		}

			addEventListener( UIComponent.EVENT_SIZE_CHANGED, handleChildSizeChange, true );
		}


		protected function handleChildSizeChange( event:UIEvent ) : void
		{
			var child:DisplayObject = event.target as DisplayObject;
			if(child.parent == _holder) {
				//trace( '[Panel] child size changed ' , event.target);
				_handlingChildSizeChange = true;
				invalidate(VALID_SIZE);
				//updateNow();
			}
		}
				
			background=null;
			viewrect=null;
			_content=null;
			_holder=null;
			_padding=null;
			super.layoutChildren();
		}

			// leaving this method here for backwards compatability
			if(background) {
				background.width = width;
				background.height = height;
			}
			
			if(!_handlingChildSizeChange) {							
			}
			super.draw();
			
			_handlingChildSizeChange = false;
			if(_holder) {
			}
			
			// mask
			scrollRectSet('width', contentWidth);
			scrollRectSet('height', contentHeight);
			
				if(content is UIComponent) {
					(content as UIComponent).updateNow();
				}				
			
					
			_holder.scrollRect = rect;
			
			log('set content = '+c);
			
		
		/**
		 * content as IView
		public function get contentView():IView {
			return content as IView;
		}
			if(_padding==null) _padding = new Padding(Style.PANEL_PADDING);
			if(!contentVisible) return padding.height;

		
		public function get contentVisible() : Boolean {
			return _contentVisible;
		}

		public function set contentVisible( contentVisible:Boolean ) : void {
			_contentVisible = contentVisible;
			_holder.visible = _contentVisible;
			invalidate(VALID_SIZE);
		}


		override public function set children( display_objects:Array ) : void {
			if(display_objects.length>1 && content == null) {
				content = new Container( Direction.VERTICAL );
				(content as Container).children = display_objects;
			} else if (display_objects.length == 1) {
				content = display_objects[0];		
			}
		}

		
		/**
		 * Optional title for display
		 */
		public function get title() : String {
			return _title;
		}


		public function set title( title:String ) : void {
			_title = title;
			invalidate();
		/**
		 * IGridItem imeplementation
	}