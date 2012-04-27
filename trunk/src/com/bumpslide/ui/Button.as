/**
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



		protected var _label:String;

		private var _iconAlignV:String = Position.MIDDLE;
		
			super();
			
			if(width!=-1) this.width = width;
			if(height!=-1) this.height = height;
			
		{
			super.skin=s;
			this.initButton();
		}
			super.postConstruct();			
		}
		
		protected function initDefaultSkin():void {
			if(padding==null){
				padding = Style.BUTTON_PADDING;
			}
			if(skin==null && skinClass==null) {
				skinClass = DefaultSkinClass;
				//trace('using default skin '+skin);
			}
		}
		


			if(stage) {
				stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			}


				stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			}

			_isMouseOver = (event && hitTestPoint(event.stageX, event.stageY) && !Multitouch.supportsTouchEvents);
		
			_isMouseOver = (event && hitTestPoint(event.stageX, event.stageY) && !Multitouch.supportsTouchEvents);
				dispatchEvent( new Event(Event.CHANGE, true) );
			invalidate(VALID_SKIN_STATE);
			invalidate(VALID_SKIN_STATE);







		}

		public function set toggle(toggle:Boolean):void {
		}
		
		/**
		 * toggle selection status when clicked
		 */

			if(_label==null && gridItemData) {
				return _gridItemData;
 			} else {
 				return _label;
			}
		[Inspectable(type="String", defaultValue="")]
			//trace('setting label to ' + label );
			invalidate(VALID_DATA);