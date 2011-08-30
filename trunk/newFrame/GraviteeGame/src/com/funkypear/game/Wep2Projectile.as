package com.funkypear.game
{

    public class Wep2Projectile extends Projectile
    {
        public var shake:int = 3;
        public var smokeLife:int = 8;
        public var smokeType:int = 0;
        public var maxDamage:int = 25;
        public var expSize:int = 60;
        public var stopMovement:Boolean = false;

        public function Wep2Projectile()
        {
            stopMovement = false;
            expSize = 60;
            shake = 3;
            maxDamage = 25;
            smokeType = 0;
            smokeLife = 8;
            return;
        }// end function

    }
}
