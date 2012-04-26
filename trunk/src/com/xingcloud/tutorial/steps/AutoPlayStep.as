package com.xingcloud.tutorial.steps
{
	import com.longame.managers.ProcessManager;
	import com.longame.utils.debug.Logger;
	
	import flash.events.MouseEvent;

	/**
	 * 显示一会自动进入下一步
	 * <AutoPlayStep stayTime="3"  name="" description="" target="" award="" delay="" rect=""/>
	 * */
	public class AutoPlayStep extends TutorialStep
	{
		/**
		 * 这一步停留的时间，秒，时间到自动进入下一步,玩家点击屏幕也可以
		 * */
		protected var stayTime:int=4;
		
		public function AutoPlayStep()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@stayTime")) this.stayTime=parseInt(xml.@stayTime);
		}
		override protected function doExecute():void
		{
			super.doExecute();
//			Logger.info(this,"doExecute",this.name+" auto play start!");
			Engine.nativeStage.addEventListener(MouseEvent.CLICK,onStageClicked);
			ProcessManager.schedule(this.stayTime*1000,this,complete);
		}
		override protected function complete():void
		{
//			Logger.info(this,"complete",this.name+" auto play complete!");
			Engine.nativeStage.removeEventListener(MouseEvent.CLICK,onStageClicked);
			super.complete();
		}
		protected function onStageClicked(event:MouseEvent):void
		{
//			Logger.info(this,"onStageClicked",this.name+" auto play clicked!");
			this.complete();
		}
		override public function abort():void
		{
			Engine.nativeStage.removeEventListener(MouseEvent.CLICK,onStageClicked);
			super.abort();
		}
	}
}