package com.longame.display.tip
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ToolTip extends InfoBubble
	{
		private static var targets:Vector.<InteractiveObject>=new Vector.<InteractiveObject>();
		private static var msgs:Vector.<String>=new Vector.<String>();
		private static var directions:Vector.<int>=new Vector.<int>();
		
		private static var _tip:InfoBubble;
		private static var currentTarget:InteractiveObject;
		
		public function ToolTip()
		{
			super();
		}
		/**
		 * 显示的气泡，可设置样式
		 * */
		public static function get tip():InfoBubble
		{
			if(_tip==null) _tip=new InfoBubble();
			return _tip;
		}
		/**
		 * 注册一个对象的tooltip事件，注册完一般不用手动调unregister,target从舞台删除时会自动unrigister
		 * @param target:目标对象
		 * @param msg:要显示的信息
		 * @param direction:显示的方向，详见Direction
		 * */
		public static function register(target:InteractiveObject,msg:String,direction:int=1):void
		{
			if(targets.indexOf(target)>-1) return;
			targets.push(target);
			msgs.push(msg);
			directions.push(direction);
			target.addEventListener(MouseEvent.ROLL_OVER,onMouseOver,false,0,true);
			target.addEventListener(MouseEvent.ROLL_OUT,onMouseOut,false,0,true);
			target.addEventListener(Event.REMOVED_FROM_STAGE,onTargetRemoved);
		}
		protected static function onTargetRemoved(event:Event):void
		{
			unregister(event.currentTarget as  InteractiveObject);
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
			if(currentTarget==target){
				 _tip.hide();
				 currentTarget=null;
			}
			target.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			target.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			target.removeEventListener(Event.REMOVED_FROM_STAGE,onTargetRemoved);
		}
		protected static function onMouseOver(event:MouseEvent):void
		{
			if(currentTarget) return;
			var t:InteractiveObject=event.currentTarget as InteractiveObject;
			var i:int=targets.indexOf(t);
			if(i==-1) return;
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
			_tip.hide();
		}
	}
}