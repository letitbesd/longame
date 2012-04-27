package com.longame.game.scene.transformation
{
	import flash.geom.Vector3D;

	/**
	 * @private
	 */
	public class IsometricTransformation implements ISpaceTransformation
	{
		public function IsometricTransformation ()
		{
			cosTheta = Math.cos(30 * Math.PI / 180);
			sinTheta = Math.sin(30 * Math.PI / 180);
		}
		
		private var cosTheta:Number;
		private var sinTheta:Number;
		
		//TODO jwopitz: Figure out the proper conversion - http://www.compuphase.com/axometr.htm
		
		/**
		 * @inheritDoc
		 */
		public function screenToSpace (p:Vector3D):Vector3D
		{
			var z:Number = p.z;
			var y:Number = p.y - p.x / (2 * cosTheta) + p.z;
			var x:Number = p.x / (2 * cosTheta) + p.y + p.z;
			
			/* if (bAxonometricAxesProjection)
			{
				x = x / axialProjection;
				y = y / axialProjection;
			} */
			
			return new Vector3D(x, y, z);
		}
		
		/**
		 * @inheritDoc
		 */
		public function spaceToScreen (p:Vector3D):Vector3D
		{
			/* if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			} */		
			
			var z:Number = p.z;
			var y:Number = (p.x + p.y) * sinTheta - p.z;
			var x:Number = (p.x - p.y) * cosTheta;
			
			return new Vector3D(x, y, z);
		}
		
	}
}