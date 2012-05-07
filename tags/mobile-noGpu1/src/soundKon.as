//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.events.*;
    import flash.utils.*;
    import flash.media.*;

    public class soundKon {

        private static var T:Timer = new Timer(10);
        private static var soundArray:Array = new Array();
        private static var musicArray:Array = new Array();
        private static var playCheck:Array = new Array();
        public static var soundOn:Boolean = true;
        private static var soundChan:SoundChannel = new SoundChannel();
        private static var musicChan0:SoundChannel = new SoundChannel();
        private static var musicChan1:SoundChannel = new SoundChannel();
        private static var soundMixer:SoundTransform = new SoundTransform();
        private static var musicMixer0:SoundTransform = new SoundTransform();
        private static var musicMixer1:SoundTransform = new SoundTransform();
        private static var T2:Timer = new Timer(1);
        private static var cc:uint = 0;
        private static var MC:Array = [musicChan0, musicChan1];
        private static var MT:Array = [musicMixer0, musicMixer1];

        public static function init():void{
            T.start();
            T2.start();
            T.addEventListener(TimerEvent.TIMER, clearPlayed);
            soundArray = new Array();
            soundArray.push({played:false, s:null});
            soundArray.push({played:false, s:new Crane1()});
            soundArray.push({played:false, s:new Crane2()});
            soundArray.push({played:false, s:new Crane3()});
            soundArray.push({played:false, s:new Crane4()});
            soundArray.push({played:false, s:new Crane5()});
            soundArray.push({played:false, s:new Star1()});
            soundArray.push({played:false, s:new Star2()});
            soundArray.push({played:false, s:new Star3()});
            soundArray.push({played:false, s:new Twinkle()});
            soundArray.push({played:false, s:new Skid()});
            soundArray.push({played:false, s:new sfxMouse()});
            soundArray.push({played:false, s:new Throw()});
            soundArray.push({played:false, s:new Upgrade()});
            musicArray = new Array();
            musicArray.push(new Track1());
            musicArray.push(new Track2());
            musicArray.push(new TrackM1());
            musicArray.push(new TrackM2());
            MT[0].volume = 0;
            MT[1].volume = 0;
            MC[0].soundTransform = MT[0];
            MC[1].soundTransform = MT[1];
        }
        public static function playSound(_arg1:uint=0):void{
            if (soundOn){
                if (_arg1 != 0){
                    soundChan = soundArray[_arg1].s.play();
                    soundArray[_arg1].played = true;
                }
            }
        }
        private static function runFade(_arg1:TimerEvent=null):void{
            var _local4:uint;
            var _local2:SoundTransform = MT[cc];
            var _local3:SoundChannel = MC[cc];
            if (cc == 0){
                _local4 = 1;
            } else {
                _local4 = 0;
            }
            if (_local2.volume < 0.6){
                _local2.volume = (_local2.volume + 0.02);
                _local3.soundTransform = _local2;
            } else {
                T2.removeEventListener(TimerEvent.TIMER, runFade);
                MT[_local4].volume = 0;
                MC[_local4].soundTransform = MT[_local4];
            }
            _local2 = MT[_local4];
            _local3 = MC[_local4];
            if (_local2.volume > 0){
                _local2.volume = (_local2.volume - 0.02);
                _local3.soundTransform = _local2;
            } else {
                _local3.stop();
            }
        }
        public static function playMusic(_arg1:uint=0):void{
            var _local2:SoundChannel;
            var _local3:SoundTransform;
            if (soundOn){
                cc++;
                if (cc == 2){
                    cc = 0;
                }
                _local2 = MC[cc];
                _local3 = MT[cc];
                MC[cc] = musicArray[_arg1].play(0, int.MAX_VALUE);
                _local3.volume = 0;
                MC[cc].soundTransform = _local3;
                T2.addEventListener(TimerEvent.TIMER, runFade, false, 0, true);
            }
        }
        private static function clearPlayed(_arg1:TimerEvent):void{
            var _local2:*;
            var _local3:*;
            for (_local2 in soundChan) {
                for (_local3 in soundChan[_local2]) {
                    soundChan[_local2].played = false;
                }
            }
        }
        public static function switchMute(_arg1:uint=0):void{
            if (soundOn){
                soundOn = false;
                MC[0].stop();
                MC[1].stop();
            } else {
                soundOn = true;
                playMusic(_arg1);
            }
        }

    }
}//package 
