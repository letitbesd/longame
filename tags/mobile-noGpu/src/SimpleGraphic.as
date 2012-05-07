package {
    import flash.display.*;
    import __AS3__.vec.*;

    public class SimpleGraphic extends Sprite {

        public var killMeExt:Function;
        public var B:Bitmap;
        public var gridIn:Sprite;
        private var bmds:Vector.<BitmapData>;
        private var repeat:Boolean= false
        private var frameOn:uint= 0
        private var killWhenDone:Boolean= false

        public function SimpleGraphic(){
            this.killMeExt = new Function();
            super();
        }
        public function drawMe(bmd:BitmapData):void{
            this.B = new Bitmap(bmd);
            addChild(this.B);
            this.B.x = -(this.B.width) / 2;
            this.B.y = -(this.B.height) / 2;
        }
//        public function animateMe(bmds:Vector.<BitmapData>, repeat:Boolean=false):void{
//            Ticker.D.addEventListener(FEvent.TICK, this.runMe, false, 0, true);
//            this.bmds = bmds;
//            this.frameOn = 1;
//            this.repeat = repeat;
//            this.drawMe(bmds[0]);
//        }
        private function runMe(evt:FEvent):void{
            this.B.bitmapData = this.bmds[this.frameOn];
            this.frameOn++;
            if (this.frameOn == this.bmds.length){
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
}
