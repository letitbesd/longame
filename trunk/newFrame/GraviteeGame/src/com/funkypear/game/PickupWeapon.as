package com.funkypear.game
{

    public class PickupWeapon extends Pickup
    {

        public function PickupWeapon()
        {
            addFrameScript(28, frame29, 37, frame38);
            return;
        }// end function

        function frame29()
        {
            gotoAndPlay(9);
            return;
        }// end function

        function frame38()
        {
            stop();
            removeMe = true;
            return;
        }// end function

    }
}
