package com
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
	import com.time.GameCounter;
	import com.weapons.WepPanel;
	
	import flash.display.Loader;
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

	public class Scene extends Sprite implements IFrameObject
	{
		public static const planetPositions:Array=[new Point(330,388),new Point(155,158),new Point(550,178),new Point(330,100)];
		private static var _G:Number = 30;
		public static var planets:Array=[];
		public static var lightnings:Array=[];
		public static var pathCanvas:Shape=new Shape();
		public var midLayer:Sprite;
		private  var hero:Hero;
		private var hero1:Hero;
		private var  hero2 :Hero;
		public static var sceneHeros:Array=[];
		private var _counter:GameCounter;
		private var _counterColor:String;
		private var _counterOn:Boolean;
		private var _currentIndex:int=0;//当前攻击英雄
		public var bg:MovieClip;
		private var directions:Array=[];
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
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
					var pos:Point=p.parent.localToGlobal(new Point(p.x,p.y));
					_loc_3 = new AVector(pos.x - _loc_6.x, pos.y - _loc_6.y);
					var distance:Number = MathUtil.getDistance(_loc_6.x, _loc_6.y, pos.x, pos.y);
					if(distance < p.radius){  
						distance = p.radius;
					}
					_loc_3.multiplyScalar(1 / distance);
					if(distance > p.radius){
						_loc_3.multiplyScalar(_G * 120 * p.mass / (distance*distance));
					}
					if(distance>p.radius+150){
						_loc_3.x=0;
						_loc_3.y=0;
					}
					_loc_1.add(_loc_3);
			}
			return _loc_1;
				
		}
	
		protected function onAdded(event:Event):void
		{
			bg=AssetsLibrary.getMovieClip("background");
			this.addChild(bg);
			midLayer=new Sprite();
			for each(var p:Point in planetPositions){
				this.addPlanet(p);
			}
			this.addChild(midLayer);
			this.addHero();
			this.addChild(pathCanvas);
			this.addWepPanel();
			EnterFrame.addObject(this);
			FightSignals.turnNextHero.add(turnNextHero);
			FightSignals.heroDead.add(removeHero);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		//添加英雄
		private function addHero():void
		{
			hero=new Hero("red");
			hero1=new Hero("blue");
			hero2 = new Hero("yellow");
			midLayer.addChild(hero);
			midLayer.addChild(hero1);
			midLayer.addChild(hero2);
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
		private function removeHero(heroIndex:int):void
		{
		   if(sceneHeros[heroIndex].parent)  sceneHeros[heroIndex].parent.removeChild(sceneHeros[heroIndex]);
		   sceneHeros.splice(heroIndex,1);
		   //更新index
		   for each (var h:Hero in sceneHeros){
		   	 h.index=sceneHeros.indexOf(h)
		   }
		}
		
		private function addWepPanel():void
		{
			var _wepPanel:WepPanel=new WepPanel();
			_wepPanel.x=660;
			_wepPanel.y=460;
			this.addChild(_wepPanel);
			
		} 
		//添加星球
		private function addPlanet(p:Point):void
		{
			var _planet:Planet=new Planet();
			midLayer.addChild(_planet);
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
			if(this._counter == null)
			{
				this._counter=new GameCounter(_currentIndex,teamIndex);
				this._counter.mouseChildren=false;
				this._counter.mouseEnabled=false;
				this.addChild(_counter);
				_counter.colorIndex=teamIndex;
			}else{
				
				_counter.colorIndex = teamIndex;
				_counter.currentHeroIndex = _currentIndex;
			}
		}
		private function turnNextHero(index:int,isFire:Boolean):void
		{
			//如果当前HERO开火，撤退时间4秒，不开火则轮到下一个HERO
			if(isFire){
				this._counter.retreat();
			}else{
				this.changeHeroState(index);			
			}
		}
		private function changeHeroState(heroIndex:int):void
		{
			sceneHeros[heroIndex].deactive();
			sceneHeros[heroIndex].isTurn=false;
			var nextIndex:int=heroIndex+1;
			if(nextIndex>sceneHeros.length-1){
				nextIndex=0;
			}
			if(sceneHeros[nextIndex].isDead==true){
				this.turnNextHero(nextIndex,false)
			}else{
				FightSignals.roundEnd.dispatch();
				sceneHeros[nextIndex].active();
				sceneHeros[nextIndex].isTurn=true;
				sceneHeros[nextIndex].changeWep(1);
				this._currentIndex=sceneHeros[nextIndex].index;
				this.counterColor=sceneHeros[nextIndex].team;
			}
		}
		private function onKeyDown(evt:KeyboardEvent):void
		{
			var pos:Point=hero.parent.localToGlobal(new Point(hero.x,hero.y));
//			trace(pos,hero.x,hero.y);
			if(evt.keyCode==Keyboard.A)
			{
			  directions[0]=true;
			}
			if(evt.keyCode==Keyboard.D)
			{
				directions[1]=true;
			}
			if(evt.keyCode==Keyboard.W)
			{
				directions[2]=true;
			}
			if(evt.keyCode==Keyboard.S)
			{
				directions[3]=true;
			}
		}
		private function onKeyUp(evt:KeyboardEvent):void
		{
			if(evt.keyCode==Keyboard.A)
			{
				directions[0]=false;
			}
			if(evt.keyCode==Keyboard.D)
			{
				directions[1]=false;
			}
			if(evt.keyCode==Keyboard.W)
			{
				directions[2]=false;
			}
			if(evt.keyCode==Keyboard.S)
			{
				directions[3]=false;
			}
		}
		public function onFrame():void
		{
			if(directions[0]==true){
			   midLayer.x+=3;
			}
			if(directions[1]==true){
				midLayer.x-=3;
			}
			if(directions[2]==true){
				midLayer.y+=3;
			}
			if(directions[3]==true){
				midLayer.y-=3;
			}
		}
		
	}
}