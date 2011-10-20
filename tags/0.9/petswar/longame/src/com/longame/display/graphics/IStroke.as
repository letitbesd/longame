package com.longame.display.graphics
{
	import flash.display.Graphics;
	
	/**
	 * The IStroke interface defines the interface that stroke classes must implement.
	 * 
	 * This is a modified extension of mx.graphics.IStroke interface located in the Flex SDK by Adobe.
	 */
	public interface IStroke
	{
		/**
		 *  Applies the properties to the specified Graphics object.
		 *   
		 *  @param target The Graphics object to apply the properties to.
		 */
		function apply (target:Graphics):void
	}
}