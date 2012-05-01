//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;

    public class ParticleEmitter {

        private var x:Number= 0
        private var y:Number= 0
        private var xVel:Number= 0
        private var yVel:Number= 0
        private var yOffset:int= 0
        private var decelFactor:Number= 1
        private var attachTo= null
        private var lastFor:uint= 40
        private var overUnder:uint= 1
        private var graphic:uint= 0
        private var graphicOverride:BitmapData= null
        private var rate:uint= 0
        private var rateNow:uint= 0
        private var spawnPer:uint= 1
        private var xRand:uint= 0
        private var yRand:uint= 0
        private var randSizer:Boolean= true
        private var explodeObject:Object;
        private var xVelP:Number= 0
        private var xRandVel:Number= 0
        private var addMode:Boolean= false
        private var yVelP:Number= 0
        private var xVelA:int= 0
        private var yVelA:int= 0
        private var decay:uint= 30
        private var speedBind:Boolean= false
        private var halfLife:Number= 0
        private var randomFactor:Number= 0

        public static var allEmitters:Array = [];

        public function ParticleEmitter(_arg1=null, _arg2:Boolean=true, _arg3:Boolean=false, _arg4:uint=0, _arg5:int=1, _arg6:uint=0):void{
            var _local7:Number;
            this.explodeObject = {staticRand:2, amount:80};
            super();
            ParticleEmitter.allEmitters.push(this);
            if (_arg1 != null){
                if (_arg2){
                    this.attachTo = _arg1;
                } else {
                    this.x = _arg1.ax;
                    this.y = _arg1.ay;
                };
            };
            if (_arg3){
                this.calibrateExplosion(_arg4, _arg5, _arg6);
                while (this.explodeObject.amount > 0) {
                    this.explodeObject.amount--;
                    _local7 = (this.explodeObject.staticRand * Math.random());
                    this.putPar(_local7);
                };
            } else {
                Ticker.D.addEventListener(FEvent.TICK, this.runEmission);
            };
        }
        public function setVar(_arg1:String, _arg2):void{
            this[_arg1] = _arg2;
        }
        private function runEmission(_arg1:FEvent):void{
            var _local2:uint;
            if (this.attachTo != null){
                this.x = this.attachTo.ax;
                this.y = (this.attachTo.ay + this.yOffset);
                if (this.speedBind){
                    this.xVelP = (this.attachTo.xVel * 0.5);
                    this.yVelP = (this.attachTo.yVel * 0.5);
                };
            } else {
                this.x = (this.x + this.xVel);
                this.y = (this.y + this.yVel);
            };
            this.xVel = (this.xVel * this.decelFactor);
            this.yVel = (this.yVel * this.decelFactor);
            if (this.rateNow == this.rate){
                _local2 = this.spawnPer;
                while (_local2 > 0) {
                    this.putPar();
                    _local2--;
                };
                this.rateNow = 0;
            } else {
                this.rateNow++;
            };
            if (this.lastFor > 0){
                this.lastFor--;
                if (this.lastFor == 0){
                    this.killMe();
                };
            };
        }
        private function putPar(_arg1:Number=1):void{
            var _local6:BitmapData;
            var _local2:Boolean;
            var _local3:uint;
            while (_local2) {
                _local3++;
                if ((((Math.random() > this.halfLife)) || ((_local3 > 10)))){
                    _local2 = false;
                };
            };
            var _local4:uint = Math.round((this.decay * _local3));
            if (this.graphicOverride == null){
                _local6 = RenderEngine.particles[this.graphic];
            } else {
                _local6 = this.graphicOverride;
            };
            var _local5:Particle = new Particle(_local6, ((this.xVelP * _arg1) + (Math.random() * this.xRandVel)), (this.yVelP * _arg1), _local4, this.xVelA, this.yVelA, this.addMode, this.randSizer);
            _local5.x = ((this.x - (this.xRand / 2)) + (Math.random() * this.xRand));
            _local5.y = (((this.y - (this.yRand / 2)) + (Math.random() * this.yRand)) + this.yOffset);
            if (this.attachTo != null){
                _local5.scaleX = this.attachTo.scaleX;
            };
            _local5.killMeExt = _gD.killSome;
            if (_gD.nowPar >= _gD.maxPar){
                _gD.killLastPar();
            };
            _gD.put(_local5, _gD.PE);
            _gD.nowPar++;
            _local5.gridIn = _gD.PE;
            _local5 = null;
        }
        public function killMe(_arg1:Boolean=true):void{
            var _local2:*;
            Ticker.D.removeEventListener(FEvent.TICK, this.runEmission);
            if (_arg1){
                for (_local2 in ParticleEmitter.allEmitters) {
                    if (ParticleEmitter.allEmitters[_local2] == this){
                        ParticleEmitter.allEmitters.splice(_local2, 1);
                    };
                };
            };
        }
        private function calibrateExplosion(_arg1:uint=0, _arg2:int=1, _arg3:uint=0):void{
            var _local4:Number = Math.random();
            this.graphic = _arg3;
            switch (_arg1){
                case 0:
                    this.xRand = 20;
                    this.yRand = 20;
                    this.decay = 14;
                    this.halfLife = 0.4;
                    this.yVelP = (-2 * _local4);
                    this.xVelP = (3 * _arg2);
                    this.yVelA = 23;
                    this.graphic = 1;
                    this.yOffset = -40;
                    this.explodeObject.amount = 30;
                    break;
                case 1:
                    this.xRand = 20;
                    this.yRand = 30;
                    this.decay = 22;
                    this.halfLife = 0.45;
                    this.yVelP = -5;
                    this.xVelP = ((4 * _arg2) * _local4);
                    this.yVelA = 23;
                    this.graphic = 1;
                    this.yOffset = -40;
                    this.explodeObject.amount = 90;
                    break;
                case 2:
                    this.xRand = 10;
                    this.yRand = 10;
                    this.decay = 17;
                    this.halfLife = 0.4;
                    this.yVelP = -2;
                    this.xVelP = (8 * _arg2);
                    this.yVelA = 17;
                    this.explodeObject.amount = 20;
                    break;
                default:
                    break;
            };
        }

        public static function clearAll():void{
            var _local1:*;
            for (_local1 in allEmitters) {
                allEmitters[_local1].killMe(false);
            };
            allEmitters = [];
        }

    }
}//package 
