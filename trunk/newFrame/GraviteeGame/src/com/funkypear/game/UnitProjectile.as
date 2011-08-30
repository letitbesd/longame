package com.funkypear.game
{
    import flash.display.*;

    public class UnitProjectile extends Projectile
    {
        public var accuracy:int = 1;
        public var leftfoot:MovieClip;
        public var unitName:String = "";
        public var maxDamage:int = 25;
        public var health:int = 1;
        public var timeSince:int = 0;
        public var rightfoot:MovieClip;
        public var damageTaken:int = 0;
        public var body:MovieClip;
        public var poisoned:Boolean = false;
        public var righthand:MovieClip;
        public var head:MovieClip;
        public var stopMovement:Boolean = false;
        public var maxHealth:int = 1;
        public var lefthand:MovieClip;

        public function UnitProjectile()
        {
            stopMovement = false;
            maxHealth = 1;
            accuracy = 1;
            health = 1;
            timeSince = 0;
            unitName = "";
            damageTaken = 0;
            maxDamage = 25;
            poisoned = false;
            hasSmoke = false;
            return;
        }// end function

        public function updateCol()
        {
            head.col.gotoAndStop(team + 2);
            body.col.gotoAndStop(team + 2);
            lefthand.col.gotoAndStop(team + 2);
            righthand.col.gotoAndStop(team + 2);
            leftfoot.col.gotoAndStop(team + 2);
            rightfoot.col.gotoAndStop(team + 2);
            return;
        }// end function

        public function updateMass()
        {
            mass = health * 5;
            if (mass < 100)
            {
                mass = 100;
            }
        }
    }
}
