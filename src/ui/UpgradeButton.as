package ui {
    import adobe.utils.*;
    
    import com.bumpslide.ui.UIComponent;
    
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.globalization.*;
    import flash.media.*;
    import flash.net.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.system.*;
    import flash.text.*;
    import flash.text.engine.*;
    import flash.text.ime.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;
    
    import model.PlayerData;
    import model.UpgradeObject;
    
    import screens.UpgradeScreen;

    public  class UpgradeButton extends UIComponent {
        [Child] public var g:MovieClip;
		[Child] public var border:MovieClip;
		[Child] public var b:SimpleButton;
		[Child] public var t:TextField;
		[Child] public var maxed:MovieClip;
		
        public var uo:UpgradeObject;
        public var id:uint;
        public var to:TipObject;
        public var tor:TipObject;
        public var outerScreen:UpgradeScreen;
        public var displayMoney:Function;
        public var romanNum:Array;
        public var getable:Boolean;
        public var greyMat:Array;
        public var colorGreyMat:ColorMatrixFilter;
        public var brightMat:Array;
        public var colorBrightMat:ColorMatrixFilter;
        public var blinkMat:Array;
        public var colorBlinkMat:ColorMatrixFilter;
        public var brightState:Boolean;
        public var targetSize:Number;

        public function UpgradeButton(){
            super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.romanNum = ["", "1", "2", "3", "4", "5"];
			this.b.addEventListener(MouseEvent.MOUSE_OVER, this.showTip, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_OUT, this.hideTip, false, 0, true);
			this.b.addEventListener(MouseEvent.CLICK, this.upgradeHandler, false, 0, true);
			this.getable = false;
			this.greyMat = [0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0, 0, 0, 1, 0];
			this.colorGreyMat = new ColorMatrixFilter(this.greyMat);
			this.brightMat = [1.56, 0, 0, 0, 11.24, 0, 1.56, 0, 0, 11.24, 0, 0, 1.56, 0, 11.24, 0, 0, 0, 1, 0];
			this.colorBrightMat = new ColorMatrixFilter(this.brightMat);
			this.blinkMat = [2.869646, -0.237666, -0.03198, 0, 80.4, -0.120354, 2.752334, -0.03198, 0, 80.4, -0.120354, -0.237666, 2.95802, 0, 80.4, 0, 0, 0, 1, 0];
			this.colorBlinkMat = new ColorMatrixFilter(this.blinkMat);
			this.brightState = false;
			this.targetSize = 1;
		}
        public function filterClear():void{
            this.g.filters = [];
            this.brightState = false;
        }
        public function filterGrey():void{
            this.g.filters = [this.colorGreyMat];
            this.brightState = false;
        }
        public function filterBright():void{
            this.g.filters = [this.colorBrightMat];
            this.brightState = true;
        }
        public function filterBlink():void{
            this.g.filters = [this.colorBlinkMat];
        }
        public function initialize(_arg1:uint, _arg2:Function):void{
            this.id = _arg1;
            this.uo = PlayerData.upgradeData[this.id];
            this.setTip();
            this.displayMoney = _arg2;
            this.g.gotoAndStop((this.id + 1));
            this.updateInner();
        }
        public function updateInner():void{
            if (_g.playerData.upgrades[this.uo.id] < this.uo.max){
                if (_g.playerData.stats[3] >= this.uo.cost[_g.playerData.upgrades[this.uo.id]]){
                    this.border.gotoAndStop(2);
                    this.filterClear();
                    this.getable = true;
                    this.maxed.visible = false;
                } else {
                    this.border.gotoAndStop(1);
                    this.filterGrey();
                    this.getable = false;
                    this.maxed.visible = false;
                }
            } else {
                this.border.gotoAndStop(1);
                this.filterClear();
                this.getable = false;
                this.maxed.visible = true;
            }
        }
        public function upgradeHandler(_arg1:MouseEvent=null):void{
            if (_g.playerData.upgrades[this.uo.id] < this.uo.max){
                if (_g.playerData.stats[3] >= this.uo.cost[_g.playerData.upgrades[this.uo.id]]){
                    _g.playerData.stats[3] = (_g.playerData.stats[3] - this.uo.cost[_g.playerData.upgrades[this.uo.id]]);
                    var _local2:Array= _g.playerData.upgrades;
                    var _local3:uint = this.uo.id;
                    _local2[_local3] =_local2[_local3] + 1;
                    this.displayMoney();
                    if (this.uo.id == 0){
                        this.outerScreen.fixGraphic();
                    }
                    this.outerScreen.updateInner();
                    ToolTip.giveError("Yay!", "Successfully upgraded!");
                    soundKon.playSound(13);
                    this.setTip();
                    this.hideTip();
                    this.showTip();
                } else {
                    trace("UPGRADE FAILED: Not enough money.");
                    ToolTip.giveError("Upgrade Failed", "You do not have enough money.");
                }
            } else {
                trace("UPGRADE FAILED: Already at max level.");
                ToolTip.giveError("Upgrade Failed", "This upgrade is already at its maximum level.");
            }
        }
        public function showTip(_arg1:MouseEvent=null):void{
            ToolTip.tip(this.to);
            this.becomeBig();
            if (this.getable){
                this.filterBright();
            }
            soundKon.playSound(11);
        }
        public function hideTip(_arg1:MouseEvent=null):void{
            ToolTip.unTip();
            this.becomeSmall();
            if (this.brightState){
                this.filterClear();
            }
        }
        public function becomeBig():void{
            this.targetSize = 1.3;
            addEventListener(Event.ENTER_FRAME, this.changeSize, false, 0, true);
        }
        public function becomeSmall():void{
            this.targetSize = 1;
            addEventListener(Event.ENTER_FRAME, this.changeSize, false, 0, true);
        }
        public function changeSize(_arg1:Event):void{
            var _local2:Number = ((this.targetSize - scaleX) * 0.35);
            if (Math.abs(_local2) < 0.02){
                scaleX = (scaleY = this.targetSize);
                removeEventListener(Event.ENTER_FRAME, this.changeSize);
            } else {
                scaleX = (scaleX + _local2);
                scaleY = scaleX;
            }
            this.b.scaleX = (scaleX / this.targetSize);
            this.b.scaleY = this.b.scaleX;
        }
        public function setTip():void{
            var _local1:String;
            this.to = null;
            if (this.uo.tipVar != null){
                _local1 = String(this.uo.toolTip).replace(String("@"), this.uo.tipVar[_g.playerData.upgrades[this.uo.id]]);
            } else {
                _local1 = this.uo.toolTip;
            }
            if (_g.playerData.upgrades[this.uo.id] < this.uo.max){
                this.to = new TipObject(((this.uo.name + " - $") + this.uo.cost[_g.playerData.upgrades[this.uo.id]]), _local1);
                this.t.text = this.romanNum[_g.playerData.upgrades[this.uo.id]];
            } else {
                this.to = new TipObject((this.uo.name + " (MAXED)"), _local1);
                this.t.text = "";
            }
        }
    }
}
