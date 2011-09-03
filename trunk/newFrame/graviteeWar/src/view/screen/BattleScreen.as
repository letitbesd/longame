package view.screen
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import view.scene.BattleScene;
	import view.ui.components.BattleUI;

	public class BattleScreen extends ScreenBase
	{
		private var _scene:BattleScene;
		private var _battleUI:BattleUI;
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
			_battleUI = new BattleUI();
			this.uiLayer.addChild(_battleUI);
		}
		
		override protected function unload():void
		{
			super.unload();
			_scene.destroy();
		}
	}
}