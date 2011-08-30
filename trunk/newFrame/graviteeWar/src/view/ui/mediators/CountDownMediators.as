package view.ui.mediators
{
	import com.longame.utils.CountDown;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CountDownMediators extends Mediator
	{
		public static const NAME:String = "BattleUIMediator";
		[Inject]
		public var view:CountDown;
		
		public function CountDownMediators()
		{
			super();
		}
		
		override public function onRegister():void
		{
			
		}
	}
}