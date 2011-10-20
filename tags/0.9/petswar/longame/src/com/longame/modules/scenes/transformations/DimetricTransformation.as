package com.longame.modules.scenes.transformations
{
	import flash.geom.Vector3D;

	/**
	 * @private
	 */
	public class DimetricTransformation implements ISpaceTransformation
	{
		public function DimetricTransformation ()
		{
		}

		public function screenToSpace (p:Vector3D):Vector3D
		{
			return null;
		}
		
		public function spaceToScreen (p:Vector3D):Vector3D
		{
			/* if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			} */		
			
			var z:Number = p.z;
			var y:Number = p.y / 4 - p.z;
			var x:Number = p.x - p.y / 2;
			
			return new Vector3D(x, y, z);
		}
		
	}
}