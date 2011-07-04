package com.longame.utils
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 	Jonathan Reyes
	 * @link 	www.jonathanreyes.com
	 */
	public class CountDown extends EventDispatcher
	{
		public var onUpdate:Signal=new Signal();
		public var onEnd:Signal=new Signal();
		public var onEmergency:Signal=new Signal(Date);
		
		
		public var data:Object;
		private var _timer:Timer;

		protected var totalTime:int;
		protected var emergencyTime:int;

		/**
		 * Countdown constructor.  
		 * @param	totalTime				total milliseconds you want to countdown to
		 * @param	$frequency = 1000	How often do you want to update the count (in milliseconds)
		 * @param   emergencyTime=0     提前多少毫秒报警
		 * @param	$start = true		Start countdown upon init
		 */
		public function CountDown(totalTime:int, $frequency:int= 1000,emergencyTime:int=0, $start:Boolean = true) :void
		{
			this.totalTime = totalTime;
			this.emergencyTime=emergencyTime;
			_timer = new Timer($frequency);
			_timer.addEventListener(TimerEvent.TIMER, _updateCount);
			
			if($start) start();
		}
		
		public function start():void {
			_timer.start();		
		}
		public function stop():void {
			_timer.stop();
		}
		public function reset():void
		{
			_timer.reset()
		}
		public function get running():Boolean
		{
			return this._timer.running;
		}
		public function destroy():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, _updateCount);
			_timer=null;
		}
		
		private function _updateCount(e:TimerEvent):void {
			var t:int=_timer.currentCount*_timer.delay;
			var _timeLeft:Number =this.totalTime-t;
			
			var _seconds:Number = Math.floor(_timeLeft / 1000);
			var _minutes:Number = Math.floor(_seconds / 60);
			var _hours:Number = Math.floor(_minutes / 60);
			var _days:Number = Math.floor(_hours / 60);
			
			_seconds %= 60;
			_minutes %= 60;
			_hours %= 24;
			
			if((this.emergencyTime>0)&&(_timeLeft<=this.emergencyTime)){
				this.onEmergency.dispatch(new Date(null,null,_days,_hours,_minutes,_seconds));
			}			
			if((_days==0)&&(_hours==0)&&(_minutes==0)&&(_seconds==0)){
				this.onEnd.dispatch();
				this.reset();
			}
			this.onUpdate.dispatch(new Date(null,null,_days,_hours,_minutes,_seconds));			
		}
	}
}