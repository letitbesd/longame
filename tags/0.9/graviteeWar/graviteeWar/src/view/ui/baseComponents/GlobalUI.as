package view.ui.baseComponents
{
	import flash.display.Sprite;
	
	import view.ui.components.Counter;
	import view.ui.components.WepButton;
	
	public class GlobalUI extends Sprite
	{
		public function GlobalUI()
		{
			super();
			initEvent();
			initDisplay();
		}
		
		private function initDisplay():void
		{
			var counter:Counter = new Counter(45);
			this.addChild(counter);
			
			var wepButton:WepButton = new WepButton();
			this.addChild(wepButton);
		}
		
		private function initEvent():void
		{
			
		}
	}
}