package
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
		private var G:Number=basicG;
		public var mass:Number=basicG;
		private var maskBd:BitmapData;
		private var maskLayer:Bitmap;
		private var holeLayer:Sprite;
		private var backLayer:MovieClip;
		private var _attractive_coeff:int=400;
		private var _shooterIndex:int;

		
		public function Planet()
		{
			super();
			this.blendMode=BlendMode.LAYER;
			
			var i:int=1+Math.floor(Math.random()*7);
//			var i:int=8;
			//加星球背景
			backLayer=AssetsLibrary.getMovieClip("planet"+i);
			this.addChild(backLayer);
//	
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
			trace("mass:"+mass);
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
		public function addHole(x:Number,y:Number,shooterIndex:int):void
		{
			//把子弹的全局坐标转换到holeLayer的坐标系下
			var p:Point=new Point(x,y);
			p=this.holeLayer.globalToLocal(p);
			var hole:MovieClip=AssetsLibrary.getMovieClip("hole");
			hole.x=p.x;
			hole.y=p.y;
		
			this._shooterIndex=shooterIndex;
			trace("&***************"+this._shooterIndex);
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
				var cd:Boolean=checkPart.hitTestObject(hero._content);
			if(cd){
//				trace("collisioned : **********"+cd.angleInDegree);
					var heroIndex:int=Scene.sceneHeros.indexOf(hero);
					var holeP:Point=new Point(holeX,holeY);
					//将Hole坐标转换到Hero坐标系下
					var pToHole:Point=hero.globalToLocal(holeP);
					//Hero中心点
					var heroMidPoint:Point=new Point(0,-16);
					//Hole中心点与人物中心点的夹角
					var an:Number=Math.atan2((pToHole.y-heroMidPoint.y),(pToHole.x-heroMidPoint.x));
					var an1:Number=180*an/Math.PI;
					var belowPlanet:Boolean;
					var hitPointAboveMid:Boolean;
					if(hero.y>this.y) belowPlanet=true;
					if(pToHole.y<heroMidPoint.y)   hitPointAboveMid=true;
					trace("Hole与人碰撞角度"+an*180/Math.PI);
					trace(pToHole);
					FightSignals.onHeroHitted.dispatch(heroIndex,an,belowPlanet,hitPointAboveMid,this._shooterIndex);
				  }else{
				  		FightSignals.turnNextHero.dispatch(this._shooterIndex);
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