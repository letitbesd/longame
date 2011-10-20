package com.longame.modules.scenes
{
	import com.longame.display.graphics.IFill;
	import com.longame.display.graphics.IStroke;
	import com.longame.modules.entities.display.primitive.AbstractPrimitive;
	import com.longame.modules.scenes.utils.DrawingUtil;
	
	import flash.display.Graphics;
	import flash.geom.Vector3D;

	/**
	 * 显示场景的坐标原点，一般用作编辑状态
	 */
	public class SceneOrigin extends AbstractPrimitive
	{
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var pt0:Vector3D =SceneManager.sceneToScreen(new Vector3D(-1 * axisLength, 0, 0));
			var ptM:Vector3D;
			var pt1:Vector3D = SceneManager.sceneToScreen(new Vector3D(axisLength, 0, 0));
			
			var g:Graphics = container.graphics;
			g.clear();
			
			//draw x-axis
			var stroke:IStroke = IStroke(strokes[0]);
			var fill:IFill = IFill(fills[0]);
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g);
			DrawingUtil.drawIsoArrow(g, new Vector3D(-1 * axisLength, 0), 180, arrowLength, arrowWidth);
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			DrawingUtil.drawIsoArrow(g, new Vector3D(axisLength, 0), 0, arrowLength, arrowWidth);
			fill.end(g);
			
			//draw y-axis
			stroke = IStroke(strokes[1]);
			fill = IFill(fills[1]);
			
			pt0 = SceneManager.sceneToScreen(new Vector3D(0, -1 * axisLength, 0));
			pt1 = SceneManager.sceneToScreen(new Vector3D(0, axisLength, 0));
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g)
			DrawingUtil.drawIsoArrow(g, new Vector3D(0, -1 * axisLength), 270, arrowLength, arrowWidth);
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			DrawingUtil.drawIsoArrow(g, new Vector3D(0, axisLength), 90, arrowLength, arrowWidth);
			fill.end(g);
			
			//draw z-axis
			stroke = IStroke(strokes[2]);
			fill = IFill(fills[2]);
			
			pt0 = SceneManager.sceneToScreen(new Vector3D(0, 0, -1 * axisLength));
			pt1 = SceneManager.sceneToScreen(new Vector3D(0, 0, axisLength));
			
			stroke.apply(g);
			g.moveTo(pt0.x, pt0.y);
			g.lineTo(pt1.x, pt1.y);
			
			g.lineStyle(0, 0, 0);
			g.moveTo(pt0.x, pt0.y);
			fill.begin(g)
			DrawingUtil.drawIsoArrow(g, new Vector3D(0, 0, axisLength), 90, arrowLength, arrowWidth,"xz");
			fill.end(g);
			
			g.moveTo(pt1.x, pt1.y);
			fill.begin(g);
			DrawingUtil.drawIsoArrow(g, new Vector3D(0, 0, -1 * axisLength), 270, arrowLength, arrowWidth, "yz");
			fill.end(g);
		}
		
		/**
		 * The length of each axis (not including the arrows).
		 */
		public var axisLength:Number = 100;
		
		/**
		 * The arrow length for each arrow found on each axis.
		 */
		public var arrowLength:Number = 20;
		
		/**
		 * The arrow width for each arrow found on each axis. 
		 * This is the total width of the arrow at the base.
		 */
		public var arrowWidth:Number = 3;
		
		/**
		 * Constructor
		 */
		public function SceneOrigin (id:String=null)
		{
			super(id);
			this._includeInLayout=false;
			this._walkable=false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width (value:Number):void
		{
			super.width = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set length (value:Number):void
		{
			super.length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height (value:Number):void
		{
			super.height = 0;
		}
	}
}