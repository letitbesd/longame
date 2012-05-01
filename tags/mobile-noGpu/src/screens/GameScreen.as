package screens
{
	import com.bumpslide.ui.UIComponent;
	import com.longame.display.screen.AbstractScreen;
	
	import ui.GameScreenUI;
	
	public class GameScreen extends AbstractScreen
	{
		public function GameScreen()
		{
//			super(new GameScreenUI);
			super();
		}
		override protected function createScene():void
		{
			_g.reset();
			_g.ready();
		}
	}
}