package com.longame.modules.groups.organizers
{
	import com.longame.core.IDestroyable;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.groups.IDisplayGroup;

	/**
	 * 可以添加进IGroup的管理模块,比如场景深度排序，碰撞检测，寻路
	 * */
	public interface IGroupOrganizer extends IDestroyable
	{
		function get group():IDisplayGroup;
		
		/**
		 * 当此org被激活时调用
		 * */
		function active(owner:IDisplayGroup):void;
		/**
		 * 当此org被禁止时调用
		 * */
		function deactive():void;

		/**
		 * 是否处于激活状态
		 */
		function get actived():Boolean;
		
		function update():void;
	}
}