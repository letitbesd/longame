package com.funkypear.utils
{
    import flash.display.*;
    import flash.net.*;

    public class Lock extends MovieClip
    {
        public var funkypearbutton:SimpleButton;
        public static const FLASHGAMESLICENSE_URL:Array = ["http://www.flashgamelicense.com/", "http://flashgamelicense.com/", "https://www.flashgamelicense.com/", "https://flashgamelicense.com/"];
        public static const FUNKYPEAR_URL:Array = ["http://www.funkypear.com/", "http://funkypear.com/"];
        public static var url:String;

        public function Lock()
        {
            return;
        }// end function

        private static function compareURLTo(param1:String) : Boolean
        {
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:String;
            var _loc_9:String;
            _loc_2 = "http://";
            if (url.substr(0, _loc_2.length) != _loc_2)
            {
                return false;
            }// end if
            _loc_3 = url.substr(_loc_2.length);
            param1 = param1.substr(_loc_2.length);
            while (_loc_3.charAt(0) == "/")
            {
                // label
                _loc_3 = _loc_3.substr(1);
            }// end while
            while (param1.charAt(0) == "/")
            {
                // label
                param1 = param1.substr(1);
            }// end while
            _loc_4 = _loc_3.split("/");
            _loc_5 = param1.split("/");
            _loc_6 = 0;
            while (_loc_6++ < _loc_5.length)
            {
                // label
                if (_loc_5[_loc_6].length < 1)
                {
                    continue;
                }// end if
                _loc_7 = _loc_5[_loc_6].indexOf("*");
                if (_loc_7 != -1)
                {
                    _loc_8 = _loc_5[_loc_6].substr(0, _loc_7);
                    _loc_9 = _loc_5[_loc_6].substr(_loc_7 + 1);
                    if (_loc_4[_loc_6].substr(0, _loc_8.length) != _loc_8)
                    {
                        return false;
                    }// end if
                    if (_loc_4[_loc_6].substr(-_loc_9.length) != _loc_9)
                    {
                        return false;
                    }// end if
                    continue;
                }// end if
                if (_loc_5[_loc_6] != _loc_4[_loc_6])
                {
                    return false;
                }// end if
            }// end while
            return true;
        }// end function

        public static function isAtURL(... args) : Boolean
        {
            var _loc_2:int;
            var _loc_3:Array;
            var _loc_4:int;
            var _loc_5:String;
            if (args.length == 0)
            {
                args.push(FUNKYPEAR_URL);
            }// end if
            _loc_2 = 0;
            while (_loc_2 < args.length)
            {
                // label
                _loc_3 = args[_loc_2];
                _loc_4 = 0;
                while (_loc_4 < _loc_3.length)
                {
                    // label
                    _loc_5 = _loc_3[_loc_4];
                    if (compareURLTo(_loc_5) || compareURLTo2(_loc_5))
                    {
                        return true;
                    }// end if
                    _loc_4++;
                }// end while
                _loc_2++;
            }// end while
            return false;
        }// end function

        public static function urlLock(param1:Stage) : void
        {
            var _loc_2:String;
            url = param1.loaderInfo.url;
            if (isAtURL(FUNKYPEAR_URL) == true || isAtURL(FLASHGAMESLICENSE_URL) == true)
            {
            }
            else
            {
                param1.addChild(new Lock);
                _loc_2 = "http://www.funkypear.com/?ref=sitelock";
                navigateToURL(new URLRequest(_loc_2), "_blank");
            }// end else if
            return;
        }// end function

        private static function compareURLTo2(param1:String) : Boolean
        {
            var _loc_2:String;
            var _loc_3:String;
            var _loc_4:Array;
            var _loc_5:Array;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:String;
            var _loc_9:String;
            _loc_2 = "https://";
            if (url.substr(0, _loc_2.length) != _loc_2)
            {
                return false;
            }// end if
            _loc_3 = url.substr(_loc_2.length);
            param1 = param1.substr(_loc_2.length);
            while (_loc_3.charAt(0) == "/")
            {
                // label
                _loc_3 = _loc_3.substr(1);
            }// end while
            while (param1.charAt(0) == "/")
            {
                // label
                param1 = param1.substr(1);
            }// end while
            _loc_4 = _loc_3.split("/");
            _loc_5 = param1.split("/");
            _loc_6 = 0;
            while (_loc_6++ < _loc_5.length)
            {
                // label
                if (_loc_5[_loc_6].length < 1)
                {
                    continue;
                }// end if
                _loc_7 = _loc_5[_loc_6].indexOf("*");
                if (_loc_7 != -1)
                {
                    _loc_8 = _loc_5[_loc_6].substr(0, _loc_7);
                    _loc_9 = _loc_5[_loc_6].substr(_loc_7 + 1);
                    if (_loc_4[_loc_6].substr(0, _loc_8.length) != _loc_8)
                    {
                        return false;
                    }// end if
                    if (_loc_4[_loc_6].substr(-_loc_9.length) != _loc_9)
                    {
                        return false;
                    }// end if
                    continue;
                }// end if
                if (_loc_5[_loc_6] != _loc_4[_loc_6])
                {
                    return false;
                }// end if
            }// end while
            return true;
        }// end function

    }
}
