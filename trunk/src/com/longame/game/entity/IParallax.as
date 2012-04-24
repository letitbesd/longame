package com.longame.game.entity
{
	import flash.display.Sprite;

	/**
	 * 在镜头移动时会产生视差的对象
	 * */
	public interface IParallax
	{
		/**
		 * 注意：此属性只有对象被直接添加到IScene中才会起作用
		 * 镜头移动时的视差，允许范围0~10,当镜头移动10像素时，此对象实际移动的距离为10*parallax
		 * parallax越大表示在镜头前移动越快，比如前景
		 * parallax越小表示在镜头前移动越慢，比如后景
		 * parallax=1的特殊情况下，完全跟随镜头的速度进行移动
		 * 默认parallax=1
		 * */
		function get parallax():Number;
		function set parallax(value:Number):void;
	}
}