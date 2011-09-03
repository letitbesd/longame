package view.ui.baseComponents
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import signals.FightSignals;
	
	public class WepPanel extends Sprite
	{
		private var _content:MovieClip;
		private var wepList:MovieClip;
		public function WepPanel()
		{
			super();
			this._content=AssetsLibrary.getMovieClip("wepicon");
			this.wepList=AssetsLibrary.getMovieClip("weplist");
			this._content.gotoAndStop(1);
			wepList.x=-120;
			wepList.y=-400;
			this.initIcon();
			this.addChild(this._content);
			this.addChild(this.wepList);
			wepList.visible=false;
			this._content.addEventListener(MouseEvent.CLICK,onIconClick);
			FightSignals.roundEnd.add(roundEnd);
		}
		private function initIcon():void
		{
			for(var i:int=0;i<=9;i++){
				var j:int=i+1;
				if(j>9) j=9
				wepList["wep"+j+"lock"].gotoAndStop(1);
				wepList["wep"+i].addEventListener(MouseEvent.CLICK,onListClick);
			}
		}
		private function onIconClick(event:MouseEvent):void
		{
			if(wepList.visible==true){
				wepList.visible=false;
			}else{
				wepList.visible=true;
			}
		}
		private function onListClick(event:MouseEvent):void
		{
			var id:int=event.target.name.charAt(3);
			this._content.gotoAndStop(id+1);
			wepList.visible=false;
			FightSignals.changWep.dispatch(id+1);
		}
		private function roundEnd():void
		{
			this._content.gotoAndStop(1);
		}
	}
}