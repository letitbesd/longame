package com.longame.display.core
{
	import flash.geom.Vector3D;

	/**
	 * 定义一个具有动画和方向以及外部渲染源的显示对象，通常用于场景元素，尤其是人物
	 * */
	public interface IAnimatorRenderer extends IDisplayRenderer
	{
		/**
		 * 定义这个对象的显示源，详细见GameDisplay的source定义
		 * */
		function get source():String;
		function set source(value:String):void;
		/**
		 * 显示对象的direction，方向
		 * */
		function get direction():int;
		function set direction(value:int):void;
		/**
		 * 显示对象的动画
		 * */
		function get animation():String;
		function set animation(value:String):void;
	}
}