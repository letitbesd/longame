package com.funkypear.game
{

    public class TargetProjectile extends Projectile
    {
        public var GFXscale:int = 0;
        public var GFXframe:int = 0;
        public var AIposY:Number = 0;
        public var AIposX:Number = 0;
        public var stopMovement:Boolean = false;
        public var AImomX:Number = 0;
        public var AImomY:Number = 0;

        public function TargetProjectile()
        {
            stopMovement = false;
            GFXframe = 0;
            GFXscale = 0;
            AImomX = 0;
            AImomY = 0;
            AIposX = 0;
            AIposY = 0;
            return;
        }// end function

    }
}
