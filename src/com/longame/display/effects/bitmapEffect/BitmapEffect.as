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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;

	public class BitmapEffect extends Object
	{

		// --------------------------------------------------------------
		// public methods
		// --------------------------------------------------------------
		
		public function BitmapEffect()
		{
			super();
		}

		/****************************************************************
		 * This method needs to be overriden to apply modification
		 * to a BitmapData object
		 */		
		public function apply(data:BitmapData, index:int=0, count:int=1):BitmapData
		{
			return null;
		}

		// --------------------------------------------------------------
		// private and protected methods
		// --------------------------------------------------------------
		
		/****************************************************************
		 * Use this function to draw a bitmap with filters onto a new bitmapData object
		 * 貌似没用过
		 */		
		protected function drawBitmap(bitmap:Bitmap, bitmapData:BitmapData):BitmapData
		{			
			// create temporary new bitmap object where we can draw bitmap on and fill it with an alpha o  
			var newBitmap:Bitmap = new Bitmap(new BitmapData(bitmapData.width,bitmapData.height,true,0));
			// draw provided bitmap onto this new bitmap.bitmapData so that applied filters are converted to pixels 
			newBitmap.bitmapData.draw(bitmap,null,null,BlendMode.NORMAL);
			// clear provided bitmapData
			bitmapData.fillRect(bitmapData.rect,0);
			// copy new biutmap pixels to provided bitmapData
			bitmapData.copyPixels(newBitmap.bitmapData, newBitmap.bitmapData.rect, new Point(0, 0),null,null,true);
			// dispose temporary new bitmap
			newBitmap.bitmapData.dispose();
			// return altered bitmapData
			return bitmapData;	
		}		
				
	}
}