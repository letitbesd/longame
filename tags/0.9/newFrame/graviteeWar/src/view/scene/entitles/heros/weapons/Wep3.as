package view.scene.entitles.heros.weapons
{
	import view.scene.BattleScene;
	import view.scene.entitles.PathSimulator;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.NonexplosibleMisslie;

	public class Wep3 extends WepBase
	{
		public function Wep3(hero:HeroBase)
		{
			super(hero);
			this.wepID=3;
		}
		override public function simulatePath(param:Object):void
		{
			this.simulator=new PathSimulator(param.strength,param.angle,param.startPos,_hero.heroIndex);
			this.currentPath=simulator.starightlineSimulate(100,BattleScene.pathCanvas.graphics);
		}
		override public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:NonexplosibleMisslie=new NonexplosibleMisslie(this.currentPath,simulator.planet,wepID,this.simulator.hitHeroIndex);
			BattleScene.pathCanvas.graphics.clear();
			this._hero.scene.add(missile);
		}
	}
}