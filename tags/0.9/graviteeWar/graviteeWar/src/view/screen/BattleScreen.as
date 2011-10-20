package view.screen
{
	import flash.geom.Rectangle;
	
	import view.scene.BattleScene;

	public class BattleScreen extends ScreenBase
	{
		private var _scene:BattleScene;
		public function BattleScreen()
		{
			super();
		}
		
		override protected function createScene():void
		{
			super.createScene();
			_scene = new BattleScene();
			_scene.setup(this._sceneLayer,new Rectangle(0,0,700,500));
		}
		
		override protected function createUi():void
		{
			super.createUi();
		}
		
		override protected function unload():void
		{
			super.unload();
			_scene.destroy();
		}
	}
}