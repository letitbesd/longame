package com.weapons
{
	import com.PathSimulator;
	import com.Scene;
	
	import com.missiles.MissileBase;
	import com.missiles.NonexplosibleMisslie;

	public class Wep3 extends WepBase
	{
		public function Wep3(id:int)
		{
			super(id);
		}
		override public function simulatePath(param:Object, heroIndex:int):void
		{
			this.simulator=new PathSimulator(param.strength,param.angle,param.startPos,heroIndex);
			this.currentPath=simulator.starightlineSimulate(100,Scene.pathCanvas.graphics);
		}
		override public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:NonexplosibleMisslie=new NonexplosibleMisslie(this.currentPath,simulator.planet,wepID,this.simulator.hitHeroIndex);
			Scene.pathCanvas.graphics.clear();
			Main.scene.addChild(missile);
		}
	}
}