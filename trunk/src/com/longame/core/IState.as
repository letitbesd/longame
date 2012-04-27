package com.longame.core
{
	public interface IState
	{
		/**
		 * 实体当前的状态，这个状态决定了其所有子元素是否被激活，只有add时的state设为当前状态的才会被激活，否则会被取消激活
		 * */
		function getState():String;
		/**
		 * 获取上一个状态
		 * */
		function getPrevState():String;
		/**
		 * 设定实体当前的状态
		 * @param state:状态名
		 * @param param:跟此状态相关的参数，可以用于此状态下某些属性的设定
		 *              param会通过child.active(entity,param)然后通过child.doWhenActive(param)传递
		 * 注意：子component在某些情况下会有改变entity的state的逻辑，这个逻辑最好不要在子component的whenActive或whenDeactive中做，要做就要调callLater
		 * */
		function setState(state:String,param:*=null):void;
		/**
		 * 当前状态参数
		 * */
		function get stateParam():*;
	}
}