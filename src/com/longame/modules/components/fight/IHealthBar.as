package com.longame.modules.components.fight
{
	import com.longame.modules.core.IComponent;
	/**
	 * 血条
	 * */
	public interface IHealthBar extends IComponent
	{
		/**
		 * 更新血条
		 * */
		function updateHP(current:Number,total:Number):void;
	}
}