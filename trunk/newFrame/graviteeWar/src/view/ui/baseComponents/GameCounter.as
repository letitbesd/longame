package view.ui.baseComponents
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import signals.FightSignals;
	import view.ui.components.time.CountDown;
	import view.ui.components.time.CountdownEvent;
	
	public class GameCounter extends Sprite
	{
		private var _content:MovieClip;
		private var _count:CountDown;
		private var _colorIndex:int;
		private var _currentHeroIndex:int;
		public function GameCounter(currentHeroIndex:int,teamIndex:int)
		{
			super();
			_content=AssetsLibrary.getMovieClip("counter");
			this.addChild(_content);
			_colorIndex=teamIndex;
			_currentHeroIndex=currentHeroIndex;
		}
//		public function start():void
//		{
//			_content.gotoAndStop(_colorIndex);
//			_count=new CountDown(45);
//			_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
//			_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
//			_count.start();
//		}
		public function retreat():void
		{
			_count.reset();
			_content.toptext.text="RETREAT";
			_content.bottomtext.text="TIME";
			_content.time.text="3";
			_count=new CountDown(3);
			_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
			_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
			_count.start();
		}
		
		private function onComplete(event:CountdownEvent):void
		{
			FightSignals.turnNextHero.dispatch(this._currentHeroIndex,false);
		}
		private function onSecond(event:CountdownEvent):void
		{
			_content.time.text=String(event.secondLeft);
		}
		public function set colorIndex(value:int):void
		{
			_content.gotoAndStop(value);
			_count=new CountDown(45);
			_count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
			_count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
			_count.start();
		}
		public function set currentHeroIndex(value:int):void
		{
			_currentHeroIndex = value;
		}
	}
}