package view.scene.entitles.heros.weapons
{
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.Lightning;

	public class Wep6 extends WepBase
	{
		public function Wep6(hero:HeroBase)
		{
			super(hero);
			this.isAssist=true;
			
		}
		override public function simulatePath(param:Object):void
		{
		}
		override public function setWepPos():void
		{
			var lightning:Lightning=new Lightning(this._hero.heroIndex);
			this._hero.scene.add(lightning);
		}
		
	}
}