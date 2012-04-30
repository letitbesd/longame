package com.xingcloud.action
{
	public class QuestAcceptAction extends Action
	{
		/**
		 * 领取任务的action
		 * @param questId: 任务id
		 * */
		public function QuestAcceptAction(questId:String, success:Function=null, fail:Function=null)
		{
			super({questId:questId}, success, fail);
		}
	}
}