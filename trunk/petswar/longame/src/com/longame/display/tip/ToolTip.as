package com.longame.display.tip
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ToolTip extends InfoBubble
	{
		private static var targets:Vector.<InteractiveObject>=new Vector.<InteractiveObject>();
		private static var msgs:Vector.<String>=new Vector.<String>();
		private static var directions:Vector.<int>=new Vector.<int>();
		private static var tip:InfoBubble;
		
		private static var currentTarget:InteractiveObject;
		
		public function ToolTip()
		{
			super();
		}
		/**
		 * 注册一个对象的tooltip事件
		 * @param target:目标对象
		 * @param msg:要显示的信息
		 * @param direction:显示的方向
		 * */
		public static function register(target:InteractiveObject,msg:String,direction:int=1):void
		{
			if(targets.indexOf(target)>-1) return;
			targets.push(target);
			msgs.push(msg);
			directions.push(direction);
			target.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
			target.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		/**
		 *  取消tooltip注册，原则上是要在对象销毁前调用，因为weakreference=true，影响应该不大
		 * */
		public static function unregister(target:InteractiveObject):void
		{
			var i:int=targets.indexOf(target);
			if(i<0) return;
			targets.splice(i,1);
			msgs.splice(i,1);
			directions.splice(i,1);
			target.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			target.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		protected static function onMouseOver(event:MouseEvent):void
		{
			if(currentTarget) return;
			var t:InteractiveObject=event.currentTarget as InteractiveObject;
			var i:int=targets.indexOf(t);
			if(i==-1) return;
			if(tip==null) tip=new InfoBubble();
			tip.direction=directions[i];
			tip.show(msgs[i]);
			t.stage.addChild(tip);
			tip.snapToTarget(t,directions[i]);
			currentTarget=t;
		}
		protected static function onMouseOut(event:MouseEvent):void
		{
			var t:InteractiveObject=event.currentTarget as InteractiveObject;
			currentTarget=null;
			tip.hide();
		}
	}
}