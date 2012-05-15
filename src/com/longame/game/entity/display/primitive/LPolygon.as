package  com.longame.game.entity.display.primitive
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	
	import com.longame.display.graphics.IFill;
	import com.longame.display.graphics.IStroke;
	import com.longame.model.consts.RenderStyle;

	/**
	 * polygon primitive in scene space.
	 */
	public class LPolygon extends AbstractPrimitive
	{
		/**
		 * @inheritDoc
		 */
		override protected function validateGeometry ():Boolean
		{
			return pts.length > 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics =_canvasShape.graphics;
			g.clear();
			g.moveTo(pts[0].x, pts[0].y);
			
			var fill:IFill = IFill(fills[0]);
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
				fill.begin(g);
			
			var stroke:IStroke = strokes.length >= 1 ? IStroke(strokes[0]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
			
			var i:uint = 1;
			var l:uint = pts.length;
			while (i < l)
			{
				g.lineTo(pts[i].x, pts[i].y);
				i++;
			}
				
			g.lineTo(pts[0].x, pts[0].y);
			
			if (fill)
				fill.end(g);
		}
		
		////////////////////////////////////////////////////////////////////////
		//	PTS
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		[ArrayElementType("flash.geom.Vector3D")]
		protected var geometryPts:Array = [];
		
		/**
		 * @private
		 */
		public function get pts ():Array
		{
			return geometryPts;
		}
		
		/**
		 * The set of points in isometric space needed to render the polygon.  At least 3 points are needed to render.
		 */
		public function set pts (value:Array):void
		{
			if (geometryPts != value)
			{
				geometryPts = value;
				this._sizeInvalidated=true;
			}
		}
		
		/**
		 * Constructor
		 */
		public function LPolygon (id:String=null)
		{
			super(id);
			this._walkable=true;
			this._height=0;
		}
	}
}