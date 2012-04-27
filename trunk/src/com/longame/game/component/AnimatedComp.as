package com.longame.game.component
{
	import com.longame.core.IAnimatedObject;
	import com.longame.managers.ProcessManager;
	/**
	 * 所有动画组件基类
	 * */
	public class AnimatedComp extends AbstractComp implements IAnimatedObject
	{
		public function AnimatedComp(id:String=null)
		{
			super(id);
		}
		
		public function onFrame(deltaTime:Number):void
		{
			
		}
		override protected function whenActive():void
		{
			super.whenActive();
			ProcessManager.addAnimatedObject(this);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			ProcessManager.removeAnimatedObject(this);
		}		
	}
}