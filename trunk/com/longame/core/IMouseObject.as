package com.longame.core
{
	import flash.events.MouseEvent;
	
	import com.longame.model.signals.MouseSignals;
	
	import org.osflash.signals.Signal;

	public interface IMouseObject
	{
		/**
		 * 把所有的鼠标响应封装到一起
		 * */
		function get onMouse():MouseSignals;
		/**
		 * 设定有否鼠标响应，对于大面积场景，让不需要鼠标响应的对象关闭此功能，对性能有提升
		 * 设置mouseEnabled=false，会同时将显示对象的mouseEnabled和mouseChildren关闭,默认是关闭的
		 * */
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
	}
}