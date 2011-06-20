package time
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="on_second", type="time.CountdownEvent")]
	[Event(name="on_complete", type="time.CountdownEvent")]
	public class CountDown extends EventDispatcher
	{
		private var _timer:Timer;
//		private var _secondsLeft:uint;
		
		public function CountDown(totalSeconds:uint)
		{
			super();
			_timer=new Timer(1000,totalSeconds);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
		}
		public function start():void
		{
			_timer.start();
		}
		public function stop():void
		{
			_timer.stop();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
//			trace("currentCount: "+_timer.currentCount,"totalCount: "+_timer.repeatCount);
			this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_SECOND,(_timer.repeatCount-_timer.currentCount)));
		}
		
		protected function onComplete(event:TimerEvent):void
		{
			this.dispatchEvent(new CountdownEvent(CountdownEvent.ON_COMPLETE,0));
		}
		
		
	}
}