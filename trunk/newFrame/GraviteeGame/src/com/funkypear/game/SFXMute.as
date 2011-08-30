package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;

    public class SFXMute extends MovieClip
    {
        public var bon:SimpleButton;
        public var boff:SimpleButton;

        public function SFXMute()
        {
            addFrameScript(0, frame1, 1, frame2);
            return;
        }// end function

        public function mute(param1:MouseEvent)
        {
            gotoAndStop(2);
            MovieClip(root).sfx = false;
            MovieClip(root).saveData();
            return;
        }// end function

        public function unmute(param1:MouseEvent)
        {
            gotoAndStop(1);
            MovieClip(root).sfx = true;
            MovieClip(root).saveData();
            return;
        }// end function

        function frame1()
        {
            stop();
            if (!bon.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                bon.addEventListener(MouseEvent.MOUSE_DOWN, mute);
            }// end if
            return;
        }// end function

        function frame2()
        {
            stop();
            if (!boff.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                boff.addEventListener(MouseEvent.MOUSE_DOWN, unmute);
            }// end if
            return;
        }// end function

    }
}
