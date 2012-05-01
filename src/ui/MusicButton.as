package ui {
    import com.bumpslide.ui.UIComponent;
    
    import flash.display.*;
    import flash.events.*;

    public class MusicButton extends UIComponent {
		[Child]
        public var sv:SimpleButton;
		[Child]
        public var b:SimpleButton;
		
        public var musicToPlay:uint;

        public function MusicButton(){
           super();
        }
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			this.b.addEventListener(MouseEvent.CLICK, this.muteSound, false, 0, true);
			this.musicToPlay = 1;
			this.updateSoundStatus();
		}
        public function muteSound(_arg1:MouseEvent):void{
            soundKon.switchMute(this.musicToPlay);
            this.updateSoundStatus();
        }
        public function updateSoundStatus():void{
            if (soundKon.soundOn){
                this.sv.visible = false;
            } else {
                this.sv.visible = true;
            };
        }
    }
}
