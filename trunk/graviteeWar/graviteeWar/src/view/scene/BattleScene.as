package view.scene
{
	import AMath.AVector;
	
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.InputManager;
	import com.longame.utils.MathUtil;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import signals.CountDownSignals;
	import signals.FightSignals;
	
	import view.scene.entitles.HeroState;
	import view.scene.entitles.IFrameObject;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;
	import view.ui.components.Counter;

	public class BattleScene extends SceneBase
	{
		public static const planetPositions:Array=[new Point(330,388),new Point(155,158),new Point(550,178)];
		
		private static var _G:Number = 30;
		public static var planets:Array=[];
		public static var pathCanvas:Shape=new Shape();
		
		public static var currentHero:Hero;
		private  var hero:Hero;
		private var hero1:Hero;
		private var  hero2 :Hero;
		public static var sceneHeros:Array=[];  
		private var nextIndex:uint;
		
		public function BattleScene()
		{
			super();
			
			this.container.addChild(AssetsLibrary.getMovieClip("background"));
			
			for each(var p:Point in planetPositions)
			{
				this.addPlanet(p);
			}
			this.addHero();
			this.container.addChild(pathCanvas);
			
			CountDownSignals.completeSignal.add(turnNextHero);
			
			 InputManager.onKeyDown.add(onKeyDown);
			 InputManager.onKeyUp.add(onKeyUp);
		}
		
		private function onKeyDown(key:uint):void
		{
			trace(key);
			if(key == Keyboard.W)
			{
//				this.camera.offsetX
			}else if(Keyboard.A)
			{
				
			}else if(Keyboard.S)
			{
				
			}else if(Keyboard.D)
			{
				
			}
		}
		
		private function onKeyUp(key:uint):void
		{
			// TODO Auto Generated method stub
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		
		//添加星球
		private function addPlanet(p:Point):void
		{
			var _planet:Planet=new Planet();
			this.heroLayer.add(_planet);
			planets.push(_planet);
			_planet.x=p.x;
			_planet.y=p.y
		}
		
		//添加英雄
		private function addHero():void
		{
			hero=new Hero("red");
			hero.isMyTurn = true;
			sceneHeros.push(hero);
			this.heroLayer.add(hero);
			
			hero1=new Hero("blue");
			sceneHeros.push(hero1);
			this.heroLayer.add(hero1);
			hero2 = new Hero("yellow");
			sceneHeros.push(hero2);		
			
			hero.index=sceneHeros.indexOf(hero);
			hero1.index=sceneHeros.indexOf(hero1);
			hero2.index = sceneHeros.indexOf(hero2);
			
			this.heroLayer.add(hero2);		
//			this.counterColor=hero.team;
			
			currentHero = hero;
		}

//        public static function calG(x:Number,y:Number):Point
//		{
//			var g:Point=new Point();
//			var g0:Point;
//			for each(var p:Planet in  planets){
//				g0=p.getG(x,y);
//				g.x+=g0.x;
//				g.y+=g0.y;
//			}
//			return g;
//		}
		
		public static function getAcceleration(x:Number,y:Number) :AVector
		{
			var _loc_3:AVector;
			var _loc_1:AVector = new AVector(0, 0);
			var _loc_6:Point = new Point(x,y);
			for each(var p:Planet in  planets)
			{
					_loc_3 = new AVector(p.x - _loc_6.x, p.y - _loc_6.y);
					var distance:Number = MathUtil.getDistance(_loc_6.x, _loc_6.y, p.x, p.y);
					if(distance < p.radius){  
						distance = p.radius;
					}
					_loc_3.multiplyScalar(1 / distance);
					if(distance > p.radius){
						_loc_3.multiplyScalar(_G * 120 * p.mass / (distance*distance));
					}
					_loc_1.add(_loc_3);
			}
			return _loc_1;
		}
	

		private function turnNextHero():void
		{
			currentHero.state = "";
			nextIndex ++;
			if(nextIndex>2){
				nextIndex=0;
			}
			trace(nextIndex);
			currentHero = sceneHeros[nextIndex];
			sceneHeros[nextIndex].state =  HeroState.NOTAIMING;
		}
	}
}