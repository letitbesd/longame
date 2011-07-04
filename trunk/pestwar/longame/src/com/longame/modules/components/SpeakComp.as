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
				_bubble.showTime=showTime;
				_bubble.show((_owner as IDisplayEntity).container,title,content);
				//将对话泡移动到对象中央线顶部
				_bubble.moveTo(-(_owner as IDisplayEntity).offsetX,-(_owner as IDisplayEntity).bounds.top-(_owner as IDisplayEntity).offsetY);
			}
		}
		override protected function  doWhenActive():void
		{
			super.doWhenActive();
			_bubble=new InfoBubble((_owner as IDisplayEntity).container);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			_bubble.hide();
			_bubble=null;
		}
	}
}