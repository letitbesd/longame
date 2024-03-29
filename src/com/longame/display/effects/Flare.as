package com.longame.display.effects{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 火焰效果
	 * http://www.project-nya.jp/modules/weblog/details.php?blog_id=1127
	 * */
	public class Flare extends Sprite {
		private var rect:Rectangle;
		private var fire:Rectangle;
		private var flare:BitmapData;
		private var bitmapData:BitmapData;
		private var bitmap:Bitmap;
		private var rPalette:Array;
		private var gPalette:Array;
		private var bPalette:Array;
		private static var point:Point = new Point(0, 0);
		private var speed:Point = new Point(0, -6);
		private var segmentWidth:uint = 8;
		private var segmentHeight:uint=2;
		private var segments:uint = 8;
		private var blur:BlurFilter;
		private var faded:uint = 0;
		public static const COMPLETE:String = Event.COMPLETE;
		
		public function Flare(r:Rectangle) {
			rect = r;
			initialize();
			draw();
		}
		/**
		 * @param speed: 决定火焰向上升起的速度
		 * @param segments:决定火焰单元的数量
		 * @param segmentWidth:  决定火焰单元的宽度
		 * @param segmentHeight:  决定火焰单元的高度，1或2，其他效果不确定
		 * */
		public function setup(speed:uint = 6, segments:uint = 8, segmentWidth:uint = 8, segmentHeight:int=1):void {
			this.speed.y = - speed;
			this.segmentWidth = segmentWidth;
			this.segmentHeight=segmentHeight;
			this.segments = segments;
		}
		private function initialize():void {
			rPalette = new Array();
			gPalette = new Array();
			bPalette = new Array();
			for (var n:uint = 0; n < 256; n++) {
				var luminance:uint = (n < 128) ? n*2 : 0;
				var rgb:Object = HLS2RGB(n*360/256, luminance, 100);
				var color:uint = rgb.r << 16 | rgb.g << 8 | rgb.b;
				rPalette[n] = color;
				gPalette[n] = 0;
				bPalette[n] = 0;
			}
			blur = new BlurFilter(2, 8, 3);
			blendMode = BlendMode.ADD;
		}
		private function draw():void {
//			fire = new Rectangle(0, 0, rect.width, rect.height + 10);
			fire = new Rectangle(0, 0, rect.width*1.1, rect.height*1.1);
			flare = new BitmapData(fire.width, fire.height, false, 0xFF000000);
			bitmapData = new BitmapData(fire.width, fire.height, false, 0xFF000000);
			bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			bitmap.x = - rect.width*0.5;
			bitmap.y = - rect.height;
			var _mask:Shape = new Shape();
			_mask.y = - 16;
			createEggMask(_mask);
			addChild(_mask);
			_mask.filters = [new BlurFilter(16, 16, 3)];
			_mask.cacheAsBitmap = true;
			bitmap.cacheAsBitmap = true;
			bitmap.mask = _mask;
		}
		public function start():void {
			addEventListener(Event.ENTER_FRAME, apply, false, 0, true);
		}
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, apply);
			faded = 0;
			addEventListener(Event.ENTER_FRAME, clear, false, 0, true);
		}
		private function apply(evt:Event):void {
			flare.lock();
			bitmapData.lock();
			for (var n:uint = 0; n < segments; n++) {
//				var px:Number = Math.random()*(rect.width - 20 - unit) + 10;
				var px:Number = Math.random()*(rect.width*0.8 - segmentWidth) + rect.width*0.1;
				var range:Rectangle = new Rectangle(px, rect.height, segmentWidth,segmentHeight)
				flare.fillRect(range, 0xFFFFFF);
			}
			flare.applyFilter(flare, fire, speed, blur);
			bitmapData.paletteMap(flare, rect, point, rPalette, gPalette, bPalette);
			flare.unlock();
			bitmapData.unlock();
		}
		private function clear(evt:Event):void {
			faded ++;
			flare.lock();
			bitmapData.lock();
			flare.applyFilter(flare, fire, speed, blur);
			bitmapData.paletteMap(flare, rect, point, rPalette, gPalette, bPalette);
			if (faded > 20) {
				bitmapData.fillRect(rect, 0x000000);
				removeEventListener(Event.ENTER_FRAME, clear);
				dispatchEvent(new Event(Flare.COMPLETE));
			}
			flare.unlock();
			bitmapData.unlock();
		}
		private function createEggMask(target:Shape):void {
			var w:Number = rect.width;
			var h:Number = rect.height*1.5;
			target.graphics.beginFill(0xFFFFFF);
			target.graphics.moveTo(-w*0.5, -h*0.2);
			target.graphics.curveTo(-w*0.4, -h, 0, -h);
			target.graphics.curveTo(w*0.4, -h, w*0.5, -h*0.2);
			target.graphics.curveTo(w*0.5, 0, 0, 0);
			target.graphics.curveTo(-w*0.5, 0, -w*0.5, -h*0.2);
			target.graphics.endFill();
		}
		private function HLS2RGB(h:Number, l:Number, s:Number):Object{
			var max:Number;
			var min:Number;
			h = (h < 0)? h % 360+360 : (h>=360)? h%360: h;
			l = (l < 0)? 0 : (l > 100)? 100 : l;
			s = (s < 0)? 0 : (s > 100)? 100 : s;
			l *= 0.01;
			s *= 0.01;
			if (s == 0) {
				var val:Number = l*255;
				return {r:val, g:val, b:val}
			}
			if (l < 0.5) {
				max = l*(1 + s)*255;
			} else {
				max = (l*(1 - s) + s)*255;
			}
			min = (2*l)*255 - max;
			return _hMinMax2RGB(h, min, max);
		}
		private function _hMinMax2RGB(h:Number, min:Number, max:Number):Object{
			var r:Number;
			var g:Number;
			var b:Number;
			var area:Number = Math.floor(h/60);
			switch(area){
				case 0:
					r = max;
					g = min + h * (max - min)/60;
					b = min;
					break;
				case 1:
					r = max - (h - 60)*(max - min)/60;
					g = max;
					b = min;
					break;
				case 2:
					r = min ;
					g = max;
					b = min + (h - 120)*(max - min)/60;
					break;
				case 3:
					r = min;
					g = max - (h - 180)*(max - min)/60;
					b =max;
					break;
				case 4:
					r = min + (h - 240)*(max - min)/60;
					g = min;
					b = max;
					break;
				case 5:
					r = max;
					g = min;
					b = max - (h - 300)*(max - min)/60;
					break;
				case 6:
					r = max;
					g = min + h*(max - min)/60;
					b = min;
					break;
			}
			r = Math.min(255, Math.max(0, Math.round(r)));
			g = Math.min(255, Math.max(0, Math.round(g)));
			b = Math.min(255, Math.max(0, Math.round(b)));
			return {r:r, g:g, b:b}
		}
		
	}
}

