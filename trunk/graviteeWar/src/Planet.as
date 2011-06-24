package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Planet extends Sprite
	{
//		public static const radius:Number=75;
		
		public static const basicRadius:Number=50;
		
		public static const basicG:Number=0.2;
		
		private var G:Number=basicG;
		
//		private var content:MovieClip;
		private var maskBd:BitmapData;
		private var maskLayer:Bitmap;
		private var holeLayer:Sprite;
		private var backLayer:MovieClip;
		
		
		public function Planet()
		{
			super();
			
			this.blendMode=BlendMode.LAYER;
			
			
//			var i:int=1+Math.floor(Math.random()*7);
			var i:int=8;
			//加背景
			backLayer=Main.getMovieClip("planet"+i);
			this.addChild(backLayer);
			//加hole层
			holeLayer=new Sprite();
			this.addChild(holeLayer);
			//加遮罩
			maskLayer=new Bitmap();
			Main.scene.addChild(maskLayer);
//			maskBd=new BitmapData(100,100,true,0xffffff);
//			maskLayer.bitmapData=maskBd;
			this.updateMask();
			
			maskLayer.x=100;
			maskLayer.y=100;
			
			holeLayer.mask=maskLayer;
			
			
			this.radius=60+Math.round(20*Math.random());
		}
		private var _radius:Number;
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(value:Number):void
		{
			if(_radius==value) return;
			_radius=value;
			var scale:Number=_radius/basicRadius;
			backLayer.scaleX=backLayer.scaleY=scale;
//			maskLayer.scaleX=maskLayer.scaleY=scale;
			G=basicG*scale*scale*scale;
			
			this.updateMask();
		}
		public function getG(x:Number,y:Number):Point
		{
			var g:Point=new Point();
			var dx:Number=x-this.x;
			var dy:Number=y-this.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			var r:Number=dist/radius;
			var gLength:Number=G/r*r;
			
			var angle:Number=Math.atan(dy/dx);
			if(x<this.x) angle+=Math.PI;
            angle+=Math.PI;
			g.x=gLength*Math.cos(angle);
			g.y=gLength*Math.sin(angle);
			
			return g;
		}
		/**
		 * 添加弹孔
		 * @param x: 弹孔中心的x坐标
		 * @param y: 弹孔中心的y坐标
		 * */
		public function addHole(x:Number,y:Number):void
		{
			//把子弹的全局坐标转换到holeLayer的坐标系下
			var p:Point=new Point(x,y);
			p=this.holeLayer.globalToLocal(p);
			var hole:MovieClip=Main.getMovieClip("hole");
			this.holeLayer.addChild(hole);
			hole.x=p.x;
			hole.y=p.y;
			
			this.updateMask();
		}
		
		private function updateMask():void
		{
			maskBd=new BitmapData(this.width,this.height,true,0xffffff);
			maskLayer.bitmapData=maskBd;
			var mar:Matrix=new Matrix();
			mar.tx=this.width/2;
			mar.ty=this.height/2;
			mar.scale(backLayer.scaleX,backLayer.scaleY);
			maskBd.draw(this,mar);
		}
	}
}