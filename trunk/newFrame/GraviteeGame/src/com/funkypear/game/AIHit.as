package com.funkypear.game
{

    public class AIHit extends Object
    {
        public var posX:Number = 0;
        public var posY:Number = 0;
        public var momX:Number = 0;
        public var momY:Number = 0;
        public var GFXscale:int = 0;
        public var GFXframe:int = 0;
        public var unitHit:int = 0;
        public var multi:int = 0;
        public var wepToKill:int = -1;

        public function AIHit(param1, param2, param3, param4, param5, param6, param7, param8)
        {
            GFXframe = param1;
            GFXscale = param2;
            momX = param3;
            momY = param4;
            posX = param5;
            posY = param6;
            unitHit = param7;
            multi = param8;
            return;
        }// end function

    }
}
