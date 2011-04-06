package com.longame.commands.net
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class GameconstLoader extends XmlLoader
	{
		/**
		 * @spreedsheetUrl google spreadSheet的url："http://spreadsheets.google.com/feeds/cells/0AhE91z3arqEDdHdQaF8tbmZGcGx5dXRob0RleXNVcVE/od6/public/basic"
		 *                 产生方法如下:
		 * 		           1、建立一个google的Excle文档。
		 *                 2、选择共享-》发布为网页
		 *                 3、点击“获取已发布数据的链接”下的下拉框，选择ATOM。选中单元格。
		 *                 然后将下面的链接复制过来，赋给spreadSheedurl。
		 * @proxyUrl 这里的值是你的php代理的url,如："http://yoururl.com/GET_GoogleSpreadsheetProxy.php"
		 * */
		public function GameconstLoader(spreadsheetUrl:String,proxyUrl:String)
		{
			var ur:URLRequest = new URLRequest(proxyUrl);
			ur.method = URLRequestMethod.POST;
			ur.data = new URLVariables();
			ur.data["url"] = spreadsheetUrl;
			super(ur);
		}
	}
}