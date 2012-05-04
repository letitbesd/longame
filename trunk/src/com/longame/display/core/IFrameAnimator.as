package com.longame.display.core
{
	import org.osflash.signals.Signal;

	public interface IFrameAnimator
	{
		function set currentFrame(value:int):void
		function get currentFrame():int;
		function get currentLabel():String;
		function get frames():AnimationFrames;
		/**
		 * 到某帧时播放一个声音
		 * @param frame: Label or Frame index
		 * @param sound: sound id added by SoundManager
		 * */
		function addFrameSound(frame:*,sound:String):void;
	}
}