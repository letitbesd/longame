package com.funkypear.game
{
    import flash.display.*;
    import flash.text.*;

    public class TeamDisplayGreen extends TeamDisplay
    {
        public var bar:MovieClip;
        public var teamname:TextField;

        public function TeamDisplayGreen()
        {
            return;
        }// end function

        public function mainLoop()
        {
            if (bar.currentFrame != targetFrame)
            {
                if (bar.currentFrame < targetFrame)
                {
                    bar.gotoAndStop(bar.currentFrame + 1);
                }
                else if (bar.currentFrame > targetFrame)
                {
                    bar.gotoAndStop(bar.currentFrame-1);
                }// end if
            }// end else if
            return;
        }// end function

    }
}
