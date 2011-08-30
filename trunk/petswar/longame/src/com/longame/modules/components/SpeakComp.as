package com.longame.modules.components
{
	import com.longame.display.tip.InfoBubble;
	import com.longame.modules.entities.IDisplayEntity;

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
		public function speak(title:String,content:String=null,showTime:int=3):void
		{
			if(this._actived){
				_bubble.show(title,content,null,0,showTime);
				//将对话泡移动到对象中央线顶部
				_bubble.x=-theOwner.offsetX;
				_bubble.y=-theOwner.bounds.top-theOwner.offsetY
			}
		}
		override protected function  doWhenActive():void
		{
			super.doWhenActive();
			_bubble=new InfoBubble();
			theOwner.container.addChild(_bubble);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			_bubble.hide();
			_bubble=null;
		}
		private function get theOwner():IDisplayEntity
		{
			return (_owner as IDisplayEntity);
		}
	}
}