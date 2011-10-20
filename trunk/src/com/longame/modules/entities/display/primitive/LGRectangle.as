package com.longame.modules.entities.display.primitive
{
	import flash.geom.Vector3D;
	
	import com.longame.modules.scenes.SceneManager;

	/**
	 * 3D square primitive in isometric space.
	 */
	public class LGRectangle extends LGPolygon
	{
		/**
		 * @inheritDoc
		 */
		override protected function validateGeometry ():Boolean
		{
			pts = [];
			pts.push(new Vector3D(0, 0, 0));
			
			//width x length
			if (width > 0 && length > 0 && height <= 0)
			{
				pts.push(new Vector3D(width, 0, 0));
				pts.push(new Vector3D(width, length, 0));
				pts.push(new Vector3D(0, length, 0));
			}
			
			//width x height
			else if (width > 0 && length <= 0 && height > 0)
			{
				pts.push(new Vector3D(width, 0, 0));
				pts.push(new Vector3D(width, 0, height));
				pts.push(new Vector3D(0, 0, height));
			}
			
			//length x height
			else if (width <= 0 && length > 0 && height > 0)
			{
				pts.push(new Vector3D(0, length, 0));
				pts.push(new Vector3D(0, length, height));
				pts.push(new Vector3D(0, 0, height));
			}
			
			else
				return false;
				
			var pt:Vector3D;
			for each (pt in pts)
				SceneManager.sceneToScreen(pt);
				
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			super.drawGeometry();
			
			//clean up
			geometryPts = [];
		}
		
		/**
		 * Constructor
		 */
		public function LGRectangle (id:String=null)
		{
			super(id);
			this._walkable=true;
		}
	}
}