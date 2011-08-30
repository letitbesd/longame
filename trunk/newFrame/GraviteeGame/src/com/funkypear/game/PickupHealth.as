package com.funkypear.game
{

    public class PickupHealth extends Pickup
    {

        public function PickupHealth()
        {
            addFrameScript(28, frame29, 36, frame37);
            return;
        }// end function

        function frame29()
        {
            gotoAndPlay(9);
            return;
        }// end function

        function frame37()
        {
            stop();
            removeMe = true;
            return;
        }// end function

    }
}
