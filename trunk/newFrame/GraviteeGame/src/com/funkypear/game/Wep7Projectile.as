package com.funkypear.game
{

    public class Wep7Projectile extends Projectile
    {
        public var shake:int = 6;
        public var smokeLife:int = 8;
        public var smokeType:int = 0;
        public var maxDamage:int = 75;
        public var expSize:int = 140;
        public var stopMovement:Boolean = false;

        public function Wep7Projectile()
        {
            stopMovement = false;
            expSize = 140;
            maxDamage = 75;
            shake = 6;
            smokeType = 0;
            smokeLife = 8;
            diameter = 12;
            return;
        }// end function

    }
}
