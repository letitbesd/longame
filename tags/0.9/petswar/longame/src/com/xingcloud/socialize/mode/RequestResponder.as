package com.xingcloud.socialize.mode
{
	import com.xingcloud.socialize.MethodEnum;
	import com.xingcloud.socialize.utils.Console;

	public class RequestResponder
	{
		public var message:String;
		public var data:*;
		public var method:String;
		public var code:String;
		public static var ERRORCODE:String="500";
		public static var SUCCESSRCODE:String="200";
		public function RequestResponder(_method:String,_message:String,_data:*,_code:String)
		{
			method=_method
			message=_message;
			if(data)
				data=proxyDataStructe(_data);
			code=_code;
		}
		/**
		 * 
		 * @param data method==MethodEnum.GET_ACTIVE_USER_PROFILE_REQUEST is ElexUser
		 * method==MethodEnum.GET_ACTIVE_USER_PROFILE_REQUEST||method==MethodEnum.GET_ALL_FRIENDS_PROFILES_REQUEST ||method==MethodEnum.GET_APP_FRIENDS_PROFILES_REQUEST||method==MethodEnum.GET_USERS_PROFILES_REQUEST
		 * is array(ElexUser);
		 * @return 
		 * 
		 */		
		private function proxyDataStructe(data:*):*{
			if(method==MethodEnum.GET_ACTIVE_USER_PROFILE_REQUEST){
				return new UserInfo(data.userId,data.gender,data.headerImgUrl,data.userName);
			}
			
			if(method==MethodEnum.GET_ALL_FRIENDS_PROFILES_REQUEST ||method==MethodEnum.GET_APP_FRIENDS_PROFILES_REQUEST||method==MethodEnum.GET_USERS_PROFILES_REQUEST){
//				Console.print("method"+method);
//				Console.print("------changing-----start");
				var users:Array=new Array();
				var snsUses:Array=(data as Array);
				for(var i:int=0;i<snsUses.length;i++){
					users.push(new UserInfo(snsUses[i].userId,snsUses[i].gender,snsUses[i].headerImgUrl,snsUses[i].userName));
				}
//				Console.print("------changing-----over");
				return users;
				
			}
			
			return {};
		}

		
	}
}