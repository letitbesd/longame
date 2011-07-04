package com.xingcloud.socialize
{
	import com.xingcloud.socialize.mode.RequestResponder;
	

	 public  class  AbstractElexRequest implements IElexRequest
	{
		protected var _method:String;
		protected var _params:*;
		protected var _resultListener:Function;
		protected var _failListener:Function;
		
		
		public function get method():String
		{
			return _method;
		}
		
		public function get params():*
		{
			return _params;
		}
		
		public function get resultListener():Function
		{
			return _resultListener;
		}
		
		public function get failListener():Function
		{
			return _failListener;
		}
		
	}
}