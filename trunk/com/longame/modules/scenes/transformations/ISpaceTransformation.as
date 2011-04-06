package com.longame.modules.scenes.transformations
{
	import flash.geom.Vector3D;
	
	/**
	 * The IAxonometric interface defines the methods necessary for transforming coordinates between spacial and screen values.
	 */
	public interface ISpaceTransformation
	{
		/**
		 * Transforms a point from screen coordinates to the equivalent axonometric coordinates.
		 * 
		 * @param screenPt A point in screen coordinates.
		 * 
		 * @return Pt A point whose values are in axonometric space relative to its position on the screen.
		 */
		function screenToSpace (p:Vector3D):Vector3D;
		
		/**
		 * Transforms a point from axonometric coordinates to the equivalent screen coordinates.
		 * 
		 * @param spacePt A point in axonometric coordinates.
		 * 
		 * @return Pt A point whose values are in screen space relative to its position in axonometric space.
		 */
		function spaceToScreen (p:Vector3D):Vector3D;
	}
}