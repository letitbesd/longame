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
		protected var _html:Boolean = false;
		
		protected var _embedFonts:Boolean = false;
		
		// IGRidItem
		protected var _gridIndex:Number;
		protected var _gridItemData:Number;
		
		
			_embedFonts = (font_embedded != null) ? Boolean( font_embedded ) : Style.LABEL_FONT_EMBEDDED; 
				
				embedFonts = _embedFonts;
			super.draw();
			_textFormat = (tf==null) ? new TextFormat() : ObjectUtil.clone(tf) as TextFormat;
			var h:Number = textField.getBounds(this).height;
			if(maxLines==1) {
				h = textField.getLineMetrics(0).height;
			}
			_padding = Padding.create( p );
			_embedFonts = val;
			if(textField) {
				textField.embedFonts = val;
				textField.antiAliasType = val ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			}
			_gridIndex = n;
			_gridItemData = d;
			text = gridItemData;
		}