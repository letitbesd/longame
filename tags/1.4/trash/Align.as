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

package com.bumpslide.util 
		* If you want to render it yourself (with tweens, for instance), pass in a callback
		* as the third parameter to this function. 
		* 
		* Example:
		* <code>
		*     Align.vbox( clips, spacing, function ( mc:Sprite, position:) {
		* 		        	
		*     } );
		* </code>
		* 
		* @param 	callback
			
				if(mc==null) continue;
				if(mc.visible==false) continue;
					callBackOrSetProperty( callback, mc, 'y', yPos );
					var mc_bounds:Rectangle = mc.getBounds( mc );
					callBackOrSetProperty( callback, mc, 'y', yPos + mc.y - mc_bounds.top );
		
		static private function callBackOrSetProperty( callback:Function, obj:Object, prop:String, value:* ):void {
			if(callback is Function) {
				callback.call( null, obj, value );
			} else {
				obj[prop] = value;
			}
		}
				if(mc==null) continue;
				if(mc.visible==false) continue;
				if(mc is Component) {
					callBackOrSetProperty( callback, mc, 'x', xPos );
					xPos += mc.width + spacing;
				} else {
					var mc_bounds:Rectangle = mc.getBounds( mc );
					callBackOrSetProperty( callback, mc, 'x', xPos + mc.x - mc_bounds.left);
					xPos += mc_bounds.width + spacing;
				}