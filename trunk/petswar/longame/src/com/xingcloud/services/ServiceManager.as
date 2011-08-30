package com.xingcloud.services
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.utils.Debug;
	import com.longame.commands.base.Command;
	import com.longame.commands.base.SerialCommand;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloudEvent;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.ItemsParser;
	import com.xingcloud.language.LanguageManager;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	use namespace xingcloud_internal;
	
	public class ServiceManager extends SerialCommand
	{
		private static var _instance:ServiceManager;
		/**
		 * 服务管理器，用于添加和加载服务
		 * 不可直接在外部被实例化 
		 */		
		public function ServiceManager(lock:lock)
		{
			super();
		}
		/**
		 * 获取服务管理器实例
		 * @return 服务管理器实例
		 * 
		 */		
		public static function get instance():ServiceManager
		{
			if(_instance==null)
			{
				_instance=new ServiceManager(new lock);
				
			}
			return _instance;
		}
		/**
		 *增加一个服务到加载队列 
		 * @param s 服务
		 * 
		 */		
		public function addService(s:Service):void
		{
			enqueue(s.executor);
		}
		/**
		 *开始加载服务 
		 * 
		 */		
		public function start():void
		{
			this.execute();
		}
		override public function onCommandComplete(cmd:Command):void
		{
			super.onCommandComplete(cmd);
		}
		override protected function notifyError(errorMsg:String):void
		{
			super.notifyError(errorMsg);
		}
		override protected function complete():void
		{
			super.complete();
		}
		
	}
}
internal class lock
{
	
}