package ui
{
	import com.bumpslide.ui.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	public class GameScreenUI extends UIComponent
	{
		[Child]
		public var _d:TextField;
		[Child]
		public var _v:TextField;
		[Child]
		public var muter:MusicButton;
		[Child]
		public var fuelBar:MovieClip;
		[Child]
		public var b_more:SimpleButton;
		[Child]
		public var rainbowStar:MovieClip;
		[Child]
		public var ee:pressSpaceMC;
		[Child]
		public var cm:MovieClip;//CraneBonuser_226
		[Child]
		public var _a:TextField;
		
		public var endY:Number;
		public var startY:Number;
		public var moveTo:Number;
		public var moveSpeed:Number;
		public var EEendY:Number;
		public var EEstartY:Number;
		public var EEmoveTo:Number;
		public var EEmoveSpeed:Number;
		public var RRendX:Number;
		public var RRstartX:Number;
		public var RRmoveTo:Number;
		public var RRmoveSpRRd:Number;
		
		public var eeBarMax:Number;
		
		public function GameScreenUI()
		{
			super();
			this.skinClass=uiGame;
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.muter.musicToPlay = 1;
			this.endY = this.cm.y;
			this.startY = -100;
			this.moveTo = 0;
			this.moveSpeed = 0.26;
			this.cm.y = this.startY;
			this.EEendY = this.ee.y;
			this.EEstartY = 610;
			this.EEmoveTo = 0;
			this.EEmoveSpeed = 0.35;
			this.ee.y = this.EEstartY;
			this.eeBarMax=this.ee.bar.width;
			this.b_more.addEventListener(MouseEvent.CLICK, this.getAGURL);
			this.RRendX = this.rainbowStar.x;
			this.RRstartX = -190;
			this.RRmoveTo = 0;
			this.RRmoveSpRRd = 0.35;
			this.rainbowStar.x = this.RRstartX;
		}
		override protected function doDispose():void
		{
			this.b_more.removeEventListener(MouseEvent.CLICK, this.getAGURL);
			this.removeEventListener(Event.ENTER_FRAME, this.run);
			removeEventListener(Event.ENTER_FRAME, this.EErun);
			removeEventListener(Event.ENTER_FRAME, this.RRrun);
			super.doDispose();
		}
		public function moveIn(_arg1:uint):void{
			this.moveTo = this.endY;
			this.cm.gotoAndStop((_arg1 - 1));
			addEventListener(Event.ENTER_FRAME, this.run, false, 0, true);
		}
		public function moveOut():void{
			this.moveTo = this.startY;
			addEventListener(Event.ENTER_FRAME, this.run, false, 0, true);
		}
		public function run(_arg1:Event):void{
			if (Math.abs((this.moveTo - this.cm.y)) <= 1){
				removeEventListener(Event.ENTER_FRAME, this.run);
			} else {
				this.cm.y = (this.cm.y + ((this.moveTo - this.cm.y) * this.moveSpeed));
			};
		}
		public function EEmoveIn():void{
			this.EEmoveTo = this.EEendY;
			addEventListener(Event.ENTER_FRAME, this.EErun, false, 0, true);
		}
		public function EEmoveOut():void{
			this.EEmoveTo = this.EEstartY;
			addEventListener(Event.ENTER_FRAME, this.EErun, false, 0, true);
		}
		public function EErun(_arg1:Event):void{
			if (Math.abs((this.EEmoveTo - this.ee.y)) <= 1){
				removeEventListener(Event.ENTER_FRAME, this.EErun);
			} else {
				this.ee.y = (this.ee.y + ((this.EEmoveTo - this.ee.y) * this.EEmoveSpeed));
			};
		}
		public function getAGURL(_arg1:MouseEvent):void{
			var url:String= "http://ArmorGames.com";
			var req:URLRequest = new URLRequest(url);
			try {
				navigateToURL(req, "_blank");
			} catch(e:Error) {
			}
		}
		public function RRmoveIn():void{
			this.RRmoveTo = this.RRendX;
			addEventListener(Event.ENTER_FRAME, this.RRrun, false, 0, true);
		}
		public function RRmoveOut():void{
			this.RRmoveTo = this.RRstartX;
			addEventListener(Event.ENTER_FRAME, this.RRrun, false, 0, true);
		}
		public function RRrun(_arg1:Event):void{
			if (Math.abs((this.RRmoveTo - this.rainbowStar.x)) <= 1){
				removeEventListener(Event.ENTER_FRAME, this.RRrun);
			} else {
				this.rainbowStar.x = (this.rainbowStar.x + ((this.RRmoveTo - this.rainbowStar.x) * this.RRmoveSpRRd));
			};
		}
	}
}