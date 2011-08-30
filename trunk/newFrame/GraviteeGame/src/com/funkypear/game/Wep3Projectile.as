package com.funkypear.game
{

    public class Wep3Projectile extends Projectile
    {
        public var shake:int = 6;
        public var smokeLife:int = 6;
        public var smokeType:int = 1;
        public var maxDamage:int = 30;
        public var expSize:int = 60;
        public var stopMovement:Boolean = false;

        public function Wep3Projectile()
        {
            stopMovement = false;
            expSize = 60;
            maxDamage = 30;
            shake = 6;
            smokeType = 1;
            smokeLife = 6;
            diameter = 12;
            return;
        }// end function

    }
}
