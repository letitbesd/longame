package  com.longame.display.graphics
{
	import flash.display.Graphics;
	
	/**
	 * The IFill interface defines the interface that fill classes must implement.
	 * 
	 * This is a modified extension of mx.graphics.IFill interface located in the Flex SDK by Adobe.
	 */
	public interface IFill
	{
		/**
		 * Initiates fill logic on target graphics.
		 * 
		 * @param target The target graphics object.
		 */
		function begin (target:Graphics):void;
		
		/**
		 * Completes fill logic on the target graphics.
		 * 
		 * @param target The target graphics object.
		 */
		function end (target:Graphics):void;
		
		/**
		 * Returns an exact copy of this IFill.
		 * 
		 * @returns IFill The clone of this IFill.
		 */
		function clone ():IFill;
	}
}