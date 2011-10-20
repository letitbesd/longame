package com.longame.modules.scenes.transformations
{
	import flash.geom.Vector3D;

	/**
	 * The default orthogonal transformation objec
	 */
	public class OrthogonalTransformation implements ISpaceTransformation
	{
		
		/**
		 * Constructor
		 * 
		 */
		public function OrthogonalTransformation ()
		{
		}
		
		private var radians:Number;
		private var ratio:Number = 2;
		
		private var axialProjection:Number = Math.cos(Math.atan(0.5));
		
		/**
		 * @inheritDoc
		 */
		public function screenToSpace (p:Vector3D):Vector3D
		{
			return p.clone();
		}
		
		/**
		 * @inheritDoc
		 */
		public function spaceToScreen (p:Vector3D):Vector3D
		{
			return p.clone();
		}
	}
}