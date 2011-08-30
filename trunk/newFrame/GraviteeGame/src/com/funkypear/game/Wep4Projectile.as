package com.funkypear.game
{

    public class Wep4Projectile extends Projectile
    {
        public var shake:int = 1;
        public var maxDamage:int = 40;
        public var expSize:int = 0;
        public var stopMovement:Boolean = false;

        public function Wep4Projectile()
        {
            stopMovement = false;
            expSize = 0;
            maxDamage = 40;
            shake = 1;
            diameter = 2;
            mass = 0;
            hasSmoke = false;
            return;
        }// end function

    }
}
