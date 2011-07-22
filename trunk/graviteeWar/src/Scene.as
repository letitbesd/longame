package
{
	import AMath.AVector;
	
	import com.heros.Hero;
	import com.heros.HeroBase;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	import com.time.CountDown;
	import com.time.CountdownEvent;
	import com.time.EnterFrame;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	public class Scene extends Sprite implements IFrameObject
	{
		public static const planetPositions:Array=[new Point(330,388),new Point(155,158),new Point(550,178)];
		private static var _G:Number = 30;
		public static var planets:Array=[];
		public static var pathCanvas:Shape=new Shape();
		private  var hero:Hero;
		private var hero1:Hero;
		private var  hero2 :Hero;
		public static var sceneHeros:Array=[];
		private var _counter:MovieClip;
		private var _counterColor:String;
		private var _counterOn:Boolean;
		private var _count:CountDown;
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			_counter = AssetsLibrary.getMovieClip("counter");
		}
		public function onFrame():void
		{
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
	
		protected function onAdded(event:Event):void
		{
			for each(var p:Point in planetPositions){
				this.addPlanet(p);
			}
			this.addHero();
			this.addChild(pathCanvas);
			EnterFrame.addObject(this);
			FightSignals.turnNextHero.add(turnNextHero);
		}
		private function turnNextHero(index:int,isFire:Boolean):void
		{
			//如果当前HERO开火，倒计时还剩4秒，不开火则轮到下一个HERO
			if(isFire){
				_count.reset();
				_count=new CountDown(4);
				_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
				_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
				_count.start();
				setTimeout(this.changeHeroStage,4000,index);
			}else{
				this.changeHeroStage(index);			
			}
		}
		private function changeHeroStage(heroIndex:int):void
		{
			sceneHeros[heroIndex].deactive();
			sceneHeros[heroIndex].isTurn=false;
			var nextIndex:int=heroIndex+1;
			if(nextIndex>2){
				nextIndex=0;
			}
			sceneHeros[nextIndex].active();
			sceneHeros[nextIndex].isTurn=true;
			this.counterColor=sceneHeros[nextIndex].team;
		}
		//添加英雄
		private function addHero():void
		{
			hero=new Hero("red");
			hero1=new Hero("blue");
			hero2 = new Hero("yellow");
			this.addChild(hero);
			this.addChild(hero1);
			this.addChild(hero2);
			sceneHeros.push(hero);
			sceneHeros.push(hero1);
			sceneHeros.push(hero2);
			hero.index=sceneHeros.indexOf(hero);
			hero1.index=sceneHeros.indexOf(hero1);
			hero2.index = sceneHeros.indexOf(hero2);
			hero.active();
			hero.isTurn=true;
			this.counterColor=hero.team;
		}
		//添加星球
		private function addPlanet(p:Point):void
		{
			var _planet:Planet=new Planet();
			this.addChild(_planet);
			planets.push(_planet);
			_planet.x=p.x;
			_planet.y=p.y
		}
		//倒计时器颜色
		public function set counterColor(value:String):void
		{
			_counterColor = value;
			var teamIndex:uint;
			switch(value)
			 {
				case "red": teamIndex=1;
				 break;
				case "blue":  teamIndex=2;
				 break;
				case "green":  teamIndex=3;
				 break;
				case "yellow": teamIndex=4;
				 break;
			 }
			this.addCounter(teamIndex);
		}
		private function addCounter(teamIndex:int):void
		{
			this.addChild(_counter);
			_counter.gotoAndStop(teamIndex);
			if(this._counterOn==true) _count.reset();
			_count=new CountDown(45);
			_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
			_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
			_count.start();
		}
		private function onComplete(event:Event):void
		{
			var currentHeroIndex:int;
			for each(var h:Hero in sceneHeros){
				if(_counterColor==h.team) currentHeroIndex=h.index;
			}
			this.turnNextHero(currentHeroIndex,false);
		}
		
		private function onSecond(event:CountdownEvent):void
		{
			_counter.time.text=String(event.secondLeft);
			this._counterOn=true;
		}

	}
}