package view.ui.components
{
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.CountDown;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import signals.CountDownSignals;
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.ui.baseComponents.GlobalUI;
	
	public class Counter extends Sprite
	{
		public var totalSeconds:uint;
		public var mc:MovieClip;
		public function Counter($totalSeconds:uint)
		{
			totalSeconds = $totalSeconds;
			initDisplay();
			super();
		}
		
		private function initDisplay():void
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			
			mc = AssetsLibrary.getMovieClip("counter");
			this.addChild(mc);
			mc.gotoAndStop(1);
			mc.time.text = totalSeconds.toString();
			this.x = 10;
			this.y = 10;
		}
		
		public function setCounterColor():void
		{
			var frame:uint = BattleScene.currentHero.index+1;
			mc.gotoAndStop(frame);
		}
		
		public function updateCounter(currentTime:uint):void
		{
			mc.time.text = currentTime.toString();
		}
	}
}