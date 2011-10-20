package com.longame.modules.entities
{
	import com.longame.modules.components.PathComp;

	/**
	 * 移动实体
	 * */
	public interface IMovableEntity extends IDisplayEntity
	{
		function get path():PathComp;
		/**
		 * 运动速度
		 * */
		function get speed():Number;
		function set speed(value:Number):void;
		
		/**
		 * 速度加成
		 * */
		function get speedScale():Number;
		function set speedScale(value:Number):void;
	}
}