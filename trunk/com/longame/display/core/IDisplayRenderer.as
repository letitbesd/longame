package com.longame.display.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.longame.core.IMouseObject;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.scenes.IScene;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.core.bounds.IBounds;
	import com.longame.modules.core.bounds.TileBounds;
	
	import org.osflash.signals.Signal;

    /**
	 * 定义一个具有图形渲染的接口
	 * */
	public interface IDisplayRenderer extends ITransformable
	{
		/**
		 * 渲染的容器，一般不要直接改变其属性，而是在render函数中统一改变，不要采用container.addChild之类的方法 
		 * */
		function get container():Sprite;
		/**
		 * 将所有的改变一次渲染,在父亲中调用
		 * */
		function render():void;
        /**
		 * 在父容器中的层级
		 * */
		function get depth():int;
		/**
		 * 碰撞宽度
		 * */
		function get width():Number;
		function set width(value:Number):void;
		/**
		 * 碰撞宽度
		 * */
		function get length():Number;
		function set length(value:Number):void;
		/**
		 * 碰撞高度，2.5D适用
		 * */
		function get height():Number;
		function set height(value:Number):void;
		/**
		 * 注册点类型，有Registration.CENTER和Registration.TOP_LEFT两种
		 * */
		function get registration():String;
		function set registration(value:String):void;
	}
}