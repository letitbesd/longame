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
	
	import signals.FightSignals;
	
	import view.scene.entitles.IFrameObject;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;
	import view.ui.components.time.CountDown;
	import view.ui.components.time.CountdownEvent;

	public class BattleScene extends SceneBase
	{
		public static const planetPositions:Array=[new Point(330,388),new Point(155,158),new Point(550,178)];
		
		private static var _G:Number = 30;
		public static var planets:Array=[];
		public static var pathCanvas:Shape=new Shape();
		public static var sceneHeros:Array=[];
		protected var currentHero:Hero;
		private  var hero:Hero;
		private var hero1:Hero;
		private var  hero2 :Hero;
		
		public function BattleScene()
		{
			super();
			
			this.container.addChild(AssetsLibrary.getMovieClip("background"));
			
			for each(var p:Point in planetPositions){
				this.addPlanet(p);
			}
			this.addHero();
			this.container.addChild(pathCanvas);
			
			FightSignals.turnNextHero.add(turnNextHero);
			
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
			currentHero = hero;
			sceneHeros.push(hero);
			hero.index=sceneHeros.indexOf(hero);
			this.heroLayer.add(hero);
			
			hero1=new Hero("blue");
			sceneHeros.push(hero1);
			hero1.index=sceneHeros.indexOf(hero1);
			this.heroLayer.add(hero1);
			
			hero2 = new Hero("yellow");
			sceneHeros.push(hero2);		
			hero2.index = sceneHeros.indexOf(hero2);
			this.heroLayer.add(hero2);		
//			this.counterColor=hero.team;
			
			this.currentHero = hero;
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
	

		private function turnNextHero(index:int,isFire:Boolean):void
		{
			//如果当前HERO开火，倒计时还剩4秒，不开火则轮到下一个HERO
			if(isFire){
//				_count.reset();
//				_count=new CountDown(4);
//				_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
//				_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
//				_count.start();
//				setTimeout(this.changeHero,4000,index);
			}else{
				this.changeHero(index);			
			}
		}
		
		private function changeHero(heroIndex:int):void
		{
			sceneHeros[heroIndex].deactive();
			sceneHeros[heroIndex].isTurn=false;
			var nextIndex:int=heroIndex+1;
			if(nextIndex>2){
				nextIndex=0;
			}
			currentHero = sceneHeros[nextIndex];
			sceneHeros[nextIndex].active();
			sceneHeros[nextIndex].isTurn=true;
//			this.counterColor=sceneHeros[nextIndex].team;
		}

		//倒计时器颜色
//		public function set counterColor(value:String):void
//		{
//			_counterColor = value;
//			var teamIndex:uint;
//			switch(value)
//			 {
//				case "red": teamIndex=1;
//				 break;
//				case "blue":  teamIndex=2;
//				 break;
//				case "green":  teamIndex=3;
//				 break;
//				case "yellow": teamIndex=4;
//				 break;
//			 }
//			this.addCounter(teamIndex);
//		}
//		private function addCounter(teamIndex:int):void
//		{
//			this.addChild(_counter);
//			_counter.gotoAndStop(teamIndex);
//			if(this._counterOn==true) _count.reset();
//			_count=new CountDown(45);
//			_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
//			_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
//			_count.start();
//		}
//		private function onComplete(event:Event):void
//		{
//			var currentHeroIndex:int;
//			for each(var h:Hero in sceneHeros){
//				if(_counterColor==h.team) currentHeroIndex=h.index;
//			}
//			this.turnNextHero(currentHeroIndex,false);
//		}
//		
//		private function onSecond(event:CountdownEvent):void
//		{
//			_counter.time.text=String(event.secondLeft);
//			this._counterOn=true;
//		}
		
//		private function initCam():void
//		{
//			
//			var _175b :int = 5000;
//			var _1795 : int;
//			var _177c : int = 5000;
//			var _1797 : int;
//			
//			var _loc_9:Number;
//			var _loc_10:Number;
//			var _loc_11:Number;
//			var _loc_12:Number;
//			var _179b:Number = 1;
//			var _loc_8:int = 0;
//			while (_loc_8 < planets.length)
//			{
//				// label
//				if (planets[_loc_8].x - planets[_loc_8].radius < _175b)
//				{
//					_175b = planets[_loc_8].x - planets[_loc_8].radius;
//				}// end if
//				if (planets[_loc_8].x + planets[_loc_8].radius > _1795)
//				{
//					_1795 = planets[_loc_8].x + planets[_loc_8].radius;
//				}// end if
//				if (planets[_loc_8].y - planets[_loc_8].radius < _177c)
//				{
//					_177c = planets[_loc_8].y - planets[_loc_8].radius;
//				}// end if
//				if (planets[_loc_8].y + planets[_loc_8].radius > _1797)
//				{
//					_1797 = planets[_loc_8].y + planets[_loc_8].radius;
//				}// end if
//				_loc_8++;
//			}// end while
//			_175b = _175b - 50;
//			_177c = _177c - 50;
//			_1795 = _1795 + 50;
//			_1797 = _1797 + 50;
//			_loc_9 = _1795 - _175b;
//			_loc_10 = _1797 - _177c;
//			if (_loc_9 < 700)
//			{
//				_175b = _175b - (700 - _loc_9) / 2;
//				_1795 = _1795 + (700 - _loc_9) / 2;
//			}// end if
//			if (_loc_10 < 500)
//			{
//				_177c = _177c - (500 - _loc_10) / 2;
//				_1797 = _1797 + (500 - _loc_10) / 2;
//			}// end if
//			_loc_9 = _1795 - _175b;
//			_loc_10 = _1797 - _177c;
//			_loc_11 = 700 / _loc_9;
//			_loc_12 = 500 / _loc_10;
//			if (_loc_11 < _loc_12)
//			{
//				_179b = _loc_11;
//			}
//			else
//			{
//				_179b = _loc_12;
//			}// end else if
//			_cam.setTarget(hero.container, _175b, _177c, _1795, _1797);
//			_cam.doMove();
//			this.x = Math.round(_cam.posX);
//			this.y = Math.round(_cam.posY);
//		}
	}
}