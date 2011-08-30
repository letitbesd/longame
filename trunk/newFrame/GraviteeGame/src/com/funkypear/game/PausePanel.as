package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;

    dynamic public class PausePanel extends MovieClip
    {
        public var restartbutton:SimpleButton;
        public var quitbutton:SimpleButton;
        public var continuebutton:SimpleButton;

        public function PausePanel()
        {
            addFrameScript(0, frame1, 1, frame2);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            continuebutton.addEventListener(MouseEvent.MOUSE_UP, MovieClip(root).game.doUnpause);
            restartbutton.addEventListener(MouseEvent.MOUSE_UP, MovieClip(root).game.doRestart);
            quitbutton.addEventListener(MouseEvent.MOUSE_UP, MovieClip(root).game.doQuit);
            return;
        }// end function

    }
}
