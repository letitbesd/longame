package view.scene.components
{
	import com.longame.modules.components.AbstractComp;
	
	import view.scene.entitles.heros.HeroBase;
	
	public class StandComp extends AbstractComp
	{
		private var animationArr:Array = [];
		public function StandComp(animation:String="bob")
		{
			super();
			(this._owner as HeroBase).doAction("bob");
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			if(_owner as HeroBase)(this._owner as HeroBase).doAction("notaiming7");
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			(this._owner as HeroBase).doAction("bob");
		}	
 	}
}