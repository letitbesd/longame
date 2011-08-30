package com.funkypear.game
{

    public class AIHitPlanet extends Object
    {
        public var posX:Number = 0;
        public var posY:Number = 0;
        public var momX:Number = 0;
        public var momY:Number = 0;
        public var GFXscale:int = 0;
        public var wepToKill:int = -1;
        public var GFXframe:int = 0;
        public var unitDist:int = 0;

        public function AIHitPlanet(param1, param2, param3, param4, param5, param6, param7)
        {
            GFXframe = 0;
            GFXscale = 0;
            momX = 0;
            momY = 0;
            posX = 0;
            posY = 0;
            unitDist = 0;
            wepToKill = -1;
            GFXframe = param1;
            GFXscale = param2;
            momX = param3;
            momY = param4;
            posX = param5;
            posY = param6;
            unitDist = param7;
            return;
        }// end function

    }
}
