package com.funkypear.game
{
    import flash.display.*;

    public class WepPanel extends MovieClip
    {
        public var panel:MovieClip;
        public var shown:Boolean = false;

        public function WepPanel()
        {
            shown = false;
            addFrameScript(0, frame1, 10, frame11);
            return;
        }// end function

        public function hideIt()
        {
            shown = false;
            MovieClip(parent.parent).panelWeps.gotoAndPlay(12);
            return;
        }// end function

        public function showIt()
        {
            shown = true;
            MovieClip(parent.parent).panelWeps.gotoAndPlay(2);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame11()
        {
            stop();
            return;
        }// end function

    }
}
