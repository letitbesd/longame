package com.xingcloud.socialize.mode
{
	public class GTrackEventMode
	{
		public var category:String;
		public var action:String;
		public var optional_label:String;
		public var optional_value:int;
		
		public function GTrackEventMode(_category:String,_action:String,_optional_label:String,_optional_value:int=0)
		{
			category=_category;
			action=_action;
			optional_label=_optional_label;
			optional_value=_optional_value;
		}
	}
}