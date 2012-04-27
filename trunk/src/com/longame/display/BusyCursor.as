package com.longame.display
{
	import com.longame.core.IAnimatedObject;
	import com.longame.managers.ProcessManager;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Flex原版的系统繁忙鼠标
	 * */
	public class BusyCursor extends Sprite implements IAnimatedObject
	{
		protected var minuteHand:Shape;
		protected var hourHand:Shape;
		
		protected var cursorHolder:Sprite;
		protected var masker:Sprite;
		
		public function BusyCursor()
		{
			super();
			this.draw();
		}
		protected static var _instance:BusyCursor;
		protected static var showing:Boolean;
		private static var showCounter:int;
		public static function show(clickable:Boolean=false):void
		{
			showCounter++;
			if(showing) return;
			showing=true;
			if(_instance==null) _instance=new BusyCursor();
			_instance.masker.visible=!clickable;
			Engine.nativeStage.addChild(_instance);
			ProcessManager.addAnimatedObject(_instance);
		}
		public static function hide():void
		{
			showCounter--;
			showCounter=Math.max(0,showCounter);
			if(!showing) return;
			if(showCounter<=0){
				showing=false;
				if(_instance==null) return;
				Engine.nativeStage.removeChild(_instance);
				ProcessManager.removeAnimatedObject(_instance);
			}
		}
		protected function draw():void
		{
			var xOff:Number = -0.5;
			var yOff:Number = -0.5;
			
			var g:Graphics;
			
			//masker
			masker=new Sprite();
			g=masker.graphics;
			g.beginFill(0x0,0);
			g.drawRect(0,0,Engine.nativeStage.stageWidth,Engine.nativeStage.stageHeight);
			g.endFill();
			addChild(masker);
			
			cursorHolder=new Sprite();
			g=cursorHolder.graphics;
			g.beginFill(0xffffff);
			g.lineStyle(2,0x333333);
			g.drawCircle(0,0,8);
			g.endFill();
			addChild(cursorHolder);
			
			// Create the minute hand.
			minuteHand = new Shape();
			minuteHand.name = "minuteHand";
			g = minuteHand.graphics;
			g.beginFill(0x000000);
			g.moveTo(xOff, yOff);
			g.lineTo(1 + xOff, 0 + yOff);
			g.lineTo(1 + xOff, 5 + yOff);
			g.lineTo(0 + xOff, 5 + yOff);
			g.lineTo(0 + xOff, 0 + yOff);
			g.endFill();
			cursorHolder.addChild(minuteHand);
			
			// Create the hour hand.
			hourHand = new Shape();
			hourHand.name = "hourHand";
			g = hourHand.graphics;
			g.beginFill(0x000000);
			g.moveTo(xOff, yOff);
			g.lineTo(4 + xOff, 0 + yOff);
			g.lineTo(4 + xOff, 1 + yOff);
			g.lineTo(0 + xOff, 1 + yOff);
			g.lineTo(0 + xOff, 0 + yOff);
			g.endFill();
			cursorHolder.addChild(hourHand);
		}
		public function onFrame(deltaTime:Number):void
		{
			minuteHand.rotation += 12;
			hourHand.rotation += 1;
			cursorHolder.x=Engine.nativeStage.mouseX+15;
			cursorHolder.y=Engine.nativeStage.mouseY;
		}
	}
}