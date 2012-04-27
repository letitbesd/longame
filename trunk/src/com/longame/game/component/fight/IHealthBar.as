package com.longame.game.component.fight
{
	import com.longame.game.core.IComponent;
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