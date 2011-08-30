package com.funkypear.game
{
    import flash.display.*;

    public class Transitions extends MovieClip
    {
        public var _12a6:BitmapData;
        public var goto:String = "";
        public var tran1:MovieClip;
        public var tran4:MovieClip;
        public var tran5:MovieClip;
        public var tran6:MovieClip;
        public var tran8:MovieClip;
        public var tran2:MovieClip;
        public var tran3:MovieClip;
        public var tran7:MovieClip;
        public var _12a10:int = 0;
        public var _12b1:Bitmap;

        public function Transitions()
        {
            _12a10 = 0;
            goto = "";
            _12a6 = new BitmapData(700, 500, true, 0);
            _12b1 = new Bitmap(_12a6);
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4, 4, frame5, 5, frame6, 6, frame7, 7, frame8, 8, frame9);
            addChild(_12b1);
            return;
        }// end function

        function frame6()
        {
            stop();
            tran5.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran5;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame7()
        {
            stop();
            tran6.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran6;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame3()
        {
            stop();
            tran2.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran2;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame4()
        {
            stop();
            tran3.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran3;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame8()
        {
            stop();
            tran7.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran7;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame9()
        {
            stop();
            tran8.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran8;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame2()
        {
            stop();
            tran1.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran1;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame5()
        {
            stop();
            tran4.cacheAsBitmap = true;
            _12b1.cacheAsBitmap = true;
            _12b1.mask = tran4;
            MovieClip(root).gotoAndStop(goto);
            alpha = 1;
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        public function doTrans(param1)
        {
            var _loc_2:*;
            _12a6.draw(param1);
            do
            {
                // label
                _loc_2 = Math.ceil(Math.random() * totalFrames-- + 1);
            }while (_loc_2 == _12a10)
            _12a10 = _loc_2;
            gotoAndStop(_loc_2);
            return;
        }// end function

    }
}
