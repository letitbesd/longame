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

		public function get initializing():Boolean {
			return _initializing;
		}
			if(_disposed) return;
			_disposed=true;
			this.doDispose();
		{
			if(this.parent) this.parent.removeChild(this);
			while(this.numChildren){
				this.destroyChild(this.getChildAt(0));
			}
			//to be inherited
		}
		protected var _disposed:Boolean;
		{
			return _disposed;
		}
		 * <code>
		 * 
		 * 	   label: "X", 
		 * 	   click: doClose,
		 * 	   alignH: "right -10",
		 * 	   y: 10
		 * 	 }
		 * </code>
		 * 
		 * @see BaseClip.LogFunction
				LogFunction.apply( this, args );
			}
		 * Function called by the log method
		 * 
		 * Default is trace.
		 * 
		 * For browser console try:
		 * 
		 * <code>
		 *   BaseClip.LogFunction = Console.Log;
		 * </code>
		
		protected var ed:Function = eventDelegate;