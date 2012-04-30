/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.longame.display.effects.bitmapEffect
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	public class ColorizeEffect extends BitmapEffect
	{
		public var red:Array = null;
		public var green:Array = null;
		public var blue:Array = null;
		public var alpha:Array = null;
		
		// --------------------------------------------------------------
		// public methods
		// --------------------------------------------------------------
		
		public function ColorizeEffect(red:Array, green:Array, blue:Array, alpha:Array)
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
			// call inherited contructor
			super();
		}
				
		public override function apply(data:BitmapData, index:int=0, count:int=1):BitmapData
		{			
			// colorize this specific frame bitmap
			var matrix:Array = new Array();
			matrix=matrix.concat(red);// red
			matrix=matrix.concat(green);// green
			matrix=matrix.concat(blue);// blue
			matrix=matrix.concat(alpha);// alpha
			
			// set color filter
			data.lock();
			data.applyFilter(data,data.rect,new Point(0,0), new ColorMatrixFilter(matrix));
			data.unlock();

			// draw this bitmap on a BitmapData object so all effects
			// become rendered as pixels
			return data;
		}
		
		// --------------------------------------------------------------
		// private and protected properties
		// --------------------------------------------------------------
		
		
	}
}