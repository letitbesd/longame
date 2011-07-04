package com.xingcloud.socialize.mode
{
	public class UserInfo implements IUserInfo
	{
		private var _userId:String;
		private var _gender:String;
		private var _headerImgUrl:String;
		private var _userName:String;
		
		public function UserInfo(userId:String,gender:String,headerImgUrl:String,userName:String)
		{
			_userId=userId;
			_gender=gender;
			_headerImgUrl=headerImgUrl;
			_userName=userName;
		}
		
		public  function get userId():String{
			return this._userId;
		}
		
		public function get userName():String{
			return this._userName;
		}
		
		public function get headerImgUrl():String{
			return this._headerImgUrl;
		}
		
		public function get gender():String{
			return this._gender;
		}
		
		
	}
}