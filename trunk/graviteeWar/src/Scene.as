package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import heros.Hero;
	
	import time.EnterFrame;
	
	public class Scene extends Sprite implements IFrameObject
	{
		public static const planetPositions:Array=[new Point(550,178)];//[new Point(330,388),new Point(155,158),new Point(550,178)];
		
		public static var planets:Array=[];
		
		public static var pathCanvas:Shape=new Shape();
		
		private  var hero:Hero;
		private var enemy:Hero;
		
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		public function onFrame():void
		{
			
		}
        public static function calG(x:Number,y:Number):Point
		{
			var g:Point=new Point();
			var g0:Point;
			for each(var p:Planet in  planets){
				g0=p.getG(x,y);
				g.x+=g0.x;
				g.y+=g0.y;
			}
			return g;
		}
		
		protected function onAdded(event:Event):void
		{
			for each(var p:Point in planetPositions){
				this.addPlanet(p);
			}
			this.addHero();
			this.addEnemies();
			this.addChild(pathCanvas);
			EnterFrame.addObject(this);
//			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		private function addEnemies():void
		{
			// TODO Auto Generated method stub
		}
		private function addHero():void
		{
			hero=new Hero("red");
			this.addChild(hero);
//			hero.x=334;
//			hero.y=305;
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
		
		protected function onMouseMove(event:MouseEvent):void
		{
			calG(event.localX,event.localY);
		}
		
	}
}