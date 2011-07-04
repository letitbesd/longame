package com.longame.modules.components.fight
{
	import com.longame.modules.core.IComponent;
	/**
	 * 用于显示治疗量的动画
	 * */
	public interface IHealAnim extends IComponent
	{
		function showHeal(value:int):void;
	}
}