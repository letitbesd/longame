package com.xingcloud.socialize.mode
{
	public class FeedObject
	{
		
		public var title:Array;//在falsh.xml中定义的<title>ddd {0}会被title[0]替换 ,fdsad fsda  {1}会被title[1]替换</title>；
		public var body:Array;//同上理论；
		public var img:Array;//同上理论；
		
		//扩展支持让title_link和img_link也支持模板定义替换，(目前还没实现)
		public var title_link:Array;//同上理论；
		public var img_link:Array;//同上理论；
		
		/**
		 * 可以定义是发给谁的
		 * feed 只能是自己.消息可以指定
		 */
		public var uid:String
		
		/**
		 * @param _title 在falsh.xml中定义的<title>ddd {0}会被title[0]替换 ,fdsad fsda  {1}会被title[1]替换</title>；
		 * @param _body 同上理论；
		 * @param _uid 同上理论;
		 * @param _img 同上理论；
		 * @param _title_link 同上理论；
		 * @param _img_link 同上理论；
		 */
		public function FeedObject(_title:Array,_body:Array,_uid:String="",_img:Array=null,_title_link:Array=null,_img_link:Array=null)
		{
			title =_title;
			body = _body;
			uid = _uid;
			img = _img;
			title_link=_title_link;
			img_link=_img_link;
		}
		
	}
}