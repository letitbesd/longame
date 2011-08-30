package com.weapons
{
	import com.Planet;
	import com.Scene;
	import com.heros.Hero;
	import com.signals.FightSignals;

	public class Wep9 extends WepBase
	{
		public function Wep9(id:int)
		{
			super(id);
			this.damageScopeStrength=2;
		}
		override public function simulatePath( param:Object, heroIndex:int):void
		{
			super.simulatePath(param, heroIndex);
		}
		override public function shoot():void
		{
			super.shoot();
		}
	}
}