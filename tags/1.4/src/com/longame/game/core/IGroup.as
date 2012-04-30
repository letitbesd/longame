package com.longame.game.core
{
	import com.longame.core.IAnimatedObject;
	import com.longame.core.IDisposable;

	/**
	 * Entity的集合，可以添加很多的entity形成一个集合，像场景这种特殊的IGroup，
	 * 还可以添加很多的IGroupManager，如LayoutManager/CollisionManager...
	 * */
	public interface IGroup extends IEntity
	{
		/**
		 * 激活的字元素个数
		 * */
		function get numChildren():uint;
	}
}