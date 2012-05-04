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

package com.bumpslide.tween 
		
		/**
		* Ease - uses default Easing (Ease.Default)
		*/
		static public function ease( obj:Object, prop:String, target:*, gain:Number=.15, options:Object=null) : FTween {		
			return FTween.tween( obj, prop, target, Ease.Default, {gain:gain}, options );
		}
		
		/**
		* Tweens object properties using simple ease out
		*/
		static public function easeIn( obj:Object, prop:String, target:*, ramp:Number=.15, options:Object=null) : FTween {		
			return FTween.tween( obj, prop, target, Ease.In, {ramp:ramp}, options );
		}
		
		/**
		* Tweens object properties using  the default ease out, but also eases in the target velocity
		*/
		static public function easeInOut( obj:Object, prop:String, target:*, gain:Number=.15, ramp:Number=.15, options:Object=null) : FTween {		
			return FTween.tween( obj, prop, target, Ease.InOut, {gain:gain, ramp:ramp}, options );
		}
				if(ft!=null) ft.stop();
			
			
			if(_options.maxVelocity>0) {
				if(_velocity>0) {
					_velocity = Math.min( _options.maxVelocity, _velocity );
				} else {
					_velocity = Math.max( -_options.maxVelocity, _velocity );
				}
			}
			
			if(_options.keepRounded) {
				_current = Math.round(_current);
			}
			