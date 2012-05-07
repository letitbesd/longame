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
        private var attachTo:SimpleObject= null
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

        public function ParticleEmitter(element:SimpleObject=null, attach:Boolean=true, exposion:Boolean=false, _arg4:uint=0, _arg5:int=1, _arg6:uint=0):void{
            var _local7:Number;
            this.explodeObject = {staticRand:2, amount:80}
            super();
            ParticleEmitter.allEmitters.push(this);
            if (element != null){
                if (attach){
                    this.attachTo = element;
                } else {
                    this.x = element.ax;
                    this.y = element.ay;
                }
            }
            if (exposion){
                this.calibrateExplosion(_arg4, _arg5, _arg6);
                while (this.explodeObject.amount > 0) {
                    this.explodeObject.amount--;
                    _local7 = (this.explodeObject.staticRand * Math.random());
                    this.putPar(_local7);
                }
            } else {
                Ticker.D.addEventListener(FEvent.TICK, this.runEmission);
            }
        }
        public function setVar(k:String, v:*):void{
            this[k] = v;
        }
        private function runEmission(evt:FEvent):void{
            var _local2:uint;
            if (this.attachTo != null){
                this.x = this.attachTo.ax;
                this.y = (this.attachTo.ay + this.yOffset);
                if (this.speedBind){
                    this.xVelP = (this.attachTo.xVel * 0.5);
                    this.yVelP = (this.attachTo.yVel * 0.5);
                }
            } else {
                this.x = (this.x + this.xVel);
                this.y = (this.y + this.yVel);
            }
            this.xVel = (this.xVel * this.decelFactor);
            this.yVel = (this.yVel * this.decelFactor);
            if (this.rateNow == this.rate){
                _local2 = this.spawnPer;
                while (_local2 > 0) {
                    this.putPar();
                    _local2--;
                }
                this.rateNow = 0;
            } else {
                this.rateNow++;
            }
            if (this.lastFor > 0){
                this.lastFor--;
                if (this.lastFor == 0){
                    this.killMe();
                }
            }
        }
        private function putPar(scale:Number=1):void{
            var _local6:BitmapData;
            var _local2:Boolean;
            var _local3:uint;
            while (_local2) {
                _local3++;
                if ((((Math.random() > this.halfLife)) || ((_local3 > 10)))){
                    _local2 = false;
                }
            }
            var _local4:uint = Math.round((this.decay * _local3));
            if (this.graphicOverride == null){
                _local6 = RenderEngine.particles[this.graphic];
            } else {
                _local6 = this.graphicOverride;
            }
            var _local5:Particle = new Particle(_local6, ((this.xVelP * scale) + (Math.random() * this.xRandVel)), (this.yVelP * scale), _local4, this.xVelA, this.yVelA, this.addMode, this.randSizer);
            _local5.x = ((this.x - (this.xRand / 2)) + (Math.random() * this.xRand));
            _local5.y = (((this.y - (this.yRand / 2)) + (Math.random() * this.yRand)) + this.yOffset);
            if (this.attachTo != null){
                _local5.scaleX = this.attachTo.scaleX;
            }
            _local5.killMeExt = _gD.killSome;
            if (_gD.nowPar >= _gD.maxPar){
                _gD.killLastPar();
            }
            _gD.put(_local5, _gD.PE);
            _gD.nowPar++;
            _local5.gridIn = _gD.PE;
            _local5 = null;
        }
        public function killMe(killChildren:Boolean=true):void{
            Ticker.D.removeEventListener(FEvent.TICK, this.runEmission);
            if (killChildren){
                for (var el:* in ParticleEmitter.allEmitters) {
                    if (ParticleEmitter.allEmitters[el] == this){
                        ParticleEmitter.allEmitters.splice(el, 1);
                    }
                }
            }
        }
        private function calibrateExplosion(type:uint=0, xVer:int=1, graphic:uint=0):void{
            var _local4:Number = Math.random();
            this.graphic = graphic;
            switch (type){
                case 0:
                    this.xRand = 20;
                    this.yRand = 20;
                    this.decay = 14;
                    this.halfLife = 0.4;
                    this.yVelP = (-2 * _local4);
                    this.xVelP = (3 * xVer);
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
                    this.xVelP = ((4 * xVer) * _local4);
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
                    this.xVelP = (8 * xVer);
                    this.yVelA = 17;
                    this.explodeObject.amount = 20;
                    break;
                default:
                    break;
            }
        }

        public static function clearAll():void{
            var _local1:*;
            for (_local1 in allEmitters) {
                allEmitters[_local1].killMe(false);
            }
            allEmitters = [];
        }

    }
}//package 
