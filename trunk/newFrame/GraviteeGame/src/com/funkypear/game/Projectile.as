package com.funkypear.game
{
    import flash.display.*;

    public class Projectile extends MovieClip
    {
        public var distance:Number = 0;
        public var life:int = 0;
        public var hasSmoke:Boolean = true;
		public var lastSmokeX:Number;
		public var lastSmokeY:Number;
		public var oldX:Number = 0;
        public var oldY:Number = 0;
        public var reflected:Boolean = false;
        public var mass:int = 260;                       //质量
        public var removeMe:Boolean = false;
        public var multi:int = 1;
        public var killReg:int = -1;
        public var team:int = -1;
        public var shieldDelay:int = 0;
        public var momX:Number = 0;
		public var momY:Number = 0;
        public var diameter:int = 8;
        public var angleVelocity:Number = 0;            //角速度
        public var lastRefX:Number = -1;
		public var lastRefY:Number = -1;

        public function Projectile()
        {
            mass = 260;
            life = 0;
            shieldDelay = 0;
            diameter = 8;
            momX = 0;
            momY = 0;
            killReg = -1;
            lastRefX = -1;
            lastRefY = -1;
            angleVelocity = 0;
            oldX = 0;
            reflected = false;
            multi = 1;
            distance = 0;
            team = -1;
            hasSmoke = true;
            oldY = 0;
            removeMe = false;
            return;
        }// end function

        public function doGravity(param1:Array) : void
        {
            var _loc_2:int;
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:Number;
            var _loc_13:Number;
            _loc_2 = 0;
            while (_loc_2 < param1.length)
            {
                // label
                if (1 != 2)
                {
                    _loc_3 = param1[_loc_2].x + param1[_loc_2].centerX - x;
                    _loc_4 = param1[_loc_2].y + param1[_loc_2].centerY - y;
                    _loc_5 = _loc_3 > 0 ? (_loc_3) : (_loc_3 * -1);
                    _loc_6 = _loc_4 > 0 ? (_loc_4) : (_loc_4 * -1);
                    _loc_9 =  _loc_3 * _loc_3 +  _loc_4 * _loc_4;
                    _loc_10 = param1[_loc_2].diameter / 2 * (param1[_loc_2].diameter / 2);
                    if (_loc_9 < _loc_10)
                    {
                        _loc_13 = mass * param1[_loc_2].mass / _loc_10;
                    }
                    else
                    {
                        _loc_13 = mass * param1[_loc_2].mass / _loc_9;
                    }// end else if
                    _loc_11 = _loc_13 / (_loc_5 + _loc_6) * _loc_5;
                    _loc_12 = _loc_13 / (_loc_5 + _loc_6) * _loc_6;
                    if (_loc_3 < 0)
                    {
                        momX = momX - _loc_11 / 20000;
                    }
                    else
                    {
                        momX = momX + _loc_11 / 20000;
                    }// end else if
                    if (_loc_4 < 0)
                    {
                        momY = momY - _loc_12 / 20000;
                    }
                    else
                    {
                        momY = momY + _loc_12 / 20000;
                    }// end if
                }// end else if
                _loc_2++;
            }// end while
            return;
        }// end function

        public function moveProjectile(param1, param2, param3, param4) : void
        {
            var _loc_5:Number;
            var _loc_6:Number;
            var _loc_7:Number;
            shieldDelay--;
            oldX = x;
            oldY = y;
            x = x + momX;
            y = y + momY;
            _loc_5 = x - oldX;
            _loc_6 = y - oldY;
            _loc_7 = _loc_5 * _loc_5 + _loc_6 * _loc_6;
            distance = distance + Math.sqrt(_loc_7);
            if (!(this is UnitProjectile) && !(this is MineProjectile) && !(this is TargetProjectile) && distance > 1200 && multi < 4)
            {
                MovieClip(root).game.showMulti(4, x, y);
                multi = 4;
            }
            else if (!(this is UnitProjectile) && !(this is MineProjectile) && !(this is TargetProjectile) && distance > 800 && multi < 3)
            {
                MovieClip(root).game.showMulti(3, x, y);
                multi = 3;
            }
            else if (!(this is UnitProjectile) && !(this is MineProjectile) && !(this is TargetProjectile) && distance > 400 && multi < 2)
            {
                MovieClip(root).game.showMulti(2, x, y);
                multi = 2;
            }// end else if
            if (angleVelocity == 0)
            {
                rotation = Math.atan2(y - oldY, x - oldX) * (180 / Math.PI) + 180;
            }
            else
            {
                rotation = rotation + angleVelocity;
            }// end else if
            if (x > param2 + 1000 || x < param1 - 1000 || y > param4 + 1000 || y < param3 - 1000)
            {
                removeMe = true;
                if (this is UnitProjectile && MovieClip(root).game.myTeamsTurn)
                {
                    if (team != 0)
                    {
                        var _loc_8:* = MovieClip(root).achievementsInfo.stats;
                        var _loc_9:String;
                        _loc_8[_loc_9] = MovieClip(root).achievementsInfo.stats["enemiesOOB"]++;
                        var _loc_8:* = MovieClip(root).achievementsInfo.stats;
                        var _loc_9:String;
                        _loc_8[_loc_9] = MovieClip(root).achievementsInfo.stats["enemyKills"]++;
                        if (killReg > 0)
                        {
                            var _loc_8:* = MovieClip(root).achievementsInfo.stats;
                            var _loc_9:* = "wep" + killReg + "Kills";
                            _loc_8[_loc_9] = MovieClip(root).achievementsInfo.stats["wep" + killReg + "Kills"]++;
                        }// end if
                    }// end if
                }// end if
                if (this is UnitProjectile && team == 0)
                {
                    var _loc_8:* = MovieClip(root).achievementsInfo.stats;
                    var _loc_9:String;
                    _loc_8[_loc_9] = MovieClip(root).achievementsInfo.stats["friendlyKills"]++;
                }// end if
            }// end if
            life++;
            return;
        }// end function

    }
}
