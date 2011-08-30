package com.funkypear.game
{
    import flash.display.*;

    public class Message extends MovieClip
    {
        public var message:MovieClip;
        public var messageQueue:Array;
        private var _118d:Array;

        public function Message()
        {
            _118d = [16711680, 39423, 10079232, 16763904];
            messageQueue = new Array();
            addFrameScript(0, frame1);
            return;
        }// end function

        public function addMessage(param1, param2)
        {
            messageQueue.push(new Array(param1, param2));
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        public function mainLoop()
        {
            if (messageQueue.length > 0 && currentFrame >= totalFrames-- || currentFrame == 1)
            {
                gotoAndPlay(2);
                message.message.text = messageQueue[0][0];
                message.message.textColor = _118d[messageQueue[0][1]];
                messageQueue.splice(0, 1);
            }// end if
            return;
        }// end function

    }
}
