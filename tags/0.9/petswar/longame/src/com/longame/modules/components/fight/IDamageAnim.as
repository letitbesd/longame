package com.longame.modules.components.fight
{
	import com.longame.modules.core.IComponent;
	/**
	 * 用于显示伤害量的动画
	 * */
	public interface IDamageAnim extends IComponent
	{
		function showDamage(value:int):void;
	}
}