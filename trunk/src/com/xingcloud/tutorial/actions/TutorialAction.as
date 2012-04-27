package com.xingcloud.tutorial.actions
{
	import com.xingcloud.action.Action;

	public class TutorialAction extends Action
	{
		public function TutorialAction(name:String)
		{
			super({XA_tutorial:name,XA_state:"over"});
		}
	}
}