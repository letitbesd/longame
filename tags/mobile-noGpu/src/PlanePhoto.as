package{
    import com.bumpslide.ui.UIComponent;
    
    import flash.display.*;
    import flash.geom.*;

    public  class PlanePhoto extends UIComponent {

		[Child]
        public var textureLay:MovieClip;
		[Child]
        public var colorMC:MovieClip;
		[Child]
		public var back:MovieClip;
		[Child]
		public var mk:*;
		
        public function PlanePhoto()
		{
            super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			//怪异，mask的话被mask的东西找不到，不用了找不到mask
			textureLay.mask=mk;
//			back.mask=mk;
		}
        public function setColor(color:*):void{
            var ct:ColorTransform = new ColorTransform();
            ct.color = parseInt(color);
            this.colorMC.transform.colorTransform = ct;
        }
        public function setTexture(id:int):void{
            while (this.textureLay.numChildren > 0) {
                this.textureLay.removeChildAt(0);
            }
            if (id > 0){
                this.textureLay.addChild(_g.getTexture(id));
            }
        }
    }
}
