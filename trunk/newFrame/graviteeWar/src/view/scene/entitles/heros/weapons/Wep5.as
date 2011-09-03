package view.scene.entitles.heros.weapons
{
	
	import com.collision.util.MathUtil;
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import view.scene.BattleScene;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.LandMine;

	public class Wep5 extends WepBase 
	{			
		private var currentPlanet:Planet;
		private var content:MovieClip;
		public function Wep5(hero:HeroBase)
		{
			super(hero);
			currentPlanet=_hero.currentPlanet;
			this.damageScope=1.3;
		}
		override public function simulatePath(param:Object):void
		{
			
		}
		override public function shoot():void
		{
//			content=AssetsLibrary.getMovieClip("wep5");
//			if(heroInfo.rotation<0) heroInfo.rotation+=360;
//			content.x=heroInfo.x-Math.cos((heroInfo.rotation-90)*Math.PI/180)*4;
//			content.y=heroInfo.y-Math.sin((heroInfo.rotation-90)*Math.PI/180)*4;
//			content.rotation=heroInfo.rotation;
//			content.gotoAndStop(2);
			var landMine:LandMine=new LandMine(this._hero);
			this._hero.scene.add(landMine);
			this.changeAction=true;
		}
		private function bomb():void
		{
			content.stop();
			this.currentPlanet.addHole(content.x,content.y,this.damageScope);
			if(content.parent) content.parent.removeChild(content);
		}
		
	}
}