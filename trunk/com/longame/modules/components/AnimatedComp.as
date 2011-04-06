package com.longame.modules.components
{
	import com.longame.core.IAnimatedObject;
	import com.longame.managers.ProcessManager;
	/**
	 * 所有动画组件基类
	 * */
	public class AnimatedComp extends AbstractComp implements IAnimatedObject
	{
		public function AnimatedComp(id:String)
		{
			super(id);
		}
		
		public function onFrame(deltaTime:Number):void
		{
			
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			ProcessManager.addAnimatedObject(this);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			ProcessManager.removeAnimatedObject(this);
		}		
	}
}