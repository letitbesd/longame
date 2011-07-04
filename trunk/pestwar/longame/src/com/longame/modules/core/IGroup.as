package com.longame.modules.core
{
	import com.longame.core.IAnimatedObject;
	import com.longame.core.IDestroyable;
	import com.longame.modules.groups.organizers.IGroupOrganizer;

	/**
	 * Entity的集合，可以添加很多的entity形成一个集合，像场景这种特殊的IGroup，
	 * 还可以添加很多的IGroupManager，如LayoutManager/CollisionManager...
	 * */
	public interface IGroup extends IEntity, IAnimatedObject
	{
		/**
		 * 激活的字元素个数
		 * */
		function get numChildren():uint;
		/**
		 * 添加organizer，organizer是管理集群的工具插件
		 * */
		function addOrganizer(mgr:IGroupOrganizer):void;
		function removeOrganizer(mgr:IGroupOrganizer):void;
		function get organizers():Vector.<IGroupOrganizer>;
		/**
		 * 根据特定条件，更新各个organizer的active状态
		 * */
//		function updateOrganizers():void;
	}
}