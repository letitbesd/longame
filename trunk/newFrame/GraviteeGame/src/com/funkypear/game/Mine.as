package com.funkypear.game
{
    import flash.display.*;

    public class Mine extends MovieClip
    {
        public var shake:int = 3;
        public var maxDamage:int = 25;
        public var positionElementX:Number = 0;
        public var positionPlanet:int = 0;
        public var positionElementY:Number = 0;
        public var removeMe:Boolean = false;
        public var positionPlace:Number = 0;
        public var timeTilBoom:int = 60;
        public var positionElement:int = 0;
        public var expSize:int = 80;
        public var activated:Boolean = false;
        public var timeTilPrimed:int = 60;
        public var positionShape:int = 0;

        public function Mine()
        {
            positionPlanet = 0;
            positionShape = 0;
            positionElement = 0;
            positionElementX = 0;
            positionElementY = 0;
            positionPlace = 0;
            timeTilPrimed = 60;
            timeTilBoom = 60;
            shake = 3;
            expSize = 80;
            maxDamage = 25;
            activated = false;
            removeMe = false;
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4, 4, frame5);
            return;
        }// end function

        function frame3()
        {
            stop();
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame4()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

        function frame5()
        {
            stop();
            return;
        }// end function

    }
}
