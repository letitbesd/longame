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
			
			var prop:String;
			
			if(merge_props && merge_props.length) {
				for each( prop in merge_props ) {
					try { 
						target[prop] = source[prop];
					} catch (er:Error) {
						//trace( e, e.getStackTrace() );
					}
				}
			} else {
			
				if(not_props==null || -1==not_props.indexOf( prop )) {
				}
			
			}