package {
    import flash.display.*;

    public class Particle extends SimpleGraphic {

        private var decayTime:uint;
        private var decayTimeMax:uint;
        private var xVel:Number;
        private var yVel:Number;
        private var xA:int;
        private var yA:int;

        public function Particle(_arg1:BitmapData, _arg2:Number=0, _arg3:Number=0, _arg4:uint=60, _arg5:int=0, _arg6:int=0, _arg7:Boolean=false, _arg8:Boolean=true):void{
            drawMe(_arg1);
            Ticker.D.addEventListener(FEvent.TICK, this.moveMe, false, 0, true);
            this.xVel = _arg2;
            this.yVel = _arg3;
            this.xA = _arg5;
            this.yA = _arg6;
            this.decayTimeMax = (this.decayTime = _arg4);
            if (_arg8){
                scaleX = (scaleY = (0.5 + (Math.random() * 2)));
            }
            if (_arg7){
                blendMode = "add";
            }
        }
        private function moveMe(_arg1:FEvent):void{
            x = (x + this.xVel);
            y = (y + this.yVel);
            this.xVel = (this.xVel + (this.xA / 100));
            this.yVel = (this.yVel + (this.yA / 100));
            if (this.decayTime > 0){
                alpha = (this.decayTime / this.decayTimeMax);
                this.decayTime--;
            } else {
                this.killMe();
            }
        }
        public function killMe():void{
            Ticker.D.removeEventListener(FEvent.TICK, this.moveMe);
            _gD.killPar(this);
            clearMe();
        }

    }
}
