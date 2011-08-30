package com.funkypear.game
{
    import flash.display.*;
    import flash.text.*;

    public class GameTimer extends MovieClip
    {
        public var bottomtext:TextField;
        public var toptext:TextField;
        public var pauseTime:Boolean = false;
        public var timeLeft:int = 1350;
        public var _11101:int = 45;
        public var _11104:int = 3;
        public var time:TextField;

        public function GameTimer(param1)
        {
            _11101 = 45;
            _11104 = 3;
            timeLeft = 1350;
            pauseTime = false;
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4);
            _11101 = param1;
            resetTimer();
            return;
        }// end function

        public function showIt()
        {
            alpha = 1;
            return;
        }// end function

        public function updateTimer()
        {
            var _loc_1:int;
            if (!pauseTime)
            {
                timeLeft--;
            }// end if
            if (timeLeft <= 0 && alpha > 0)
            {
                hideIt();
            }// end if
            if (alpha > 0)
            {
                _loc_1 = Math.ceil(timeLeft / 30);
                if (_loc_1 < 0)
                {
                    _loc_1 = 0;
                }// end if
                time.text = _loc_1.toString();
            }// end if
            return;
        }// end function

        public function hideIt()
        {
            time.text = "";
            alpha = 0;
            return;
        }// end function

        public function resetTimer()
        {
            toptext.text = "TIME";
            bottomtext.text = "LEFT";
            timeLeft = _11101 * 30;
            updateTimer();
            showIt();
            return;
        }// end function

        function frame3()
        {
            stop();
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame4()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

        public function resetRetreatTimer()
        {
            toptext.text = "RETREAT";
            bottomtext.text = "TIME";
            timeLeft = _11104 * 30;
            updateTimer();
            showIt();
            return;
        }// end function

        public function changeCol(param1)
        {
            gotoAndStop(param1 + 1);
            return;
        }// end function

    }
}
