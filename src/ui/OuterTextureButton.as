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
    
    import screens.UpgradeScreen;

    public class OuterTextureButton extends UIComponent {

		[Child]
        public var b:MovieClip;
        public var holderFunction:UpgradeScreen;
        public var textureVar:uint;

        public function OuterTextureButton(){
            super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.b.addEventListener(MouseEvent.CLICK, this.doFunction, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_OVER, this.m_big, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_OUT, this.m_small, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_DOWN, this.m_big, false, 0, true);
			this.b.addEventListener(MouseEvent.MOUSE_UP, this.m_small, false, 0, true);
		}
        public function initialize(_arg1:uint, _arg2:UpgradeScreen):void{
            this.textureVar = _arg1;
            this.holderFunction = _arg2;
            if (_arg1 > 0){
                this.b.textureLay.addChild(_g.getTexture(this.textureVar));
            }
        }
        public function doFunction(_arg1:MouseEvent=null):void{
            this.holderFunction.textureExOuter(this.textureVar, 1);
        }
        public function m_big(_arg1:MouseEvent=null):void{
            this.b.scaleX = (this.b.scaleY = 1.3);
        }
        public function m_small(_arg1:MouseEvent=null):void{
            this.b.scaleX = (this.b.scaleY = 1);
        }
    }
}//package Flight_fla 
