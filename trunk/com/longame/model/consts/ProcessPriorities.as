/*
Copyright 2009, Eric Smith. All rights reserved.
This work is subject to the terms in the software agreement that was issued with the Citrus Engine product.
*/
package  com.longame.model.consts
{
	/**
	 * This class is used for implementing the <code>tickPriority</code> property of the <code>ITickedComponent</code>.
	 * The different values in this class specify the relative position in which the <code>ITickedComponent</code>'s 
	 * <code>onTick()</code> method will fire.
	 */
	public class ProcessPriorities
	{
		/**
		 * This is used for all "advance" type processing of machines and components, such as moving a character,
		 * performing AI, etc.
		 */
		public static const ADVANCE:Number = 4;
		
		/**
		 * This is used for detecting input during each frame.
		 */
		public static const INPUT:Number = 5;
		
		/**
		 * This is used for physics advances by the physics engine.
		 */
		public static const PHYSICS:Number = 6;
	}
}