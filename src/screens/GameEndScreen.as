package screens
{
	import com.longame.display.screen.McScreen;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GameEndScreen extends McScreen
	{
		[Child] public var b_playOn:SimpleButton;
		[Child] public var b_more:SimpleButton;
		[Child] public var b_score:SimpleButton;
		[Child] public var day:TextField;
		
		public function GameEndScreen()
		{
			super("GameEnd.swf@content");
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.b_playOn.addEventListener(MouseEvent.CLICK, this.playOn, false, 0, true);
//			this.b_more.addEventListener(MouseEvent.CLICK, this.getAGURL);
//			this.b_score.addEventListener(MouseEvent.CLICK, this.submitScore);
			this.b_score.visible = true;
			this.day.text = String((_g.playerData.stats[4] + " Days"));
		}
		private function playOn(evt:MouseEvent):void
		{
			ScreenManager.openScreen(UpgradeScreen);
		}
	}
}