package
{
	import Playtomic.Log;
	
	import com.longame.display.screen.ScreenManager;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	
	import model.PlayerData;
	
	import screens.GameScreen;
	import screens.MainMenuScreen;
	import screens.PostScreen;
	import screens.UpgradeScreen;
	
	[SWF(width="720",height="480",backgroundColor="0x0")]
	public class Flight0 extends Engine
	{
		public static var newGame:Boolean=true;
		public var toolTip:ToolTip;
		
		private static const START_SCREEN:Class=MainMenuScreen;
		
		//飞机和星星的粒子效果有问题
		//右上角的bonus纸鹤的效果有问题
		//升级后先显示故事,然后再在PostScreen上播放一个场景移动的动画,然后再到upgrade页面
		
		public function Flight0()
		{
		}
		override protected function init():void
		{
			super.init();
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			soundKon.init();
			PlayerData.init();
			_g.init(this, stage);
			Ticker.init(stage);
			PlayerData.init();
			AchieveMents.init();
			toolTip = new ToolTip(stage, this);
			nativeStage.addChild(toolTip);
			toolTip.startDrag(true);
			RenderEngine.renderBGs();
			RenderEngine.renderAll();
			
			ScreenManager.openScreen(START_SCREEN);
		}
	}
}