package com.funkypear.game
{
    import flash.display.*;

    public class ShieldNode extends MovieClip
    {
        public var life:int = 3;
        public var timeTilDie:int = 0;
        public var shieldLine:ShieldLine;

        public function ShieldNode()
        {
            life = 3;
            timeTilDie = 0;
            return;
        }// end function

    }
}
