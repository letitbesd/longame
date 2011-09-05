package view.ui.mediators
{
	import com.longame.utils.CountDown;
	import com.longame.utils.Util;
	
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Mediator;
	
	import signals.CountDownSignals;
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.ui.components.Counter;
	
	public class CountDownMediators extends Mediator
	{
		public static const NAME:String = "CountDownMediator";
		[Inject]
		public var view:Counter;
		
		private var theStage:Stage;
		private var countDown:CountDown;
		private var totalSeconds:uint;
		private var retreatTimeSeconds:uint = 3;
		
		public function CountDownMediators()
		{
			super();
		}	
		
		override public function onRegister():void
		{
			totalSeconds = this.view.totalSeconds;
			countDown = new CountDown(totalSeconds * 1000);
			
			FightSignals.fightStart.add(countStart);
			
			FightSignals.attackComplete.add(retreatTime);
			countDown.onUpdate.add(updateFun);
			countDown.onEnd.add(endFun);
		}
		
		private function countStart():void
		{
			countDown.start();
		}
		
		private function retreatTime(heroIndex:uint):void
		{
			resetCounter(retreatTimeSeconds);
			this.view.mc.toptext.text = "RETREAT"
			this.view.mc.bottomtext.text = "Time";
		}
		
		private function endFun():void
		{
			CountDownSignals.completeSignal.dispatch();
			resetCounter(totalSeconds);
			turnNext();
		}
		
		private function turnNext():void
		{
			this.view.setCounterColor();
			this.view.mc.toptext.text = "Time"
			this.view.mc.bottomtext.text = "LEFT";
		}
		
		private function resetCounter(seconds:uint):void
		{
			countDown.reset();
			countDown.onUpdate.remove(updateFun);
			countDown.onEnd.remove(endFun);
			
			countDown = new CountDown(seconds * 1000);
			this.view.updateCounter(seconds);
			countDown.onUpdate.add(updateFun);
			countDown.onEnd.add(endFun);
			countDown.start();
		}
		
		private function updateFun(date:Date):void
		{
			this.view.updateCounter(date.seconds);
			CountDownSignals.updateSignal.dispatch();
		}
	}
}