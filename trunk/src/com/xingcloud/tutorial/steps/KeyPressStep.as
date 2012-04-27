package com.xingcloud.tutorial.steps
{
	import com.longame.managers.InputManager;
	import com.longame.utils.StringParser;
	
	import flash.ui.Keyboard;

	/**
	 * 监听键盘按下的向导
	 * <KeyPressStep name="" keys="LEFT,RIGHT" description="" award="" delay="" target="" rect="">
	 *      <HighLight/>	     
	 *      <InfoTip/>
	 * </KeyPressStep>
	 * */
	public class KeyPressStep extends TutorialStep
	{
		/**
		 * 定义需要按下那些键，可以是一个或一组键,LEFT,RIGHT,大写
		 * */
		protected var _keys:Array=[];
		
		public function KeyPressStep()
		{
			super();
		}
		override public function parseFromXML(xml:XML):void
		{
			super.parseFromXML(xml);
			if(xml.hasOwnProperty("@keys")){
				_keys=StringParser.toArray(xml.@keys);
			}else{
				throw new Error("KeyPressStep must define the keys property!");
			}
		}
		override protected function doExecute():void
		{
			super.doExecute();
			InputManager.onKeyDown.add(onKeyDown);
		}
		
		private function onKeyDown(key:uint):void
		{
			var keysAllDown:Boolean=true;
			for each(var keyName:String in _keys){
				if(!InputManager.isKeyDown(Keyboard[keyName])){
					keysAllDown=false;
					break;
				}
			}
			if(keysAllDown) this.complete();
		}
		override protected function complete():void
		{
			super.complete();
			InputManager.onKeyDown.remove(onKeyDown);
		}
		override public  function abort():void
		{
			InputManager.onKeyDown.remove(onKeyDown);
			super.abort();
		}
	}
}