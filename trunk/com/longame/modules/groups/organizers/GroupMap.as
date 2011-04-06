package com.longame.modules.groups.organizers
{
	import be.dauntless.astar.IMap;
	import be.dauntless.astar.IPositionTile;
	
	import com.longame.core.IDestroyable;
	import com.longame.model.Direction;
	import com.longame.model.signals.SignalBus;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * IDisplayGroup里面的显示对象分布图，以方格为位置单元
	 * */
	public class GroupMap extends AbstractGroupOrganizer implements IMap
	{
		private var _map:Dictionary=new Dictionary(true);
		private var _basicEntity:Boolean;
		/**
		 * @param basicEntity: 是否一个基本IDisplayEntity的地图，通常只有IScene需要设为true
		 * */
		public function GroupMap(basicEntity:Boolean)
		{
			_basicEntity=basicEntity;
		}
		override public function active(owner:IDisplayGroup):void
		{
			if(actived) return;
			super.active(owner);
			//已有的物品添加进来
			(group as DisplayGroup).foreachDisplay(this.addChild,true,_basicEntity);
			this.configSignals(true);
		}
		override public function deactive():void
		{
			if(!actived) return;
			this.configSignals(false);
			for (var key:String in _map){
				var t:EntityTile=_map[key] as EntityTile;
				t.destroy();
				delete _map[key];
			}
			super.deactive();
		}
		override public function destroy():void
		{
			if(destroyed) return;
			super.destroy();
			_tileMovedChildren=null;
			_map==null;
		}
		/**
		 * 获取位于x和y索引出的tile
		 * */
		public function getTile(x:int,y:int):IPositionTile
		{
			return  _map[getUniqueKey(x,y)];
		}
		/**
		 * 获取以x，y处单元格为基准点，方向为direction的邻居
		 * */
		public function getNeighbour(x:int,y:int,direction:int):EntityTile
		{
			return getTile(x+Direction.dx[direction],y+Direction.dy[direction]) as EntityTile;
		}
		public function setTile(tile:IPositionTile):void
		{
			//do nothing;
		}
		/**
		 * 将一个显示对象添加到map的对应单元格
		 * todo,如果是场景，需要tile坐标转换到全局
		 * */	
		protected function addChild(ch:IDisplayEntity):void
		{
			//todo here
			//如果用这段，LGGrid这种东西就不会影响到map，entityTile.clear()不影响，displayGroup.fillBlankArea()不影响
			//如果不用这段，GroupBounds得不到正确的更新，多半是因为GroupBoundsDebugger没有被计算进去？
			if(!ch.includeInLayout) return;
			var tiles:Vector.<Point>=ch.tileBounds.tiles;
			var max:uint=tiles.length;
			var tile:EntityTile;
			for(var i:int=0;i<max;i++){
				var t:Point=tiles[i];
				tile=getTile(t.x,t.y) as EntityTile;
				if(tile==null){
					tile=new EntityTile(this,t.x,t.y);
					_map[getUniqueKey(t.x,t.y)]=tile;
				}
				tile.addChild(ch);
			}
			if(!_basicEntity){
				ch.onTileBoundsChange.add(onChildBoundsChanged);
				if(group.autoLayout) ch.onTileMove.add(onChildTileMoved)
			}
			this.onChildTileMoved(ch,null);
		}
		/**
		 * 将一个显示对象从map的对应单元格删除
		 * */	
		protected function removeChild(ch:IDisplayEntity,tiles:Vector.<Point>=null):void
		{
			if(ch.includeInLayout==false) return;
			if(tiles==null) tiles=ch.tileBounds.tiles;
			var max:uint=tiles.length;
			for(var i:int=0;i<max;i++){
				var t:Point=tiles[i];
				var tile:EntityTile=getTile(t.x,t.y) as EntityTile;
				if(tile) {
					tile.removeChild(ch);
					if(tile.isEmpty()){
						tile.destroy();
						delete _map[getUniqueKey(t.x,t.y)];
					}
				}
			}
			if(!_basicEntity){
				ch.onTileBoundsChange.remove(onChildBoundsChanged);
				if(group.autoLayout) ch.onTileMove.remove(onChildTileMoved)
			}
		}
		private function configSignals(add:Boolean):void
		{
			if(!_basicEntity){
				add?(group as IEntity).onChildActived.add(this.onChildActived):(group as IEntity).onChildActived.remove(this.onChildActived);
				add?(group as IEntity).onChildDeactived.add(this.onChildDeactived):(group as IEntity).onChildDeactived.remove(this.onChildDeactived);
			}else{
				add?SignalBus.hook("onDisplayEntityActive",this.onChildActived):SignalBus.unhook("onDisplayEntityActive",this.onChildActived);
				add?SignalBus.hook("onDisplayEntityDeactive",this.onChildDeactived):SignalBus.unhook("onDisplayEntityDeactive",this.onChildDeactived);
				add?SignalBus.hook("onDisplayEntityBoundsChange",this.onChildBoundsChanged):SignalBus.unhook("onDisplayEntityBoundsChange",this.onChildBoundsChanged);
				if(group.autoLayout) add?SignalBus.hook("onDisplayEntityTileMove",this.onChildTileMoved):SignalBus.unhook("onDisplayEntityTileMove",this.onChildTileMoved);
			}
		}
		/**
		 * 每个tile的唯一标志
		 * */
		private function getUniqueKey(x:int,y:int):String
		{
			return x+"_"+y;
		}
		private function onChildActived(child:IDisplayEntity):void
		{
			this.addChild(child);
		}
		private function onChildDeactived(child:IDisplayEntity):void
		{
			this.removeChild(child);
		}		
		private function onChildBoundsChanged(child:IDisplayEntity,newTiles:Vector.<Point>,oldTiles:Vector.<Point>):void
		{
			//先从旧的tile里删除
			this.removeChild(child,oldTiles)
			//再重新添加
			this.addChild(child);			
		}
		private var _tileMovedChildren:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		private function onChildTileMoved(ch:IDisplayEntity,delta:Point):void
		{
			//如果group不需要自动深度排序，不处理
			if(group.autoLayout==false) return;
			//对于GameScene，非直接子元素改变不要引起tileMovedChildren变化，因为这个东西用来排序，而排序只有直接父容器才有权利
			if(ch.parent!=this.group) return;
			if(_tileMovedChildren.indexOf(ch)>-1) return;
			_tileMovedChildren.push(ch);
		}
		public function get tileMovedChildren():Vector.<IDisplayEntity>
		{
			return _tileMovedChildren;
		}
		/**
		 * 跟随DisplayGroup每帧render的频率，做一些更新
		 * 由于DisplayMap里存储了每帧一些发生变化的一些元素，如每帧tileMove了的元素，在group渲染完后要将其清空，保证每帧都是最新的
		 * */
		override protected function doUpdate():void
		{
			 _tileMovedChildren.length=0;//splice(0,_tileMovedChildren.length);
		}
        public function get width():int
		{
			return (_group as IDisplayGroup).tileBounds.width;
		}
		public function get height():int
		{
			return (_group as IDisplayGroup).tileBounds.length;
		}
		/**
		 * 获取x,y处tile的8个邻居tile，会以Direction定义的顺序返回
		 * */
		public function getNeighbours(x:int,y:int):Array
		{
			var max:int=Direction.maxDirection;
			var ns:Array=new Array(max);
			var dx:int;
			var dy:int;
			for(var i:int=0;i<=max;i++){
				dx=Direction.dx[i];
				dy=Direction.dy[i];
				var tile:EntityTile=this.getTile(x+dx,y+dy) as EntityTile;
				ns[i]=tile;			
			}
			return ns;
		}
		/**
		 * from和to对应的两个tile是否对角
		 * */
		public function isDiagonal(from:Point, to:Point):Boolean
		{
			return Direction.isDiagonalTiles(from,to);
		}
		/**
		 * x，y索引处的方格是否在Map的有效区域内
		 * */
		public function isValidTile(x:int,y:int):Boolean
		{
			return (_group as IDisplayGroup).tileBounds.contains(x,y);
		}
	}
}