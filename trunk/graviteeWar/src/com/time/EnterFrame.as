package com.time
{
	import flash.display.Shape;
	import flash.events.Event;
	import com.IFrameObject;

	public class EnterFrame
	{
		private static var shape:Shape=new Shape();
		
		private static var frameObjects:Array=[];
		
		public function EnterFrame()
		{
			
		}
		public static function start():void
		{
			shape.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		public static function stop():void
		{
			frameObjects=[];
			shape.removeEventListener(Event.ENTER_FRAME,onFrame);
		}
		public static function addObject(obj:IFrameObject):void
		{
			if(frameObjects.indexOf(obj)>-1) return;
			frameObjects.push(obj);
		}
		public static function removeObject(obj:IFrameObject):void
		{
			var i:int=frameObjects.indexOf(obj);
			if(i>-1) frameObjects.splice(i,1);
		}
		
		private static function onFrame(e:Event):void
		{
			for each(var obj:IFrameObject in frameObjects){
				obj.onFrame();
			}
		}
	}
}