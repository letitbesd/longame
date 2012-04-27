package com.longame.game.component
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
		override protected function whenActive():void
		{
			super.whenActive();
			ProcessManager.addTickedObject(this);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			ProcessManager.removeTickedObject(this);
		}
	}
}