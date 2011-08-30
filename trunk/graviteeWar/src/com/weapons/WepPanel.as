package com.weapons
{
	import com.longame.managers.AssetsLibrary;
	import com.signals.FightSignals;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class WepPanel extends Sprite
	{
		private var _content:MovieClip;
		private var wepPanel:MovieClip;
		public function WepPanel()
		{
			super();
			this._content=AssetsLibrary.getMovieClip("wepicon");
			this.wepPanel=AssetsLibrary.getMovieClip("weplist");
			this._content.gotoAndStop(1);
			wepPanel.x=-120;
			wepPanel.y=-400;
			this.initIcon();
			this.addChild(this._content);
			this.addChild(this.wepPanel);
			wepPanel.visible=false;
			this._content.addEventListener(MouseEvent.CLICK,onIconClick);
			FightSignals.roundEnd.add(roundEnd);
		}
		private function initIcon():void
		{
			for(var i:int=0;i<=9;i++){
				var j:int=i+1;
				if(j>9) j=9
				wepPanel["wep"+j+"lock"].gotoAndStop(1);
				wepPanel["wep"+i].addEventListener(MouseEvent.CLICK,onPanelClick);
			}
		}
		private function onIconClick(event:MouseEvent):void
		{
			if(wepPanel.visible==true){
				wepPanel.visible=false;
			}else{
				wepPanel.visible=true;
			}
		}
		private function onPanelClick(event:MouseEvent):void
		{
			var id:int=event.target.name.charAt(3);
			this._content.gotoAndStop(id+1);
			wepPanel.visible=false;
			FightSignals.changWep.dispatch(id+1);
		}
		private function roundEnd():void
		{
			this._content.gotoAndStop(1);
		}
	}
}