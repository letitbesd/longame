package com.longame.game.entity.display.primitive
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import com.longame.display.graphics.IBitmapFill;
	import com.longame.display.graphics.IFill;
	import com.longame.display.graphics.IStroke;
	import com.longame.game.scene.SceneManager;
	import com.longame.model.consts.RenderStyle;
	
	/**
	 * 3D box primitive in isometric space.
	 */
	public class LGBox extends AbstractPrimitive
	{
		/**
		 * Constructor
		 */
		public function LGBox (id:String=null)
		{
			super(id);
		}
		
		override public function set stroke (value:IStroke):void
		{
			strokes = [value, value, value, value, value, value];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function validateGeometry ():Boolean
		{
			return (width <= 0 && length <= 0 && height <= 0) ? false : true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics = container.graphics;
			g.clear();
			
			//all pts are named in following order "x", "y", "z" via rfb = right, front, bottom
			var lbb:Vector3D = SceneManager.sceneToScreen(new Vector3D(0, 0, 0));
			var rbb:Vector3D = SceneManager.sceneToScreen(new Vector3D(width, 0, 0));
			var rfb:Vector3D = SceneManager.sceneToScreen(new Vector3D(width, length, 0));
			var lfb:Vector3D = SceneManager.sceneToScreen(new Vector3D(0, length, 0));
			
			var lbt:Vector3D = SceneManager.sceneToScreen(new Vector3D(0, 0, height));
			var rbt:Vector3D = SceneManager.sceneToScreen(new Vector3D(width, 0, height));
			var rft:Vector3D = SceneManager.sceneToScreen(new Vector3D(width, length, height));
			var lft:Vector3D = SceneManager.sceneToScreen(new Vector3D(0, length, height));
			
			//bottom face
			g.moveTo(lbb.x, lbb.y);
			var fill:IFill = fills.length >= 6 ? IFill(fills[5]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
				fill.begin(g);
			
			var stroke:IStroke = strokes.length >= 6 ? IStroke(strokes[5]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(rbb.x, rbb.y);
			g.lineTo(rfb.x, rfb.y);
			g.lineTo(lfb.x, lfb.y);
			g.lineTo(lbb.x, lbb.y);
			
			if (fill)
				fill.end(g);
				
			//back-left face
			g.moveTo(lbb.x, lbb.y);
			fill = fills.length >= 5 ? IFill(fills[4]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
				fill.begin(g);
			
			stroke = strokes.length >= 5 ? IStroke(strokes[4]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(lfb.x, lfb.y);
			g.lineTo(lft.x, lft.y);
			g.lineTo(lbt.x, lbt.y);
			g.lineTo(lbb.x, lbb.y);
			
			if (fill)
				fill.end(g);
				
			//back-right face
			g.moveTo(lbb.x, lbb.y);
			fill = fills.length >= 4 ? IFill(fills[3]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
				fill.begin(g);
			
			stroke = strokes.length >= 4 ? IStroke(strokes[3]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(rbb.x, rbb.y);
			g.lineTo(rbt.x, rbt.y);
			g.lineTo(lbt.x, lbt.y);
			g.lineTo(lbb.x, lbb.y);
			
			if (fill)
				fill.end(g);
				
			//front-left face
			g.moveTo(lfb.x, lfb.y);
			fill = fills.length >= 3 ? IFill(fills[2]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
			{
				if (fill is IBitmapFill)
				{
					var m:Matrix = IBitmapFill(fill).matrix ? IBitmapFill(fill).matrix : new Matrix();
					m.tx += lfb.x;
					m.ty += lfb.y;
					
					if (!IBitmapFill(fill).repeat)
					{
						//calculate how to stretch fill for face
						//this is not great OOP, sorry folks!
						
						
					}
					
					IBitmapFill(fill).matrix = m;
				}
				
				fill.begin(g);
			}
			
			stroke = strokes.length >= 3 ? IStroke(strokes[2]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(lft.x, lft.y);
			g.lineTo(rft.x, rft.y);
			g.lineTo(rfb.x, rfb.y);
			g.lineTo(lfb.x, lfb.y);
			
			if (fill)
				fill.end(g);
				
			//front-right face
			g.moveTo(rbb.x, rbb.y);
			fill = fills.length >= 2 ? IFill(fills[1]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
			{
				if (fill is IBitmapFill)
				{
					m = IBitmapFill(fill).matrix ? IBitmapFill(fill).matrix : new Matrix();
					m.tx += lfb.x;
					m.ty += lfb.y;
					
					if (!IBitmapFill(fill).repeat)
					{
						//calculate how to stretch fill for face
						//this is not great OOP, sorry folks!
						
						
					}
					
					IBitmapFill(fill).matrix = m;
				}
				
				fill.begin(g);
			}
			
			stroke = strokes.length >= 2 ? IStroke(strokes[1]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(rfb.x, rfb.y);
			g.lineTo(rft.x, rft.y);
			g.lineTo(rbt.x, rbt.y);
			g.lineTo(rbb.x, rbb.y);
			
			if (fill)
				fill.end(g);
				
			//top face
			g.moveTo(lbt.x, lbt.y);
			fill = fills.length >= 1 ? IFill(fills[0]) : DEFAULT_FILL;
			if (fill && _renderStyle != RenderStyle.WIREFRAME)
			{
				if (fill is IBitmapFill)
				{
					m = IBitmapFill(fill).matrix ? IBitmapFill(fill).matrix : new Matrix();
					m.tx += lbt.x;
					m.ty += lbt.y;
					
					if (!IBitmapFill(fill).repeat)
					{
						
					}
					
					IBitmapFill(fill).matrix = m;
				}
				
				fill.begin(g);
			}
			
			stroke = strokes.length >= 1 ? IStroke(strokes[0]) : DEFAULT_STROKE;
			if (stroke)
				stroke.apply(g);
				
			g.lineTo(rbt.x, rbt.y);
			g.lineTo(rft.x, rft.y);
			g.lineTo(lft.x, lft.y);
			g.lineTo(lbt.x, lbt.y);
			
			if (fill)
				fill.end(g);
		}
	}
}