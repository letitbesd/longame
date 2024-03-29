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
	import flash.geom.Matrix;

	public class ReflectionEffect extends BitmapEffect
	{
		public var heightPercentage:int = 60;
		// --------------------------------------------------------------
		// public methods
		// --------------------------------------------------------------
		
		public function ReflectionEffect(heightPercentage:int=60)
		{
			this.heightPercentage = heightPercentage;
			// call inherited contructor
			super();
		}
		
		public override function apply(data:BitmapData, index:int = 0, count:int=1):BitmapData
		{
			
			var frameBitmap:Bitmap = new Bitmap(data);

			// flip vertically
			var matrix:Matrix = new Matrix;
			matrix.scale(1,-1);
			matrix.translate(0,data.height);
			
			// draw onto new canvas
			var bitmapData:BitmapData = new BitmapData(data.width,(data.height/100)*heightPercentage);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(frameBitmap,matrix);
						
			// implement transparency
			for (var r:int=0; r<bitmapData.height; r++)
			{
				var rowFactor:Number = 1 - (r / bitmapData.height);
				for (var j:int = 0; j <bitmapData.width; j++) {
					var pixelColor:uint = bitmapData.getPixel32(j, r);
					var pixelAlpha:uint = pixelColor>>>24;
					var pixelRGB:uint = pixelColor & 0xffffff;
					var resultAlpha:uint = pixelAlpha * rowFactor;
					bitmapData.setPixel32(j, r, resultAlpha <<24 | pixelRGB);
				}			
			}
			
			return bitmapData;
		}
		
		// --------------------------------------------------------------
		// private and protected properties
		// --------------------------------------------------------------
		
		
	}
}