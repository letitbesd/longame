package com.funkypear.game
{
    import flash.display.*;

    public class Pickup extends MovieClip
    {
        public var expired:Boolean = false;
        public var positionElementX:Number = 0;
        public var positionPlanet:int = 0;
        public var positionElementY:Number = 0;
        public var removeMe:Boolean = false;
        public var timeSince:int = 0;
        public var positionElement:int = 0;
        public var positionShape:int = 0;

        public function Pickup()
        {
            removeMe = false;
            timeSince = 0;
            positionPlanet = 0;
            positionShape = 0;
            expired = false;
            positionElement = 0;
            positionElementX = 0;
            positionElementY = 0;
            return;
        }// end function

    }
}
