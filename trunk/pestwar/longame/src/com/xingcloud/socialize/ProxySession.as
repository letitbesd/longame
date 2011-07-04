package com.xingcloud.socialize
{
	import com.xingcloud.socialize.utils.Console;
	
	public class ProxySession
	{
		public var connectId:String;
		public var userId:String;
		public function ProxySession(_connectId:String,_userId:String)
		{
			connectId=_connectId;
			userId=_userId;
			Console.print("connectId"+connectId);
			Console.print("userId"+userId);
		}
	
	}
}