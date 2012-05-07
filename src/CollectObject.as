package {
	import flash.display.MovieClip;

    public class CollectObject extends SimpleObject {

        public var doodadType:uint= 0
        public var active:Boolean= true
        public var prevX:Number= 0
        public var prevGap:Number= 0
        private var mc:MovieClip;
        private var pe:ParticleEmitter;

        public function CollectObject(type:uint=0){
            this.doodadType = type;
            this.active = true;
            switch (type){
                case 0:
                    addChild(new CollectGraphic());
                    break;
                case 1:
                    addChild(new GoldStar());
                    this.pe = new ParticleEmitter(this);
                    this.pe.setVar("xRand", 40);
                    this.pe.setVar("yRand", 15);
                    this.pe.setVar("spawnPer", 1);
                    this.pe.setVar("addMode", true);
                    this.pe.setVar("lastFor", 0);
                    break;
                case 2:
                    this.mc = new CraneDoodad();
                    this.mc.crane.stop();
                    Ticker.D.addEventListener(FEvent.TICK, this.animate, false, 0, true);
                    addChild(this.mc);
                    break;
                case 3:
                    this.mc = new WindmillDoodad();
                    this.mc.crane.stop();
                    Ticker.D.addEventListener(FEvent.TICK, this.animate, false, 0, true);
                    addChild(this.mc);
                    break;
                case 4:
                    addChild(new RainbowStar());
                case 5:
                    addChild(new PurpleStar());
                    break;
            }
        }
        private function animate(evt:FEvent):void{
            this.mc.crane.nextFrame();
            if (this.mc.crane.currentFrame == this.mc.crane.totalFrames){
                this.mc.crane.gotoAndStop(0);
            }
        }
        public function pickUp():void{
            var numUp:PlusNumUp;
            if (this.active){
                this.active = false;
                if (((!(_g.P.groundedNow)) || (_g.P.bounceMode))){
                    switch (this.doodadType){
                        case 0:
                            _g.P.normalStar();
                            numUp = new PlusNumUp(this.getGraphic(_g.P.craneMult));
                            _gD.put(numUp, _gD.FG);
                            numUp.x = x;
                            numUp.y = y;
                            _gP.removeDoodad(this);
                            break;
                        case 1:
                            _g.P.goldStar();
                            numUp = new PlusNumUp(new BonusNum());
                            _gD.put(numUp, _gD.FG);
                            numUp.x = x;
                            numUp.y = y;
                            _gP.removeDoodad(this);
                            break;
                        case 2:
                            _g.P.crane();
                            _gP.removeDoodad(this);
                            break;
                        case 3:
                            numUp = new PlusNumUp(new WindNum());
                            _gD.put(numUp, _gD.FG);
                            numUp.x = x;
                            numUp.y = y;
                            _g.P.windMill();
                            break;
                        case 4:
                            _g.P.rainbowStar();
                            numUp = new PlusNumUp(this.getGraphic(_g.P.craneMult));
                            _gD.put(numUp, _gD.FG);
                            numUp.x = x;
                            numUp.y = y;
                            _gP.removeDoodad(this);
                            break;
                        case 5:
                            _g.P.purpleStar();
                            numUp = new PlusNumUp(this.getGraphic(5));
                            _gD.put(numUp, _gD.FG);
                            numUp.x = x;
                            numUp.y = y;
                            _gP.removeDoodad(this);
                            break;
                    }
                }
            }
        }
        public function endMe():void{
            if (this.doodadType == 1){
                this.pe.killMe();
                this.pe = null;
            }
            Ticker.D.removeEventListener(FEvent.TICK, this.animate);
        }
        private function getGraphic(type:uint):MovieClip{
            switch (type){
                case 1:
                    return (new PlusNum1());
                case 2:
                    return (new PlusNum2());
                case 3:
                    return (new PlusNum3());
                case 4:
                    return (new PlusNum4());
                case 5:
                    return (new PlusNum5());
                default:
                    return (new PlusNum1());
            }
			return null;
        }

    }
}
