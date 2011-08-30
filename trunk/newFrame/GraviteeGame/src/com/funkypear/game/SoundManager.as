package com.funkypear.game
{
    import flash.display.*;
    import flash.media.*;

    public class SoundManager extends SoundManagerSuper
    {
        public var sound_pickuphealth:MovieClip;
        protected const MENU_VOLUME:Number = 1;
        public var sound_blackhole:MovieClip;
        protected const GAME_VOLUME:Number = 0.5;
        public var sound_award:MovieClip;
        public var sound_sniper:MovieClip;
        public var sound_minebeep:MovieClip;
        public var sound_teleport:MovieClip;
        public var sound_spit:MovieClip;
        public var sound_rocketshoot:MovieClip;
        public var sound_bounce:MovieClip;
        public var sound_pickupammo:MovieClip;
        public var sound_explosion:MovieClip;
        public var sound_zap:MovieClip;
        public var sound_burn:MovieClip;
        public static const GAME:uint = 1;
        public static const MENU:uint = 0;

        public function SoundManager()
        {
            music_sounds.push(new GameMusic());
            transforms.push(new SoundTransform(GAME_VOLUME, 0));
            channels.push(new SoundChannel());
            volumes.push(GAME_VOLUME);
            _1191 = uint.MAX_VALUE;
            return;
        }// end function

    }
}
