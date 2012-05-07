package {
	import flash.display.MovieClip;

    public class CollectObject extends SimpleObject {

        public var doodadType:uint= 0
        public var active:Boolean= true
        public var prevX:Number= 0
        public var prevGap:Number= 0
        private var mc:MovieClip;
        private var pe:ParticleEmitter;

        public function CollectObject(doodadType:uint=0){
            this.doodadType = doodadType;
            this.active = true;
            switch (doodadType){
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
                if ((!_g.P.groundedNow) || _g.P.bounceMode){
                    switch (this.doodadType){
                        case 0:
                            _g.P.normalStar();
                            numUp = new PlusNumUp("PlusNum"+_g.P.craneMult);
                            _gP.removeDoodad(this);
                            break;
                        case 1:
                            _g.P.goldStar();
                            numUp = new PlusNumUp("BonusNum");
                            _gP.removeDoodad(this);
                            break;
                        case 2:
                            _g.P.crane();
                            _gP.removeDoodad(this);
                            break;
                        case 3:
                            numUp = new PlusNumUp("WindNum");
                            _g.P.windMill();
                            break;
                        case 4:
                            _g.P.rainbowStar();
							numUp = new PlusNumUp("PlusNum"+_g.P.craneMult);
                            _gP.removeDoodad(this);
                            break;
                        case 5:
                            _g.P.purpleStar();
                            numUp = new PlusNumUp("PlusNum5");
                            _gP.removeDoodad(this);
                            break;
                    }
					if(numUp){
						//TODO
//						_gD.put(numUp, _gD.FG);
						numUp.x = x;
						numUp.y = y;
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
    }
}
