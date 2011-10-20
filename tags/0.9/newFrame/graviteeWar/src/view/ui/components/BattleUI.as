package view.ui.components
{
	
	
	import flash.display.Sprite;
	
	import view.ui.baseComponents.GameCounter;
	import view.ui.baseComponents.WepPanel;
	
	public class BattleUI extends Sprite
	{
		private var _wepPanel:WepPanel;
		private var _counter:GameCounter;
		public function BattleUI()
		{
			super();
			_wepPanel = new WepPanel();
			_counter  = new GameCounter(0,1);
			this.addChild(_wepPanel);
			this.addChild(_counter);
			_wepPanel.x = 660;
			_wepPanel.y = 460;
		}
		
		public function get wepPanel():WepPanel
		{
		  return _wepPanel;
		}
		
		public function get counter():GameCounter
		{
		  return _counter;
		}
		
		
	}
}