package screens
{
	import com.addthis.share.ShareAPI;
	import com.gskinner.motion.GTweener;
	import com.longame.display.screen.McScreen;
	import com.longame.display.screen.ScreenManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.PlayerData;
	
	import ui.AchOuter;
	import ui.ColorSetPanel;
	import ui.MusicButton;
	import ui.UpgradeButton;
	
	public class UpgradeScreen extends McScreen
	{
		[Child]	public var u0:UpgradeButton;
		[Child]	public var u1:UpgradeButton;
		[Child]	public var u2:UpgradeButton;
		[Child]	public var u3:UpgradeButton;
		[Child]	public var u4:UpgradeButton;
		[Child]	public var u5:UpgradeButton;
		[Child]	public var u6:UpgradeButton;
		[Child] public var u7:UpgradeButton;
		[Child] public var u8:UpgradeButton;
		[Child] public var u9:UpgradeButton;
		[Child] public var u10:UpgradeButton;
		[Child] public var u11:UpgradeButton;
		[Child] public var u12:UpgradeButton;
		[Child] public var u13:UpgradeButton;
		[Child] public var u14:UpgradeButton;
		
		[Child] public var ach_0:AchOuter;
		[Child] public var ach_1:AchOuter;
		[Child] public var ach_2:AchOuter;
		[Child]	public var ach_3:AchOuter;
		[Child]	public var ach_4:AchOuter;
		[Child]	public var ach_5:AchOuter;
		[Child]	public var ach_6:AchOuter;
		[Child]	public var ach_7:AchOuter;
		[Child]	public var ach_8:AchOuter;
		[Child]	public var ach_9:AchOuter;
		[Child]	public var ach_10:AchOuter;
		[Child]	public var ach_11:AchOuter;
		[Child]	public var ach_12:AchOuter;
		[Child]	public var ach_13:AchOuter;
		[Child]	public var ach_14:AchOuter;
		[Child]	public var ach_15:AchOuter;
		[Child] public var ach_16:AchOuter;
		[Child] public var ach_17:AchOuter;
		[Child] public var ach_18:AchOuter;
		[Child] public var ach_19:AchOuter;
		[Child]	public var ach_20:AchOuter;
		[Child] public var ach_21:AchOuter;
		[Child]	public var ach_22:AchOuter;
		[Child]	public var ach_23:AchOuter;

		[Child]	public var cus_but:SimpleButton;
		[Child]	public var t_money:TextField;
		[Child]	public var facebook_btn:SimpleButton;
		[Child]	public var profilePic:PlanePhoto;
		[Child]	public var muter:MusicButton;
		[Child] public var twitter_btn:SimpleButton;
		[Child] public var cm:ColorSetPanel;
		[Child] public var b_play:SimpleButton;
		[Child] public var day:TextField;
		
		public var share_url:String;
		public var api:ShareAPI;
		public var P:PlayerData;
		public var i:int;
		public var cus_endX:Number;
		public var cus_startX:Number;
		public var cus_moveTo:Number;
		public var cus_moveSpeed:Number;
		public var cus_In:Boolean;
		public var colorExOuter:Function;
		public var colorCusArray:Array;
		
		public function UpgradeScreen()
		{
			super("Upgrade.swf@content");
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.share_url = "http://armorgames.com/play/7598/flight";
			this.api = new ShareAPI();
			addChild(this.api);
			this.muter.musicToPlay = 0;
			this.P = _g.playerData;
			this.displayMoney();
			this.day.text = new String(this.P.stats[4]);
			this.i = 0;
			while (this.i < 15) {
				this[("u" + this.i)].initialize(this.i, this.displayMoney);
				this[("u" + this.i)].outerScreen = this;
				this.i++;
			}
			this.fixGraphic();
			this.cus_endX = 453;
			this.cus_startX = this.cm.x;
			this.cus_moveTo = 0;
			this.cus_moveSpeed = 0.26;
			this.cus_In = false;
			this.colorCusArray = [3486527, 15851976, 16101178, 0xF1C900, 0xD90000, 15515095, 7493777, 11971317, 4291536, 11197434, 9363659, 10916224, 7057240, 12910424];
			this.i = 0;
			while (this.i < 14) {
				this.cm[("cb_" + this.i)].initialize(this.colorCusArray[this.i], this.colorExtOuter);
				this.i++;
			}
			this.i = 0;
			while (this.i < 7) {
				this.cm[("tb_" + this.i)].initialize(this.i, this);
				this.i++;
			}
			this.profilePic.setColor(_g.playerData.customize[0]);
			this.profilePic.setTexture(_g.playerData.customize[1]);
			this.initAch();

		}
		override protected function addEvents():void
		{
			this.facebook_btn.addEventListener(MouseEvent.CLICK, this.addThisToFacebook);
			this.twitter_btn.addEventListener(MouseEvent.CLICK, this.addThisToTwitter);
			this.cus_but.addEventListener(MouseEvent.CLICK, this.doMove);
			this.cm.b_exit.addEventListener(MouseEvent.CLICK, this.bExit);
			this.b_play.addEventListener(MouseEvent.CLICK,playGame);
		}
		override protected function removeEvents():void
		{
			this.facebook_btn.removeEventListener(MouseEvent.CLICK, this.addThisToFacebook);
			this.twitter_btn.removeEventListener(MouseEvent.CLICK, this.addThisToTwitter);
			this.cus_but.removeEventListener(MouseEvent.CLICK, this.doMove);
			this.cm.b_exit.removeEventListener(MouseEvent.CLICK, this.bExit);
			this.b_play.removeEventListener(MouseEvent.CLICK,playGame);
		}
		protected function playGame(event:MouseEvent):void
		{
			ScreenManager.openScreen(GameScreen);			
		}
		public function addThisToFacebook(_arg1:MouseEvent):void{
			this.api.share(this.share_url, "facebook");
		}
		public function addThisToTwitter(_arg1:MouseEvent):void{
			this.api.share(this.share_url, "twitter");
		}
		public function displayMoney():void{
			var _local1:* = ("$" + this.P.stats[3].toFixed(2));
			this.t_money.text = _local1;
		}
		public function updateInner():void{
			var _local1:* = 0;
			while (_local1 < 15) {
				this[("u" + _local1)].updateInner();
				_local1++;
			}
		}
		public function fixGraphic():void{
			(this.profilePic.skin as MovieClip).gotoAndStop((_g.playerData.upgrades[0] + 1));
			this.profilePic.colorMC.gotoAndStop((_g.playerData.upgrades[0] + 1));
			this.profilePic.setTexture(_g.playerData.customize[1]);
		}
		public function colorExtOuter(_arg1:String, _arg2:uint):void{
			_g.playerData.customize[_arg2] = _arg1;
			this.profilePic.setColor(_arg1);
			_g.ROOT.toolTip.startDrag(true);
		}
		public function textureExOuter(_arg1:uint, _arg2:uint):void{
			_g.playerData.customize[_arg2] = _arg1;
			this.profilePic.setTexture(_arg1);
			_g.ROOT.toolTip.startDrag(true);
		}
		public function cus_moveIn():void{
			GTweener.to(this.cm,1,{x:this.cus_endX});
		}
		public function cus_moveOut():void{
			GTweener.to(this.cm,1,{x:this.cus_startX});
		}
		public function initAch():void{
			var _local1:* = 0;
			while (_local1 < 24) {
				this[("ach_" + _local1)].initilize(_local1);
				_local1++;
			}
		}
		public function bExit(_arg1:MouseEvent=null):void{
			if (this.cus_In){
				this.doMove();
			}
		}
		public function doMove(_arg1:MouseEvent=null):void{
			if (this.cus_In){
				this.cus_In = false;
				this.cus_moveOut();
			} else {
				this.cus_In = true;
				this.cus_moveIn();
			}
		}
	}
}