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
		
		protected var _isDragging:Boolean = false;
		
			super.commitProperties();
		}
		
		
		override protected function draw():void
			
			if(hasChanged(VALID_DATA)) {
				if(skin && skin is ISkin) { 
					(skin as ISkin).renderSkin(skinState);
				}
				validate(VALID_DATA);
			}
			_isDragging = true;
			
			invalidate( VALID_SKIN_STATE );
			
			callLater( 10, _dragBehavior.startDragging, event);
			_isDragging = true;
			
			_isDragging = true;
			
			// notify our friends
			percent = getActualHandlePosition() / getHandleBounds();
			
			_isDragging = false;
			
			
			if(handle is Button) (handle as Button).skinState = Button.STATE_OFF;
				sendEvent(EVENT_CHANGE, value);
				sendChangeEvent('value', value);
			}
			invalidate(VALID_DATA);
		
		public function set onChange( f:Function ) : void {