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
	import flash.events.MouseEvent;
		
		private var _mouseWheelScroll:Boolean = true;

			if(_scrollbarClassChanged) {				
			
			//trace('scrollbar='+scrollbar);
			if(!mouseWheelEnabled) return;
			super.draw();
			// size the scrollbar regardless of whether or not we need it
			if(isVertical) {
				scrollbar.setSize( scrollbarWidth, height-padding.height);
			} else {
				scrollbar.setSize( width-padding.width, scrollbarWidth );
			}
				
			
			super.layoutChildren();		
		}

		public function get maxScrollPosition():Number {
			return scrollbar.scrollTarget.totalSize - scrollbar.scrollTarget.visibleSize;
		}
		
		public function get minScrollPosition():Number {
			return 0;
		}
		


