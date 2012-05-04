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
package com.bumpslide.command
{

	import flash.utils.Dictionary;
	[DefaultProperty(name='mappedCommands')]
	
		
		public function set mappedCommands( a:Array ):void {
			for each (var map:* in a) {
				if( map is MapCommand) {
					var m:MapCommand = (map as MapCommand);
					addCommand( m.name,  m.commandClass );
				}
			}
		}  
		
		  