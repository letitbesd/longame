package com.longame.display.core
{
	import org.osflash.signals.Signal;

	public interface IFrameAnimator
	{
		function set currentFrame(value:int):void
		function get currentFrame():int;
		function get currentLabel():String;
		function get frames():AnimationFrames;
	}
}