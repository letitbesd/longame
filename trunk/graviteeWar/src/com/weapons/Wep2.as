package com.weapons
{
	import AMath.AVector;
	
	import collision.CDK;
	import collision.CollisionData;
	import com.IFrameObject;
	import com.PathNode;
	import com.Planet;
	import com.Scene;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	import com.time.EnterFrame;
	import flash.display.MovieClip;
	import flash.geom.Point;

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
		public function Wep2(id:int)
		{
			super(id);
			count=0;
			trace("------------------");
			FightSignals.missileBomded.add(missileScatter);
		}
		override public function simulatePath(param:Object, heroIndex:int):void
		{
			super.simulatePath(param, heroIndex);
		}
		override public function shoot():void
		{
			super.shoot();
		}
		private function missileScatter(planet:Planet,lastNode:PathNode):void
		{ 
			this.currentPlanet=planet;
//			var angle:Number=Math.atan2(lastNode.y-this.currentPlanet.y,lastNode.x-this.currentPlanet.x)*180/Math.PI;
			var angle:Number=lastNode.rotation;
			an=(lastNode.rotation+180)*Math.PI/180;
			if(angle<0) angle+=360;
			for(var i:int=0;i<=3;i++)
			{
				subMissiles[i]=AssetsLibrary.getMovieClip("missile2a");
				Main.scene.addChild(subMissiles[i]);
				subMissiles[i].x=lastNode.x;
				subMissiles[i].y=lastNode.y;
				if((i+1)%2==0)
				{
					subMissiles[i].rotation=angle-90;
				}
				else
				{
					subMissiles[i].rotation=angle+90;
				}
				initSpeedsX[i]=Math.cos(subMissiles[i].rotation*Math.PI/180)*baseSpeed[i];
				initSpeedsY[i]=Math.sin(subMissiles[i].rotation*Math.PI/180)*baseSpeed[i];
				initSpeedsX[i]+=Math.cos(an)*50;
				initSpeedsY[i]+=Math.sin(an)*50;
			}
			EnterFrame.addObject(this);
		}
		override public function onFrame():void
		{
			
			for(var i:int=0;i<=3;i++)
			{
				if(subMissiles[i])
				{
					var g:AVector=this.currentPlanet.getG(subMissiles[i].x,subMissiles[i].y);
					initSpeedsX[i]+=g.x*0.4;
					initSpeedsY[i]+=g.y*0.4;
					subMissiles[i].x+=initSpeedsX[i]*0.08;
					subMissiles[i].y+=initSpeedsY[i]*0.08;
					var cd:CollisionData=CDK.check(subMissiles[i],this.currentPlanet)
					 if(cd)
					 {
						 this.currentPlanet.addHole(subMissiles[i].x,subMissiles[i].y,0.5);
						 if(subMissiles[i].parent) subMissiles[i].parent.removeChild(subMissiles[i]);
						 subMissiles[i]=null;
						 count++;
						 if(count == 4)
						 {
							 FightSignals.missileBomded.remove(missileScatter);
							 EnterFrame.removeObject(this);
						 }
					 }
				}
			}
		}
	}
}