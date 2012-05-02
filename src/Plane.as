package {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;

    public class Plane extends SimpleObject {

        public var thrown:Boolean= false
        public var fuel:Number;
        public var maxFuel:Number;
        public var turnFuelCost:Number;
        public var wing:Number= 4
        public var lift:Number= 0
        public var drag:Number= 0
        public var CL:Number= 0.8
        public var termVel:Number= 40
        public var standard:Number= 0.8
        public var maxPower:Number= 100
        public var groundDrag:Number= 0.82
        public var airRes:Number= 1
        public var wheelsOut:Boolean= false
        public var collectGap:Number= 50
        public var totalDist:Number= 0
        public var flightTime:Number= 0
        public var maxAlt:Number= 0
        public var turnSpeed:Number= 1.7
        private var selfAngleSpeed:Number= 0
        private var angleFactor:Number= 0
        private var turnAngleSpeed:Number= 0
        private var engineOn:Boolean= false
        private var peE:ParticleEmitter;
        private var enginePower:Number= 0
        public var craneMult:uint= 1
        private var craneMultCountDown:uint= 0
        public var turnMomentum:Number= 0
        private var switchPhaseMax:uint= 15
        private var switchPhase:uint;
        private var randomSwitchMax:uint= 60
        private var randomSwitch:uint;
        private var currentPhase:uint= 3
        private var targetPhase:uint= 1
        private var usedFuel:Boolean= false
        private var fuelUseEngine:Number;
        private var craneTime:Number;
        private var stallCountDownMax:uint= 70
        private var stallCountDown:uint;
        public var stalling:Boolean= false
        private var stallWarning:Boolean= false
        private var spacePressMax:uint= 100
        private var spacePressNow:uint= 0
        private var spaceDown:Boolean= false
        public var useD:Number= 0
        public var useA:Number= 0
        public var useV:Number= 0
        public var groundedNow:Boolean= false
        public var rotVel:Number= 0
        public var planeTurning:Boolean= false
		/**
		 * Plane movieClip assets
		 * */
        private var B2:MovieClip;
        private var subHolder:Sprite;
        private var rainbowAble:Boolean= false
        private var starTypeCollected:Array;
        private var starCollectedReal:uint= 0
        private var distanceUnderRadar:Number= 0
        private var velocityCountDown:uint;
        private var purpleStarsGet:uint= 0
        private var escapeCount:uint= 0
        private var windMillGetCount:uint= 0
        private var bounceDistance:Number= 0
        private var effectTime:uint= 0
        private var miniEffectPhase:uint= 2
        private var effectPhase:Boolean= true
        private var theFilter:GlowFilter;
        private var theColor:ColorTransform;

        private static var hitFilter:GlowFilter = new GlowFilter(16777105, 1, 2, 2, 5);
        private static var hitColor:ColorTransform = new ColorTransform();
        private static var healFilter:GlowFilter = new GlowFilter(16759039, 1, 2, 2, 5);
        private static var healColor:ColorTransform = new ColorTransform();
        private static var normalColor:ColorTransform = new ColorTransform();

        public function Plane():void{
			hitColor.redOffset = 150;
			hitColor.greenOffset = 110;
			hitColor.blueOffset = 50;
			hitColor.greenMultiplier = 0.9;
			hitColor.blueMultiplier = 0.9;
			healColor.redOffset = 200;
			healColor.greenOffset = 70;
			healColor.blueOffset = 200;
			
            this.switchPhase = this.switchPhaseMax;
            this.randomSwitch = this.randomSwitchMax;
            this.stallCountDown = this.stallCountDownMax;
            this.starTypeCollected = [];
            super();
            this.starTypeCollected = [false, false, false, false];
            this.starCollectedReal = 0;
            this.distanceUnderRadar = 0;
            this.velocityCountDown = 120;
            this.rotVel = 0;
            this.purpleStarsGet = 0;
            this.windMillGetCount = 0;
            this.escapeCount = 0;
            this.subHolder = new Sprite();
            bounceMode = false;
            this.rainbowAble = false;
            this.thrown = false;
            this.usedFuel = false;
            _g.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, this.pressSpace);
            _g.STAGE.removeEventListener(KeyboardEvent.KEY_UP, this.releaseSpace);
            this.maxFuel = (this.fuel = ((_g.playerData.upgrades[0] + 1) * 1100));
            _gD.uiBody.fuelBar.gotoAndStop((_g.playerData.upgrades[0] + 1));
            _gD.uiBody.fuelBar.b.width = (_gD.uiBody.fuelBar.bm.width = ((_g.playerData.upgrades[0] + 1) * 65));
            _gD.uiBody.fuelBar.b.gotoAndStop((1 + _g.playerData.upgrades[8]));
            _gD.uiBody.fuelBar.bm.gotoAndStop((1 + _g.playerData.upgrades[8]));
            this.peE = null;
            this.craneMult = 1;
            this.fuelUseEngine = (20 - (2 * _g.playerData.upgrades[8]));
            this.turnFuelCost = (8 - (1 * _g.playerData.upgrades[8]));
            this.craneTime = (90 + (30 * _g.playerData.upgrades[12]));
            _gD.uiBody.rainbowStar.visible = false;
            switch (_g.playerData.upgrades[5]){
                case 1:
                    this.enginePower = 0.8;
                    break;
                case 2:
                    this.enginePower = 1;
                    break;
                case 3:
                    this.enginePower = 1.2;
                    break;
                default:
                    break;
            }
            switch (_g.playerData.upgrades[3]){
                case 1:
                    this.turnSpeed = 1.8;
                    break;
                case 2:
                    this.turnSpeed = 2.2;
                    break;
                case 3:
                    this.turnSpeed = 2.6;
                    break;
                default:
                    break;
            }
            switch (_g.playerData.upgrades[0]){
                case 0:
                    this.B2 = new PRS_1();
                    break;
                case 1:
                    this.B2 = new PRS_2();
                    break;
                case 2:
                    this.B2 = new PRS_3();
                    break;
                case 3:
                    this.B2 = new PRS_4();
                    break;
                case 4:
                    this.B2 = new PRS_5();
                    break;
                case 0:
                    this.B2 = new PRS_1();
                    break;
            }
            var _local1:ColorTransform = new ColorTransform();
            _local1.color = _g.playerData.customize[0];
            this.B2.colorSet.transform.colorTransform = _local1;
            var _local2:Number = ((34 - (0.45 * _g.playerData.upgrades[1])) - (0.07 * _g.playerData.upgrades[0]));
            init(_local2, 10);
            addChild(this.B2);
            this.B2.x = -65;
            this.B2.y = -30;
            this.B2.gotoAndStop(3);
            this.B2.colorSet.gotoAndStop(3);
            this.B2.textureLay.gotoAndStop((_g.playerData.customize[1] + 1));
            this.airRes = ((1 - (0.08 * _g.playerData.upgrades[2])) - (0.01 * _g.playerData.upgrades[0]));
            this.wing = (3.1 + (0.1 * _g.playerData.upgrades[0]));
            this.maxPower = ((115 + (2 * _g.playerData.upgrades[0])) + (8 * _g.playerData.upgrades[4]));
        }
        public function startRainbowStar(evt:MouseEvent=null):void{
            if (this.rainbowAble){
                this.rainbowAble = false;
                _gD.uiBody.RRmoveOut();
                _gP.startRainbow();
            }
        }
        private function switchAngle(_arg1:uint=1, _arg2:uint=15):void{
            this.targetPhase = _arg1;
            this.switchPhase = _arg2;
        }
        public function pickUp():void{
            if (!this.thrown){
                startDrag(true);
                held = true;
                _gD.camPointLock = false;
                Ticker.reset();
            }
        }
        public function rotationFeedback(_arg1:Number):void{
            this.turnMomentum = (this.turnMomentum + _arg1);
        }
        public function letGo():void{
            var _local1:ParticleEmitter;
            var _local2:uint;
            var _local3:Number;
            if (held){
                _gD.hideTut();
                if (_g.playerData.stats[1] > 0){
                    _gP.windRunning = true;
                }
                this.groundedNow = false;
                soundKon.playSound(12);
                if (_g.playerData.upgrades[11] > 0){
                    this.rainbowAble = true;
                    _gD.uiBody.rainbowStar.visible = true;
                    _gD.uiBody.RRmoveIn();
					_gD.uiBody.rainbowStar.b.addEventListener(MouseEvent.CLICK,this.startRainbowStar);
                } else {
                    this.rainbowAble = false;
					_gD.uiBody.rainbowStar.b.removeEventListener(MouseEvent.CLICK,this.startRainbowStar);
                }
                if (_g.playerData.upgrades[5] > 0){
                    _g.tutorial("tut_engine");
                } else {
                    if (_g.playerData.upgrades[3] > 0){
                        _g.tutorial("tut_turn");
                    }
                }
                if (_g.playerData.upgrades[4] > 0){
                    _local1 = new ParticleEmitter(this);
                    _local1.setVar("xRand", 40);
                    _local1.setVar("yRand", 15);
                    _local1.setVar("spawnPer", (_g.playerData.upgrades[4] * 2));
                    _local1.setVar("graphic", 4);
                    _local1.setVar("addMode", true);
                    _local1.setVar("speedBind", true);
                    _local1.setVar("yVelA", 30);
                }
                stopDrag();
                this.thrown = true;
                ax = x;
                ay = y;
                _local2 = (Ticker.prevX.length - 1);
                while (_local2 > -1) {
                    if ((Ticker.nowX - Ticker.prevX[_local2]) > 0){
                        yVel = (Ticker.nowY - Ticker.prevY[_local2]);
                        xVel = (Ticker.nowX - Ticker.prevX[_local2]);
                        break;
                    }
                    if (_local2 == 0){
                        yVel = 0;
                        xVel = 0;
                    }
                    _local2--;
                }
                if (xVel <= 0){
                    xVel = 0;
                }
                if ((Math.abs(xVel) + Math.abs(yVel)) > this.maxPower){
                    _local3 = (this.maxPower / (Math.abs(xVel) + Math.abs(yVel)));
                    yVel = (yVel * _local3);
                    xVel = (xVel * _local3);
                }
                yVel = (yVel * (1 + (0.1 * _g.playerData.upgrades[4])));
                xVel = (xVel * (1 + (0.1 * _g.playerData.upgrades[4])));
                _g.ROOT.toolTip.startDrag(true);
                held = false;
                _gD.setCamOn(this);
                if (xVel != 0){
                    this.angleFactor = ((100 * yVel) / xVel);
                }
                this.turnMomentum = Math.abs((this.angleFactor / 100));
                this.adjustAngle();
            }
        }
		/**
		 * 倾斜
		 * */
        public function tilt(type:String="END"):void{
            switch (type){
                case "UP":
                    this.selfAngleSpeed = -(this.turnSpeed);
                    break;
                case "DOWN":
                    this.selfAngleSpeed = this.turnSpeed;
                    break;
                case "END":
                    this.selfAngleSpeed = 0;
                    this.turnMomentum = Math.abs((this.angleFactor / 100));
                    break;
            }
        }
        public function engineSwitch(type:String="END"):void{
            switch (type){
                case "START":
                    this.engineOn = true;
                    this.peE = new ParticleEmitter(this);
                    this.peE.setVar("xRand", 40);
                    this.peE.setVar("yRand", 10);
                    this.peE.setVar("graphic", 1);
                    this.peE.setVar("spawnPer", 3);
                    this.peE.setVar("addMode", true);
                    this.peE.setVar("speedBind", true);
                    this.peE.setVar("lastFor", 90000000);
                    break;
                case "END":
                    if (this.peE != null){
                        this.peE.killMe();
                        this.peE = null;
                    }
                    this.engineOn = false;
                    break;
            }
        }
        private function displayStallWarn():void{
        }
        public function adjustAngle():void{
            var _local3:Number;
            var _local4:Boolean;
            var _local5:Number;
            var _local6:*;
            var _local7:Number;
            var _local8:Number;
            if (this.stalling){
                if (this.spacePressNow > 0){
                    this.spacePressNow--;
                }
//                _gD.uiBody.ee.bar.width = (_gD.uiBody.ee.barMax * (this.spacePressNow / this.spacePressMax));
				_gD.uiBody.ee.bar.width = (_gD.uiBody.eeBarMax * (this.spacePressNow / this.spacePressMax));
            }
            _g.planeShadow.x = x;
            if (bounceMode){
                _g.planeShadow.y = ((15 + (_gP.ground - _gD.camPoint.y)) + _g.sh2);
                this.bounceDistance = (this.bounceDistance + xVel);
            } else {
                _g.planeShadow.y = ((_gP.ground - _gD.camPoint.y) + _g.sh2);
            }
            var _local1:uint = 230;
            var _local2:Number = (_gP.ground - ay);
            if (_local2 < _local1){
                _local3 = ((_local1 - _local2) / _local1);
            }
            _g.planeShadow.alpha = _local3;
            _g.SS.x = (_g.SW.x = (_g.JW.x = (x + 95)));
            if (y < 240){
                _g.SW.y = 240;
                _g.JW.y = 240;
            } else {
                _g.SW.y = y;
                _g.JW.y = y;
            }
            _g.JW.y = (_g.JW.y + 35);
            _g.SW.y = (_g.SW.y - 35);
            _g.SS.y = _g.SW.y;
            if (!this.stalling){
                _local4 = false;
                if (((this.thrown) && (!(this.groundedNow)))){
                    if (rotation < -10){
                        if (xVel < 25){
                            _local4 = true;
                        }
                    }
                    if (xVel < 10){
                        _local4 = true;
                    }
                }
                if (((_local4) && ((this.stallCountDown > 0)))){
                    this.stallCountDown--;
                } else {
                    this.stallCountDown = this.stallCountDownMax;
                }
                if (this.stallCountDown < (this.stallCountDownMax * 0.75)){
                    this.stallWarning = true;
                    this.displayStallWarn();
                    _g.SW.visible = true;
                } else {
                    this.stallWarning = false;
                    _g.SW.visible = false;
                }
                if (this.stallCountDown == 0){
                    this.stallMe();
                }
            }
            this.updateUI();
            if (this.randomSwitch > 0){
                this.randomSwitch--;
            } else {
                if (this.thrown){
                    this.randomSwitch = this.randomSwitchMax;
                    this.switchAngle(Math.ceil((0.01 + (Math.random() * 2.9))));
                }
            }
            if (this.targetPhase != this.currentPhase){
                if (this.switchPhase > 0){
                    this.switchPhase--;
                } else {
                    if (this.targetPhase > this.currentPhase){
                        this.currentPhase++;
                    } else {
                        this.currentPhase--;
                    }
                    this.switchPhase = this.switchPhaseMax;
                    this.B2.gotoAndStop(this.currentPhase);
                    this.B2.colorSet.gotoAndStop(this.currentPhase);
                    this.B2.textureLay.gotoAndStop((_g.playerData.customize[1] + 1));
                }
            }
            if (this.thrown){
                this.flightTime++;
                if (this.craneMultCountDown > 0){
                    this.craneMultCountDown--;
                    if (this.craneMultCountDown == 0){
                        this.craneMult = 1;
                        _gD.uiBody.moveOut();
                    }
                }
                if (this.engineOn){
                    this.usedFuel = true;
                    if ((((((this.fuel >= this.fuelUseEngine)) && (!(this.stalling)))) && (!(bounceMode)))){
                        this.fuel = (this.fuel - this.fuelUseEngine);
                        xVel = (xVel + this.enginePower);
                    } else {
                        this.engineSwitch("END");
                        if (this.fuel < this.fuelUseEngine){
                            _g.tutorial("tut_empty");
                        }
                    }
                }
                if (this.treat((-((ay - _gP.ground)) / 200)) > this.maxAlt){
                    this.maxAlt = this.treat((-((ay - _gP.ground)) / 200));
                }
                this.totalDist = (this.totalDist + xVel);
                if (this.velocityCountDown > 0){
                    this.velocityCountDown--;
                } else {
                    if (((xVel * 30) / 200) > 25){
                        AchieveMents.putA(11);
                    }
                }
                if ((-((ay - _gP.ground)) / 200) <= 3){
                    this.distanceUnderRadar = (this.distanceUnderRadar + xVel);
                    if ((this.distanceUnderRadar / 200) >= 300){
                        AchieveMents.putA(6);
                    }
                } else {
                    this.distanceUnderRadar = 0;
                }
                if ((this.totalDist / 200) >= 300){
                    if (!this.usedFuel){
                        AchieveMents.putA(0);
                    }
                }
                if ((this.totalDist / 200) >= 1000){
                    AchieveMents.putA(8);
                }
                if ((this.totalDist / 200) >= 200){
                    AchieveMents.putA(22);
                }
                if ((this.bounceDistance / 200) >= 100){
                    AchieveMents.putA(19);
                }
                if (this.flightTime == 1800){
                    AchieveMents.putA(23);
                }
                if ((-((ay - _gP.ground)) / 200) >= 15){
                    AchieveMents.putA(21);
                }
                _local5 = xVel;
                if (_local5 == 0){
                    _local5 = 0.01;
                }
                _local6 = (yVel / xVel);
                if (this.selfAngleSpeed != 0){
                    if ((((((this.turnFuelCost <= this.fuel)) && (!(this.stalling)))) && (!(bounceMode)))){
                        this.usedFuel = true;
                        this.fuel = (this.fuel - this.turnFuelCost);
                        this.planeTurning = true;
                    } else {
                        if (this.turnFuelCost > this.fuel){
                            _g.tutorial("tut_empty");
                        }
                        this.selfAngleSpeed = 0;
                        this.planeTurning = false;
                    }
                }
                if (this.selfAngleSpeed == 0){
                    this.turnAngleSpeed = this.turnMomentum;
                    if (this.turnAngleSpeed < 0){
                        this.turnAngleSpeed = 0;
                    }
                } else {
                    this.turnAngleSpeed = 0;
                }
                if (!this.stalling){
                    this.angleFactor = (this.angleFactor + this.selfAngleSpeed);
                    this.angleFactor = (this.angleFactor + this.turnAngleSpeed);
                }
                _local7 = (57.2957795 * Math.atan((this.angleFactor / 100)));
                _local8 = (57.2957795 * Math.atan((yVel / xVel)));
                if (!this.groundedNow){
                    rotation = _local7;
                } else {
                    if (bounceMode){
                        this.subHolder.rotation = (this.subHolder.rotation + this.rotVel);
                        this.rotVel = (this.rotVel * 0.9);
                    }
                }
                this.CL = (1 - (Math.abs(_local7) / 90));
            }
        }
        private function updateUI():void{
            _gD.uiBody._d.text = (this.treat((this.totalDist / 200)) + "m");
            _gD.uiBody._a.text = (this.treat((-((ay - _gP.ground)) / 200)) + "m");
            _gD.uiBody._v.text = (this.treat(((xVel * 30) / 200)) + "m/s");
            this.useD = (this.totalDist / 200);
            if ((-((ay - _gP.ground)) / 200) > this.useA){
                this.useA = (-((ay - _gP.ground)) / 200);
            }
            if (((xVel * 30) / 200) > this.useV){
                this.useV = ((xVel * 30) / 200);
            }
            _gD.uiBody.fuelBar.b.width = ((this.fuel / this.maxFuel) * _gD.uiBody.fuelBar.bm.width);
        }
        public function doodadGet():void{
        }
        public function normalStar():void{
            var _local3:*;
            var _local1:uint = (6 + Math.round((Math.random() * 2)));
            soundKon.playSound(_local1);
            this.starCollectedReal++;
            if (this.starCollectedReal >= 100){
                AchieveMents.putA(10);
            }
            if (this.starCollectedReal >= 20){
                AchieveMents.putA(20);
            }
            this.starTypeCollected[0] = true;
            var _local2:uint;
            for (_local3 in this.starTypeCollected) {
                if (this.starTypeCollected[_local3]){
                    _local2++;
                }
            }
            if (_local2 == 4){
                AchieveMents.putA(5);
            }
            _g.tutorial("tut_star");
            xVel = (xVel + 0);
            yVel = (yVel - 0);
            _g.starsGathered = (_g.starsGathered + this.craneMult);
            this.starTypeCollected[0] = 1;
        }
        public function purpleStar():void{
            var _local2:*;
            this.starCollectedReal++;
            _g.tutorial("tut_space");
            if (this.starCollectedReal > 100){
                AchieveMents.putA(10);
            }
            this.purpleStarsGet++;
            if (this.purpleStarsGet > 30){
                AchieveMents.putA(9);
            }
            this.starTypeCollected[1] = true;
            var _local1:uint;
            for (_local2 in this.starTypeCollected) {
                if (this.starTypeCollected[_local2]){
                    _local1++;
                }
            }
            if (_local1 == 4){
                AchieveMents.putA(5);
            }
            _g.starsGathered = (_g.starsGathered + 5);
            this.applyEffect("Heal");
        }
        public function rainbowStar():void{
            var _local2:*;
            this.starCollectedReal++;
            if (this.starCollectedReal > 100){
                AchieveMents.putA(10);
            }
            this.starTypeCollected[2] = true;
            var _local1:uint;
            for (_local2 in this.starTypeCollected) {
                if (this.starTypeCollected[_local2]){
                    _local1++;
                }
            }
            if (_local1 == 4){
                AchieveMents.putA(5);
            }
            xVel = (xVel + 8);
            yVel = (yVel - 2);
            _gD.doShake(1);
            this.applyEffect("Heal");
            _g.starsGathered = (_g.starsGathered + this.craneMult);
            var _local3:ParticleEmitter = new ParticleEmitter(this);
            _local3.setVar("xRand", 40);
            _local3.setVar("yRand", 15);
            _local3.setVar("spawnPer", 1);
            _local3.setVar("addMode", true);
            _local3.setVar("speedBind", true);
            _local3.setVar("graphic", 4);
            _local3.setVar("yVelA", 30);
            var _local4:ParticleEmitter = new ParticleEmitter(this);
            _local4.setVar("xRand", 40);
            _local4.setVar("yRand", 15);
            _local4.setVar("spawnPer", 1);
            _local4.setVar("addMode", true);
            _local4.setVar("speedBind", true);
            _local4.setVar("graphic", 0);
            _local4.setVar("yVelA", 30);
            var _local5:ParticleEmitter = new ParticleEmitter(this);
            _local5.setVar("xRand", 40);
            _local5.setVar("yRand", 15);
            _local5.setVar("spawnPer", 1);
            _local5.setVar("addMode", true);
            _local5.setVar("speedBind", true);
            _local5.setVar("graphic", 3);
            _local5.setVar("yVelA", 30);
            if (this.angleFactor > -5){
                this.angleFactor = -5;
                this.turnMomentum = Math.abs((this.angleFactor / 100));
            }
        }
        public function goldStar():void{
            var _local2:*;
            soundKon.playSound(9);
            this.starCollectedReal++;
            if (this.starCollectedReal > 100){
                AchieveMents.putA(10);
            }
            this.starTypeCollected[3] = true;
            var _local1:uint;
            for (_local2 in this.starTypeCollected) {
                if (this.starTypeCollected[_local2]){
                    _local1++;
                }
            }
            if (_local1 == 4){
                AchieveMents.putA(5);
            }
            xVel = (xVel + 25);
            yVel = (yVel - 5);
            _gD.doShake(1);
            this.applyEffect("Hit");
            _gP.GS_Get();
            var _local3:ParticleEmitter = new ParticleEmitter(this);
            _local3.setVar("xRand", 40);
            _local3.setVar("yRand", 15);
            _local3.setVar("spawnPer", 3);
            _local3.setVar("addMode", true);
            _local3.setVar("speedBind", true);
            _local3.setVar("yVelA", 30);
            if (this.angleFactor > -5){
                this.angleFactor = -5;
                this.turnMomentum = Math.abs((this.angleFactor / 100));
            }
        }
        public function windMill():void{
            var _local1:ParticleEmitter;
            _g.tutorial("tut_windmill");
            this.windMillGetCount++;
            if (this.windMillGetCount >= 3){
                AchieveMents.putA(1);
            }
            yVel = (yVel - 20);
            xVel = (xVel + 20);
            if (this.angleFactor > -15){
                this.angleFactor = -15;
                this.turnMomentum = Math.abs((this.angleFactor / 100));
            }
            if (_g.playerData.upgrades[9] > 0){
                yVel = (yVel - (2 * _g.playerData.upgrades[9]));
                xVel = (xVel + (7 * _g.playerData.upgrades[9]));
                _local1 = new ParticleEmitter(this);
                _local1.setVar("xRand", 40);
                _local1.setVar("yRand", 15);
                _local1.setVar("spawnPer", _g.playerData.upgrades[9]);
                _local1.setVar("addMode", true);
                _local1.setVar("graphic", 3);
                _local1.setVar("speedBind", true);
                _local1.setVar("yVelA", 30);
            }
        }
        public function crane():void{
            _g.tutorial("tut_crane");
            this.applyEffect("Heal");
            var _local1:ParticleEmitter = new ParticleEmitter(this);
            _local1.setVar("xRand", 40);
            _local1.setVar("yRand", 15);
            _local1.setVar("spawnPer", 3);
            _local1.setVar("addMode", true);
            _local1.setVar("graphic", 2);
            _local1.setVar("lastFor", this.craneTime);
            _local1.setVar("speedBind", true);
            _local1.setVar("yVelA", 30);
            if (this.craneMult < 5){
                this.craneMult++;
                if (this.craneMult == 5){
                    AchieveMents.putA(4);
                }
            }
            soundKon.playSound(this.craneMult);
            this.craneMultCountDown = this.craneTime;
            _gD.uiBody.moveIn(this.craneMult);
            if (_g.playerData.upgrades[6] > 0){
                xVel = (xVel + 10);
                yVel = (yVel - 5);
                _gD.doShake(1);
                if (this.angleFactor > -5){
                    this.angleFactor = -5;
                    this.turnMomentum = Math.abs((this.angleFactor / 100));
                }
            }
        }
        private function endStall():void{
            xVel = (xVel + 55);
            yVel = -10;
            this.angleFactor = -15;
            this.turnMomentum = Math.abs((this.angleFactor / 100));
            _gD.doShake(1);
            this.stalling = false;
            _g.SW.visible = false;
            _g.SS.visible = false;
            _g.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, this.pressSpace);
            _g.STAGE.removeEventListener(KeyboardEvent.KEY_UP, this.releaseSpace);
            var _local1:ParticleEmitter = new ParticleEmitter(this);
            _local1.setVar("xRand", 40);
            _local1.setVar("yRand", 15);
            _local1.setVar("spawnPer", 3);
            _local1.setVar("graphic", 1);
            _local1.setVar("addMode", true);
            _local1.setVar("speedBind", true);
            _local1.setVar("yVelA", 30);
            _gD.uiBody.EEmoveOut();
            this.spacePressMax = (this.spacePressMax + 25);
            if ((-((ay - _gP.ground)) / 200) <= 3){
                AchieveMents.putA(7);
            }
            this.escapeCount++;
            if (this.escapeCount >= 3){
                AchieveMents.putA(18);
            }
        }
        public function stallMe():void{
            this.stalling = true;
            _g.SW.visible = false;
            _g.SS.visible = true;
            _gD.doShake(1);
            this.spacePressNow = 0;
            if (_g.playerData.upgrades[10] > 0){
                _g.tutorial("tut_ee");
                _gD.uiBody.EEmoveIn();
                _g.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, this.pressSpace, false, 0, true);
                _g.STAGE.addEventListener(KeyboardEvent.KEY_UP, this.releaseSpace, false, 0, true);
            } else {
                _g.tutorial("tut_stall");
            }
        }
        private function pressSpace(_arg1:KeyboardEvent):void{
            if (!this.groundedNow){
                if (this.spaceDown == false){
                    this.spaceDown = true;
                    this.spacePressNow = (this.spacePressNow + 10);
                    if (this.spacePressNow >= this.spacePressMax){
                        this.spacePressNow = this.spacePressMax;
                        this.endStall();
                    }
                }
            }
        }
        private function releaseSpace(_arg1:KeyboardEvent):void{
            this.spaceDown = false;
        }
        private function treat(_arg1:Number):Number{
            var _local2:Number = Math.ceil((_arg1 * 100));
            var _local3:Number = (_local2 - (Math.floor(_arg1) * 100));
            var _local4:String = String(_local2);
            return ((_local2 / 100));
        }
        public function grounded():void{
            var _local1:uint;
            if (_g.playerData.upgrades[14]){
                bounceMode = true;
                yVel = (yVel * -0.7);
                yVel = (yVel - 10);
                xVel = (xVel + 10);
                this.B2.visible = false;
                _local1 = Math.floor((Math.random() * 2.99));
                addChild(this.subHolder);
                switch (_local1){
                    case 0:
                        this.subHolder.addChild(new _magicTurtle());
                        break;
                    case 1:
                        this.subHolder.addChild(new _magicPenguin());
                        break;
                    case 2:
                        this.subHolder.addChild(new _magicHedgehog());
                        break;
                }
                addChild(new _poofTransform());
                soundKon.playSound(9);
            } else {
                soundKon.playSound(10);
                yVel = 0;
            }
            this.groundedNow = true;
            _gD.clearShake();
            rotation = 0;
        }
        public function applyEffect(_arg1:String, _arg2:uint=9):void{
            switch (_arg1){
                case "Hit":
                    this.theFilter = Plane.hitFilter;
                    this.theColor = Plane.hitColor;
                    break;
                case "Heal":
                    this.theFilter = Plane.healFilter;
                    this.theColor = Plane.healColor;
                    break;
                default:
                    break;
            }
            this.effectTime = _arg2;
            this.effectPhase = true;
            this.miniEffectPhase = 2;
            Ticker.D.addEventListener(FEvent.TICK, this.runEffect, false, 0, true);
        }
        private function runEffect(_arg1:FEvent):void{
            this.miniEffectPhase--;
            if (this.miniEffectPhase == 0){
                this.miniEffectPhase = 1;
                if (this.effectPhase){
                    this.filters = [this.theFilter];
                    this.transform.colorTransform = this.theColor;
                    this.effectPhase = false;
                } else {
                    this.filters = [];
                    this.transform.colorTransform = normalColor;
                    this.effectPhase = true;
                }
                this.effectTime--;
                if (this.effectTime == 0){
                    Ticker.D.removeEventListener(FEvent.TICK, this.runEffect);
                    this.filters = [];
                    this.transform.colorTransform = normalColor;
                }
            }
        }
    }
}
