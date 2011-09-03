package view.scene.entitles.missiles
{
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.scene.entitles.PathNode;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.Hero;
/**
 * 不爆炸子弹，不能击飞HERO，狙击枪，飞镖
 * */
	public class NonexplosibleMisslie extends MissileBase
	{
		private var _hitHeroIndex:int;
		/**
		 * 武器是否具有毒性
		 * */
		private var _isPoisononus:Boolean;
		public function NonexplosibleMisslie(path:Vector.<PathNode>, targetPlanet:Planet, id:int,hitHeroIndex:int,isPoisonous:Boolean=false)
		{
			super(path, targetPlanet, id);
			this._hitHeroIndex=hitHeroIndex;
			this._isPoisononus=isPoisonous;
		}
		override public function destroy():void
		{
			//如果击中HERO,发送信号
			if(this._hitHeroIndex>-1){
				this.sendSignal();
			}
			this.scene.remove(this);
		}
		private function sendSignal():void
		{
			for each(var h:Hero in BattleScene.sceneHeros)
			{
				if(h.heroIndex==this._hitHeroIndex)
				{
					//将子弹坐标系转到HERO坐标系下
					var missilePos:Vector3D=h.globalToLocal(new Point(this.x,this.y));
					var heroMidPos:Point=new Point(0-16);
//					var an:Number=Math.atan2((missilePos.y-heroMidPos.y),(missilePos.x-heroMidPos.x));
					FightSignals.onHeroHitted.dispatch(h.heroIndex,0,h.y>h.currentPlanet.y,missilePos.y<heroMidPos.y);
					//如果武器具有毒性，发送英雄中毒信号
					if(this._isPoisononus==true){
						FightSignals.heroPoisoned.dispatch(this._hitHeroIndex);
					}
				}
			}
		}
	}
}