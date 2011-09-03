package
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	import view.ui.baseComponents.GlobalUI;
	import view.ui.components.BattleUI;
	import view.ui.mediators.BattleUIMediator;
	
	public class ApplicationContext extends Context
	{
		public function ApplicationContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			this.setUp();
		}
		
		private function setUp():void
		{
			injector.mapSingleton(GlobalUI);
			
			mediatorMap.mapView(BattleUI,BattleUIMediator);
		}
	}
}