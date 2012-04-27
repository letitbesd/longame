package com.longame.game.entity
{
	import com.longame.game.component.fight.HealthComp;
	import com.longame.game.core.IEntity;
	
	import org.osflash.signals.Signal;

    /**
	 * 一个有生命的个体
	 * */
	public interface IHealthEntity extends IEntity
	{
		/**
		 * 获取生命值管理组件
		 * */
		function get health():HealthComp;
		/**
		 * 受到伤害时发出,回调模板：
		 * function callBack(hurtedEntity:IHealthEntity,changed:Number,originatorEntity:AbstractEntity):void;
		 * 分别是：受伤的主体，受伤害多少，发起伤害的主体
		 * */
		function get onHurted():Signal;
		/**
		 * 受到治疗时发出,回调模板：
		 * function callBack(healedEntity:IHealthEntity,changed:Number,originatorEntity:AbstractEntity):void;
		 * 分别是：受治疗的主体，受治疗多少，发起治疗的主体
		 * */
		function get onHealed():Signal;
		/**
		 * 死亡时发出,回调模板：
		 * function callBack(diedEntity:IHealthEntity,changed:Number,originatorEntity:AbstractEntity):void;
		 * 分别是：死亡主体，受伤害多少，致其死亡的主体
		 * */
		function get onDied():Signal;
		/**
		 * 复活时发出,回调模板：
		 * function callBack(entity:IHealthEntity,changed:Number,originatorEntity:AbstractEntity):void;
		 * 分别是：复活的主体，受治疗多少，发起治疗的主体
		 * */
		function get onResurrected():Signal;
	}
}