package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;

    public class SoundManagerSuper extends Sprite
    {
        public var _1191:int;
        protected const CROSS_FADE_SPEED:Number = 0.05;
        protected var _1194:Boolean = true;
        public var _1198:Boolean = false;
        protected var transforms:Array;
        protected var volumes:Array;
        protected var music_sounds:Array;
        protected var _119f:int;
        protected var _11910:Boolean = true;
        protected var channels:Array;
        protected var _11a3:Array;

        public function SoundManagerSuper()
        {
            var _loc_1:int;
            var _loc_2:MovieClip;
            _11a3 = new Array();
            music_sounds = new Array();
            channels = new Array();
            transforms = new Array();
            volumes = new Array();
            _1194 = true;
            _11910 = true;
            _1198 = false;
            _loc_1 = 0;
            while (_loc_1 < numChildren)
            {
                // label
                _loc_2 = getChildAt(_loc_1) as MovieClip;
                if (_loc_2 != null)
                {
                    _11a3[_loc_2.name] = _loc_2;
                }// end if
                _loc_1++;
            }// end while
            return;
        }// end function

        public function set sfx(param1:Boolean) : void
        {
            _11910 = param1;
            return;
        }// end function

        public function get music() : Boolean
        {
            return _1194;
        }// end function

        public function _1195() : void
        {
            if (_1194)
            {
                turnOffMusic();
            }
            else
            {
                turnOnMusic();
            }// end else if
            return;
        }// end function

        public function _1196(param1:String) : void
        {
            if (_11910)
            {
                if (_11a3[param1] != null)
                {
                    _11a3[param1].gotoAndPlay(2);
                }// end if
            }// end if
            return;
        }// end function

        private function _1197(param1:Event) : void
        {
            if (transforms[_119f].volume > 0)
            {
                transforms[_119f].volume = transforms[_119f].volume - CROSS_FADE_SPEED;
                channels[_119f].soundTransform = transforms[_119f];
            }// end if
            if (transforms[_1191].volume < 1)
            {
                transforms[_1191].volume = transforms[_1191].volume + CROSS_FADE_SPEED;
                channels[_1191].soundTransform = transforms[_1191];
            }// end if
            if (transforms[_1191].volume >= volumes[_1191] && transforms[_119f].volume <= 0)
            {
                channels[_119f].stop();
                _1198 = false;
                param1.target.removeEventListener(Event.ENTER_FRAME, _1197);
            }// end if
            return;
        }// end function

        public function turnOnMusic() : void
        {
            _1194 = true;
            _11910 = true;
            playMusic(0, true);
            return;
        }// end function

        public function set music(param1:Boolean) : void
        {
            _1194 = param1;
            return;
        }// end function

        public function playMusic(param1:uint, param2:Boolean = false) : void
        {
            var _loc_3:uint;
            if (_1191 != param1 || param2)
            {
                if (music_sounds.length > 0)
                {
                    if (_1194)
                    {
                        _loc_3 = 0;
                        while (_loc_3++ < music_sounds.length)
                        {
                            // label
                            if (_loc_3 == param1)
                            {
                                continue;
                            }// end if
                            if (channels[_loc_3] != null)
                            {
                                channels[_loc_3].stop();
                            }// end if
                        }// end while
                        transforms[param1].volume = volumes[param1];
                        channels[param1] = music_sounds[param1].play(0, int.MAX_VALUE, transforms[param1]);
                    }// end if
                    _1191 = param1;
                }// end if
            }// end if
            return;
        }// end function

        public function turnOffMusic() : void
        {
            var _loc_1:uint;
            _loc_1 = 0;
            while (_loc_1++ < channels.length)
            {
                // label
                if (channels[_loc_1] != null)
                {
                    channels[_loc_1].stop();
                }// end if
            }// end while
            _1194 = false;
            _11910 = false;
            return;
        }// end function

        public function get sfx() : Boolean
        {
            return _11910;
        }// end function

        public function _11a2(param1:int) : void
        {
            if (!_1194 || _1191 == param1 || _1198)
            {
                return;
            }// end if
            transforms[param1].volume = 0;
            channels[param1] = music_sounds[param1].play(0, int.MAX_VALUE, transforms[param1]);
            _119f = _1191;
            _1191 = param1;
            _1198 = true;
            addEventListener(Event.ENTER_FRAME, _1197);
            return;
        }// end function

    }
}
