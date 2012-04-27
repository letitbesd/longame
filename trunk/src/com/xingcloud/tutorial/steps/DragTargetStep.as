package com.xingcloud.tutorial.steps
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 拖动某个对象的行为
	 * <DragTargetStep distance="50" ...>
	 * </DragTargetStep>
	 * */
	public class DragTargetStep extends TutorialStep
	{
		/**
		 * 拖动多少距离就算ok
		 * */
		private var distance:int=20;
		public function DragTargetStep()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@distance")){
				this.distance=parseInt(xml.@distance);
			}
		}
		override protected function doExecute():void
		{
			super.doExecute();
			target.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		private var startDragPos:Point;
		private function onMouseDown(event:MouseEvent):void
		{
			startDragPos=new Point(event.stageX,event.stageY);
			target.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		protected function onMouseMove(event:MouseEvent):void
		{
			var currentPos:Point=new Point(event.stageX,event.stageY);
			currentPos=currentPos.subtract(startDragPos);
			if(currentPos.length>=this.distance){
				this.complete();
			}
		}
		
		override protected function complete():void
		{
			target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			super.complete();
		}
		override public function abort():void
		{
			target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			super.abort();
		}
	}
}