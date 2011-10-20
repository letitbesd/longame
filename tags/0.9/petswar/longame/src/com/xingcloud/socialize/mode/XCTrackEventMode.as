package com.xingcloud.socialize.mode
{
	public class XCTrackEventMode
	{
		public var method:String;
		public var data:Array;
		public var gameuid:String;
		//fun:String,data:Array,gameuid:String
		public function XCTrackEventMode(_method:String,_data:Array,_gameuid:String)
		{
			method=_method;
			data=_data;
			gameuid=_gameuid;
		}
	}
}