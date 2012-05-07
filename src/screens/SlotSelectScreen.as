package screens
{
	import com.longame.display.screen.McScreen;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.PlayerData;
	
	public class SlotSelectScreen extends McScreen
	{
		[Child]
		public var gameDataType:TextField;
		[Child]
		public var b_back:SimpleButton;
		[Child]
		public var b_data1:SimpleButton;
		[Child]
		public var b_data2:SimpleButton;
		[Child]
		public var b_data3:SimpleButton;
		
		[Child]
		public var pmp1:PlanePhoto;
		[Child]
		public var pmp2:PlanePhoto;
		[Child]
		public var pmp3:PlanePhoto;
		
		private var pm1:PlayerData;
		private var pm2:PlayerData;
		private var pm3:PlayerData;
		
		public function SlotSelectScreen()
		{
			super("SlotSelect.swf@content");
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.pm1 = PlayerData.mirrorGame(1);
			this.pm2 = PlayerData.mirrorGame(2);
			this.pm3 = PlayerData.mirrorGame(3);
			this.pmp1.setColor(this.pm1.customize[0]);
			this.pmp2.setColor(this.pm2.customize[0]);
			this.pmp3.setColor(this.pm3.customize[0]);
			(this.pmp1.skin as MovieClip).gotoAndStop((this.pm1.upgrades[0] + 1));
			(this.pmp2.skin as MovieClip).gotoAndStop((this.pm2.upgrades[0] + 1));
			(this.pmp3.skin as MovieClip).gotoAndStop((this.pm3.upgrades[0] + 1));
			this.pmp1.colorMC.gotoAndStop((this.pm1.upgrades[0] + 1));
			this.pmp2.colorMC.gotoAndStop((this.pm2.upgrades[0] + 1));
			this.pmp3.colorMC.gotoAndStop((this.pm3.upgrades[0] + 1));
			this.pmp1.setTexture(this.pm1.customize[1]);
			this.pmp2.setTexture(this.pm2.customize[1]);
			this.pmp3.setTexture(this.pm3.customize[1]);
			if (Flight0.newGame){
				this.gameDataType.text = "NEW GAME";
			} else {
				this.gameDataType.text = "LOAD GAME";
			}
		}
		override protected function addEvents():void
		{
			this.b_back.addEventListener(MouseEvent.CLICK, this.backToMenuHandler);
			this.b_data1.addEventListener(MouseEvent.CLICK, this.doGameHandler1);
			this.b_data2.addEventListener(MouseEvent.CLICK, this.doGameHandler2);
			this.b_data3.addEventListener(MouseEvent.CLICK, this.doGameHandler3);
		}
		override protected function removeEvents():void
		{
			this.b_back.removeEventListener(MouseEvent.CLICK, this.backToMenuHandler);
			this.b_data1.removeEventListener(MouseEvent.CLICK, this.doGameHandler1);
			this.b_data2.removeEventListener(MouseEvent.CLICK, this.doGameHandler2);
			this.b_data3.removeEventListener(MouseEvent.CLICK, this.doGameHandler3);
		}
		public function doGameHandler1(evt:MouseEvent=null):void{
			this.doGameReal(1);
		}
		public function doGameHandler2(evt:MouseEvent=null):void{
			this.doGameReal(2);
		}
		public function doGameHandler3(evt:MouseEvent=null):void{
			this.doGameReal(3);
		}
		public function doGameReal(slot:uint):void{
			if (Flight0.newGame){
				PlayerData.saveGame(slot);
				_g.currentSlot = slot;
				Engine.showScreen(StoryScreen);
//				Engine.showScreen(UpgradeScreen);
			} else {
				PlayerData.loadGame(slot);
				_g.currentSlot = slot;
				Engine.showScreen(UpgradeScreen);
			}
		}
		private function backToMenuHandler(evt:MouseEvent):void
		{
			Engine.showScreen(MainMenuScreen);
		}
		override protected function doDispose():void
		{
			super.doDispose();
		}
	}
}