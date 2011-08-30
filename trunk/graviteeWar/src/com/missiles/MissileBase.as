package com.missiles
{
	import com.IFrameObject;
	import com.PathNode;
	import com.Planet;
	import com.PlayOnceObject;
	import com.Scene;
	import com.heros.Hero;
	import com.longame.managers.AssetsLibrary;
	import com.signals.FightSignals;
	import com.time.CountdownEvent;
	import com.time.EnterFrame;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MissileBase extends Sprite implements IFrameObject
	{
		private var path:Vector.<PathNode>;
		private var _content:MovieClip;
		protected var _scopeStrength:int;
		protected var _targetPlanet:Planet;
		private var node:PathNode;
		protected var fire:MissileFire;
		private var wepID:int;
		public function MissileBase(path:Vector.<PathNode>,targetPlanet:Planet,id:int,scopeStrength:int=1)
		{
			super();
			if(id==10){
				this.path=path.concat();
			}else{
				this.path=path;
			}	
			this._targetPlanet=targetPlanet;
			_content=AssetsLibrary.getMovieClip("missile"+id);
			_content.scaleX=-1;
			this._scopeStrength=scopeStrength;
			wepID=id;
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		public function onFrame():void
		{
		   if(path.length==0){
			   this.destroy();
			   return;
		   }
           node=path.shift();
		   this.x=node.x;
		   this.y=node.y;
		   this.rotation=node.rotation;
		   this.addChild(_content);
		}
		public function destroy():void
		{
			if(_targetPlanet&&wepID!=2){
				_targetPlanet.addHole(this.x,this.y,this._scopeStrength);
			}
			PlayOnceObject.play("explodeEffect",this.x,this.y);
			this.fire.destroy();
			if(this.parent) this.parent.removeChild(this);
			EnterFrame.removeObject(this);
			if(wepID==2) FightSignals.missileBomded.dispatch(_targetPlanet,node);
			if(wepID==9){
				for each(var h:Hero in Scene.sceneHeros)
				{	
					if(h._planet==_targetPlanet)  FightSignals.heroPoisoned.dispatch(h.index);
				}	
			}
		}	
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