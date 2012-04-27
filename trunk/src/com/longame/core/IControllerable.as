/*
Copyright 2009, Eric Smith. All rights reserved.
This work is subject to the terms in the software agreement that was issued with the Citrus Engine product.
*/
package com.longame.core
{
	/**
	 * Use the IControllerReady interface for cogs that implement keyboard controls.
	 * The IControllerReady interface contains two methods that must be implemented, <code>onStart</code>,
	 *  and <code>onStop</code>. Each method takes the value of the keyCode that was pressed to start or stop
	 * controller input. <code>The onStart()</code> method is called when the key is pressed, and the <code>onStop()</code>
	 * method is called when the key is released.
	 */
	public interface IControllerable
	{
		/**
		 * This method is called by the <code>ControllerCog</code> of a machine whenever a key is pressed.
		 * @param	keyCode The keycode that was pressed to activate this method.
		 */
		function onControlStart(keyCode:int):void;
		
		/**
		 * This method is called by the <code>ControllerCog</code> of a machine whenever a key is released.
		 * @param	keyCode The keycode that was released to activate this method.
		 */
		function onControlEnd(keyCode:int):void;
	}
}