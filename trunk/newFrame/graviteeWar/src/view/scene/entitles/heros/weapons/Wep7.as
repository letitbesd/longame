package view.scene.entitles.heros.weapons
{
	import view.scene.BattleScene;
	import view.scene.entitles.PathSimulator;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.ThroughMissile;

	public class Wep7 extends WepBase
	{
		public function Wep7(hero:HeroBase)
		{
			super(hero);
			this.damageScope=1.5;
			this.wepID=7
		}
		override public function simulatePath( param:Object):void
		{
			simulator=new PathSimulator(param.strength,param.angle,param.startPos,this._hero.heroIndex,false);
			currentPath=simulator.curveSimulate(100,BattleScene.pathCanvas.graphics);
		}
		override public function shoot():void
		{	
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:ThroughMissile=new ThroughMissile(this.currentPath,simulator.planet,wepID,this.damageScope);
			BattleScene.pathCanvas.graphics.clear();
			this._hero.scene.add(missile);
		}
	}
}