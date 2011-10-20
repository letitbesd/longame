package com.longame.modules.entities.display.primitive
{
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.display.graphics.IFill;
	import com.longame.display.graphics.IStroke;
	
	/**
	 * The IIsoPrimitive interface defines methods for any IIsoDisplayObject class that is utilizing Flash's drawing API.
	 */
	public interface IPrimitive extends IDisplayRenderer
	{
		//////////////////////////////////////////////////////////////////
		//	STYLES
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get renderStyle ():String;
		
		/**
		 * For IDsiaplayRenderer that make use of Flash's drawing API, it is necessary to develop render logic corresponding to the
		 * varios render style types.
		 * 
		 * @see RenderStyle
		 */
		function set renderStyle (value:String):void;
		
		/**
		 * @private
		 */
		function get fill ():IFill;
		
		/**
		 * The primary fill used to draw the faces of this object.  This overwrites any values in the fills array.
		 */
		function set fill (value:IFill):void;
		
		/**
		 * @private
		 */
		function get fills ():Array;
		
		/**
		 * An array of IFill objects used to apply material fills to the faces of the primitive object.
		 * 
		 * @see as3isolib.graphics.IFill
		 */
		function set fills (value:Array):void;
		
		/**
		 * @private
		 */
		function get stroke ():IStroke;
		
		/**
		 * The primary stroke used to draw the edges of this object.  This overwrites any values in the strokes array.
		 */
		function set stroke (value:IStroke):void;
		
		/**
		 * @private
		 */
		function get strokes ():Array;
		
		/**
		 * An array of IStroke objects used to apply line styles to the face edges of the primitive object.
		 * 
		 * @see as3isolib.graphics.IFill
		 */
		function set strokes (value:Array):void;
	}
}