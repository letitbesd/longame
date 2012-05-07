package ui {
    import com.bumpslide.ui.UIComponent;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class OuterColorButton extends UIComponent {

		[Child]
        public var b:SimpleButton;
        public var holderFunction:Function;
        public var colorVar:uint;
        public var ct:ColorTransform;

        public function OuterColorButton(){
           super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.ct = new ColorTransform();
			this.b.addEventListener(MouseEvent.CLICK, this.doFunction, false, 0, true);
		}
        public function initialize(_arg1:uint, _arg2:Function):void{
            this.colorVar = _arg1;
            this.holderFunction = _arg2;
            this.ct.color = _arg1;
            this.b.transform.colorTransform = this.ct;
        }
        public function doFunction(_arg1:MouseEvent=null):void{
            this.holderFunction(this.colorVar, 0);
        }
    }
}//package Flight_fla 
