package com.weapons
{
	import com.Scene;
	
	import com.missiles.MissileBase;
	import com.missiles.NonexplosibleMisslie;

	public class Wep4 extends WepBase
	{
		public function Wep4(id:int)
		{
			super(id);
		}
		override public function simulatePath( param:Object, heroIndex:int):void
		{
			super.simulatePath(param, heroIndex);
		}
		override public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:NonexplosibleMisslie=new NonexplosibleMisslie(this.currentPath,simulator.planet,wepID,this.simulator.hitHeroIndex,true);
			Scene.pathCanvas.graphics.clear();
			Main.scene.addChild(missile);
		}
	}
}