package  com.xingcloud.tutorial.steps
{
	import com.longame.utils.StringParser;
	import com.longame.utils.debug.Logger;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 点击某个target或rect所定义的区域，就可进入下一步
	 * <ButtonClickStep name="" description="" target="" award="" delay="" rect="" listenDown="true"/>
	 */	

	public class ClickTargetStep extends TutorialStep
	{	
		//是否监听down而不是click
		private var listenDown:Boolean=false;
		
		public function ClickTargetStep()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@listenDown")) this.listenDown=StringParser.toBoolean(xml.@listenDown);
		}
		override protected function doExecute():void
		{
//			Logger.info(this,"doExecute",this.name+":"+target+" click target start!");
			super.doExecute();
			if(this.listenDown) target.addEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			else target.addEventListener(MouseEvent.CLICK,onMouse);
		}
		private function onMouse(e:MouseEvent):void
		{
//			Logger.info(this,"onClick",this.name+":"+target+" click target end!");
			if(this.listenDown) target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			else target.removeEventListener(MouseEvent.CLICK,onMouse);
			this.complete();
		}
		override public function abort():void
		{
			if(this.listenDown) target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse);
			else target.removeEventListener(MouseEvent.CLICK,onMouse);
			super.abort();
		}
	}
}