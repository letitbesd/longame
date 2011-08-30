package com.weapons
{
	public class Wep1 extends WepBase
	{
		public function Wep1(id:int)
		{
			super(id);
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