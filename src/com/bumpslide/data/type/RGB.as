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

package com.bumpslide.data.type {

		}

		/**
		 * Interpolate from one color to another. val is 0 to 1.0;
		 */
		public static function interpolate( rgb1:RGB, rgb2:RGB, val:Number ):RGB
		{
			return new RGB( (rgb2.red - rgb1.red ) * val + rgb1.red,  (rgb2.green - rgb1.green ) * val + rgb1.green, (rgb2.blue - rgb1.blue ) * val + rgb1.blue);
		}
	}                    