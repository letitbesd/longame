package com.longame.core
{
	public interface IState
	{
		/**
		 * 实体当前的状态，这个状态决定了其所有子元素是否被激活，只有add时的state设为当前状态的才会被激活，否则会被取消激活
		 * */
		function get state():String;
		
		function set state(value:String):void;
	}
}