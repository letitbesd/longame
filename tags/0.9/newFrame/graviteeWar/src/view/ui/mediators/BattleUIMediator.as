package view.ui.mediators
{
	import com.longame.utils.CountDown;
	
	import org.robotlegs.mvcs.Mediator;
	
	import view.ui.baseComponents.GameCounter;
	import view.ui.components.BattleUI;
	
	public class BattleUIMediator extends Mediator
	{
		public static const NAME:String = "BattleUIMediator";
		[Inject]
		public var view:BattleUI;
		
		public function BattleUIMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			
		}
	}
}