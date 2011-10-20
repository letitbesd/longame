package com.longame.display.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 定义一个所有显示对象需要的接口，这些属性都是跟Matrix有关的
	 * */
	public interface ITransformable
	{
		/**
		 * x坐标
		 * */
		function set x(value:Number):void;
		function get x():Number;
		/**
		 * y坐标
		 * */
		function set y(value:Number):void;
		function get y():Number;
		/**
		 * z坐标，2.5d或3d场合才会用
		 * */
		function set z(value:Number):void;
		function get z():Number;
		/**
		 * 其坐标在x方向上的偏移
		 * */
		function get offsetX():Number;
		function set offsetX(value:Number):void;
		/**
		 * 其坐标在y方向上的偏移
		 * */
		function get offsetY():Number;
		function set offsetY(value:Number):void;
		/**
		 * 旋转角度
		 * */
		function set rotation(degree:Number):void;
		function get rotation():Number;
		/**
		 * x方向上的缩放
		 * */
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		/**
		 *y方向上的缩放
		 * */	
		function set scaleY(value:Number):void;
		function get scaleY():Number;
	}
}