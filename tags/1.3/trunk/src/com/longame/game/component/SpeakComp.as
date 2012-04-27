package com.longame.game.component
{
	import com.longame.display.tip.InfoBubble;
	import com.longame.game.entity.IDisplayEntity;

	/**
	 * 角色说话的组件
	 * */
	public class SpeakComp extends AbstractComp
	{
		private var _bubble:InfoBubble;
		public function SpeakComp(id:String=null)
		{
			super(id);
		}
		/**
		 * 说话
		 * @param title:标题
		 * @param content:内容
		 * @param showTime:显示时间，秒
		 * */
		public function speak(title:String,content:String=null,showTime:int=3,offsetX:Number=0,offsetY:Number=0):void
		{
			if(this._actived){
				_bubble.autoSize=true;
				_bubble.show(title,content,null,0,showTime);
				//将对话泡移动到对象中央线顶部
				_bubble.x=-theOwner.offsetX+offsetX;
				_bubble.y=-theOwner.bounds.top-theOwner.offsetY+offsetY;
			}
		}
		public function shutup():void
		{
			if(_bubble){
				_bubble.hide();
			}
		}
		override protected function  whenActive():void
		{
			super.whenActive();
			_bubble=new InfoBubble();
			theOwner.container.addChild(_bubble);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			_bubble.hide();
			_bubble=null;
		}
		private function get theOwner():IDisplayEntity
		{
			return (_owner as IDisplayEntity);
		}
	}
}