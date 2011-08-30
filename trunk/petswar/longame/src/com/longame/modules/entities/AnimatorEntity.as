package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.display.GameAnimator;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.utils.ObjectUtil;
	
	import flash.display.Sprite;
	
	use namespace long_internal;

	public class AnimatorEntity extends SpriteEntity
	{
		private var _defaultAnimation:String;
		private var _defaultFrameRate:int=30;
		
		public function AnimatorEntity(id:String=null)
		{
			super(id);
		}
		public function get animator():GameAnimator
		{
			return container as GameAnimator;
		}
		override public function get container():Sprite
		{
			return _container;
		}
		override protected function createView():void
		{
			if(_source==null) throw new Error("The source for a displayEntity couldn't be null!");
			_container=new  GameAnimator(_defaultAnimation,_renderAsBitmap);
			(_container as GameAnimator).clip.frameRate=_defaultFrameRate;
			/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
			_container.mouseEnabled=_container.mouseChildren=false;	
			_container.tabEnabled=false;
		}
		override protected function doRender():void
		{
			super.doRender();
			animator.defaultAnimation=_defaultAnimation;
		}
		public function gotoAndPlay(frame:*,loops:int=-1,frameRate:int=-1):void
		{
			animator.gotoAndPlay(frame,loops,frameRate);
		}
		public function gotoAndStop(frame:*):void
		{
			animator.gotoAndStop(frame);
		}
		public function play(frameRate:int=-1):void
		{
			animator.clip.play(true,frameRate);
		}
		public function stop():void
		{
			animator.clip.stop();
		}
		public function set defaultAnimation(value:String):void
		{
			if(_defaultAnimation==value) return;
			_defaultAnimation=value;
			if(animator) animator.defaultAnimation=value;
		}
		public function get defaultAnimation():String
		{
			return _defaultAnimation;
		}
		public function set defaultFrameRate(value:int):void
		{
			if(_defaultFrameRate==value) return;
			_defaultFrameRate=value;
			if(animator) animator.clip.frameRate=_defaultFrameRate;
		}
		public function get defaultFrameRate():int
		{
			return _defaultFrameRate;
		}
	}
}