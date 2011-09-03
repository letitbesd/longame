package view.scene.entitles.heros.weapons
{
	import view.scene.entitles.heros.HeroBase;

	public class Wep9 extends WepBase
	{
		public function Wep9(hero:HeroBase)
		{
			super(hero);
			this.damageScope=2;
			this.wepID=9;
		}
		override public function simulatePath( param:Object):void
		{
			super.simulatePath(param);
		}
		override public function shoot():void
		{
			super.shoot();
		}
	}
}