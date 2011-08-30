package com.funkypear.game
{
    import flash.display.*;

    public class TeamDisplayBar extends MovieClip
    {
        public var shown:Boolean = true;

        public function TeamDisplayBar()
        {
            shown = true;
            return;
        }// end function

        public function showMe()
        {
            shown = true;
            return;
        }// end function

        public function hideMe()
        {
            shown = false;
            return;
        }// end function

        public function mainLoop()
        {
            if (y > 440 && shown)
            {
                y = y - 5;
            }
            else if (y < 510 && !shown)
            {
                y = y + 5;
            }// end else if
            return;
        }// end function

    }
}
