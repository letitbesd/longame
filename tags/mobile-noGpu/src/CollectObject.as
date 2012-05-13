package {
	import flash.display.MovieClip;

    public class CollectObject extends SimpleObject {

        public var doodadType:uint= 0
        public var prevX:Number= 0
        public var prevGap:Number= 0
        private var mc:MovieClip;
        private var pe:ParticleEmitter;

        public function CollectObject(doodadType:uint=0){
            this.doodadType = doodadType;
            
        }
		override protected function whenActive():void
		{
			super.whenActive();
			switch (doodadType){
				case 0:
					this.source=CollectGraphic;
					break;
				case 1:
					this.source=GoldStar;
					this.pe = new ParticleEmitter(this);
					this.pe.setVar("xRand", 40);
					this.pe.setVar("yRand", 15);
					this.pe.setVar("spawnPer", 1);
					this.pe.setVar("addMode", true);
					this.pe.setVar("lastFor", 0);
					break;
				case 2:
					this.source=CraneDoodad
					this.stop();
					break;
				case 3:
					this.source=WindmillDoodad;
					this.stop();
					break;
				case 4:
					this.source=RainbowStar;
				case 5:
					this.source=PurpleStar;
					break;
			}
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			//this.gotoAndPlay(1);
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			if (this.doodadType == 1){
				this.pe.killMe();
				this.pe = null;
			}
		}
		override protected function whenFramed():void
		{
			if((doodadType==1)||(doodadType==3)){
				if(this.currentFrame==this.totalFrames){
					this.mc.crane.gotoAndStop(0);
				}
			}
		}
        public function pickUp():void{
            var numUp:PlusNumUp;
            if (this.actived){
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
						this.scene.add(numUp);
						//TODO
//						_gD.put(numUp, _gD.FG);
						numUp.x = x;
						numUp.y = y;
					}
                }
				this.dispose();
            }
        }
    }
}
