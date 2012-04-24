package com.longame.signals
{
	import com.bumpslide.ui.Button;
	
	import org.osflash.signals.Signal;

	/**
	 * 引擎用全局信号
	 * */
	public class GlobalSignals
	{
		/**
		 * 用String指定的id来全局通信
		 * */
         public static const IDSignal:Signal=new Signal(String);
		 /**
		 * 当按钮组的当前选中发生变化时
		 * @param Button 当前选中的button
		 * */
		 public static const onButtonGroupChanged:Signal=new Signal(Button);
	}
}