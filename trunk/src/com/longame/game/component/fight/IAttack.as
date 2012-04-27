package com.longame.game.component.fight
{
	import com.longame.game.core.IComponent;
	import com.longame.game.entity.Character;

	/**
	 * 定义一个攻击组件，攻击组件里应该定义一个攻击的数值模型
	 * */
	public interface IAttack extends IComponent
	{
		/**
		 * 执行攻击，攻击完毕会使对象的IHit组件被激活，并调用IHit.hit(damage,animation);
		 * @param target: 攻击的对象
		 * @param damge: 给对方造成的损伤
		 * @param type:攻击类型，可以根据类型来播放行为动画
		 * */
		function attack(target:Character,damage:Number,type:String=null):void;
	}
}