package view.ui.components
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class WepButton extends Sprite
	{
		private var mc:MovieClip;
		public function WepButton()
		{
			initDisplay();
			initEvent();
			super();
		}
		
		private function initDisplay():void
		{
			this.buttonMode = true;
			this.useHandCursor = true;

			mc = AssetsLibrary.getMovieClip("wepicon");
			mc.gotoAndStop(1);
			this.addChild(mc);
			this.x = 660;
			this.y = 460;
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			
		}
	}
}