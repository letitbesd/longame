package view.ui.components.time
{
	import flash.events.Event;
	
	public class CountdownEvent extends Event
	{
		public static const ON_SECOND:String="on_second";
		public static const ON_COMPLETE:String="on_complete";
		
		private var _secondLeft:uint;
		
		public function CountdownEvent(type:String,secondLeft:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._secondLeft=secondLeft;
		}
		public function get secondLeft():uint
		{
			return _secondLeft;
		}
	}
}