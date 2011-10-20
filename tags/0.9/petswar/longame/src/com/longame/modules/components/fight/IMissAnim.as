package com.longame.modules.components.fight
{
	import com.longame.modules.core.IComponent;
	/**
	 * 被攻击时miss时的动画组件，当HealthComp.damage0,...)时，会自动激活这个组件
	 * */
	public interface IMissAnim extends IComponent
	{
		function showMiss():void;
	}
}