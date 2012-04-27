package com.xingcloud.tutorial.tips
{
	import com.longame.utils.StringParser;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 高亮显示某个显示对象，这个对象范围以外的东西都被半透明覆盖，在向导系统里经常要用
	 * <Highlight target="" clickable="false" strokeColor="0x00ff" strokeWeight="2"/>
	 * */
	public class Highlight extends TutorialTip
	{
		private static const FILL_ALPHA:Number=0;
		/**
		 *hilight 的颜色 
		 */		
		public var strokeColor:int = -1;
		/**
		 *hilight 的线条笔画粗细 
		 */		
		public var strokeWeight:Number =0.5;
		/**
		 * 被高亮的对象，是否可点击
		 * */
		private var clickable:Boolean=true;
		
		public function Highlight()
		{
			
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@clickable")) this.clickable=StringParser.toBoolean(xml.@clickable);
			if(xml.hasOwnProperty("@strokeColor")) this.strokeColor=StringParser.toUint(xml.@strokeColor);
			if(xml.hasOwnProperty("@strokeWeight")) this.strokeWeight=Number(xml.@strokeWeight);
		}
		override protected function doShow():void
		{
			super.doShow();
			var p:Point=new Point();
			var _rect:Rectangle=_owner.rect;
			if(_rect==null) {
				if(target) {
					_rect=target.getBounds(target.stage);
				}else {
					return;
				}
			}else{
				p.x=_rect.x;
				p.y=_rect.y;
			}
			//下面这个方法可以画出一个矩形填充
			_canvas.graphics.beginFill(0x0,FILL_ALPHA);
			_canvas.graphics.drawRect(0,0,Engine.stage.stageWidth,Engine.stage.stageHeight);
			if(strokeColor>=0) _canvas.graphics.lineStyle(strokeWeight,strokeColor);
			//中间挖空一个矩形
			_canvas.graphics.drawRect(_rect.x,_rect.y,_rect.width,_rect.height);
			_canvas.graphics.endFill();
			//如果需要不可点击，再加个矩形遮挡
			if(this.clickable==false){
				var mask:Sprite=new Sprite();
				mask.graphics.beginFill(0xff,0);
				mask.graphics.drawRect(_rect.x,_rect.y,_rect.width,_rect.height);
				mask.x=p.x;
				mask.y=p.y;
				_canvas.addChild(mask);
			}
		}
	}
}