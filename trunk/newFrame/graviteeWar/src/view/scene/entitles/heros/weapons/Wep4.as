package view.scene.entitles.heros.weapons
{
	import view.scene.BattleScene;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.NonexplosibleMisslie;

	public class Wep4 extends WepBase
	{
		public function Wep4(hero:HeroBase)
		{
			super(hero);
			this.wepID=4;
		}
		override public function simulatePath( param:Object):void
		{
			super.simulatePath(param);
		}
		override public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:NonexplosibleMisslie=new NonexplosibleMisslie(this.currentPath,simulator.planet,wepID,this.simulator.hitHeroIndex,true);
			BattleScene.pathCanvas.graphics.clear();
			this._hero.scene.add(missile);
		}
	}
}