package com.weapons
{
	import com.PathSimulator;
	import com.Scene;
	
	import com.missiles.ThroughMissile;

	public class Wep7 extends WepBase
	{
		public function Wep7(id:int)
		{
			super(id);
			this.damageScopeStrength=1.5;
		}
		override public function simulatePath( param:Object, heroIndex:int):void
		{
			simulator=new PathSimulator(param.strength,param.angle,param.startPos,heroIndex,false);
			currentPath=simulator.curveSimulate(100,Scene.pathCanvas.graphics);
		}
		override public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:ThroughMissile=new ThroughMissile(this.currentPath,simulator.planet,wepID,this.damageScopeStrength);
			Scene.pathCanvas.graphics.clear();
			Main.scene.addChild(missile);
		}
	}
}