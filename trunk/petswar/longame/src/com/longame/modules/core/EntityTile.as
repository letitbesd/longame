package com.longame.modules.core
{
	import be.dauntless.astar.BasicTile;
	
	import com.longame.core.IDestroyable;
	import com.longame.core.long_internal;
	import com.longame.model.Direction;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.groups.organizers.TileMap;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	use namespace long_internal;
	
	/**
	 * 场景的一个单元格，除了寻路，也是优化场景管理的一个很好的方法
	 * */
	public class EntityTile extends BasicTile implements IDestroyable
	{
		/**这个tile上面的场景元素，IsoDisplayObject**/
		protected var _children:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		protected var _childrenCount:int;
		protected var _owner:TileMap;
		private var _position:Point;
		
		public function EntityTile(owner:TileMap,x:int, y:int)
		{
			super(1,x,y,false);
			_owner=owner;
			_walkable=true;
			_position=SceneManager.getTilePosition(this.x,this.y);
		}
		/**
		 * 是哪个displayMap下的tile
		 * */
		public function get owner():TileMap
		{
			return _owner;
		}
		/**
		 * 获取方格中心点在整个场景中的实际坐标
		 * */
		public function get position():Point
		{
			return _position;
		}
		/**
		 * 获取此tile指定方向上的邻居
		 * @param: direction,见Direction的8个方向
		 * */
		public function getNeighbor(direction:int):EntityTile
		{
			if(_owner==null) return null;
			return _owner.getNeighbour(_x,_y,direction);
		}
		/**
		 * 获取此tile所有方向上的邻居
		 * @param: diogonal 是否获取对角方向上的邻居
		 * */
		public function getNeighbours(diogonal:Boolean=true):Vector.<EntityTile>
		{
			if(_owner==null) return null;
			var ns:Vector.<EntityTile>=new Vector.<EntityTile>();
			var max:int=diogonal?Direction.maxDirection:4;
			for(var i:int=0;i<max;i++){
				var tile:EntityTile=this.getNeighbor(i);
				if(tile==null) continue;
				ns.push(tile);				
			}
			return ns;
		}
		public function get destroyed():Boolean
		{
			return _owner==null;
		}
		/**
		 * 将此单元格销毁，让单元格内物品全从场景消失
		 * */
		public function destroy():void
		{
			_children=null;
			_owner=null;
			_childrenCount=0;
		}
		/**
		 * 消除所有显示元素
		 * */
		public function clearChildren(excludedType:Class=null):void
		{
			for each(var ch:IDisplayEntity in _children){
				if(excludedType&&(ch is excludedType)) continue;
				ch.destroy();
			}
		}
		public function get children():Vector.<IDisplayEntity>
		{
			return _children;
		}
		public function get numChildren():int
		{
			return _childrenCount;
		}
		public function addChild(obj:IDisplayEntity):void
		{
			if(_children.indexOf(obj)>-1) return;
			_children[_childrenCount]=obj;
			_childrenCount++;
			if( !obj.walkable)
			{
				this._walkable=false;
			}
		}
		public function removeChild(obj:IDisplayEntity):void
		{
			var i:int=_children.indexOf(obj);
			if(i==-1) return;
			_children.splice(i,1);
			_childrenCount--;
			this.updateWalkable();
		}
		/**
		 * 方格内是否有显示物品
		 * */
		public function isEmpty():Boolean
		{
			return (_childrenCount<=0);
		}
        /**
		 * 此单云格是否可以叠加
		 * @param excluded: 不考虑的对象
		 * */
		public function isStackable(excluded:IDisplayEntity=null):Boolean
		{
			for each(var ch:IDisplayEntity in _children){
				if(ch==excluded) continue;
				//todo
//				if(ch.stackable==false)
				{
					return false;
				}
			}	
			return true;	
		}
		/**
		 * 如果当前单元格有很多物品按高度叠加起来，获取其总高度，下一个叠加的就置于此高度
		 * */
		public function get currentHeight():Number
		{
			var top:Number=0;
			for each(var ch:IDisplayEntity in _children){
				
				var chTop:Number=ch.bounds.top;
				if(chTop>top) top=chTop
			}
             return top;
		}
		/**
		 * 更新可行走状态
		 * */
		protected function updateWalkable(excludedEntity:IDisplayEntity=null):void
		{
			for each(var ch:IDisplayEntity in _children){
				if(excludedEntity&&(ch==excludedEntity)) continue;
				if(!ch.walkable)
				{
					this._walkable=false;
					return;
				}
			}
			this._walkable=true;
		}
	}
}