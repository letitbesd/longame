package com.funkypear.game
{

    public class Particle extends Object
    {
        public var maxLife:int;
        public var posX:Number;
        public var posY:Number;
        public var type:int;
        public var momX:Number;
        public var momY:Number;
        public var life:int = 0;

        public function Particle(param1, param2, param3, param4, param5, param6)
        {
            life = 0;
            posX = param1;
            posY = param2;
            momX = param3;
            momY = param4;
            type = param5;
            maxLife = param6;
            return;
        }// end function

        public function moveMe()
        {
            posX = posX + momX;
            posY = posY + momY;
            life++;
            return;
        }// end function

    }
}
