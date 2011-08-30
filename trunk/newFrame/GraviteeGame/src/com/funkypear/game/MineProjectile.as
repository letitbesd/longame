package com.funkypear.game
{

    public class MineProjectile extends Projectile
    {
        public var shake:int = 5;
        public var lastIntSectionElement:int = -1;
        public var lastIntSectionPlanet:int = -1;
        public var maxDamage:int = 25;
        public var timeTilBoom:int = 60;
        public var expSize:int = 80;
        public var stopMovement:Boolean = false;
        public var intDelay:int = 0;
        public var lastIntSectionShape:int = -1;
        public var activated:Boolean = false;
        public var timeTilPrimed:int = 60;

        public function MineProjectile()
        {
            stopMovement = false;
            expSize = 80;
            shake = 5;
            maxDamage = 25;
            lastIntSectionPlanet = -1;
            lastIntSectionShape = -1;
            lastIntSectionElement = -1;
            intDelay = 0;
            timeTilPrimed = 60;
            timeTilBoom = 60;
            activated = false;
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4, 4, frame5);
            hasSmoke = false;
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame3()
        {
            stop();
            return;
        }// end function

        function frame4()
        {
            stop();
            return;
        }// end function

        function frame5()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

    }
}
