//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class PlusNumUp extends Sprite {

        private var stayTime:uint= 40
        private var xVel:Number= 0
        private var xAccel:Number= -0.32
        private var scaler:Number= 1
        private var gf:GlowFilter;
        private var ctr:ColorTransform;
        private var ctr2:ColorTransform;
        private var ctrOS:Number= 0xFF

        public function PlusNumUp(asset:DisplayObject):void{
            this.gf = new GlowFilter();
            this.ctr = new ColorTransform();
            this.ctr2 = new ColorTransform();
            super();
            addChild(asset);
            Ticker.D.addEventListener(FEvent.TICK, this.run, false, 0, true);
            scaleX = (scaleY = (1 + this.scaler));
            this.ctr.redOffset = (this.ctr.blueOffset = (this.ctr.greenOffset = this.ctrOS));
            this.transform.colorTransform = this.ctr;
            this.filters = [this.gf];
            this.gf.blurX = 5;
            this.gf.blurY = 5;
            this.gf.strength = 1;
            this.gf.color = 0xFFFFFF;
        }
        private function run(_arg1:FEvent):void{
            if (this.scaler > 0.01){
                this.scaler = (this.scaler - 0.2);
                this.gf.blurX = (this.gf.blurX - 1);
                this.gf.blurY = (this.gf.blurY - 1);
                this.gf.strength = (this.gf.strength - 0.2);
                this.ctrOS = (this.ctrOS - (0xFF / 5));
                this.ctr.redOffset = (this.ctr.blueOffset = (this.ctr.greenOffset = this.ctrOS));
                this.transform.colorTransform = this.ctr;
                this.filters = [this.gf];
                scaleX = (scaleY = (1 + this.scaler));
            }
            this.xVel = (this.xVel + this.xAccel);
            x = (x + this.xVel);
            this.stayTime--;
            if (this.stayTime < 30){
                this.alpha = (this.alpha - 0.03);
            }
            if (this.stayTime == 0){
                this.killThis();
            }
        }
        private function killThis():void{
            Ticker.D.removeEventListener(FEvent.TICK, this.run);
            try {
                _gD.FG.removeChild(this);
            } catch(e:Error) {
            }
        }

    }
}//package 
