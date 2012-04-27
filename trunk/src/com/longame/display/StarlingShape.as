package com.longame.display
{
	import com.longame.utils.DisplayObjectUtil;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class StarlingShape extends Image
	{
		private var _shape:Shape;
		public function StarlingShape()
		{
			_shape=new Shape();
			var texture:Texture=Texture.fromBitmapData(new BitmapData(100,100,true,0x00ffffff));
			super(texture);
		}
		public function get graphics():Graphics
		{
			if(_shape==null) throw new Error("No shape,no graphics!");
			return _shape.graphics;
		}
		public function draw():void
		{
			//to override here,
			//graphics.clear();
			//graphics.draw();
			var bmd:BitmapData=DisplayObjectUtil.getBitmapData(_shape).bmd;
			var txture:Texture=Texture.fromBitmapData(bmd);
			
			var frame:Rectangle = texture.frame;
			var width:Number  = frame ? frame.width  : texture.width;
			var height:Number = frame ? frame.height : texture.height;
			var pma:Boolean = texture.premultipliedAlpha;
			this.updateVertexData(width, height, 0xffffff, pma);
			this.texture=texture;
			this.readjustSize();
		}
		override public function dispose():void
		{
			_shape=null;
			super.dispose();
		}
	}
}