package com.longame.utils
{
	public class UrlUtil
	{
		/**
		 * 获取url的文件后缀，小写
		 * */
       public static function getExtension(url:String):String
	   {
		   if(url==null) return null;
		   //先去掉？的参数值
		   var i:int=url.indexOf("?");
		   if(i>-1) url=url.slice(0,i);
		   i=url.lastIndexOf(".");
		   if(i<0) return null;
		   return url.slice(i+1,url.length).toLowerCase();
	   }
	   /**
	   * 获取url地址上的key value参数
	   * */
	   public static function getParams(url:String):Object
	   {
		   if(url==null) return null;
		   var i:int=url.indexOf("?");
		   if(i<0) return null;
		   var paramStr:String=url.slice(i+1,url.length);
		   if(paramStr.length==0) return null;
		   var keyValues:Array=paramStr.split("&");
		   var param:Object={}
		   for each(var keyValue:String in keyValues){
			   var arr:Array=keyValue.split("=");
			   param[arr[0] as String]=arr[1];
		   }
		   return param;
	   }
	}
}