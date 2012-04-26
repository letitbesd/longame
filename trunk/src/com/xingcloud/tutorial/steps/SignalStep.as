package com.xingcloud.tutorial.steps
{
	import com.longame.model.signals.GlobalSignals;

	/**
	 * 某个信号触发这个步骤完成，比如让角色拿到某个东西，GlobalSignals.IDSignal.dispatch("gotSomething")时，这个步骤完成
	 * <SignalStep name=""  description="" signal="gotSomething">
	 * </SignalStep>
	 * */
	public class SignalStep extends TutorialStep
	{
		private var _signal:String;
		
		public function SignalStep()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			_signal=xml.@signal;
		}
		override protected function doExecute():void
		{
			super.doExecute();
			GlobalSignals.IDSignal.add(checkID);
		}
		private function checkID(signalId:String):void
		{
			if(_signal==signalId){
				this.complete();
			}
		}
		override protected function complete():void
		{
			super.complete();
			GlobalSignals.IDSignal.remove(checkID);
		}
		override public function abort():void
		{
			GlobalSignals.IDSignal.remove(checkID);
			super.abort();
		}
	}
}