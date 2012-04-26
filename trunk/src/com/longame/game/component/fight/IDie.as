package com.longame.game.component.fight
{
	import com.longame.game.core.IComponent;
	/**
	 * 死亡组件，实体会消失，目前不需要实现任何接口，仅仅是个标志而已，用法
	 * var die:IDie=new DieComp();
	 * entity.add(die,"dieState");
	 * 那么一旦HealthComp检测到生命值完结，自动entity.state="dieState";实体便会消失，在die里面可以实现死亡的动画
	 * */
	public interface IDie extends IComponent
	{
//		function die():void;
	}
}