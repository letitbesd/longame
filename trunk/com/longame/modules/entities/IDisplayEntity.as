package com.longame.modules.entities
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.longame.core.IMouseObject;
	import com.longame.display.core.IAnimatorRenderer;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.bounds.IBounds;
	import com.longame.modules.core.bounds.TileBounds;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.IScene;
	
	import org.osflash.signals.Signal;
	/**
	 * 显示对象，其鼠标是禁止了的，如果启用，请用mouseEnabled=true
	 * */
	public interface IDisplayEntity extends IEntity, IDisplayRenderer, IMouseObject
	{
		/**
		 * 此对象的可视化容器
		 * */
		function get parent():IDisplayGroup;
		/**
		 * 此对象加入的场景
		 * */
		function get scene():IScene;
		/**
		 * 属性是否发生了变化
		 * */
		function get invalidated():Boolean;
		/**
		 * 全局的屏幕坐标转换到本地的场景坐标，如果tiled为true，则计算p点所代表IScene上的tile坐标在this上的位置
		 * @param p:目标点
		 * @param tiled:是否以方格为单位，默认是像素单位，如果是方格单位，p.z是没有意义的，只计算x,y平面内的tile坐标
		 * */
		function globalToLocal(p:Point,tiled:Boolean=false):Vector3D;
		/**
		 * 本地场景坐标转换到全局屏幕坐标，如果是tiled为true，则计算p点所代表的tile坐标在IScene上的位置
		 * @param p:目标点
		 * @param tiled:是否以方格为单位，默认是像素单位，如果是方格单位，p.z是没有意义的，只计算x,y平面内的tile坐标
		 * */
		function localToGlobal(p:Vector3D,tiled:Boolean=false):Point;
		/**
		 * 是否会被父容器进行深度排序，默认为true，如果是false，比如GameScene的层就需要false，不参与深度排序
		 * 再如地板层，大量的单方格物品堆积的时候，是不需要排序的，节省资源。
		 * */
		function get includeInLayout():Boolean;
		function set includeInLayout(value:Boolean):void;
		/**
		 * 可否行走
		 * */
		function get walkable():Boolean;
		function set walkable(value:Boolean):void;
		/**
		 * 在场景中的边界，不一定和实际图形一致，尤其在2.5D场景中，如果不定义，将获取其图形的实际边界
		 * */
		function get bounds():IBounds;
		/**
		 * 以单元格为单位计算的对象边界
		 * */
		function get tileBounds():TileBounds
		/**
		 * 获取对象注册点对应的那个tile
		 * */
		function get tile():EntityTile;
		/**
		 * 以目前物体的坐标为基准，将物体吸附最近的单元格
		 * */
		function autoSnap():void;
		/**
		 * 将物体吸附到指定单元格
		 * */
		function snapToTile(tx:int,ty:int):void
		/**
		 * 当显示对象被移动时分发,侦听函数模板：
		 * function callBack(entity:IDisplayEntity):void;
		 * */
		function get onMove():Signal;
		/**
		 * 当对象的注册点所处方格发生变化（可能是自身移动，也可能是父级移动）,侦听函数模板：
		 * function callBack(entity:IDisplayEntity,tileDelta:Point):void;
		 * tileDelta.x是x方向上移动了几个格子,tileDelta.y是在y方向上移动了几个格子
		 * */
		function get onTileMove():Signal;
		/**
		 * 当显示对象的实际大小被改变时分发,侦听函数模板：
		 * function callBack(entity:IDisplayEntity):void;
		 * */
		function get onScale():Signal;
		/**
		 * 当显示对象被旋转时分发,侦听函数模板：
		 * function callBack(entity:IDisplayEntity):void;
		 * */
		function get onRotate():Signal;
		/**
		 * 当显示对象的碰撞尺寸发生了变化,侦听函数模板：
		 * function callBack(entity:IDisplayEntity):void;
		 * */
		function get onResize():Signal
		/**
		 * 当对象tileBounds范围发生变化,move和resize均会引发这个事件，侦听函数模板：
		 * function callBack(entity:IDisplayEntity,newTiles:Vector.<Point>,oldTiles:Vector.<Point>):void;
		 * */
		function get onTileBoundsChange():Signal;
		/**
		 * 当includeInLayout状态发生变化
		 * function callBack(entity:IDisplayEntity):void;
		 * */
		function get onLayoutStateChange():Signal;
		/**
		 * 当层级发生变化
		 * function callBack(target:IDisplayEntity,oldIndex:int,newIndex:int)
		 * */
		function get onDepthChanged():Signal;
	}
}