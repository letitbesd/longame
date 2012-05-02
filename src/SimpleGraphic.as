//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;
    import __AS3__.vec.*;

    public class SimpleGraphic extends Sprite {

        public var killMeExt:Function;
        public var B:Bitmap;
        public var gridIn:Sprite;
        private var runLoopArray:Vector.<BitmapData>;
        private var repeat:Boolean= false
        private var frameOn:uint= 0
        private var killWhenDone:Boolean= false

        public function SimpleGraphic(){
            this.killMeExt = new Function();
            super();
        }
        public function initEx(_arg1:uint, _arg2:Boolean=true):void{
        }
        public function drawMe(_arg1:BitmapData):void{
            this.B = new Bitmap(_arg1);
            addChild(this.B);
            this.B.x = (-(this.B.width) / 2);
            this.B.y = (-(this.B.height) / 2);
        }
        public function animateMe(_arg1, _arg2:Boolean=false):void{
            Ticker.D.addEventListener(FEvent.TICK, this.runMe, false, 0, true);
            this.runLoopArray = _arg1;
            this.frameOn = 1;
            this.repeat = _arg2;
            this.drawMe(_arg1[0]);
        }
        private function runMe(_arg1:FEvent):void{
            this.B.bitmapData = this.runLoopArray[this.frameOn];
            this.frameOn++;
            if (this.frameOn == this.runLoopArray.length){
                if (this.repeat){
                    this.frameOn = 0;
                } else {
                    Ticker.D.removeEventListener(FEvent.TICK, this.runMe);
                    if (this.killWhenDone){
                        this.clearMe();
                    }
                }
            }
        }
        public function clearMe():void{
            Ticker.D.removeEventListener(FEvent.TICK, this.runMe);
            try {
                removeChild(this.B);
            } catch(e:Error) {
            }
            this.B = null;
        }

    }
}//package 
