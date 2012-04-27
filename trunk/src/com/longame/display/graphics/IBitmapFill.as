package com.longame.display.graphics
{
	import flash.geom.Matrix;
	
	/**
	 * The IBitmapFill interface defines the interface that fill classes utilizing bitmaps must implement.
	 */
	public interface IBitmapFill extends IFill
	{
		/**
		 * The matrix object describing any additional transformations to be applied to the fill.
		 */
		function get matrix ():Matrix;
		
		/**
		 * @private
		 */
		function set matrix (value:Matrix):void;
		
		/**
		 * Flag indicating if the fill is to repeat or stretch.
		 */
		function get repeat ():Boolean;
		
		/**
		 * @private
		 */
		function set repeat (value:Boolean):void;
	}
}