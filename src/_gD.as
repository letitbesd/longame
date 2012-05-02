package {
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import ui.GameScreenUI;

    public class _gD {

        private static const camOffset:Number = 140;
        private static const camLockSpeed:Number = 0.12;
        /**
		 * 游戏场景总容器
		 * */
        public static var GRID:Sprite;
        public static var FG:Sprite;
        public static var G:Sprite;
        public static var UG:Sprite;
        public static var BG:Sprite;
        public static var UI:Sprite;
        public static var PE:Sprite;
        public static var uiBody:GameScreenUI;
        public static var postBox:PostBox = new PostBox();
        public static var bgNum:uint = 0;
		/**
		 * 向导提示按钮
		 * */
        public static var TB:TutBox = new TutBox();
        public static var G1:Sprite = new Sprite();
        public static var G2:Sprite = new Sprite();
        public static var G3:Sprite = new Sprite();
        public static var G4:Sprite = new Sprite();
        public static var G5:Sprite = new Sprite();
        public static var GSPACE:Sprite = new Sprite();
        public static var yDrop:Number;
        public static var G1Y:Number;
        public static var G2Y:Number;
        public static var G3Y:Number;
        public static var G4Y:Number;
        private static var shakeArray:Array = [];
        public static var camPoint:Point = new Point(0, 0);
        public static var camPointLock:Boolean = false;
        public static var camLockTo:Object;
        public static var maxPar:uint = 450;
        public static var nowPar:uint = 0;

		/**
		 * 显示向导提示
		 * */
        public static function showTut(label:String, hideButton:Boolean=false):void{
            TB.visible = true;
            TB.mouseEnabled = true;
            TB.t.gotoAndStop(label);
            if (TB.alpha < 0){
                TB.alpha = 0;
                TB.visible = false;
            }
            if (hideButton){
                TB.b.visible = false;
            } else {
                TB.b.visible = true;
            }
            TB.addEventListener(Event.ENTER_FRAME, fadeInTut, false, 0, true);
            TB.removeEventListener(Event.ENTER_FRAME, fadeOutTut);
        }
        private static function fadeInTut(evt:Event):void{
            TB.alpha = (TB.alpha + 0.07);
            if (TB.alpha > 1){
                TB.removeEventListener(Event.ENTER_FRAME, fadeInTut);
                TB.alpha = 1;
            }
        }
        private static function fadeOutTut(evt:Event):void{
            TB.alpha = (TB.alpha - 0.07);
            if (TB.alpha < 1){
                TB.removeEventListener(Event.ENTER_FRAME, fadeOutTut);
                TB.alpha = 0;
                TB.visible = false;
                TB.mouseEnabled = false;
            }
        }
		/**
		 * 隐藏向导提示
		 * */
        public static function hideTut():void{
            TB.addEventListener(Event.ENTER_FRAME, fadeOutTut, false, 0, true);
            TB.removeEventListener(Event.ENTER_FRAME, fadeInTut);
        }
        public static function killPar(p:Particle):void{
            if (nowPar > 0){
                nowPar--;
            }
            try {
                PE.removeChild(p);
            } catch(e:Error) {
            }
        }
        public static function killLastPar():void{
            var par:Particle = PE.getChildAt(0) as Particle;
            par.killMe();
        }
        public static function reset():void{
            nowPar = 0;
            GRID = new Sprite();
            FG = new Sprite();
            G = new Sprite();
            BG = new Sprite();
            UI = new Sprite();
            PE = new Sprite();
            UG = new Sprite();
            GRID.addChild(BG);
            GRID.addChild(UG);
            GRID.addChild(G);
            GRID.addChild(PE);
            GRID.addChild(FG);
            GRID.addChild(UI);
            shakeArray = [];
            uiBody = new GameScreenUI();
            UI.addChild(uiBody);
            UI.addChild(postBox);
            UI.addChild(TB);
            TB.x = 360;
            TB.y = 240;
            TB.alpha = 0;
            TB.visible = false;
            initBG();
            _g.ROOT.addChildAt(GRID, 0);
        }
        public static function hideInterface():void{
            _g.ROOT.removeChild(GRID);
        }
        private static function initBG():void{
            G1 = new Sprite();
            G2 = new Sprite();
            G3 = new Sprite();
            G4 = new Sprite();
            G5 = new Sprite();
            GSPACE = new Sprite();
            BG.addChild(GSPACE);
            BG.addChild(G5);
            BG.addChild(G4);
            BG.addChild(G3);
            BG.addChild(G2);
            BG.addChild(G1);
            G1.addChild(new Bitmap(RenderEngine.frontBGRender[bgNum]));
            var img1:Bitmap = new Bitmap(RenderEngine.frontBGRender[bgNum]);
            G1.addChild(img1);
            img1.x = 720;
            G2.addChild(new Bitmap(RenderEngine.midBGRender[bgNum]));
            var img2:Bitmap = new Bitmap(RenderEngine.midBGRender[bgNum]);
            G2.addChild(img2);
            img2.x = 999;
            G3.addChild(new Bitmap(RenderEngine.backBGRender[bgNum]));
            var img3:Bitmap = new Bitmap(RenderEngine.backBGRender[bgNum]);
            G3.addChild(img3);
            img3.x = 999;
            G4.addChild(new Bitmap(RenderEngine.cloudBG[bgNum]));
            var img4:Bitmap = new Bitmap(RenderEngine.cloudBG[bgNum]);
            G4.addChild(img4);
            img4.x = 999;
            G5.addChild(new Bitmap(RenderEngine.skyBG[bgNum]));
            GSPACE.addChild(new Bitmap(RenderEngine.spaceBG[0]));
            G1.y = (G1Y = ((_g.sh2 * 2) - G1.height));
            G2.y = (G2Y = ((_g.sh2 * 2) - G2.height));
            G3.y = (G3Y = ((_g.sh2 * 2) - G3.height));
            G4.y = (G4Y = -265);
        }
        public static function setSky(alpha:Number):void{
            G5.alpha = alpha;
        }
        public static function put(obj:DisplayObject, container:Sprite=null, removeOld:Boolean=false):void{
            if (container == null){
                container = G;
            }
            if (removeOld){
                while (container.numChildren > 0) {
                    container.removeChildAt(0);
                }
            }
            container.addChild(obj);
        }
        public static function resetCam():void{
            camPointLock = false;
            camPoint.x = _g.sw2;
            camPoint.y = _g.sh2;
            camLockTo = null;
        }
        public static function killSome(target:DisplayObject, container:Sprite):void{
            try {
				container.removeChild(target);
            } catch(e:Error) {
            }
        }
        public static function runCamera():void{
            var _local2:*;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            if (camLockTo != null){
                _local3 = ((camLockTo.ax + camOffset) - camPoint.x);
                if (camLockTo.ay < _g.sh2){
                    _local4 = (camLockTo.ay - camPoint.y);
                } else {
                    _local4 = 0;
                    camPoint.y = _g.sh2;
                }
                camPoint.x = (camPoint.x + (_local3 * camLockSpeed));
                camPoint.y = (camPoint.y + (_local4 * camLockSpeed));
                _g.P.x = ((_g.sw2 - camOffset) + _local3);
                if (camLockTo.ay < _g.sh2){
                    _g.P.y = (_g.sh2 + (camLockTo.ay - camPoint.y));
                } else {
                    _g.P.y = _g.P.ay;
                }
                if ((Math.abs(_local3) + Math.abs(_local4)) < 2){
                    camPointLock = true;
                    camLockTo = null;
                }
            }
            if (camPointLock){
                _g.P.x = (_g.sw2 - camOffset);
                camPoint.x = (_g.P.ax + camOffset);
                if (_g.P.ay < _g.sh2){
                    _g.P.y = _g.sh2;
                    camPoint.y = _g.P.ay;
                } else {
                    camPoint.y = _g.sh2;
                    _g.P.y = _g.P.ay;
                }
            }
            var _local1:Number = 30;
            for (_local2 in shakeArray) {
                _local5 = 0;
                _local5 = (-(Math.sin(shakeArray[_local2].sinVal)) * shakeArray[_local2].amount);
                if (_local5 > _local1){
                    _local5 = _local1;
                }
                if (_local5 < -(_local1)){
                    _local5 = -(_local1);
                }
                camPoint.y = (camPoint.y + _local5);
                if (camPointLock){
                    _g.P.y = (_g.P.y + _local5);
                }
                shakeArray[_local2].sinVal = (shakeArray[_local2].sinVal + shakeArray[_local2].sinPlus);
                if (shakeArray[_local2].decay > 0){
                    shakeArray[_local2].amount = (shakeArray[_local2].amount * shakeArray[_local2].decay);
                } else {
                    shakeArray[_local2].decay++;
                }
            }
            for (_local2 in shakeArray) {
                if ((((shakeArray[_local2].amount <= 0.1)) || ((shakeArray[_local2].decay == 0)))){
                    shakeArray.splice(_local2, 1);
                }
            }
            alignCamera();
        }
        public static function clearShake():void{
            shakeArray = [];
        }
        public static function setCamOn(data:*):void{
            camLockTo = data;
        }
        public static function doShake(type:uint=0, amount:Number=15):void{
            switch (type){
                case 0:
                    shakeArray.push({sinVal:0, amount:30, decay:0.82, sinPlus:2});
                    break;
                case 1:
                    shakeArray.push({sinVal:0, amount:15, decay:0.78, sinPlus:3});
                    break;
                case 2:
                    shakeArray.push({sinVal:0, amount:40, decay:0.85, sinPlus:1.8});
                    break;
                case 3:
                    shakeArray.push({sinVal:0, amount:amount, decay:0.96, sinPlus:0.2});
                    break;
            }
        }
        private static function alignCamera():void{
            G1.x = (-(getBGNum(1, 720)) + _g.sw2);
            G2.x = (-(getBGNum(0.6, 1000)) + _g.sw2);
            G3.x = (-(getBGNum(0.3, 1000)) + _g.sw2);
            G4.x = (-(getBGNum(0.05, 1000)) + _g.sw2);
            yDrop = (-(camPoint.y) + _g.sh2);
            G1.y = (G1Y + yDrop);
            G2.y = (G2Y + (yDrop * 0.9));
            G3.y = (G3Y + (yDrop * 0.7));
            G4.y = (G4Y + (yDrop * 0.06));
            _gP.setSky();
            PE.y = -((-(_g.sh2) + camPoint.y));
            PE.x = -((-(_g.sw2) + camPoint.x));
        }
        private static function getBGNum(x:Number, y:Number):Number{
            return (((camPoint.x * x) - (Math.floor((((camPoint.x * x) - _g.sw2) / y)) * y)));
        }

    }
}
