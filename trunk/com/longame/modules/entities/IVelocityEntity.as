package com.longame.modules.entities
{
	import com.longame.modules.components.VelocityComp;

	/**
	 * 具有速度控制的实体
	 * */
	public interface IVelocityEntity extends IDisplayEntity
	{
		/**
		 * 速度控制组件
		 * */
		function get velocity():VelocityComp;
	}
}