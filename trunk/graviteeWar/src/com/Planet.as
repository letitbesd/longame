package com
{
	import AMath.*;
	
	import collision.CDK;
	import collision.CollisionData;
	
	import com.heros.Hero;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Planet extends Sprite
	{
		public static const basicRadius:Number=50;
		public static const basicG:Number=0.5;
		public var mass:Number=basicG;
		private var G:Number=basicG;
		private var maskBd:BitmapData;
		private var maskLayer:Bitmap;
		private var holeLayer:Sprite;
		public var backLayer:MovieClip;
		private var _attractive_coeff:int=400;
		private static var _G:Number = 30;
		
		public function Planet()
		{
			super();
			this.blendMode=BlendMode.LAYER;
			var i:int=1+Math.floor(Math.random()*7);
//			var i:int=8;
			//加星球背景
			backLayer=AssetsLibrary.getMovieClip("planet"+i);
			this.addChild(backLayer);
			//加hole层
			holeLayer=new Sprite();
			this.addChild(holeLayer);
			this.radius=60+Math.round(20*Math.random());
			this.filters =[new GlowFilter(0,0.5, 8, 8, 5, 1, true)];
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
//			mass=basicG*scale*scale*scale;
//			mass = 4 / 3 * Math.PI * Math.pow(value, 3);
			this.mass = _radius;
		}
		
		public function getG(x:Number,y:Number):AVector
		{
//			var g:Point=new Point();
//			var dx:Number=x-this.x;
//			var dy:Number=y-this.y;
//			var dist:Number=Math.sqrt(dx*dx+dy*dy);
//			var r:Number=dist/radius;
//			var gLength:Number=G/r*r;
//			
//			var angle:Number=Math.atan(dy/dx);
//			if(x<this.x) angle+=Math.PI;
//            angle+=Math.PI;
//			g.x=gLength*Math.cos(angle);
//			g.y=gLength*Math.sin(angle);
//			return g;
			var _loc_3:AVector;
			var _loc_6:Point = new Point(x,y);
			_loc_3 = new AVector(this.x - _loc_6.x, this.y - _loc_6.y);
			var distance:Number = MathUtil.getDistance(_loc_6.x, _loc_6.y, this.x, this.y);
			if(distance < this.radius){  
				distance = this.radius;
			}
			_loc_3.multiplyScalar(1 / distance);
			if(distance > this.radius){
				_loc_3.multiplyScalar(_G * 120 * this.mass / (distance*distance));
			}
			return _loc_3;
		}
		/**
		 * 添加弹孔
		 * @param x: 弹孔中心的x坐标
		 * @param y: 弹孔中心的y坐标
		 * */
		public function addHole(x:Number,y:Number,scopeStrength:Number):void
		{
			//把子弹的全局坐标转换到holeLayer的坐标系下
			var p:Point=new Point(x,y);
			p=this.holeLayer.globalToLocal(p);
			var hole:MovieClip=AssetsLibrary.getMovieClip("hole");
			hole.x=p.x;
			hole.y=p.y;
			hole.scaleX=hole.scaleY=scopeStrength;
			hole.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.holeLayer.addChild(hole);
		}
		
		protected function onAdded(event:Event):void
		{
			event.target.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			var p:Point=new Point(event.target.x,event.target.y);
			p=this.holeLayer.localToGlobal(p);
			for each(var h:Hero in Scene.sceneHeros)
			{
				this.holeCollisionWithHero(h,p.x,p.y);
			}
		}
		
		private function holeCollisionWithHero(hero:Hero,holeX:Number,holeY:Number):void
		{
//				var p:Point=new Point(hole.x,hole.y);
				var checkPart:Shape = new Shape();
				checkPart.graphics.clear();
				checkPart.graphics.beginFill(0x66ccff,0.1);
				checkPart.graphics.drawCircle(holeX,holeY,27.5);
				checkPart.graphics.endFill();
//				Main.scene.addChild(checkPart);
//				var cd:CollisionData=CDK.check(checkPart,hero);
//				var c:Shape=new Shape();
//				c.graphics.clear();
//				c.graphics.beginFill(0x66ccff,1);
//				c.graphics.drawCircle(holeX,holeY,2);
//				c.graphics.endFill();
//				Main.scene.addChild(c);
				var cd:Boolean=checkPart.hitTestObject(hero._content);
			if(cd){
					var heroIndex:int=Scene.sceneHeros.indexOf(hero);
					var holePos:Point=new Point(holeX,holeY);
					//将Hole坐标转换到Hero坐标系下
					var pToHole:Point=hero.globalToLocal(holePos);
					//Hero中心点
					var heroMidPoint:Point=new Point(0,-15);
					var pos:Point=hero.localToGlobal(heroMidPoint);
					var c1:Shape = new Shape();
					//Hole中心点与人物中心点的夹角
					var an:Number=Math.atan2((pToHole.y-heroMidPoint.y),(pToHole.x-heroMidPoint.x));
					//人物是否在星球下半部分
					var belowPlanet:Boolean;
					var hitPointAboveMid:Boolean;
					if(hero.y>this.y) belowPlanet=true;
					if(pToHole.y<heroMidPoint.y)   hitPointAboveMid=true;
					if(hero.atRight)  an += Math.PI;
					trace(pToHole.x<0);
					trace("Hole与人碰撞角度"+an*180/Math.PI,hitPointAboveMid);		
					FightSignals.onHeroHitted.dispatch(heroIndex,an,belowPlanet,hitPointAboveMid);
				  }
		}
		
		public function getForceAttract (m1:Number, m2:Number, vec2Center:Vector2D):Vector2D
		{
			var numerator:Number = this._attractive_coeff * m1 * m2;
			var denominator:Number = vec2Center.getMagnitude() * vec2Center.getMagnitude();
			var forceMagnitude:Number = numerator / denominator;
			var forceDirection:Number = vec2Center.getAngle();
			if (forceMagnitude > 0) forceMagnitude = Math.min(forceMagnitude, 5);
			var forceX:Number = forceMagnitude * Math.cos(forceDirection);
			var forceY:Number = forceMagnitude * Math.sin(forceDirection);
			var force:Vector2D = new Vector2D(forceX, forceY);
			return force;
		}
	}
}