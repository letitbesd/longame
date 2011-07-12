package
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import signals.FightSignals;
	
	import time.CountdownEvent;
	import time.EnterFrame;
	
	public class Missile extends Sprite implements IFrameObject
	{
		private var path:Vector.<PathNode>;
		private var _content:MovieClip;
		
		private var _targetPlanet:Planet;
		
		public function Missile(path:Vector.<PathNode>,targetPlanet:Planet)
		{
			super();
			this.path=path;
			this._targetPlanet=targetPlanet;
			_content=AssetsLibrary.getMovieClip("missile");
			this.addChild(_content);
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		public function onFrame():void
		{
		   if(path.length==0){
			   this.destroy();
			   return;
		   }
           var node:PathNode=path.shift();
		   this.x=node.x;
		   this.y=node.y;
		   this.rotation=node.rotation;
		}
		public function destroy():void
		{
			if(_targetPlanet){
				_targetPlanet.addHole(this.x,this.y);
			}
			if(this.parent) this.parent.removeChild(this);
			EnterFrame.removeObject(this);
			PlayOnceObject.play("explodeEffect",this.x,this.y);
			this.fire.destroy();
		}
		private var fire:MissileFire;
		protected function onAdded(event:Event):void
		{
			EnterFrame.addObject(this);
			fire=new MissileFire(this);
			Main.scene.addChild(fire);
		}
		public function getFireStartPoint():Point
		{
			return this._content.localToGlobal(new Point(_content.fireContainer.x,_content.fireContainer.y));
		}
	}
}