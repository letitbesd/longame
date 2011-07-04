package com.xingcloud.users.actions
{
	/**
	 * 后台返回结果
	 * */
	public class ActionResult
	{
		/**
		 *action成功的code
		 * */
		public static const SUCCESS_CODE:uint=200;
		/**
		 *action失败，错误来源于客服端
		 * */
		public static const CLIENT_ERROR_CODE:uint=400;
		/**
		 *action失败，错误来源于服务器端
		 * */
		public static const  SERVER_ERROR_CODE:uint=500;
		/**
		*action在后台执行的状态代码，辨别错误
		*/
		public var  code:uint;
		/**
		*action在后台执行返回的消息
		*/
		public var  message:String;
		/**
		*执行一个action后可能会返回的数据（Object）
		*/
		public var  data:Object;
		
		public function ActionResult(code:uint=200,message:String="",data:Object=null){
			this.code=code;
			this.message=message;
			this.data=data;
		}
		public static function parseFromObj(data:Object):ActionResult
		{
			var result:ActionResult=new ActionResult();
			result.code=parseInt(data["code"]);
			result.message=data["message"];
			result.data=data["data"];
			return result;
		}
		public function get success():Boolean
		{
			return code==ActionResult.SUCCESS_CODE;
		}
	}
}