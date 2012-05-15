package {
    import com.longame.display.screen.ScreenManager;
    
    import flash.display.*;
    import flash.events.*;
    
    import model.PlayerData;
    
    import screens.GameScreen;
    import screens.MainMenuScreen;
    import screens.PostScreen;
    import screens.UpgradeScreen;

    public class _g {

        public static var ROOT:Object;
        public static var STAGE:Stage;
        public static var P:Plane;
        public static var sw2:uint = 360;
        public static var sh2:uint = 240;
        public static var airdensity:Number = 10;
        private static var tiltUpKey:uint = 37;
        private static var tiltDownKey:uint = 39;
        private static var tiltUpKey2:uint = 65;
        private static var tiltUpKey3:uint = 38;
        private static var tiltDownKey2:uint = 68;
        private static var tiltDownKey3:uint = 40;
        private static var engineKey:uint = 32;
        private static var rainbowKey:uint = 82;
        private static var pauseKey:uint = 80;
        private static var confirmKey:uint = 32;
        private static var tiltUp:Boolean = false;
        private static var tiltDown:Boolean = false;
        private static var boostOn:Boolean = false;
        private static var engineActivate:Boolean = false;
        public static var planeShadow:PlaneShadow = new PlaneShadow();
        public static var SW:StallWarning = new StallWarning();
        public static var SS:StallSign = new StallSign();
        public static var JW:JetStreamWarning = new JetStreamWarning();
        public static var playerData:PlayerData = new PlayerData();
        public static var currentSlot:uint = 1;
        public static var adder:Number;
        public static var gamePaused:Boolean = false;
        public static var realPause:Boolean = false;
        public static var starsGathered:uint = 0;
		
		public static var changeLevel:Boolean;
		public static var justLeveled:Boolean

        public static function getAch(ach:aHolder):void{
            STAGE.addChild(ach);
        }
        public static function pauseGame():void
		{
            Ticker.stopTicker();
        }
        public static function resumeGame():void
		{
            Ticker.startTicker();
        }
        public static function init(root:Object, stage:Stage):void
		{
            ROOT = root;
            STAGE = stage;
        }
        public static function reset():void
		{
            soundKon.playMusic(1);
            gamePaused = false;
            realPause = false;
			//背景
            _gD.bgNum = playerData.stats[1];
            if (_gD.bgNum > 4){
                _gD.bgNum = Math.floor((Math.random() * 4.99));
            }
            _gD.reset();
			_gD.TB.b.addEventListener(MouseEvent.CLICK,resumeFromTutorial);
        }
        public static function pause():void{
            Ticker.stopTicker();
            realPause = true;
        }
        public static function resume():void{
            Ticker.startTicker();
            _gD.hideTut();
            realPause = false;
        }
        public static function pauseResume():void{
            if (P.thrown){
                if (gamePaused){
                    resume();
                    gamePaused = false;
                } else {
                    if (!realPause){
                        pause();
                        _gD.showTut("pause", true);
                        gamePaused = true;
                    }
                }
            }
        }
        public static function tutorial(name:String, pauseGame:Boolean=true):void{
            var newTut:Boolean=true;
            for (var tut:* in playerData.tut) {
                if (playerData.tut[tut] == name){
                    newTut = false;
					break;
                }
            }
            if (newTut){
                if (pauseGame){
                    pause();
                }
                if (name == "tut_throw"){
                    _gD.showTut(name, true);
                } else {
                    _gD.showTut(name);
                }
                playerData.tut.push(name);
            }
        }
        public static function resumeFromTutorial(_arg1:MouseEvent=null):void{
            resume();
        }
        public static function ready():void{
			changeLevel=false;
            _gP.resetObjects();
            _gP.burstDraw();
            tutorial("tut_throw", false);
            starsGathered = 0;
            engineActivate = false;
            P = new Plane();
            SW = new StallWarning();
            JW = new JetStreamWarning();
            SS = new StallSign();
            _gD.put(planeShadow);
            _gD.put(P);
            _gD.put(SW);
            _gD.put(SS);
            _gD.put(JW);
            SS.visible = false;
            JW.visible = false;
            planeShadow.x = (P.x = (P.ax = 200));
            planeShadow.y = _gP.ground;
            P.y = (P.ay = 200);
            _gP.P = P;
            _gP.add(P);
            _gD.resetCam();
            Ticker.startTicker();
            if ((_g.playerData.upgrades[3] + _g.playerData.upgrades[5]) == 0){
                _gD.uiBody.fuelBar.visible = false;
            }
            P.addEventListener(MouseEvent.MOUSE_DOWN, pickUp);
            STAGE.addEventListener(MouseEvent.MOUSE_UP, letGo);
            STAGE.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
            STAGE.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
        }
        private static function keyDown(evt:KeyboardEvent):void{
            var _local2:uint = evt.keyCode;
            if (_local2 == pauseKey){
                pauseResume();
            }
            if (_local2 == engineKey){
                if (P.thrown){
                    if (!engineActivate){
                        if (_g.playerData.upgrades[5] > 0){
                            if (_g.P.fuel >= 10){
                                if (!_g.P.groundedNow){
                                    engineActivate = true;
                                    P.engineSwitch("START");
                                }
                            }
                        }
                    }
                }
            }
            if (_local2 == confirmKey){
                if (realPause){
                    resume();
                }
            }
            if (_local2 == rainbowKey){
                P.startRainbowStar();
            }
            if ((((((_local2 == tiltUpKey)) || ((_local2 == tiltUpKey2)))) || ((_local2 == tiltUpKey3)))){
                if (!tiltUp){
                    if (_g.playerData.upgrades[3] > 0){
                        tiltUp = true;
                        tiltDown = false;
                        P.tilt("UP");
                    }
                }
            }
            if ((((((_local2 == tiltDownKey)) || ((_local2 == tiltDownKey2)))) || ((_local2 == tiltDownKey3)))){
                if (!tiltDown){
                    if (_g.playerData.upgrades[3] > 0){
                        tiltDown = true;
                        tiltUp = false;
                        P.tilt("DOWN");
                    }
                }
            }
        }
        private static function keyUp(evt:KeyboardEvent):void{
            var _local2:uint = evt.keyCode;
            if (_local2 == engineKey){
                if (P.thrown){
                    if (engineActivate){
                        engineActivate = false;
                        P.engineSwitch("END");
                    }
                }
            }
            if ((((((_local2 == tiltDownKey)) || ((_local2 == tiltDownKey2)))) || ((_local2 == tiltDownKey3)))){
                if (tiltDown){
                    P.tilt("END");
                }
                tiltDown = false;
            }
            if ((((((_local2 == tiltUpKey)) || ((_local2 == tiltUpKey2)))) || ((_local2 == tiltUpKey3)))){
                if (tiltUp){
                    P.tilt("END");
                }
                tiltUp = false;
            }
        }
        public static function finish():void{
            endGame();
            adder = (P.totalDist / 200);
            P.removeEventListener(MouseEvent.MOUSE_DOWN, pickUp);
            STAGE.removeEventListener(MouseEvent.MOUSE_UP, letGo);
            _gD.postBox.calculate();
            _gD.postBox.moveIn();
        }
        public static function endGame():void{
            Ticker.stopTicker();
        }
        public static function save():void{
            PlayerData.saveGame(currentSlot);
        }
        public static function proceed():void{
			endGame();
			_gD.hideInterface();
            if (playerData.stats[1] < 5){
				ScreenManager.openScreen(PostScreen);
//                ROOT.sceneTrans(1, "Level", true);
            } else {
                soundKon.playMusic(0);
				ScreenManager.openScreen(UpgradeScreen);
//                ROOT.sceneTrans(1, "Upgrade", true);
            }
        }
        public static function getTexture(id:uint):MovieClip{
            switch (id){
                case 1:
                    return (new _Texture1());
                case 2:
                    return (new _Texture2());
                case 3:
                    return (new _Texture3());
                case 4:
                    return (new _Texture4());
                case 5:
                    return (new _Texture5());
                case 6:
                    return (new _Texture6());
            }
			return null;
        }
        private static function pickUp(evt:MouseEvent=null):void{
            P.pickUp();
        }
        private static function letGo(evt:MouseEvent=null):void{
            P.letGo();
        }

    }
}
