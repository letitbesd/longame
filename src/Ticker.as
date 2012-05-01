package {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

    public class Ticker {

        private static const C:Number = 33.3333333333333;
        public static const D:EventDispatcher = new EventDispatcher();

        private static var last:uint = getTimer();
        private static var s:Stage;
        private static var counterKeeper:uint = 0;
        private static var counterTotal:uint = 0;
        public static var nowY:Number;
        public static var nowX:Number;
        public static var prevY:Array;
        public static var prevX:Array;

        public static function init(stage:Stage):void{
            s = stage;
        }
        public static function startTicker():void{
            last = getTimer();
            D.addEventListener(FEvent.TICK, doEvent);
            s.addEventListener(Event.ENTER_FRAME, tick);
        }
        public static function stopTicker():void{
            D.removeEventListener(FEvent.TICK, doEvent);
            s.removeEventListener(Event.ENTER_FRAME, tick);
        }
        public static function reset():void{
            prevX = [];
            prevY = [];
        }
        private static function tick(evt:Event):void{
            var currentTime:uint = getTimer();
            var frame:Number = ((currentTime - last) / C);
            last = currentTime;
            D.dispatchEvent(new FEvent(FEvent.TICK, frame));
            if (_g.P.held){
                prevY.push(new Number(nowY));
                prevX.push(new Number(nowX));
                if (prevY.length > 90){
                    prevY.shift();
                    prevX.shift();
                };
                nowY = s.mouseY;
                nowX = s.mouseX;
				var movedDisY:Number = Number((nowY - prevY[(prevY.length - 1)]));
				var movedDisX:Number = Number((nowX - prevX[(prevX.length - 1)]));
                if ((((movedDisX > 600)) && ((movedDisY < 0)))){
                    _g.P.letGo();
                };
            };
        }
		private static function doEvent(evt:FEvent):void{
			_gP.runEngine(evt.f);
			_gD.runCamera();
		}
    }
}
