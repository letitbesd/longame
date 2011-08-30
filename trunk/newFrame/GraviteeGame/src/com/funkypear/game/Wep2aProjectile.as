package com.funkypear.game
{

    public class Wep2aProjectile extends Projectile
    {
        public var shake:int = 3;
        public var smokeLife:int = 8;
        public var smokeType:int = 0;
        public var maxDamage:int = 15;
        public var onlyPlanet:int = 0;
        public var expSize:int = 30;
        public var stopMovement:Boolean = false;

        public function Wep2aProjectile(param1)
        {
            stopMovement = false;
            expSize = 30;
            onlyPlanet = 0;
            shake = 3;
            maxDamage = 15;
            smokeType = 0;
            smokeLife = 8;
            onlyPlanet = param1;
            return;
        }// end function

    }
}
