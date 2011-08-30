package com.missiles
{
	
	import com.PathNode;
	import com.Planet;
	import com.Scene;
	import com.heros.Hero;
	import com.signals.FightSignals;
	import com.time.EnterFrame;
	import flash.events.Event;
	import flash.geom.Point;
	public class NonexplosibleMisslie extends MissileBase
	{
		private var _hitHeroIndex:int;
		private var _isPoisononus:Boolean;
		public function NonexplosibleMisslie(path:Vector.<PathNode>, targetPlanet:Planet, id:int,hitHeroIndex:int,isPoisonous:Boolean=false)
		{
			super(path, targetPlanet, id);
			this._hitHeroIndex=hitHeroIndex;
			this._isPoisononus=isPoisonous;
		}
		override public function destroy():void
		{
			this.carAngle();
			if(this.parent) this.parent.removeChild(this);
			EnterFrame.removeObject(this);
		}
		override protected function onAdded(event:Event):void
		{
			EnterFrame.addObject(this);
		}
		private function carAngle():void
		{
			for each(var h:Hero in Scene.sceneHeros)
			{
				if(h.index==this._hitHeroIndex)
				{
					//将子弹坐标系转到HERO坐标系下
					var missilePos:Point=h.globalToLocal(new Point(this.x,this.y));
					var heroMidPos:Point=new Point(0-16);
					var an:Number=Math.atan2((missilePos.y-heroMidPos.y),(missilePos.x-heroMidPos.x));
					FightSignals.onHeroHitted.dispatch(h.index,an,h.y>h._planet.y,missilePos.y<heroMidPos.y);
					if(this._isPoisononus==true){
						FightSignals.heroPoisoned.dispatch(this._hitHeroIndex);
					}
				}
			}
		}
	}
}