package com.longame.game.scene.transformation
{
	import flash.geom.Vector3D;
	
	/**
	 * The default isometric transformation object that provides the ideal 2:1 x to y ratio.
	 */
	public class DefaultIsometricTransformation implements ISpaceTransformation
	{
		
		/**
		 * Constructor
		 * 
		 * @param projectValuesToAxonometricAxes A flag indicating whether to compute x, y, z, width, lenght, and height values to the axonometric axes or screen axes.
		 * @param maintainZaxisRatio A flag indicating if the z axis values are to be adjusted to maintain proportions based on the x &amp; axis values. 
		 */
		public function DefaultIsometricTransformation (projectValuesToAxonometricAxes:Boolean = false, maintainZAxisRatio:Boolean = false)
		{
			bAxonometricAxesProjection = projectValuesToAxonometricAxes;
			bMaintainZAxisRatio = maintainZAxisRatio;
		}
		
		private var radians:Number;
		private var ratio:Number = 2;
		
		private var bAxonometricAxesProjection:Boolean;
		private var bMaintainZAxisRatio:Boolean;
		
		private var axialProjection:Number = Math.cos(Math.atan(0.5));
		
		/**
		 * @inheritDoc
		 */
		public function screenToSpace (p:Vector3D):Vector3D
		{
			var z:Number = p.z;
			var y:Number = p.y - p.x / ratio + p.z;
			var x:Number = p.x / ratio + p.y + p.z;
			
			if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
				z = z * axialProjection;
			
			if (bAxonometricAxesProjection)
			{
				x = x / axialProjection;
				y = y / axialProjection;
			}
			
			return new Vector3D(x, y, z);
		}
		
		/**
		 * @inheritDoc
		 */
		public function spaceToScreen (p:Vector3D):Vector3D
		{
			if (!bAxonometricAxesProjection && bMaintainZAxisRatio)
				p.z = p.z / axialProjection;
			
			if (bAxonometricAxesProjection)
			{
				p.x = p.x * axialProjection;
				p.y = p.y * axialProjection;
			}
			
			var z:Number = p.z;
			var y:Number = (p.x + p.y) / ratio - p.z;
			var x:Number = p.x - p.y;
			
			return new Vector3D(x, y, z);
		}
	}
}