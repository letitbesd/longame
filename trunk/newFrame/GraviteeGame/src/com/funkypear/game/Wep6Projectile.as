package com.funkypear.game
{

    public class Wep6Projectile extends Projectile
    {
        public var shake:int = 0;
        public var maxDamage:int = 10;
        public var expSize:int = 0;
        public var stopMovement:Boolean = false;

        public function Wep6Projectile()
        {
            stopMovement = false;
            expSize = 0;
            maxDamage = 10;
            shake = 0;
            hasSmoke = false;
            return;
        }// end function

    }
}
