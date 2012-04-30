package com.longame.game.group
{
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.EntityItemSpec;
	import com.longame.game.core.IGroup;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.SpriteEntity;
	import com.longame.game.group.component.TileMap;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public interface IDisplayGroup extends IDisplayEntity, IGroup
	{
		/**
		 * 把child添加到index层级
		 * */
		function addAt(child:IDisplayEntity, state:String = "",index:uint=uint.MAX_VALUE):void;
		/**
		 *把index层的对象删除
		 * */
		function removeAt(index:uint):IDisplayEntity;
		/**
		 * 显示网格
		 * @param width:显示多宽，网格单位
		 * @param height:显示多高，网格单位
		 * 不指定则显示实际边界内的网格
		 * */
		function showGrid(width:uint=0,height:uint=0):void;
		/**
		 * 隐藏网络
		 * */
		function hideGrid():void;
		/**
		 * 子显示对象在方格体系里的位置分布图
		 * */
		function get map():TileMap;
		/**
		 * 是否用GroupLayouter自动深度排序，默认为false,有角色移动的图层应该设为true，但像很多2d游戏或2.5D游戏中全是没有高度的方格物品，设为false更节省资源
		 * */
		function get autoLayout():Boolean;
		function set autoLayout(value:Boolean):void;
		/**
		 * 返回所有的IDisplayRenderer显示元素，如果需要对每个元素进行操作，请优先选用foreachDisplays处理，节省一半运算量
		 * @param activedOnly:是否只返回actived=true的子元素
		 * @param basicEntity:是否返回最基本的IDisplayEntity，如果是IDisplayGroup，会一直寻找下去，直到子元素是个IDisplayEntity
		 * */
		function getDisplays(activedOnly:Boolean=true,basicEntity:Boolean=false):Vector.<IDisplayEntity>;
		/**
		 * 返回所有类型为IDisplayGroup的子元素
		 * */
		function get groupChildren():Vector.<IDisplayGroup>;
		/**
		 * 显示元素的数量
		 * */
		function get numDisplay():int;
		/**
		 * 遍历所有的显示个体，用callBack(child:IdisplayEntity):void来回调，这样的好处是，节省一倍的运算量
		 * */
		function foreachDisplay(callBack:Function,activedOnly:Boolean=true,basicEntity:Boolean=false):void
		/**
		 * 设定子元素的层级，返回最后确认后的层级,如果是小于等于0的数字，会把它放到最低层，如果是个超出子元素长度的数字，会把它放到顶层
		 * 只针对actived元素
		 * */
		function setChildIndex(child:IDisplayEntity,index:int):int;
		/**
		 * 获取子元素层级，只针对actived字元素
		 * */
		function getChildIndex(child:IDisplayEntity):int;
	    /**
		 * 获取指定层级的子元素，只针对actived子元素
		 * */
		function getChildAt(index:int):IDisplayEntity;
		/**
		 * 添加一个图层，图层不参与layout，按添加先后来决定层次
		 * @param id: 图层的id
		 * @param index: 添加的层级
		 * @param state:图层在state状态下有效，见IDisplayEntity.add
		 * */
		function addLayer(id:String=null,index:int=int.MAX_VALUE,state:String=""):DisplayGroup;
		/**
		 * 添加一个简单图层，这个图层用SpriteEntity来渲染，可能只是EntityItemSpec定义的一张图片或一个显示对象，图层不参与layout，按添加先后来决定层次
		 * @param itemIdOrSource: 物品id或一个显示源（图片，MovieClip,swf的地址或显示元件的class名。。。）
		 * @param index: 添加的层级
		 * @param id: 图层的id
		 * @param state:图层在state状态下有效，见IDisplayEntity.add
		 * */
		function addSimpleLayer(itemIdOrSource:*,id:String=null,index:int=int.MAX_VALUE,state:String=""):SpriteEntity;
		/**
		 * 用itemSpec定义的SpriteEntity填充空白区域，这个空白区域起始方格为x,y，和x,y相连接的所有空白方格都会被填充
		 * */
		function fillBlankArea(x:int,y:int,itemSpec:EntityItemSpec):void;
	}
}