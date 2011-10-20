package view.scene.entitles.heros.weapons
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.geom.Point;
	
	import signals.FightSignals;
	
	import view.scene.entitles.*;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.ScatterMissile;

	public class Wep2 extends WepBase 
	{
		private var subMissiles:Array=[];
		private var currentPlanet:Planet;
		private var baseSpeed:Array=[40,40,70,70];
		private var vx:Number;
		private var vy:Number;
		private var baseAngle:Number;
		private var an:Number;
		private var initSpeedsX:Array=[];
		private var initSpeedsY:Array=[];
		private var count:int;
		public function Wep2(hero:HeroBase)
		{
			super(hero);
			count=0;
			trace("------------------");
			FightSignals.missileBomded.add(missileScatter);
			this.wepID=2;
		}
		override public function simulatePath(param:Object):void
		{
			super.simulatePath(param);
		}
		override public function shoot():void
		{
			super.shoot();
		}
		private function missileScatter(planet:Planet,lastNode:PathNode):void
		{ 
			this.currentPlanet=planet;
			var angle:Number=lastNode.rotation;
			an=(lastNode.rotation+180)*Math.PI/180;
			if(angle<0) angle+=360;
			for(var i:int=0;i<=3;i++)
			{
				if((i+1)%2==0)
				{
					subMissiles[i]=angle-90;
				}
				else
				{
					subMissiles[i]=angle+90;
				}
				initSpeedsX[i]=Math.cos(subMissiles[i]*Math.PI/180)*baseSpeed[i];
				initSpeedsY[i]=Math.sin(subMissiles[i]*Math.PI/180)*baseSpeed[i];
				initSpeedsX[i]+=Math.cos(an)*50;
				initSpeedsY[i]+=Math.sin(an)*50;
				var scatterMissile:ScatterMissile=new ScatterMissile(new Point(initSpeedsX[i],initSpeedsY[i]),currentPlanet,new Point(lastNode.x,lastNode.y));
				this._hero.scene.add(scatterMissile);
			}
		}
	}
}