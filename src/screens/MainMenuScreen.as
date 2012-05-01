package screens
{
	import com.bumpslide.view.BasicView;
	import com.longame.display.screen.McScreen;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import model.PlayerData;
	
	import ui.MusicButton;
	
	public class MainMenuScreen extends McScreen
	{
		[Child(source="puffMenu.b_newGame")]
		public var newGame:SimpleButton;
		[Child(source="puffMenu.b_loadGame")]
		public var loadGame:SimpleButton;
		[Child(source="puffMenu.b_moreGames")]
		public var moreGames:SimpleButton;
		[Child(source="puffMenu.b_highScores")]
		public var highScores:SimpleButton;
		
		[Child]
		public var muter:MusicButton;
		
		public function MainMenuScreen()
		{
			super("MainMenu.swf@content");
		}
		override protected function addEvents():void
		{
			this.newGame.addEventListener(MouseEvent.CLICK, this.newGameHandler);
			this.loadGame.addEventListener(MouseEvent.CLICK, this.loadGameHandler);
//			this.highScores.addEventListener(MouseEvent.CLICK, this.agiScore);
//			this.moreGames.addEventListener(MouseEvent.CLICK, this.getAGURL2);
		}
		override protected function removeEvents():void
		{
			this.newGame.removeEventListener(MouseEvent.CLICK, this.newGameHandler);
			this.loadGame.removeEventListener(MouseEvent.CLICK, this.loadGameHandler);
//			this.highScores.removeEventListener(MouseEvent.CLICK, this.agiScore);
//			this.moreGames.removeEventListener(MouseEvent.CLICK, this.getAGURL2);
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			soundKon.playMusic(0);
			
//			this.facebook_btn.addEventListener(MouseEvent.CLICK, this.addThisToFacebook);
//			this.twitter_btn.addEventListener(MouseEvent.CLICK, this.addThisToTwitter);
			

//			this.easyType = new Object();
//			this.easyType.type = "Throw Score";
//			this.easyType.format = "none";
//			this.easyType.descending = true;
//			this.hardType = new Object();
//			this.hardType.type = "Total Days";
//			this.hardType.format = "custom";
//			this.hardType.customFormatCallback = this.myFormat;
//			this.hardType.descending = false;
//			this.scoreTypes = new Array();
//			this.scoreTypes.push(this.easyType);
//			this.scoreTypes.push(this.hardType);
			this.muter.musicToPlay = 0;
		}
		public function newGameHandler(_arg1:MouseEvent=null):void{
			Flight0.newGame = true;
			_g.playerData = new PlayerData()
			Engine.showScreen(SlotSelectScreen);
		}
		public function loadGameHandler(_arg1:MouseEvent=null):void{
			Flight0.newGame = false;
			Engine.showScreen(SlotSelectScreen);
		}
		override protected function doDispose():void
		{
			super.doDispose();
		}
	}
}