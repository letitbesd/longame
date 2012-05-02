//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.geom.*;

    public class _gP {

        private static const maxDoodads:uint = 0;
        private static const maxCollect:uint = 25;
        private static const craneSpawnTimeMax:uint = 25;
        private static const windmillSpawnTimeMax:uint = 65;

        public static var P:Plane;
        public static var physicalObjects:Array;
        public static var physicalDoodads:Array;
        public static var physicalCollect:Array;
        public static var groundHeight:Number = 80;
        public static var ground:Number = ((_g.sh2 * 2) - groundHeight);
        private static var nowDoodads:uint = 0;
        private static var burstGenMax:uint = 2;
        private static var burstGen:uint = burstGenMax;
        private static var nowCollect:uint = 25;
        private static var yellowStarPerc:Number = 0.02;
        private static var craneSpawn:uint = 0;
        private static var windmillSpawn:uint = 0;
        private static var rainbowCount:uint = 0;
        private static var rainbowMode:Boolean = false;
        private static var windDirection:Number;
        private static var windStrength:Number;
        private static var windStrengthDefault:Number = 20;
        private static var windPhaseNow:Number = 0;
        private static var windPhaseInterval:Number = 0.2;
        public static var GSCoolDown:uint;
        private static var gustTimer:uint;
        private static var windForceX:Number;
        private static var windForceY:Number;
        private static var windDuration:uint;
        public static var windRunning:Boolean = false;
        private static var jetCountDown:uint = 0;
        private static var jetInc:Boolean = false;
        public static var jetPoint:Number;
        private static var jetStrength:Number = 0.1;
        private static var jetCooldown:uint;
        private static var jetRadius:Number = 400;
        private static var jetForce:Number;
        private static var jetDuration:Number;
        public static var planeJet:SimpleObject;
        private static var jetMinHeight:Number = -((200 * 25));
        private static var jetMaxHeight:Number = -((200 * 100));
        private static var skyMaxHeight:Number = -((200 * 55));
        private static var thetaMax:Number = (Math.abs(skyMaxHeight) - Math.abs(jetMinHeight));

        public static function GS_Get():void{
            GSCoolDown = 120;
        }
        public static function resetObjects():void{
            physicalObjects = [];
            physicalDoodads = [];
            physicalCollect = [];
            rainbowMode = false;
            rainbowCount = 0;
            nowDoodads = 0;
            nowCollect = 0;
            GSCoolDown = 0;
            initJetNums();
            yellowStarPerc = (0.03 + (0.02 * _g.playerData.upgrades[7]));
            craneSpawn = (craneSpawnTimeMax + Math.round((Math.random() * craneSpawnTimeMax)));
            windmillSpawn = (windmillSpawnTimeMax + Math.round((Math.random() * windmillSpawnTimeMax)));
            gustTimer = (Math.round((Math.random() * 200)) + 90);
            windForceX = 0;
            windForceY = 0;
            windRunning = false;
        }
        public static function add(obj:SimpleObject):void{
            physicalObjects.push(obj);
        }
        private static function runWindEngine():void{
            var _local1:Number;
            if (windRunning){
                gustTimer--;
                if (gustTimer == 0){
                    _g.tutorial("tut_wind");
                    windForceX = ((Math.random() * 100) - 25);
                    windForceY = ((Math.random() * 300) - 150);
                    if (windForceX < 0){
                        windForceX = (windForceX * (1 - (0.2 * _g.playerData.upgrades[9])));
                    }
                    if (windForceY < 0){
                        windForceY = (windForceY * (1 - (0.2 * _g.playerData.upgrades[9])));
                    }
                    _local1 = (5 + (15 * (Math.abs(windForceY) / 150)));
                    _gD.doShake(3, _local1);
                    windDuration = (Math.round((Math.random() * 40)) + 20);
                    gustTimer = (Math.round((Math.random() * 200)) + 90);
                }
                windDuration--;
                if (windDuration == 0){
                    windForceX = 0;
                    windForceY = 0;
                }
            }
        }
        private static function initJetNums():void{
            jetCountDown = 0;
            jetCooldown = 60;
            jetPoint = 0;
            jetForce = 0;
            jetDuration = 0;
            planeJet = new SimpleObject();
        }
        public static function startJetstream():void{
            if (_g.playerData.upgrades[13] == 0){
                jetCountDown = 60;
            } else {
                jetCountDown = 90;
            }
            jetPoint = (_g.P.ay - 250);
            if (jetPoint > jetMinHeight){
                jetPoint = jetMinHeight;
            } else {
                if (jetPoint < jetMaxHeight){
                    jetPoint = jetMaxHeight;
                }
            }
            jetDuration = 0;
            planeJet.ay = jetPoint;
            createJetwarning();
        }
        private static function runJetStream():void{
            var _local1:Number;
            if (jetCountDown > 0){
                jetCountDown--;
                _local1 = (1 - (Math.abs((_g.P.ay - jetPoint)) / jetRadius));
                if (_local1 > 0){
                    _g.JW.visible = true;
                    _g.tutorial("tut_jet");
                } else {
                    _g.JW.visible = false;
                }
                if (jetCountDown == 15){
                    planeJet.ay = jetPoint;
                    createJetstream();
                }
                if (jetCountDown == 0){
                    jetDuration = 20;
                    _g.JW.visible = false;
                    _local1 = (1 - (Math.abs((_g.P.ay - jetPoint)) / jetRadius));
                    if (_local1 > 0.7){
                        _gD.doShake(2);
                    } else {
                        if (_local1 > 0.5){
                            _gD.doShake(2);
                        } else {
                            if (_local1 > 0.1){
                                _gD.doShake(2);
                            }
                        }
                    }
                }
            }
            if (jetDuration > 0){
                jetDuration--;
                realJetstream();
                if (jetDuration == 0){
                    jetForce = 0;
                    jetCooldown = 60;
                }
            }
            if (jetCooldown > 0){
                jetCooldown--;
                if (jetCooldown == 0){
                    startJetstream();
                }
            }
        }
        public static function realJetstream():void{
            var _local1:Number = (1 - (Math.abs((_g.P.ay - jetPoint)) / jetRadius));
            if (_local1 < 0){
                _local1 = 0;
            }
            jetForce = (_local1 * jetStrength);
        }
        public static function createJetstream():void{
            var _local1:ParticleEmitter = new ParticleEmitter(planeJet, true);
            _local1.setVar("xRand", 300);
            _local1.setVar("xRandVel", -30);
            _local1.setVar("xVelP", -30);
            _local1.setVar("yRand", 250);
            _local1.setVar("spawnPer", 14);
            _local1.setVar("graphic", 5);
            _local1.setVar("decay", 90);
            _local1.setVar("halfLife", 0.3);
            _local1.setVar("addMode", false);
            var _local2:ParticleEmitter = new ParticleEmitter(planeJet, true);
            _local2.setVar("xRand", 400);
            _local2.setVar("xRandVel", -20);
            _local2.setVar("xVelP", -20);
            _local2.setVar("yRand", 500);
            _local2.setVar("spawnPer", 10);
            _local2.setVar("graphic", 5);
            _local2.setVar("decay", 90);
            _local2.setVar("halfLife", 0.3);
            _local2.setVar("addMode", false);
            var _local3:ParticleEmitter = new ParticleEmitter(planeJet, true);
            _local3.setVar("xRand", 500);
            _local3.setVar("xRandVel", -8);
            _local3.setVar("xVelP", -10);
            _local3.setVar("yRand", 800);
            _local3.setVar("spawnPer", 6);
            _local3.setVar("graphic", 5);
            _local3.setVar("decay", 90);
            _local3.setVar("halfLife", 0.3);
            _local3.setVar("addMode", false);
        }
        public static function createJetwarning():void{
            var _local1:ParticleEmitter = new ParticleEmitter(planeJet, true);
            _local1.setVar("xRand", 300);
            _local1.setVar("xRandVel", -8);
            _local1.setVar("xVelP", -3);
            _local1.setVar("yRand", 800);
            _local1.setVar("spawnPer", 4);
            _local1.setVar("graphic", 6);
            _local1.setVar("decay", 90);
            _local1.setVar("halfLife", 0.3);
            _local1.setVar("lastFor", (jetCountDown + 15));
            _local1.setVar("addMode", false);
            var _local2:ParticleEmitter = new ParticleEmitter(planeJet, true);
            _local2.setVar("xRand", 300);
            _local2.setVar("xRandVel", -12);
            _local2.setVar("xVelP", -3);
            _local2.setVar("yRand", 400);
            _local2.setVar("spawnPer", 4);
            _local2.setVar("graphic", 6);
            _local2.setVar("decay", 90);
            _local2.setVar("halfLife", 0.3);
            _local2.setVar("lastFor", (jetCountDown + 15));
            _local2.setVar("addMode", false);
        }
        public static function setSky():void{
            var _local1:Number = (Math.abs(skyMaxHeight) - Math.abs(_g.P.ay));
            var _local2:Number = (_local1 / thetaMax);
            if (_local2 < 0){
                _local2 = 0;
            }
            if (_local2 > 1){
                _local2 = 1;
            }
            _gD.setSky(_local2);
        }
        public static function runEngine(_arg1:Number=1):void{
            var _local2:*;
            var _local3:Number;
            runJetStream();
            planeJet.ax = (_g.P.ax + 800);
            for (_local2 in physicalObjects) {
                runPhysics(physicalObjects[_local2]);
            }
            _g.P.adjustAngle();
            for (_local2 in physicalDoodads) {
                runPhysics(physicalDoodads[_local2], true);
            }
            for (_local2 in physicalCollect) {
                runPhysics(physicalCollect[_local2], true);
            }
            if (rainbowMode){
                if (rainbowCount > 0){
                    rainbowCount--;
                } else {
                    rainbowMode = false;
                }
            }
            if (!_g.P.groundedNow){
                runWindEngine();
            }
            if (_g.P.thrown){
                if (craneSpawn > 0){
                    craneSpawn--;
                }
                if (windmillSpawn > 0){
                    windmillSpawn--;
                }
                if (burstGen == 0){
                    if (nowCollect < maxCollect){
                        burstGen = burstGenMax;
                        if (_g.P.ay < -((200 * 50))){
                            objectGen.generateCollect(false, 5);
                            nowCollect++;
                        }
                        if ((((craneSpawn == 0)) && ((_g.P.ay > -((200 * 50)))))){
                            craneSpawn = (craneSpawnTimeMax + Math.round((Math.random() * craneSpawnTimeMax)));
                            objectGen.generateCollect(false, 2);
                            nowCollect++;
                        } else {
                            if (windmillSpawn == 0){
                                windmillSpawn = (windmillSpawnTimeMax + Math.round((Math.random() * windmillSpawnTimeMax)));
                                objectGen.generateCollect(false, 3);
                                nowCollect++;
                            } else {
                                _local3 = Math.random();
                                if (GSCoolDown > 0){
                                    GSCoolDown--;
                                }
                                if ((((_local3 < yellowStarPerc)) && ((GSCoolDown == 0)))){
                                    if (_g.P.ay > -((200 * 50))){
                                        objectGen.generateCollect(false, 1);
                                        nowCollect++;
                                    }
                                } else {
                                    if (_g.P.ay > -((200 * 30))){
                                        if (rainbowMode){
                                            objectGen.generateCollect(false, 4);
                                            nowCollect++;
                                        } else {
                                            objectGen.generateCollect(false, 0);
                                            nowCollect++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    burstGen--;
                }
            }
            if (nowDoodads < maxDoodads){
                nowDoodads++;
                objectGen.generateObject();
            }
        }
        public static function burstDraw():void{
            var i:uint = 3;
            while (i > 0) {
                nowCollect++;
                i--;
                objectGen.generateCollect(true);
            }
        }
        public static function startRainbow():void{
            rainbowMode = true;
            rainbowCount =300;
        }
        private static function runPhysics(target:*, _arg2:Boolean=false):void{
            var _local3:Number;
            var _local4:Number;
            var _local5:Point;
            var _local6:*;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            var _local18:Boolean;
            var _local19:Point;
            var _local20:Number;
            var _local21:Number;
            var _local22:Number;
            var _local23:Number;
            var _local24:*;
            if (!target.held){
                if (target.rota){
                    target.rotation = (target.rotation + 5);
                }
                if (target == _g.P){
                    _local5 = new Point(_g.P.ax, _g.P.ay);
                    for (_local6 in physicalCollect) {
                        _local18 = false;
                        if (physicalCollect[_local6].doodadType == 3){
                            _local19 = new Point(physicalCollect[_local6].ax, (physicalCollect[_local6].ay - physicalCollect[_local6].height));
                        } else {
                            _local19 = new Point(physicalCollect[_local6].ax, physicalCollect[_local6].ay);
                        }
                        if (Point.distance(_local19, _local5) <= _g.P.collectGap){
                            _local18 = true;
                        }
                        if (_local18){
                            physicalCollect[_local6].pickUp();
                            _g.P.doodadGet();
                        }
                    }
                    _local7 = (target.xVel / 10);
                    _local8 = (((0.37 * _g.airdensity) * (4 * Math.pow(_local7, 2.5))) * _g.P.wing);
                    _local9 = _g.P.CL;
                    _local10 = (1 - _g.P.CL);
                    _local11 = Math.pow((1 - (Math.abs((_local9 - 0.5)) * 2)), 1.4);
                    _local12 = (0.5 - (_g.P.CL * 0.5));
                    _local13 = 37;
                    _local14 = 25;
                    _local15 = _local10;
                    if (_local15 > 0.65){
                        _local15 = 0.65;
                    }
                    if (_g.P.planeTurning == true){
                        _g.P.lift = ((1.2 * _local8) * _local15);
                    } else {
                        _g.P.lift = ((1 * _local8) * _local15);
                    }
                    if (_g.P.lift > 750){
                        _g.P.lift = 750;
                    }
                    _g.P.drag = (((_local8 * _local12) * 0.35) * target.airRes);
                    if (_g.P.rotation > 0){
                        _g.P.lift = (_g.P.lift * -0.3);
                    } else {
                        if (_g.P.stalling){
                            _g.P.lift = (_g.P.lift * 0.2);
                        }
                    }
                    if (_g.P.rotation >= 60){
                        if (target.yVel >= 40){
                            AchieveMents.putA(2);
                        }
                    }
                    _local16 = ((_local7 * Math.pow(_local10, 2)) * 0.005);
                    if (_g.P.rotation < 0){
                    } else {
                        _local16 = (_local16 * 0.42);
                    }
                    _g.P.rotationFeedback(_local16);
                    _local17 = ((_local9 * _local13) * target.yVel);
                    if (target.yVel < 0){
                        _local17 = (_local17 * 1);
                    }
                    if (_g.P.stalling){
                        _local17 = (_local17 * 0.25);
                    }
                    if ((((target.yVel > 0)) && (!(_g.P.stalling)))){
                        _local20 = (((0.85 * _local11) * _local14) * target.yVel);
                    } else {
                        _local20 = 0;
                    }
                    if (!target.groundedNow){
                        _local21 = (((target.mass * 5.5) - _local17) - _g.P.lift);
                        _local22 = (_local20 - _g.P.drag);
                        _local22 = (_local22 + windForceX);
                        _local21 = (_local21 + windForceY);
                        target.xVel = (target.xVel * (1 - jetForce));
                    } else {
                        if (target.bounceMode){
                            _local22 = 0;
                            _local21 = (target.mass * 2);
                            target.xVel = (target.xVel * 0.995);
                            target.rotVel = (target.rotVel + (target.xVel / 20));
                        } else {
                            _local22 = 0;
                            _local21 = 0;
                            target.xVel = (target.xVel * target.groundDrag);
                            target.ay = ground;
                        }
                        if (Math.abs(target.xVel) < 0.5){
                            target.xVel = 0;
                            _g.finish();
                        }
                    }
                    if (!target.thrown){
                        _local22 = 0;
                    }
                } else {
                    _local21 = target.yForce;
                    _local22 = target.xForce;
                }
                _local3 = (_local22 / target.mass);
                _local4 = (_local21 / target.mass);
                target.xVel = (target.xVel + (_local3 / 3));
                target.yVel = (target.yVel + (_local4 / 3));
                if (target == _g.P){
                    if (target.xVel < 0){
                        target.xVel = 0;
                    }
                }
                target.ax = (target.ax + target.xVel);
                if (target.yVel > 40){
                    target.yVel = 40;
                }
                if (((!((_gD.camLockTo == null))) && ((target == _g.P)))){
                    _gD.camPoint.x = (_gD.camPoint.x + target.xVel);
                }
                if ((target.ay + target.yVel) > ground){
                    if (target.bounceMode){
                        target.ay = ground;
                        target.yVel = (target.yVel * -0.7);
                        target.xVel = (target.xVel * 0.9);
                    } else {
                        _local23 = 0;
                        target.ay = ground;
                        if ((((_g.P == target)) && (target.thrown))){
                            target.grounded();
                        }
                    }
                } else {
                    _local23 = target.yVel;
                    target.ay = (target.ay + target.yVel);
                    if (((!((_gD.camLockTo == null))) && ((target == _g.P)))){
                        _gD.camPoint.y = (_gD.camPoint.y + target.yVel);
                    }
                }
                if (!_arg2){
                    target.y = target.ay;
                    if ((((target == _g.P)) && (_gD.camPointLock))){
                        for (_local24 in physicalDoodads) {
                            physicalDoodads[_local24].ax = (physicalDoodads[_local24].ax + (physicalDoodads[_local24].camFact * target.xVel));
                            if (_gD.camPoint.y < _g.sh2){
                                physicalDoodads[_local24].ay = (physicalDoodads[_local24].ay + (physicalDoodads[_local24].camFact * _local23));
                            }
                        }
                    }
                } else {
                    target.prevGap = (target.ax - target.prevX);
                    target.prevX = target.ax;
                    target.x = ((target.ax - _gD.camPoint.x) + _g.sw2);
                    target.y = ((target.ay - _gD.camPoint.y) + _g.sh2);
                    if (_g.P.xVel == 0){
                    } else {
                        if (_g.P.xVel > 0){
                            if (target.x < -400){
                                removeDoodad(target);
                            }
                        } else {
                            if (target.x > ((_g.sw2 * 2) + 400)){
                                removeDoodad(target);
                            }
                        }
                    }
                }
            }
        }
        public static function killDoodads():void{
            var _local1:*;
            for (_local1 in physicalCollect) {
                _gD.UG.removeChild(physicalCollect[_local1]);
                physicalCollect[_local1].endMe();
            }
            physicalCollect = [];
        }
        public static function removeDoodad(target:*):void{
            var _local2:*;
            for (_local2 in physicalDoodads) {
                if (physicalDoodads[_local2] == target){
                    physicalDoodads.splice(_local2, 1);
                    _gD.G4.removeChild(target);
                    nowDoodads--;
                }
            }
            for (_local2 in physicalCollect) {
                if (physicalCollect[_local2] == target){
                    physicalCollect.splice(_local2, 1);
                    _gD.UG.removeChild(target);
                    target.endMe();
                    if (nowCollect > 0){
                        nowCollect--;
                    }
                }
            }
            target = null;
        }

    }
}//package 
