package com.funkypear.game
{
    import flash.display.*;

    public class TeamDisplay extends MovieClip
    {
        private var _17110:Boolean = true;
        public var targetFrame:int = 1;

        public function TeamDisplay()
        {
            targetFrame = 1;
            _17110 = true;
            return;
        }// end function

        public function doFlash()
        {
            if (_17110)
            {
                if (alpha > 0.6)
                {
                    alpha = alpha - 0.03;
                    if (alpha <= 0.6)
                    {
                        _17110 = false;
                    }// end if
                }// end if
            }
            else if (alpha < 1)
            {
                alpha = alpha + 0.03;
                if (alpha >= 1)
                {
                    _17110 = true;
                }// end if
            }// end else if
            return;
        }// end function

        public function resetAlpha()
        {
            _17110 = true;
            alpha = 1;
            return;
        }// end function

        public function setTargetFrame(param1)
        {
            targetFrame = param1;
            return;
        }// end function

    }
}
