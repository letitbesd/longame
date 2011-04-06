package com.longame.managers
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import com.longame.utils.debug.Logger;
	
	
	/**
	 * 在ELEX里面总共有三种资源
	 * 1，database.xml 属于频繁需要改动的资源，这个资源的路径的ConfigManager的配置参数为 “database”
	 * 2，动态资源（各种美术资源） 属于不需要频繁改动的资源，这些资源的路径的配置参数为 “host”
	 * 3，服务接口 属于后台的具体服务调用地址，这些资源的路径的配置参数为 “web_base”
	 */	
	public class ConfigManager
	{
		private static var local:Dictionary = new Dictionary();
		private static var _stage:Stage;
		public static function init(s:Stage):void
		{
			_stage=s;
		}
		
		public static function getConfig(name:String):*
		{
			var str:*;
			if (_stage){
				str = _stage.loaderInfo.parameters[name];
			}
//			else if(r.parent)
//			{
//				str = r.parent.loaderInfo.parameters[name];
//			}
			else{
				Logger.warn("ConfigManager","getConfig","The App has no stage yet!");
			}
			
			/*
			else
			{
			throw(new Error("肯定存在问题！，要不然是main.swf " + 
			"没有放置到stage上就开始 调用parent的loaderInfo，建议延迟这个方法的调用"));
			}
			*/
			
			if(str)
			{
				return str;
			}
			var s:* = ConfigManager.local[name];
			if(s is Function)
			{
				return s();
			}else if(s || s == "" || s == 0)
			{
				return s;
			}else
			{
				//throw(new Error("不存在这个配置文件"));
				return null;
			}
		}
		
		
		public static function setConfig(name:String,value:*):void
		{
			ConfigManager.local[name] = value;
		}
		/**
		 * 将xml形式的配置信息记录进来
		 * <config>
		 *    <config1>value1</config1>
		 *    <config2>value2</config2>
		 * </config>
		 * */
		public static function parseFromXML(xmlConfig:XML):void
		{
			for each(var conf:XML in xmlConfig.children()){
				setConfig(conf.localName(),conf.toString());
			}
		}
		
		
	}
}