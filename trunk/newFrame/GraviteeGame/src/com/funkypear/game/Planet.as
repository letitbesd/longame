package com.funkypear.game
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Planet extends MovieClip
    {
//        public var _17d2:TempCOM;
//        public var _17d3:COM;
//        public var _17d4:Array;
        public var _17d5:Number;
        public var mass:int = 100;
        public var shapeArray:Array;
        public var GFXID:int = 1;
        public var _17dd:Bitmap;
        public var area:Number = 0;
        public var classicGFX:Boolean = false;
        public var _17e1:Number = 0;
        public var BMData:BitmapData;
        public var _17e3:Number;
        public var _17e6:MovieClip;
        public var diameter:int = 100;
        public var centerY:int = 0;
        public var centerX:int = 0;
        public var debugLayer:MovieClip;
        public var _planetGFX:PlanetGFX;
        public var isSun:Boolean = false;
        public var shape2:MovieClip;
        public var _17ef:int = 100;

        public function Planet()
        {
            centerX = 0;
            centerY = 0;
            mass = 100;
            _17ef = 100;
            area = 0;
            debugLayer = new MovieClip();
            diameter = 100;
//            _17d3 = new COM();
//            _17d2 = new TempCOM();
            isSun = false;
            _planetGFX = new PlanetGFX();
            shapeArray = new Array(new Array());
            _17e6 = new MovieClip();
            shape2 = new MovieClip();
            _17d5 = 360 / 60;
            _17e3 = 360 / 30;
            x = 200;
            y = 200;
            return;
        }// end function

        public function _17d6(param1, param2)
        {
            var _loc_3:*;
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:Boolean;
            var _loc_9:Array;
            var _loc_10:Array;
            var _loc_11:*;
            var _loc_12:Point;
            var _loc_13:int;
            var _loc_14:int;
            var _loc_15:int;
            var _loc_16:int;
            var _loc_17:Point;
            var _loc_18:Point;
            var _loc_19:Point;
            var _loc_20:Point;
            var _loc_21:int;
            var _loc_22:int;
            var _loc_23:int;
            var _loc_24:int;
            var _loc_25:int;
            var _loc_26:int;
            var _loc_27:*;
            var _loc_28:*;
            var _loc_29:*;
            var _loc_30:*;
            var _loc_31:*;
            var _loc_32:*;
            var _loc_33:int;
            var _loc_34:int;
            var _loc_35:int;
            var _loc_36:int;
            var _loc_37:int;
            var _loc_38:*;
            var _loc_39:*;
            var _loc_40:*;
            var _loc_41:*;
            var _loc_42:Rectangle;
            var _loc_43:Rectangle;
            var _loc_44:*;
            var _loc_45:*;
            var _loc_46:int;
            var _loc_47:int;
            var _loc_48:MovieClip;
            var _loc_49:int;
            var _loc_50:*;
            var _loc_51:*;
            var _loc_52:*;
            var _loc_53:*;
            var _loc_54:Point;
            var _loc_55:Point;
            var _loc_56:Point;
            var _loc_57:Point;
            var _loc_58:Boolean;
            var _loc_59:Boolean;
            var _loc_60:*;
            var _loc_61:*;
            var _loc_62:*;
            var _loc_63:*;
            var _loc_64:*;
            var _loc_65:*;
            var _loc_66:*;
            var _loc_67:int;
            var _loc_68:int;
            var _loc_69:*;
            var _loc_70:*;
            var _loc_71:*;
            _loc_3 = 1;
            _loc_4 = new Array();
            do
            {
                // label
                _loc_27 = false;
                _loc_26 = 0;
                while (_loc_26 < param1.length)
                {
                    // label
                    _loc_28 = 0;
                    while (_loc_28++ < param1[_loc_26].length)
                    {
                        // label
                        _loc_29 = 0;
                        while (_loc_29++ < param2[0].length)
                        {
                            // label
                            if (param1[_loc_26][_loc_28].x == param2[0][_loc_29].x && param1[_loc_26][_loc_28].y == param2[0][_loc_29].y)
                            {
                                _loc_27 = true;
                            }// end if
                        }// end while
                    }// end while
                    _loc_26++;
                }// end while
                if (_loc_27)
                {
                    _loc_29 = 0;
                    while (_loc_29++ < param2[0].length)
                    {
                        // label
                        param2[0][_loc_29].x = param2[0][_loc_29].x + (Math.random() * 2)--;
                        param2[0][_loc_29].y = param2[0][_loc_29].y + (Math.random() * 2)--;
                    }// end while
                }// end if
            }while (_loc_27)
            _loc_5 = 0;
            _loc_6 = 0;
            _loc_7 = 0;
            _loc_8 = true;
            _loc_9 = new Array();
            _loc_10 = new Array();
            _loc_15 = 0;
            _loc_16 = 0;
            _loc_26 = 0;
            while (_loc_26 < param1.length)
            {
                // label
                _loc_23 = param2[0].length;
                _loc_24 = param1[_loc_26].length;
                _loc_32 = 0;
                while (_loc_32++ < _loc_24)
                {
                    // label
                    _loc_34 = 50000;
                    _loc_35 = -50000;
                    _loc_36 = 50000;
                    _loc_37 = -50000;
                    _loc_21 = 0;
                    while (_loc_21 < _loc_23)
                    {
                        // label
                        if (param2[0][_loc_21].x > _loc_35)
                        {
                            _loc_35 = param2[0][_loc_21].x;
                        }// end if
                        if (param2[0][_loc_21].x < _loc_34)
                        {
                            _loc_34 = param2[0][_loc_21].x;
                        }// end if
                        if (param2[0][_loc_21].y > _loc_37)
                        {
                            _loc_37 = param2[0][_loc_21].y;
                        }// end if
                        if (param2[0][_loc_21].y < _loc_36)
                        {
                            _loc_36 = param2[0][_loc_21].y;
                        }// end if
                        _loc_21++;
                    }// end while
                    if (param1[_loc_26][(_loc_32 + 1) % _loc_24].x - param1[_loc_26][_loc_32].x > 0)
                    {
                        _loc_39 = param1[_loc_26][_loc_32].x;
                        _loc_38 = param1[_loc_26][(_loc_32 + 1) % _loc_24].x;
                    }
                    else
                    {
                        _loc_38 = param1[_loc_26][_loc_32].x;
                        _loc_39 = param1[_loc_26][(_loc_32 + 1) % _loc_24].x;
                    }// end else if
                    if (param1[_loc_26][(_loc_32 + 1) % _loc_24].y - param1[_loc_26][_loc_32].y > 0)
                    {
                        _loc_40 = param1[_loc_26][_loc_32].y;
                        _loc_41 = param1[_loc_26][(_loc_32 + 1) % _loc_24].y;
                    }
                    else
                    {
                        _loc_41 = param1[_loc_26][_loc_32].y;
                        _loc_40 = param1[_loc_26][(_loc_32 + 1) % _loc_24].y;
                    }// end else if
                    _loc_42 = new Rectangle(_loc_39--, _loc_40--, _loc_38 - _loc_39 + 2, _loc_41 - _loc_40 + 2);
                    _loc_43 = new Rectangle(_loc_34--, _loc_36--, _loc_35 - _loc_34 + 2, _loc_37 - _loc_36 + 2);
                    _loc_44 = _loc_42.intersection(_loc_43);
                    if (_loc_44.width > 0 && _loc_44.height > 0)
                    {
                        _loc_45 = 0;
                        while (_loc_45++ < _loc_23)
                        {
                            // label
                            _loc_17 = new Point(param1[_loc_26][_loc_32].x, param1[_loc_26][_loc_32].y);
                            _loc_18 = new Point(param1[_loc_26][(_loc_32 + 1) % _loc_24].x, param1[_loc_26][(_loc_32 + 1) % _loc_24].y);
                            _loc_19 = new Point(param2[0][_loc_45].x, param2[0][_loc_45].y);
                            _loc_20 = new Point(param2[0][(_loc_45 + 1) % _loc_23].x, param2[0][(_loc_45 + 1) % _loc_23].y);
                            _loc_11 = lineIntersectLine(_loc_17, _loc_18, _loc_19, _loc_20, true);
                            if (_loc_11)
                            {
                                if (_loc_9.length > 0 && _loc_9[_loc_9.length--].x == _loc_11.x && _loc_9[_loc_9.length--].y == _loc_11.y)
                                {
                                    _loc_9.splice(_loc_9.length--, 1);
                                    _loc_10.splice(_loc_10.length--, 1);
                                    continue;
                                }// end if
                                if (_loc_9.length > 0)
                                {
                                }// end if
                                _loc_9.push(_loc_11);
                                _loc_10.push(_loc_32);
                            }// end if
                        }// end while
                    }// end if
                }// end while
                if (_loc_9.length == 0)
                {
                    _loc_46 = param1[_loc_26].length;
                    _loc_47 = 0;
                    _loc_48 = new MovieClip();
                    _loc_48.graphics.lineStyle(1, 0, 0);
                    _loc_48.graphics.beginFill(0, 0);
                    _loc_48.graphics.moveTo(param2[0][0].x, param2[0][0].y);
                    _loc_45 = 1;
                    while (_loc_45++ < param2[0].length)
                    {
                        // label
                        _loc_48.graphics.lineTo(param2[0][_loc_45].x, param2[0][_loc_45].y);
                    }// end while
                    _loc_48.graphics.endFill();
                    addChild(_loc_48);
                    _loc_48.x = _17e6.x;
                    _loc_48.y = _17e6.y;
                    _loc_32 = 0;
                    while (_loc_32++ < _loc_46)
                    {
                        // label
                        if (_loc_48.hitTestPoint(param1[_loc_26][_loc_32].x + x + MovieClip(parent.parent).x, param1[_loc_26][_loc_32].y + y + MovieClip(parent.parent).y, true))
                        {
                            _loc_47++;
                        }// end if
                    }// end while
                    removeChild(_loc_48);
                    if (_loc_46 != _loc_47)
                    {
                        _loc_4.push(new Array());
                        _loc_32 = 0;
                        while (_loc_32++ < param1[_loc_26].length)
                        {
                            // label
                            _loc_4[_loc_4.length--].push(new Point(param1[_loc_26][_loc_32].x, param1[_loc_26][_loc_32].y));
                        }// end while
                    }// end if
                }// end if
                _loc_33 = -1;
                while (_loc_9.length > 0)
                {
                    // label
                    if (_loc_33 < 3)
                    {
                    }// end if
                    _loc_4.push(new Array());
                    _loc_52 = _loc_10[0] + 1;
                    _loc_53 = _loc_10[1] + 1;
                    if (_loc_10[0]-- < 0)
                    {
                        _loc_50 = _loc_50 + param1[_loc_26].length;
                    }// end if
                    if (_loc_10[1]-- < 0)
                    {
                        _loc_51 = _loc_51 + param1[_loc_26].length;
                    }// end if
                    if (_loc_52 >= param1[_loc_26].length)
                    {
                        _loc_52 = _loc_52 - param1[_loc_26].length;
                    }// end if
                    if (_loc_53 >= param1[_loc_26].length)
                    {
                        _loc_53 = _loc_53 - param1[_loc_26].length;
                    }// end if
                    _loc_54 = new Point(param1[_loc_26][_loc_10[0]].x, param1[_loc_26][_loc_10[0]].y);
                    _loc_55 = new Point(param1[_loc_26][_loc_10[1]].x, param1[_loc_26][_loc_10[1]].y);
                    _loc_56 = new Point(param1[_loc_26][_loc_50].x, param1[_loc_26][_loc_50].y);
                    _loc_57 = new Point(param1[_loc_26][_loc_51].x, param1[_loc_26][_loc_51].y);
                    if (!_17e10(param2[0], _loc_54))
                    {
                        _loc_49 = _loc_10[0];
                    }
                    else if (!_17e10(param2[0], _loc_55))
                    {
                        _loc_49 = _loc_10[1];
                    }
                    else if (!_17e10(param2[0], _loc_56))
                    {
                        _loc_49 = _loc_50;
                    }
                    else if (!_17e10(param2[0], _loc_57))
                    {
                        _loc_49 = _loc_51;
                        // Jump to 2476;
                    }// end else if
                    _loc_7 = _loc_49;
                    _loc_58 = false;
                    while (!_loc_58)
                    {
                        // label
                        _loc_15 = 0;
                        _loc_59 = false;
                        _loc_16++;
                        if (_loc_8)
                        {
                            _loc_23 = param2[0].length;
                            _loc_24 = param1[_loc_26].length;
                            _loc_34 = 50000;
                            _loc_35 = -50000;
                            _loc_36 = 50000;
                            _loc_37 = -50000;
                            _loc_21 = 0;
                            while (_loc_21 < _loc_23)
                            {
                                // label
                                if (param2[0][_loc_21].x > _loc_35)
                                {
                                    _loc_35 = param2[0][_loc_21].x;
                                }// end if
                                if (param2[0][_loc_21].x < _loc_34)
                                {
                                    _loc_34 = param2[0][_loc_21].x;
                                }// end if
                                if (param2[0][_loc_21].y > _loc_37)
                                {
                                    _loc_37 = param2[0][_loc_21].y;
                                }// end if
                                if (param2[0][_loc_21].y < _loc_36)
                                {
                                    _loc_36 = param2[0][_loc_21].y;
                                }// end if
                                _loc_21++;
                            }// end while
                            if (param1[_loc_26][(_loc_7 + 1) % _loc_24].x - param1[_loc_26][_loc_7].x > 0)
                            {
                                _loc_39 = param1[_loc_26][_loc_7].x;
                                _loc_38 = param1[_loc_26][(_loc_7 + 1) % _loc_24].x;
                            }
                            else
                            {
                                _loc_38 = param1[_loc_26][_loc_7].x;
                                _loc_39 = param1[_loc_26][(_loc_7 + 1) % _loc_24].x;
                            }// end else if
                            if (param1[_loc_26][(_loc_7 + 1) % _loc_24].y - param1[_loc_26][_loc_7].y > 0)
                            {
                                _loc_40 = param1[_loc_26][_loc_7].y;
                                _loc_41 = param1[_loc_26][(_loc_7 + 1) % _loc_24].y;
                            }
                            else
                            {
                                _loc_41 = param1[_loc_26][_loc_7].y;
                                _loc_40 = param1[_loc_26][(_loc_7 + 1) % _loc_24].y;
                            }// end else if
                            _loc_42 = new Rectangle(_loc_39--, _loc_40--, _loc_38 - _loc_39 + 2, _loc_41 - _loc_40 + 2);
                            _loc_43 = new Rectangle(_loc_34--, _loc_36--, _loc_35 - _loc_34 + 2, _loc_37 - _loc_36 + 2);
                            _loc_44 = _loc_42.intersection(_loc_43);
                            _loc_62 = -1;
                            _loc_63 = 10000000000000000000000;
                            _loc_12 = null;
                            if (_loc_44.width > 0 && _loc_44.height > 0)
                            {
                                _loc_21 = 0;
                                while (_loc_21 < _loc_23)
                                {
                                    // label
                                    _loc_17 = new Point(param1[_loc_26][_loc_7].x, param1[_loc_26][_loc_7].y);
                                    _loc_18 = new Point(param1[_loc_26][(_loc_7 + 1) % _loc_24].x, param1[_loc_26][(_loc_7 + 1) % _loc_24].y);
                                    _loc_19 = new Point(param2[0][_loc_21].x, param2[0][_loc_21].y);
                                    _loc_20 = new Point(param2[0][(_loc_21 + 1) % _loc_23].x, param2[0][(_loc_21 + 1) % _loc_23].y);
                                    _loc_11 = lineIntersectLine(_loc_17, _loc_18, _loc_19, _loc_20, true);
                                    if (_loc_11)
                                    {
                                        _loc_64 = param1[_loc_26][_loc_7].x - _loc_11.x;
                                        _loc_65 = param1[_loc_26][_loc_7].y - _loc_11.y;
                                        _loc_66 = _loc_64 * _loc_64 + _loc_65 * _loc_65;
                                    }// end if
                                    if (_loc_11 && _loc_66 < _loc_63)
                                    {
                                        _loc_63 = _loc_66;
                                        _loc_15++;
                                        _loc_12 = _loc_11;
                                        _loc_62 = _loc_21;
                                    }// end if
                                    _loc_21++;
                                }// end while
                            }// end if
                            if (_loc_12)
                            {
                                while (_loc_67-- >= 0)
                                {
                                    // label
                                    if (_loc_4.length-- == 0)
                                    {
                                    }// end if
                                    if (_loc_9[_loc_9.length--].x == _loc_12.x && _loc_9[_loc_67].y == _loc_12.y)
                                    {
                                        _loc_9.splice(_loc_67, 1);
                                        _loc_10.splice(_loc_67, 1);
                                    }// end if
                                }// end while
                                _loc_25 = _loc_62;
                            }// end if
                            if (_loc_15 == 0)
                            {
                                _loc_4[_loc_33].push(param1[_loc_26][_loc_7]);
                                if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                {
                                    debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                    debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                    debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                }// end if
                            }
                            else
                            {
                                _loc_4[_loc_33].push(param1[_loc_26][_loc_7]);
                                if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                {
                                    debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                    debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                    debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                }// end if
                                _loc_4[_loc_33].push(_loc_12);
                                if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                {
                                    debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                    debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                    debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                }// end if
                                _loc_68 = 0;
                                _loc_21 = 0;
                                while (_loc_21 < param1[_loc_26].length)
                                {
                                    // label
                                    _loc_17 = new Point(_loc_12.x, _loc_12.y);
                                    _loc_18 = new Point(param2[0][_loc_25].x, param2[0][_loc_25].y);
                                    _loc_19 = new Point(param1[_loc_26][_loc_21].x, param1[_loc_26][_loc_21].y);
                                    _loc_20 = new Point(param1[_loc_26][(_loc_21 + 1) % param1[_loc_26].length].x, param1[_loc_26][(_loc_21 + 1) % param1[_loc_26].length].y);
                                    _loc_69 = lineIntersectLine(_loc_17, _loc_18, _loc_19, _loc_20, true);
                                    if (_loc_69 && Math.round(_loc_69.x * 1000) / 1000 != Math.round(_loc_12.x * 1000) / 1000 || Math.round(_loc_69.y * 1000) / 1000 != Math.round(_loc_12.y * 1000) / 1000)
                                    {
                                        _loc_70 = _loc_69;
                                        while (_loc_67-- >= 0)
                                        {
                                            // label
                                            if (Math.round(_loc_9[_loc_9.length--].x * 1000) / 1000 == Math.round(_loc_69.x * 1000) / 1000 && Math.round(_loc_9[_loc_67].y * 1000) / 1000 == Math.round(_loc_69.y * 1000) / 1000)
                                            {
                                                _loc_9.splice(_loc_67, 1);
                                                _loc_10.splice(_loc_67, 1);
                                            }// end if
                                        }// end while
                                        _loc_71 = _loc_21;
                                        _loc_68++;
                                    }// end if
                                    _loc_21++;
                                }// end while
                                if (_loc_68 == 0)
                                {
                                    _loc_8 = false;
                                    _loc_4[_loc_33].push(param2[0][_loc_25]);
                                    if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                    {
                                        debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                        debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                        debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                    }// end if
                                    _loc_7 = _loc_25;
                                }
                                else
                                {
                                    _loc_4[_loc_33].push(_loc_70);
                                    if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                    {
                                        debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                        debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                        debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                    }// end if
                                    _loc_7 = _loc_71;
                                }// end else if
                            }// end else if
                        }
                        else
                        {
                            _loc_23 = param1[_loc_26].length;
                            _loc_24 = param2[0].length;
                            _loc_62 = -1;
                            _loc_63 = 10000000000000000000000;
                            _loc_21 = 0;
                            while (_loc_21 < _loc_23)
                            {
                                // label
                                _loc_17 = new Point(param2[0][_loc_7].x, param2[0][_loc_7].y);
                                _loc_18 = new Point(param2[0][(_loc_7 + 1) % _loc_24].x, param2[0][(_loc_7 + 1) % _loc_24].y);
                                _loc_19 = new Point(param1[_loc_26][_loc_21].x, param1[_loc_26][_loc_21].y);
                                _loc_20 = new Point(param1[_loc_26][(_loc_21 + 1) % _loc_23].x, param1[_loc_26][(_loc_21 + 1) % _loc_23].y);
                                _loc_11 = lineIntersectLine(_loc_17, _loc_18, _loc_19, _loc_20, true);
                                if (_loc_11)
                                {
                                    _loc_64 = param2[0][_loc_7].x - _loc_11.x;
                                    _loc_65 = param2[0][_loc_7].y - _loc_11.y;
                                    _loc_66 = _loc_64 * _loc_64 + _loc_65 * _loc_65;
                                }// end if
                                if (_loc_11 && _loc_66 < _loc_63)
                                {
                                    _loc_63 = _loc_66;
                                    _loc_15++;
                                    _loc_12 = _loc_11;
                                    _loc_62 = _loc_21;
                                }// end if
                                _loc_21++;
                            }// end while
                            if (_loc_12)
                            {
                                while (_loc_67-- >= 0)
                                {
                                    // label
                                    if (_loc_9[_loc_9.length--].x == _loc_12.x && _loc_9[_loc_67].y == _loc_12.y)
                                    {
                                        _loc_9.splice(_loc_67, 1);
                                        _loc_10.splice(_loc_67, 1);
                                    }// end if
                                }// end while
                                _loc_25 = _loc_62;
                            }// end if
                            if (_loc_15 == 0)
                            {
                                _loc_4[_loc_33].push(param2[0][_loc_7]);
                                if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                {
                                    debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                    debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                    debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                }// end if
                            }
                            else
                            {
                                _loc_4[_loc_33].push(_loc_12);
                                if (_loc_4[_loc_33].length < _loc_3 && _loc_4[_loc_33].length > 1)
                                {
                                    debugLayer.graphics.lineStyle(2, 16711680, 0.05 * (_loc_4[_loc_33].length % 10 + 3));
                                    debugLayer.graphics.moveTo(_loc_4[_loc_33][_loc_4[_loc_33].length--].x, _loc_4[_loc_33][_loc_4[_loc_33].length--].y);
                                    debugLayer.graphics.lineTo(_loc_4[_loc_33][_loc_4[_loc_33].length - 2].x, _loc_4[_loc_33][_loc_4[_loc_33].length - 2].y);
                                }// end if
                                _loc_8 = true;
                                _loc_7 = _loc_25;
                            }// end else if
                        }// end else if
                        if (_loc_8)
                        {
                            _loc_7 = (_loc_7 + 1) % param1[_loc_26].length;
                        }
                        else if (--_loc_7 < 0)
                        {
                            _loc_7 = --_loc_7 + param2[0].length;
                        }// end else if
                        if (_loc_8 == true && _loc_7 == _loc_49)
                        {
                            _loc_58 = true;
                            if (_loc_33 == 0)
                            {
                            }// end if
                        }// end if
                    }// end while
                }// end while
                _loc_26++;
            }// end while
            return _loc_4;
        }// end function

        public function _17d7()
        {
            var _loc_1:int;
            _loc_1 = getTimer();
//            _17d4 = new Array();
            return;
        }// end function

        public function _17d8(param1:Point, param2:Point, param3:Point, param4:Point)
        {
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:Rectangle;
            var _loc_10:Rectangle;
            _loc_5 = Math.round((param2.y - param1.y) / (param2.x - param1.x) * 10000) / 10000;
            _loc_6 = Math.round((param4.y - param3.y) / (param4.x - param3.x) * 10000) / 10000;
            _loc_7 = Math.round((param1.y - _loc_5 * param1.x) * 10) / 10;
            _loc_8 = Math.round((param3.y - _loc_6 * param3.x) * 10) / 10;
            if (_loc_5 == _loc_6 && _loc_7 == _loc_8)
            {
                _loc_9 = new Rectangle(param1.x, param1.y, param2.x - param1.x, param2.y - param1.y);
                _loc_10 = new Rectangle(param3.x, param3.y, param4.x - param3.x, param4.y - param3.y);
                if (_loc_9.intersects(_loc_10))
                {
                    return true;
                }// end if
                return false;
            }
            else
            {
                return false;
            }// end else if
        }// end function

        public function lineIntersectLine(param1:Point, param2:Point, param3:Point, param4:Point, param5:Boolean = true) : Point
        {
            var _loc_6:Point;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:Number;
            var _loc_13:Number;
            _loc_7 = param2.y - param1.y;
            _loc_9 = param1.x - param2.x;
            _loc_11 = param2.x * param1.y - param1.x * param2.y;
            _loc_8 = param4.y - param3.y;
            _loc_10 = param3.x - param4.x;
            _loc_12 = param4.x * param3.y - param3.x * param4.y;
            _loc_13 = _loc_7 * _loc_10 - _loc_8 * _loc_9;
            if (_loc_13 == 0)
            {
                return null;
            }// end if
            _loc_6 = new Point();
            _loc_6.x = (_loc_9 * _loc_12 - _loc_10 * _loc_11) / _loc_13;
            _loc_6.y = (_loc_8 * _loc_11 - _loc_7 * _loc_12) / _loc_13;
            if (param5)
            {
                if (Math.pow(_loc_6.x - param2.x, 2) + Math.pow(_loc_6.y - param2.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param1.x, 2) + Math.pow(_loc_6.y - param1.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param4.x, 2) + Math.pow(_loc_6.y - param4.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param3.x, 2) + Math.pow(_loc_6.y - param3.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }// end if
            }// end if
            return _loc_6;
        }// end function

        public function removeChunk(param1, param2, param3)
        {
            var _loc_4:MovieClip;
            var _loc_5:Matrix;
            var _loc_6:Array;
            var _loc_7:int;
            _loc_4 = new MovieClip();
            _loc_4.graphics.beginFill(0, 0.5);
            _loc_4.graphics.drawCircle((param3 + 6) / 2, (param3 + 6) / 2, (param3 + 6) / 2));
            _loc_4.graphics.endFill();
            _loc_5 = new Matrix();
            _loc_5.translate(param1 - x + diameter / 2 - (param3 + 6) / 2, param2 - y + diameter / 2 - (param3 + 6) / 2);
            BMData.draw(_loc_4, _loc_5, null, "multiply", null, false);
            _loc_6 = new Array(new Array());
            _loc_7 = 0;
            while (_loc_7 < 360)
            {
                // label
                _loc_6[0].push(new Point(param3 / 2 * Math.sin(_loc_7 * (Math.PI / 180)) + (param1 - x), param3 / 2 * Math.cos(_loc_7 * (Math.PI / 180)) + (param2 - y)));
                _loc_7 = _loc_7 + _17e3;
            }// end while
            shapeArray = _17d6(shapeArray, _loc_6);
            _17e4(shapeArray, 16777215, _17e6, 2);
            _17e4(shapeArray, 16777214, shape2, 2);
            MovieClip(root).game.unitJiggleFix();
            _17e7();
            return;
        }// end function

        public function findNewCenter()
        {
            return;
        }// end function

        public function _17e4(param1, param2, param3, param4)
        {
            var _loc_5:int;
            var _loc_6:int;
            if (param2 == 16777215)
            {
                _17dd.mask = null;
            }// end if
            param3.graphics.clear();
            _loc_5 = 0;
            while (_loc_5 < param1.length)
            {
                // label
                if (param2 == 16777215 || param2 == 16777214 || param2 == 16777213)
                {
                    param3.graphics.beginFill(11103, 1);
                }// end if
                param3.graphics.moveTo(param1[_loc_5][0].x, param1[_loc_5][0].y);
                _loc_6 = 0;
                while (_loc_6 < param1[_loc_5].length)
                {
                    // label
                    param3.graphics.lineTo(param1[_loc_5][_loc_6].x, param1[_loc_5][_loc_6].y);
                    _loc_6++;
                }// end while
                param3.graphics.lineTo(param1[_loc_5][0].x, param1[_loc_5][0].y);
                if (param2 == 16777215 || param2 == 16777214)
                {
                    param3.graphics.endFill();
                }// end if
                _loc_5++;
            }// end while
            if (param2 == 16777215)
            {
                _17dd.mask = param3;
            }// end if
            return;
        }// end function

        public function _17e7()
        {
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Number = 0;
            var _loc_6:Number = 0;
            var _loc_7:*;
            var _loc_8:int;
            while (_loc_4 < shapeArray.length)
            {
                // label
                _loc_7 = 0;
                _loc_8 = 0;
                while (_loc_8 < shapeArray[_loc_4].length)
                {
                    // label
                    _loc_3 = (_loc_8 + 1) % shapeArray[_loc_4].length;
                    _loc_2 = shapeArray[_loc_4][_loc_8].x * shapeArray[_loc_4][_loc_3].y - shapeArray[_loc_4][_loc_3].x * shapeArray[_loc_4][_loc_8].y;
                    _loc_7 = _loc_7 + _loc_2;
                    _loc_8++;
                }// end while
                _loc_1 = _loc_1 + _loc_7;
                _loc_4++;
            }// end while
            _17e1 = Math.abs(_loc_1 / 2);
            mass = _17ef * (_17e1 / area);
            _loc_5 = 0;
            _loc_6 = 0;
            _loc_4 = 0;
            while (_loc_4 < shapeArray.length)
            {
                // label
                _loc_8 = 0;
                while (_loc_8 < shapeArray[_loc_4].length)
                {
                    // label
                    _loc_3 = (_loc_8 + 1) % shapeArray[_loc_4].length;
                    _loc_5 = _loc_5 + (shapeArray[_loc_4][_loc_8].x + shapeArray[_loc_4][_loc_3].x) * (shapeArray[_loc_4][_loc_8].x * shapeArray[_loc_4][_loc_3].y - shapeArray[_loc_4][_loc_3].x * shapeArray[_loc_4][_loc_8].y);
                    _loc_6 = _loc_6 + (shapeArray[_loc_4][_loc_8].y + shapeArray[_loc_4][_loc_3].y) * (shapeArray[_loc_4][_loc_8].x * shapeArray[_loc_4][_loc_3].y - shapeArray[_loc_4][_loc_3].x * shapeArray[_loc_4][_loc_8].y);
                    _loc_8++;
                }// end while
                _loc_4++;
            }// end while
            centerX = -1 * (1 / (6 * _17e1) * _loc_5);
            centerY = -1 * (1 / (6 * _17e1) * _loc_6);
            return;
        }// end function

        public function updatePlanet()
        {
            var _loc_1:PlanetGFX;
            var mar:Matrix;
            var _loc_4:int;
            _loc_1 = new PlanetGFX();
            if (classicGFX)
            {
                _loc_1.gotoAndStop(GFXID + 60);
            }
            else
            {
                _loc_1.gotoAndStop(GFXID);
            }// end else if
            BMData = new BitmapData(diameter, diameter, true, 0);
            mar = new Matrix();
            mar.scale(diameter / 100, diameter / 100);
            mar.translate(diameter / 2, diameter / 2);
            BMData.draw(_loc_1, mar, null, null, null, false);
            _17dd = new Bitmap(BMData);
            _17dd.x = -diameter / 2;
            _17dd.y = -diameter / 2;
            _planetGFX.gotoAndStop(GFXID);
            centerX = diameter / 2;
            centerY = diameter / 2;
            area = Math.PI * Math.pow(diameter / 2, 2);
            mass = 4 / 3 * Math.PI * Math.pow(diameter / 2, 3);
            _17ef = mass;
            _planetGFX.scaleX = diameter / 100;
            _planetGFX.scaleY = diameter / 100;
            _loc_4 = 0;
            while (_loc_4 < 360)
            {
                // label
                shapeArray[0].push(new Point(diameter / 2 * Math.sin(_loc_4 * (Math.PI / 180)), diameter / 2 * Math.cos(_loc_4 * (Math.PI / 180))));
                _loc_4 = _loc_4 + _17d5;
            }// end while
            _17e7();
            if (!isSun)
            {
                addChild(shape2);
                addChild(_17dd);
                addChild(_17e6);
                _17e4(shapeArray, 16777215, _17e6, 2);
                _17e4(shapeArray, 16777214, shape2, 2);
            }
            else
            {
                addChild(_17dd);
            }// end else if
            addChild(debugLayer);
            return;
        }// end function

        public function _17e10(param1, param2)
        {
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            _loc_3 = 0;
            _loc_4 = 0;
            while (_loc_4 < param1.length)
            {
                // label
                if (param1[_loc_4].y > param2.y && param1[(_loc_4 + 1) % param1.length].y <= param2.y || param1[_loc_4].y <= param2.y && param1[(_loc_4 + 1) % param1.length].y > param2.y)
                {
                    _loc_5 = new Point(param1[_loc_4].x, param1[_loc_4].y);
                    _loc_6 = new Point(param1[(_loc_4 + 1) % param1.length].x, param1[(_loc_4 + 1) % param1.length].y);
                    _loc_7 = new Point(param2.x, param2.y);
                    _loc_8 = new Point(param2.x - 500, param2.y);
                    if (lineIntersectLine(_loc_5, _loc_6, _loc_7, _loc_8, true))
                    {
                        _loc_3++;
                    }// end if
                }// end if
                _loc_4++;
            }// end while
            if (_loc_3 % 2 == 1)
            {
                return true;
            }// end if
            return false;
        }// end function

    }
}
