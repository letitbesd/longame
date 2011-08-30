package com.funkypear.game
{

    public class Wep5Projectile extends Projectile
    {
        public var shake:int = 6;
        public var smokeLife:int = 8;
        public var inPlanet:int = 0;
        public var smokeType:int = 0;
        public var maxDamage:int = 60;
        public var expSize:int = 100;
        public var stopMovement:Boolean = false;
        public var planetHit:int = -1;

        public function Wep5Projectile()
        {
            stopMovement = false;
            expSize = 100;
            maxDamage = 60;
            shake = 6;
            inPlanet = 0;
            planetHit = -1;
            smokeType = 0;
            smokeLife = 8;
            diameter = 12;
            return;
        }// end function

    }
}
