package com.xingcloud.tutorial.steps
{
	import com.longame.managers.ProcessManager;
	
	import flash.events.MouseEvent;

	/**
	 * 显示一会自动进入下一步
	 * */
	public class AutoPlayStep extends TutorialStep
	{
		/**
		 * 这一步停留的时间，秒，时间到自动进入下一步,玩家点击屏幕也可以
		 * */
		protected var stayTime:int=5;
		
		public function AutoPlayStep(delay:uint=0)
		{
			super(delay);
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@stayTime")) this.stayTime=parseInt(xml.@stayTime);
		}
		override protected function doExecute():void
		{
			super.doExecute();
			if(Engine.stage){
				Engine.stage.addEventListener(MouseEvent.CLICK,onStageClicked);
			}
			ProcessManager.schedule(this.stayTime*1000,this,complete);
		}
		
		protected function onStageClicked(event:MouseEvent):void
		{
			Engine.stage.removeEventListener(MouseEvent.CLICK,onStageClicked);
			this.complete();
		}
	}
}