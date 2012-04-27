package com.longame.display.core
{
	import com.longame.core.IAnimatedObject;
	import com.longame.core.IDestroyable;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.debug.Logger;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	/**
	 * 播放一次就消失的动画，用于特效等场合，被添加到舞台后就自动播放，播放完自动消失
	 * */
	public class OnceClip extends Sprite implements IAnimatedObject, IDestroyable
	{
		public var onOver:Signal=new Signal(OnceClip);
		
		protected var autoDestroy:Boolean;
		protected var source:*;
		protected var _clip:MovieClip;
		/**
		 * 播放完毕是否自动销毁，否则只是将动画停止
		 * */
		public function OnceClip(source:*,autoDestroy:Boolean=true)
		{
			this.autoDestroy=autoDestroy;
			this.source=source;
			super();
			RenderManager.getDisplayFromSource(source,onLoaded,onLoadedFail);
		}
		private var _playing:Boolean;
		public function play():void
		{
			if(_playing||!clip) return;
			_playing=true;
			this.addChild(clip);
			this.stage?onAdded():this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		private function onLoadedFail():void
		{
			Logger.error(this,"onLoadedFail",source+" can not be loaded!");
			this.over();
		}
		private function onLoaded(clip:MovieClip):void
		{
			this._clip=clip;
			if(clip==null) {
				this.onLoadedFail();
				return;
			}
			this.whenBuild();
		}
		protected function whenBuild():void
		{
			this.play();
		}
		protected function onAdded(event:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			clip.gotoAndPlay(1);
			ProcessManager.addAnimatedObject(this);
		}
	    public function onFrame(deltaTime:Number):void
		{
			if(this.clip.currentFrame==this.clip.totalFrames){
				this.over();
			}
		}
		private function over():void
		{
			if(_playing){
				ProcessManager.removeAnimatedObject(this);
				_playing=false;
			}
			onOver.dispatch(this);
			if(this.autoDestroy) {
				this.destroy();
			}else if(clip){
				clip.stop();
				this.removeChild(clip);
			}
		}
		private var _destroyed:Boolean;
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			if(this.parent) this.parent.removeChild(this);
			_clip=null;
			source=null;
			onOver.removeAll();
			onOver=null;
		}
		public function get playing():Boolean
		{
			return _playing;
		}
		public function get clip():MovieClip
		{
			return _clip;
		}
	}
}