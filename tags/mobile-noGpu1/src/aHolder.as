package {
    import com.bumpslide.ui.UIComponent;
    
    import flash.display.*;
    import flash.events.*;

    public class aHolder extends UIComponent {

		[Child]
		public var a:MovieClip;
		
        private var count:uint= 0
        public var placeTaken:uint= 0
        private var xUse:uint= 360
        private var yUse:Array;

		private var type:uint;
		private var arg2:uint;
        public function aHolder(type:uint, placeTaken:uint){
            this.yUse = [340, 260, 180, 100];
            super();
			this.type=type;
			this.placeTaken=placeTaken;
			this.skinClass=achPlateOuter;
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.a.inner.gotoAndStop((type + 1));
			addEventListener(Event.ENTER_FRAME, this.run, false, 0, true);
			this.a.t.text = AchieveMents.LIST[type].t;
			x = this.xUse;
			y = this.yUse[placeTaken];
			(this.skin as MovieClip).play();
		}
        private function run(evt:Event):void{
			if((this.skin as MovieClip).currentFrame==16){
				(this.skin as MovieClip).stop();
				if (this.count == 30){
					(this.skin as MovieClip).play();
				} else {
					this.count++;
				}
			}
			if((this.skin as MovieClip).currentFrame==(this.skin as MovieClip).totalFrames){
				this.dispose();
			}
        }
		override protected function doDispose():void
		{
			super.doDispose();
			removeEventListener(Event.ENTER_FRAME, this.run);
			AchieveMents.killA(this.placeTaken);
		}
    }
}
