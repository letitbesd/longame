package com.xingcloud.users.actions
{
	/**
	 * action是玩家在游戏中进行的某个行为，如农场中浇花，收获，卖东西等等，
	 * 目前action仅仅是个模型，确保前后台对行为的判别一致，并传递后台所需参数
	 * */
	public interface IAction
	{
		/**
		 * 以{itemId:"123",count:4}形式传给后台的参数
		 * */
		function get params():Object;
		/**
		 * 前后台依靠name确保执行action的一致性
		 * */
		function get name():String;
		/**
		 * 每个特定的action在执行前都需要验证是否合法
		 * */
		function validate():Boolean;
		/**
		 *执行 
		 * 
		 */		
		function execute():void;
	}
}