package com.longame.game.component.fight
{
	import com.longame.game.core.IComponent;
	/**
	 * 用于显示伤害数字或治疗数字的动画
	 * */
	public interface IHealthAnim extends IComponent
	{
		function showAnim(value:int):void;
	}
}