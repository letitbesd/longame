package com.longame.modules.entities.display.primitive
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	
	import com.longame.display.graphics.IStroke;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.modules.scenes.utils.DrawingUtil;
	
	/**
	 * @private
	 */
	public class LGHexGrid extends LGGrid
	{
		public function LGHexGrid (id:String)
		{
			super(id);
			this._walkable=true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics = container.graphics;
			g.clear();
			
			var stroke:IStroke = IStroke(strokes[0]);
			if (stroke)
				stroke.apply(g);
			
			var pt:Vector3D;
			var pts:Array = generatePts();
			for each (pt in pts)
				drawHexagon(pt, g);
		}
		
		private function generatePts ():Array
		{
			var pt:Vector3D;
			var pts:Array = [];
			
			var xOffset:Number = tileSize * Math.cos(Math.PI / 3);
			var yOffset:Number = tileSize * Math.sin(Math.PI / 3);
			
			var i:uint;
			var m:uint = uint(gridSize[0]);
			
			var j:uint;
			var n:uint = uint(gridSize[1]);
			while (j < n)
			{
				i = 0;
				
				while (i < m)
				{
					pt = new Vector3D();
					pt.x = i * (tileSize + xOffset);
					pt.y = j * yOffset * 2;
					if (i % 2 > 0)
						pt.y += yOffset;
					
					pts.push(pt);
					
					i++;
				}
				
				j++;
			}
			
			return pts;
		}
		
		private function drawHexagon (startPt:Vector3D, g:Graphics):void
		{
			var pt0:Vector3D = Vector3D(startPt.clone());
			var pt1:Vector3D = DrawingUtil.polarVector3d(pt0, tileSize, 0);
			var pt2:Vector3D = DrawingUtil.polarVector3d(pt1, tileSize, Math.PI / 3);
			var pt3:Vector3D = DrawingUtil.polarVector3d(pt2, tileSize, 2 * Math.PI / 3);
			var pt4:Vector3D = DrawingUtil.polarVector3d(pt3, tileSize, Math.PI);
			var pt5:Vector3D = DrawingUtil.polarVector3d(pt4, tileSize, 4 * Math.PI / 3);
			
			var pt:Vector3D;
			var pts:Array = new Array(pt0, pt1, pt2, pt3, pt4, pt5);
			
			for each (pt in pts)
				SceneManager.sceneToScreen(pt);
			
			g.beginFill(0, 0);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			g.lineTo(pt2.x, pt2.y);
			g.lineTo(pt3.x, pt3.y);
			g.lineTo(pt4.x, pt4.y);
			g.lineTo(pt5.x, pt5.y);
			g.lineTo(pt0.x, pt0.y);
			g.endFill();
		}
	}
}