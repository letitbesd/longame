package com.xingcloud.tutorial.tips
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.ColorAdjustPlugin;
	import com.longame.display.tip.InfoBubble;
	import com.longame.utils.StringParser;

	public class InfoTip extends AbstractTip
	{
		private var infoBubble:InfoBubble;
		//以下两个参数可以在xml设定
		//tip的方向
		private var direction:int=0;
		//tip是否需要闪烁来强调
		private var emphasize:Boolean=false;
		
		public function InfoTip()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@direction")) this.direction=parseInt(xml.@direction);
			if(xml.hasOwnProperty("@emphasize")) this.emphasize=StringParser.toBoolean(xml.@emphasize);
		}
		override protected function doShow():void
		{
			if(infoBubble==null) {
				infoBubble=new  InfoBubble();
				infoBubble.autoSize=false;
			}
			this._canvas.addChild(infoBubble);
			if(this.owner.rect) infoBubble.snapToBounds(this.owner.rect,direction);
			else           infoBubble.snapToTarget(this.target,direction);
			infoBubble.show(_owner.name,_owner.description);
			if(this.emphasize){
				ColorAdjustPlugin.install();
				var gt:GTween=new GTween(infoBubble,0.5,{brightness:100});
				var gt1:GTween=new GTween(infoBubble,0.5,{brightness:0});
				gt.nextTween=gt1;
				gt1.nextTween=gt;
			}
		}
		override protected function doHide():void
		{
			infoBubble.hide();
			infoBubble=null;
		}
	}
}