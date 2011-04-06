package com.longame.modules.scenes
{
	import com.longame.display.Camera;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

    /**
	 * 场景接口，场景建立需要scene.setup(...);，然后用camera控制场景
	 * */
	public interface IScene extends IDisplayGroup
	{
		/**
		 * 创建场景，只有执行这个之后，场景才正式运转
		 * @param view: 场景容器，
		 * @param lensRect:虚拟镜头的矩形范围，以舞台剧全局坐标为基点
		 * 之后通过scene.camera来控制场景的移动缩放等
		 * */
		function setup(view:DisplayObjectContainer,lensRect:Rectangle):void
		/**
		 * 场景类型
		 * */
		function get type():String;
		/**
		 * 方格大小
		 * */
		function get tileSize():uint
		/**
		 * 虚拟镜头用于场景的缩放，聚焦，跟随，旋转甚至一些颜色滤镜效果
		 * */
		function get camera():Camera;
		/**
		 * 是否显示坐标系原点
		 * */
		function setOriginVisible(value:Boolean):void;
		/**
		 * 在physicsEnabled为true的情况下，获取Box2DWorld
		 * */
//		function get box2dWorld():Box2DWorld;
	}
}