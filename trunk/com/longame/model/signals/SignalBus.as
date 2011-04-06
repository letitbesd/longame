package com.longame.model.signals
{
	import flash.utils.Dictionary;
	
	import com.longame.utils.debug.Logger;
	
	import org.osflash.signals.Signal;

	/**
	 * 全局signal总线
	 * 两个"相距很远"的对象targetA和targetB,targetA有个信号signal，targetB有个回调函数call，通常情况信号处理方式为：
	 *     targetA.signal.add(call)
	 * 如果他们"相距很远"，targetB不知道targetA，怎么办呢，用signalBus:
	 * 	   在targetA中：SignalBus.register(signal,"signalA");
	 *   在targetB中：SignalBus.hook("signalA",call);
	 * A和B不用知道谁是谁，但是可以通过则SignalBus建立其信息通道，如果不需要了还需要注销一下：
	 * 	   在targetA中：SignalBus.unresigter(signal,"signalA");
	 *   在targetB中：SignalBus.unhook("signalA",call);
	 * */
	public class SignalBus
	{
        private static var signals:Dictionary=new Dictionary(true);
		private static var callBacks:Dictionary=new Dictionary(true);
		/**
		 * 用一个alias别名来注册信号signal，这样其他对象可以通过alias来找到这个信号
		 * */
		public static function register(signal:Signal,alias:String):void
		{
			var group:Vector.<Signal>=signals[alias] as Vector.<Signal>;
			if(group==null) {
				group=new Vector.<Signal>();
				signals[alias]=group;
			}
			if(group.indexOf(signal)>-1) return;
			group.push(signal);
			var callGroup:Vector.<Function>=callBacks[alias];
			if(callGroup==null) return;
//			Logger.info("SignalBus","register","register signal: "+alias+", calls length: "+callGroup.length);
			for each(var call:Function in callGroup){
				signal.add(call);
			}
		}
		/**
		 * 注销一个信号,给定alias我们会去指定的组里注销
		 * */
		public static function unregister(signal:Signal,alias:String):void
		{
			var signalGroup:Vector.<Signal>=signals[alias] as Vector.<Signal>;
			if(signalGroup){
				var i:int=signalGroup.indexOf(signal);
				if(i>-1) {
					signalGroup.splice(i,1);
					var callGroup:Vector.<Function>=callBacks[alias];
					if(callGroup){
//						Logger.info("SignalBus","unregister","unregister signal: "+alias+", calls length: "+callGroup.length);
						for each(var call:Function in callGroup){
							signal.remove(call);
						}
//						delete callBacks[alias];
					}
				}
			}
		}
		/**
		 * 将一个回调函数关联到以signalName为别名的信号上
		 * */
		public static function hook(signalName:String,callBack:Function):void
		{
			var callGroup:Vector.<Function>=callBacks[signalName];
			if(callGroup==null) {
				callGroup=new Vector.<Function>();
				callBacks[signalName]=callGroup;
			}
			if(callGroup.indexOf(callBack)>-1) return;
			callGroup.push(callBack);
			var group:Vector.<Signal>=signals[signalName] as Vector.<Signal>;
			if(group){
				for each(var signal:Signal in group){
					signal.add(callBack);
//					Logger.info("SignalBus","hook","hooked: "+signalName);
				}
			}
		}
		/**
		 * 将一个回调函数和以signalName为别名的信号取消关联
		 * */
		public static function unhook(signalName:String,callBack:Function):void
		{
			var callGroup:Vector.<Function>=callBacks[signalName];
			if(callGroup==null) return;
			var i:int=callGroup.indexOf(callBack);
			if(i<0) return;
			callGroup.splice(i,1);
			
			var group:Vector.<Signal>=signals[signalName] as Vector.<Signal>;
			if(group){
				for each(var signal:Signal in group){
					signal.remove(callBack);
//					Logger.info("SignalBus","unhook","unhooked: "+signalName);
				}
			}	
		}
	}
}