package com.funkypear.game
{
    import flash.display.*;

    public class BlackHole extends MovieClip
    {
        public var life:int = 100;
        public var powerX:Number = 0;
        public var powerY:Number = 0;
        public var _11f6:int = 10;
        public var timeTilSpit:int = 1;

        public function BlackHole()
        {
            life = 100;
            timeTilSpit = 1;
            _11f6 = 10;
            powerX = 0;
            powerY = 0;
            return;
        }// end function

        public function mainLoop()
        {
            timeTilSpit--;
            life--;
            if (timeTilSpit < 0)
            {
                timeTilSpit = _11f6;
            }// end if
            return;
        }// end function

    }
}
