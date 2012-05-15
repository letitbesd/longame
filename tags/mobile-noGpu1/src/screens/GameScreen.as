package screens
{
	import com.bumpslide.ui.UIComponent;
	import com.longame.display.screen.Screen;
	
	import ui.GameScreenUI;
	
	public class GameScreen extends Screen
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