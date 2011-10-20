package com.longame.display.core
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	/**
	 * 播放一次就消失的动画，用于特效等场合，被添加到舞台后就自动播放，播放完自动消失
	 * */
	public class OnceClip extends Clip
	{
		public var onOver:Signal=new Signal(OnceClip);
		
		private var autoDestroy:Boolean;
		/**
		 * 播放完毕是否自动销毁，否则只是将动画停止
		 * */
		public function OnceClip(autoDestroy:Boolean=true)
		{
			this.autoDestroy=autoDestroy;
			super();
		}
		override protected function doBuild(mc:MovieClip,source:*,renderAsBitmap:Boolean):void
		{
            super.doBuild(mc,source,renderAsBitmap);
			this.stage?doPlay():this.addEventListener(Event.ADDED_TO_STAGE,doPlay);
		}
		
		protected function doPlay(event:Event=null):void
		{
			this.gotoAndPlay(1);
		}
		override public function onFrame(deltaTime:Number):void
		{
			if(this._currentFrame==this._frames.length){
				if(this.autoDestroy)　this.destroy();
				else this.stop();
				onOver.dispatch(this);
			}else{
				super.onFrame(deltaTime);
			}
		}
		
	}
}