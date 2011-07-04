package com.xingcloud.socialize.utils
{
	import flash.external.ExternalInterface;

	public class Console
	{
		public function Console()
		{
		}
		public static function print(text:String):void {
			if (ExternalInterface.available) {
				try{
					ExternalInterface.call("function(text){if (window.console) window.console.info(text);}", text);
				}catch(e:Error){
					
				}
			}
		}
	}
}