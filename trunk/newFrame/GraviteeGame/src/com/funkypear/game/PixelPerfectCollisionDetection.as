package com.funkypear.game
{
    import flash.display.*;
    import flash.geom.*;

    public class PixelPerfectCollisionDetection extends Object
    {

        public function PixelPerfectCollisionDetection()
        {
            return;
        }// end function

        public static function getCollisionRect(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0) : Rectangle
        {
            var _loc_6:Rectangle;
            var _loc_7:Rectangle;
            var _loc_8:Rectangle;
            var _loc_9:BitmapData;
            var _loc_10:BitmapData;
            var _loc_11:uint;
            var _loc_12:Rectangle;
            var _loc_13:int;
            _loc_6 = param1.getBounds(param3);
            _loc_7 = param2.getBounds(param3);
            _loc_8 = _loc_6.intersection(_loc_7);
            if (_loc_8.size.length > 0)
            {
                if (param4)
                {
                    _loc_8.width = Math.ceil(_loc_8.width);
                    _loc_8.height = Math.ceil(_loc_8.height);
                    _loc_9 = getAlphaMap(param1, _loc_8, BitmapDataChannel.RED, param3);
                    _loc_10 = getAlphaMap(param2, _loc_8, BitmapDataChannel.GREEN, param3);
                    _loc_9.draw(_loc_10, null, null, BlendMode.LIGHTEN);
                    if (param5 <= 0)
                    {
                        _loc_11 = 65792;
                    }
                    else
                    {
                        if (param5 > 1)
                        {
                            param5 = 1;
                        }// end if
                        _loc_13 = Math.round(param5 * 255);
                        _loc_11 = _loc_13 << 16 | _loc_13 << 8 | 0;
                    }// end else if
                    _loc_12 = _loc_9.getColorBoundsRect(_loc_11, _loc_11);
                    _loc_9.getColorBoundsRect(_loc_11, _loc_11).x = _loc_12.x + _loc_8.x;
                    _loc_12.y = _loc_12.y + _loc_8.y;
                    return _loc_12;
                }
                else
                {
                    return _loc_8;
                }// end else if
            }
            else
            {
                return null;
            }// end else if
        }// end function

        public static function isColliding(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0)
        {
            var _loc_6:Rectangle;
            _loc_6 = getCollisionRect(param1, param2, param3, param4, param5);
            if (_loc_6 != null && _loc_6.size.length > 0)
            {
                return _loc_6;
            }// end if
            return false;
        }// end function

        public static function getCollisionPoint(param1:DisplayObject, param2:DisplayObject, param3:DisplayObjectContainer, param4:Boolean = false, param5:Number = 0) : Point
        {
            var _loc_6:Rectangle;
            var _loc_7:Number;
            var _loc_8:Number;
            _loc_6 = getCollisionRect(param1, param2, param3, param4, param5);
            if (_loc_6 != null && _loc_6.size.length > 0)
            {
                _loc_7 = (_loc_6.left + _loc_6.right) / 2;
                _loc_8 = (_loc_6.top + _loc_6.bottom) / 2;
                return new Point(_loc_7, _loc_8);
            }// end if
            return null;
        }// end function

        private static function getAlphaMap(param1:DisplayObject, param2:Rectangle, param3:uint, param4:DisplayObjectContainer) : BitmapData
        {
            var _loc_5:Matrix;
            var _loc_6:Matrix;
            var _loc_7:BitmapData;
            var _loc_8:BitmapData;
            _loc_5 = param4.transform.concatenatedMatrix.clone();
            _loc_5.invert();
            _loc_6 = param1.transform.concatenatedMatrix.clone();
            _loc_6.concat(_loc_5);
            _loc_6.translate(-param2.x, -param2.y);
            _loc_7 = new BitmapData(param2.width, param2.height, true, 0);
            _loc_7.draw(param1, _loc_6);
            _loc_8 = new BitmapData(param2.width, param2.height, false, 0);
            _loc_8.copyChannel(_loc_7, _loc_7.rect, new Point(0, 0), BitmapDataChannel.ALPHA, param3);
            return _loc_8;
        }// end function

    }
}
