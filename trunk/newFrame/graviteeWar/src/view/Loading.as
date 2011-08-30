package view
{
	import com.longame.core.IAnimatedObject;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;

	public class Loading
	{
		public function Loading()
		{
			
		}
//		private static var i:uint = 0;
//		private static var j:uint = 0;
		private static var mc:MovieClip;
		private static var showing:Boolean;
		public static function init(mc:MovieClip):void
		{
			Loading.mc=mc;
		}
		private static var count:int;
		public static function show(really:Boolean=true):void
		{
			if(mc==null) return;
			count++;
			if(!really) return;
			if(showing) return;
			showing=true;
			mc.gotoAndStop(1);
			Engine.stage.addChild(mc);
		}
		public static function hide():void
		{
			count--;
			count=Math.max(0,count);
			if(!showing) return;
			if(count<=0){
				showing=false;
				mc.gotoAndStop("over");
			}
		}
	}
}