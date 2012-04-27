package com.xingcloud.tutorial.tips
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.easing.Exponential;
	import com.gskinner.motion.plugins.ColorAdjustPlugin;
	import com.longame.display.tip.InfoBubble;
	import com.longame.managers.AssetsLibrary;
	import com.longame.model.Direction;
	import com.longame.utils.StringParser;
	
	import flash.display.MovieClip;

	/**
	 * <InfoTip direction="1" emphasize="true" icon="somMc" width="200" autoSize="false"/>
	 * */
	public class InfoTip extends TutorialTip
	{
		private const EMPHASIZE_STRENGTH:int=10;
		private var _tip:InfoBubble;
		//显示标题，无则用ower.name
		private var title:String;
		//显示内容，无则用owner.description
		private var description:String;
		//以下两个参数可以在xml设定
		//tip的方向
		private var direction:int=0;
		//tip的固定宽度
		private var tipWidth:int=0;
		//tip是否自动大小，为true是上面的无作用
		private var tipAutosize:Boolean=true;
		//tip是否需要闪烁来强调
		private var emphasize:Boolean=true;
		//显示一张图片，目前只支持className
		private var icon:String;
		private var g1:GTween;
		private var g2:GTween;
		
		public function InfoTip()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@direction")) this.direction=parseInt(xml.@direction);
			if(xml.hasOwnProperty("@emphasize")) this.emphasize=StringParser.toBoolean(xml.@emphasize);
			if(xml.hasOwnProperty("@title")) this.title=String(xml.@title);
			if(xml.hasOwnProperty("@description")) this.description=String(xml.@description);
			if(xml.hasOwnProperty("@icon")) this.icon=String(xml.@icon);
			if(xml.hasOwnProperty("@width")) this.tipWidth=StringParser.toUint(xml.@width);
			if(xml.hasOwnProperty("@autoSize")) this.tipAutosize=StringParser.toBoolean(xml.@autoSize);
		}
		override protected function doShow():void
		{
			if(_tip==null) {
				_tip=new  InfoBubble();
				_tip.autoSize=this.tipAutosize;
				if((!_tip.autoSize)&&(this.tipWidth>0))  _tip.tipWidth=this.tipWidth;
			}
			this._canvas.addChild(_tip);
			if(this.owner.rect) _tip.snapToBounds(this.owner.rect,direction);
			else           _tip.snapToTarget(this.target,direction);
			if(icon) var iconMc:MovieClip=AssetsLibrary.getMovieClip(icon);
			_tip.show(this.title||_owner.name,this.description||_owner.description,iconMc);
			if(this.emphasize){
				var od:int=Direction.getOppositedDirection(this.direction);
				var offx:int=Direction.dx[od]*EMPHASIZE_STRENGTH;
				var offy:int=Direction.dy[od]*EMPHASIZE_STRENGTH;
				g1=new GTween(_tip,0.8,{x:_tip.x,y:_tip.y},{ease:Exponential.easeIn});
				g2=new GTween(_tip,0.8,{x:_tip.x+offx,y:_tip.y+offy},{ease:Exponential.easeOut});
				g1.nextTween=g2;
				g2.nextTween=g1;
			}
		}
		override protected function doHide():void
		{
			_tip.hide();
			_tip=null;
			if(g1){
				g1.paused=true;
				g2.paused=true;
				g1=null;
				g2=null;
			}
		}
	}
}