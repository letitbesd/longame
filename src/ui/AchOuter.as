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

    public class AchOuter extends UIComponent {

		[Child]
        public var g:MovieClip;
		[Child]
        public var b:SimpleButton;
		
        public var id:uint;
        public var ach:Object;
        public var to:TipObject;
        public var gotIt:Boolean;
        public var greyMat:Array;
        public var colorGreyMat:ColorMatrixFilter;
        public var brightMat:Array;
        public var colorBrightMat:ColorMatrixFilter;
        public var blinkMat:Array;
        public var colorBlinkMat:ColorMatrixFilter;

        public function AchOuter(){
           super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.b.useHandCursor = false;
			this.b.addEventListener(MouseEvent.MOUSE_OVER, this.showAch, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_OUT, this.hideAch, false, 0, true);
			this.id = 0;
			this.gotIt = false;
			this.greyMat = [0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0, 0, 0, 1, 0];
			this.colorGreyMat = new ColorMatrixFilter(this.greyMat);
			this.brightMat = [1.56, 0, 0, 0, 11.24, 0, 1.56, 0, 0, 11.24, 0, 0, 1.56, 0, 11.24, 0, 0, 0, 1, 0];
			this.colorBrightMat = new ColorMatrixFilter(this.brightMat);
			this.blinkMat = [2.869646, -0.237666, -0.03198, 0, 80.4, -0.120354, 2.752334, -0.03198, 0, 80.4, -0.120354, -0.237666, 2.95802, 0, 80.4, 0, 0, 0, 1, 0];
			this.colorBlinkMat = new ColorMatrixFilter(this.blinkMat);
		}
        public function initilize(_arg1:uint):void{
            this.id = _arg1;
            this.ach = AchieveMents.LIST[this.id];
            this.g.gotoAndStop((_arg1 + 1));
            this.to = new TipObject(this.ach.t, this.ach.desc);
            if (_g.playerData.achievements[_arg1]){
                this.gotIt = true;
            } else {
                this.filterGrey();
            }
        }
        public function showAch(_arg1:MouseEvent):void{
            ToolTip.tip(this.to);
            if (this.gotIt){
                this.filterBright();
            }
        }
        public function hideAch(_arg1:MouseEvent):void{
            ToolTip.unTip();
            if (this.gotIt){
                this.filterClear();
            }
        }
        public function filterClear():void{
            this.g.filters = [];
        }
        public function filterGrey():void{
            this.g.filters = [this.colorGreyMat];
        }
        public function filterBright():void{
            this.g.filters = [this.colorBrightMat];
        }
        public function filterBlink():void{
            this.g.filters = [this.colorBlinkMat];
        }

    }
}//package Flight_fla 
