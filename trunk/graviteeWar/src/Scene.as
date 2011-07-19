package
{
	import AMath.AVector;
	
	import com.heros.Hero;
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
		private var _counter:TextField=new TextField();
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
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
			var format:TextFormat=new TextFormat(null,30,0x00ff00,true);
			_counter.defaultTextFormat=format;
			//自动根据文字设定宽度，以显示全部文字
			_counter.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(_counter);
			_counter.filters=[new GlowFilter(0x00ff00,0.6,10,10,6,3)];
			_counter.selectable=false;
			this.addChild(_counter);
			var count:CountDown=new CountDown(100);
			count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
			count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
			count.start();
			FightSignals.turnNextHero.add(turnNextHero);
		}
		
		private function onComplete(event:Event):void
		{
			// TODO Auto-generated method stub
		}
		
		private function onSecond(event:CountdownEvent):void
		{
			//			trace("还剩下： "+event.secondLeft);
			_counter.text="还剩下： "+event.secondLeft;
		}
		private function turnNextHero(index:int):void
		{
			sceneHeros[index].deactive();
			var nextIndex:int=index+1;
			if(nextIndex>2){
				nextIndex=0;
			}
			sceneHeros[nextIndex].active();
			
		}
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
		}
		private function addPlanet(p:Point):void
		{
			var _planet:Planet=new Planet();
			this.addChild(_planet);
			planets.push(_planet);
			_planet.x=p.x;
			_planet.y=p.y
		}
	}
}