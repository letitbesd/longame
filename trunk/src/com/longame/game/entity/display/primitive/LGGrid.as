package com.longame.game.entity.display.primitive
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.longame.display.graphics.IStroke;
	import com.longame.display.graphics.Stroke;
	import com.longame.game.scene.SceneManager;

	/**
	 * IsoGrid provides a display grid in the X-Y plane.
	 */
	public class LGGrid extends AbstractPrimitive
	{
		////////////////////////////////////////////////////
		//	GRID SIZE
		////////////////////////////////////////////////////
		
		private var gSize:Array = [0, 0];
		
		/**
		 * Returns an array containing the width and length of the grid.
		 */
		public function get gridSize ():Array
		{
			return gSize;
		}
		public function get rows():int
		{
			return gSize[0]
		}
		public function get colomns():int
		{
			return gSize[1]
		}
		public function get sizeX():Number
		{
			return this.tileSize*this.gridSize[0]
		}
		public function get sizeY():Number
		{
			return this.tileSize*this.gridSize[1]
		}		
		/**
		 * Sets the number of grid tiles in each direction respectively.
		 * 
		 * @param width The number of tiles along the x-axis.
		 * @param length The number of tiles along the y-axis.
		 * @param height The number of tiles along the z-axis (currently not implemented).
		 */
		public function setGridSize (width:uint, length:uint, height:uint = 0):void
		{
			if (gSize[0] != width || gSize[1] != length || gSize[2] != height)
			{
				gSize = [width, length, height];
				this.width=width*SceneManager.tileSize;
				this.length=length*SceneManager.tileSize;
				this._sizeInvalidated=true;
			}
		}
		////////////////////////////////////////////////////
		//	tile SIZE
		////////////////////////////////////////////////////
		
		private var cSize:Number;
		
		/**
		 * @private
		 */
		public function get tileSize ():Number
		{
			return cSize;
		}
		
		/**
		 * Represents the size of each grid tile.  This value sets both the width, length and height (where applicable) to the same size.
		 */
		public function set tileSize (value:Number):void
		{
			if (value < 2)
				throw new Error("tileSize must be a positive value greater than 2");
				
			if (cSize != value)
			{
				cSize = value;
				this._sizeInvalidated=true;
			}
		}
		////////////////////////////////////////////////////
		//	GRID STYLES
		////////////////////////////////////////////////////
		
		public function get gridlines ():IStroke
		{
			return IStroke(strokes[0]);
		}
		
		public function set gridlines (value:IStroke):void
		{
			strokes = [value];
		}
		
		////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function LGGrid (id:String=null)
		{
			super(id);
			this.gridlines = new Stroke(0, 0xCCCCCC, 0.5);
			this.tileSize =SceneManager.tileSize;
			this.setGridSize(10,10)
			this._includeInLayout=false;
			this._includeInBounds=false;
//			this._walkable=true;
		}
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics =_canvasShape.graphics;
			g.clear();
			
			var stroke:IStroke = IStroke(strokes[0]);
			if (stroke)
				stroke.apply(g);
			
			var pt:Vector3D = new Vector3D();
			
			var i:int;
			var m:int = int(gridSize[0]);
			while (i <= m)
			{
				pt = SceneManager.sceneToScreen(new Vector3D(cSize * i));
				g.moveTo(pt.x, pt.y);
				
				pt = SceneManager.sceneToScreen(new Vector3D(cSize * i, cSize * gridSize[1]));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			i = 0;
			m = int(gridSize[1]);
			while (i <= m)
			{
				pt = SceneManager.sceneToScreen(new Vector3D(0, cSize * i));
				g.moveTo(pt.x, pt.y);
				
				pt = SceneManager.sceneToScreen(new Vector3D(cSize * gridSize[0], cSize * i));
				g.lineTo(pt.x, pt.y);
				
				i++;
			}
			
			//now add the invisible layer to receive mouse events
			pt = SceneManager.sceneToScreen(new Vector3D(0, 0));
			g.moveTo(pt.x, pt.y);
			g.lineStyle(0, 0, 0);
			g.beginFill(0x999999,0);
			
			pt = SceneManager.sceneToScreen(new Vector3D(cSize * gridSize[0], 0));
			g.lineTo(pt.x, pt.y);
			
			pt = SceneManager.sceneToScreen(new Vector3D(cSize * gridSize[0], cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);
			
			pt = SceneManager.sceneToScreen(new Vector3D(0, cSize * gridSize[1]));
			g.lineTo(pt.x, pt.y);
			
			pt = SceneManager.sceneToScreen(new Vector3D(0, 0));
			g.lineTo(pt.x, pt.y);
			g.endFill();
			
		}
		
		protected var tileMap:Array
	}
}