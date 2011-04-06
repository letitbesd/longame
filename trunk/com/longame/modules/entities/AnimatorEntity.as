package com.longame.modules.entities
{
	import flash.display.Sprite;
	
	import com.longame.core.long_internal;
	import com.longame.display.GameAnimator;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.utils.ObjectUtil;
	
	use namespace long_internal;

	public class AnimatorEntity extends SpriteEntity
	{
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
			if(_container==null)
			{
				if(_source==null) throw new Error("The source for a displayEntity couldn't be null!");
				_container=new  GameAnimator(source);
				/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
				_container.mouseEnabled=_container.mouseChildren=false;	
				_container.tabEnabled=false;
			}
			return _container;
		}
		override public function destroy():void
		{
			if(destroyed) return;
			animator.destroy();
			_container=null;
			super.destroy();
		}
		public function gotoAndPlay(frame:*,loops:int=-1,frameRate:uint=30):void
		{
			animator.gotoAndPlay(frame,loops,frameRate);
		}
		public function gotoAndStop(frame:*):void
		{
			animator.gotoAndStop(frame);
		}
	}
}