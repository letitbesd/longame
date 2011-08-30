package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;

    public class HealthFloat extends MovieClip
    {
        public var removeMe:Boolean = false;
        public var float:MovieClip;
        public var _1110a:int = 0;
        private var colorArr:Array;

        public function HealthFloat()
        {
            removeMe = false;
            colorArr = [16711680, 39423, 10079232, 16763904];
            _1110a = 0;
            addEventListener(Event.ENTER_FRAME, mainLoop);
            return;
        }// end function

        public function updateDisplay(param1, param2, param3)
        {
            if (param3)
            {
                float.num.text = "+" + param1.toString();
            }
            else
            {
                float.num.text = param1.toString();
            }// end else if
            float.num.textColor = colorArr[param2];
            return;
        }// end function

        public function mainLoop(param1:Event)
        {
            if (currentFrame == totalFrames)
            {
                MovieClip(parent.parent).removeHealthFloat(this);
                removeEventListener(Event.ENTER_FRAME, mainLoop);
            }// end if
            return;
        }// end function

    }
}
