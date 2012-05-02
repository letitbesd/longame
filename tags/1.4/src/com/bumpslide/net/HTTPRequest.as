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

package com.bumpslide.net 
	import flash.errors.IOError;

	 * This is the grandaddy of all the IRequest implementations. 
	 * 
		protected var _httpStatus:int;
		protected var _dataFormat:String = URLLoaderDataFormat.TEXT;
		
		// don't raise an error on these status codes
		public var acceptedHttpStatus:Array = [0,200];
		
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = _dataFormat;
		/**
		 * Event handlers that can be applied to a URLLoader or a Loader's 
		 * contentLoaderInfo property as is done in the LoaderRequest class.
		 * 
		 * Used in initRequest implementations.
		/**
		 * Called from killRequest to remove the event handlers. 
		 * 
		 * Pulled out to a function so we can use it in the LoaderRequest class. 
			if ( acceptedHttpStatus.indexOf( _httpStatus ) == -1 ) {
				raiseError( new Error( event.toString()  ) );
			} else {
			}
			return _httpStatus;
		}

		public function get dataFormat() : String {
			return _dataFormat;
		}

		public function set dataFormat(dataFormat:String) : void {
			_dataFormat = dataFormat;
		}