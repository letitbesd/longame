package com.longame.modules.components.fight
{
	import com.longame.modules.core.IComponent;
	import com.longame.modules.entities.Character;
	
	/**
	 * 定义一个被攻击的组件
	 * */
	public interface IHit extends IComponent
	{
		/**
		 * 被攻击
		 * @param damge: 收到的损伤，自动调用HealthComp.damage(...)，HealthCom里会自动播放损伤数字动画和更新血条，如果有的话
		 * @param type:受攻击的类型，可以根据类型来播放行为动画
		 * @param originator:攻击者
		 * */
		function hit(damage:int,type:String=null,originator:Character=null):void;
	}
}