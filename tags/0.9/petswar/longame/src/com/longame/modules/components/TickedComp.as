package com.longame.modules.components
{
	import com.longame.core.ITickedObject;
	import com.longame.managers.ProcessManager;
	/**
	 * 所有tick组件基类
	 * */
	public class TickedComp extends AbstractComp implements ITickedObject
	{
		public function TickedComp(id:String=null)
		{
			super(id);
		}
		public function onTick(deltaTime:Number):void
		{
			
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			ProcessManager.addTickedObject(this);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			ProcessManager.removeTickedObject(this);
		}
	}
}