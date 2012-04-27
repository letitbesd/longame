package com.longame.game.scene
{
	import com.longame.core.IAnimatedObject;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.IParallax;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

    /**
	 * 场景
	 * */
	public interface IScene extends IDisplayGroup, IAnimatedObject
	{
		/**
		 * 其视差不等于1的所有直接添加到场景中的对象，用于Camera移动时错位移动，形成远近纵深感
		 * */
		function get parallaxChildren():Vector.<IDisplayEntity>;
		function get camera():Camera;
	}
}