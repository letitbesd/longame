package com.longame.game.group.component
{
	import be.dauntless.astar.IMap;
	import be.dauntless.astar.IPositionTile;
	
	import com.longame.core.IDestroyable;
	import com.longame.core.long_internal;
	import com.longame.model.Direction;
	import com.longame.game.component.AbstractComp;
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.IEntity;
	import com.longame.game.core.IGroup;
	import com.longame.game.entity.DisplayEntity;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.scene.IScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	use namespace long_internal;

	/**
	 * IDisplayGroup里面的显示对象分布图，以方格为位置单元
	 * 说明：目前GameScene的tileMap里存储的是所有基本显示单元既IDisplayEntity的分布图，包括各个子group（层）里的所有基本显示单元，如果需要GameScene自动深度排序，
	 * 请确保场景无group嵌套，否则排序无意义。不过一般场景都是分层的，所以GameScene本身是不需要自动深度排序的，只是里面各个层会自己排序
	 * */
	public class TileMap extends AbstractComp implements IMap
	{
		protected var _tilesMap:Dictionary=new Dictionary(true);
		
		private var _childMap:Dictionary=new Dictionary(true);
		
		public function TileMap()
		{
		}
		override protected function whenActive():void
		{
			if(!(_owner is IDisplayGroup)) throw new Error("TileMap can only used by IDisplayGroup!");
			super.whenActive();
		}
		override protected function whenDeactive():void
		{
			for (var key:String in _tilesMap){
				var t:EntityTile=_tilesMap[key] as EntityTile;
				t.destroy();
				delete _tilesMap[key];
			}
			super.whenDeactive();
		}
		override protected function whenDestroy():void
		{
			_tileMovedChildren=null;
			_alwaysInTopChildren=null;
			_tilesMap==null;
			_childMap=null;
			super.whenDestroy();
		}
		/**
		 * 获取位于x和y索引出的tile
		 * */
		public function getTile(x:int,y:int):IPositionTile
		{
			return  _tilesMap[getUniqueKey(x,y)];
		}
		public function get tiles():Dictionary
		{
			return _tilesMap;
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
		 * 将一个对象所占方格区域添加到map的对应单元格
		 * */	
		long_internal function addChild(ch:IDisplayEntity):void
		{
//			if(!ch.includeInLayout) return;
			if(!ch.includeInBounds) return;
			var newTiles:Vector.<EntityTile>=new Vector.<EntityTile>();
			_childMap[ch]=newTiles;
			
			var offset:Point=SceneManager.getTileOffsetBetween(ch,this._owner as IDisplayGroup);
			
			var left:int=ch.tileBounds.left;
			var right:int=ch.tileBounds.right;
			var back:int=ch.tileBounds.back;
			var front:int=ch.tileBounds.front;
			var x:int;
			var y:int;
			var tile:EntityTile;
			for(var i:int=left;i<=right;i++){
				for(var j:int=back;j<=front;j++){
					x=i+offset.x;
					y=j+offset.y;
					tile=getTile(x,y) as EntityTile;
					if(tile==null){
						tile=new EntityTile(this,x,y);
						_tilesMap[getUniqueKey(x,y)]=tile;
					}
					tile.addChild(ch);
					newTiles.push(tile);
				}
			}
			this.moveChild(ch,null);
		}
		/**
		 * 将一个显示对象从map的对应单元格删除
		 * */	
		long_internal function removeChild(ch:IDisplayEntity):void
		{
			if(!ch.includeInBounds) return;
			
			var tiles:Vector.<EntityTile>=_childMap[ch];
			if((tiles==null) ||(tiles.length==0)) return;
			
			
			var max:uint=tiles.length;
			var tile:EntityTile;
			
			for(var i:int=0;i<max;i++){
				tile=tiles[i] as EntityTile;
				if(tile) {
					tile.removeChild(ch);
					if(tile.isEmpty()){
						tile.destroy();
						delete _tilesMap[getUniqueKey(tile.x,tile.y)];
					}
				}
			}
			delete _childMap[ch];
		}
		/**
		 * child的tileBounds发生了变化
		 * */
		long_internal function changeChild(child:IDisplayEntity):void
		{
			//先从旧的tile里删除
			this.removeChild(child)
			//再重新添加
			this.addChild(child);			
		}
		private var _tileMovedChildren:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		private var _alwaysInTopChildren:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		/**
		 * child的tile发生了移动
		 * */
		long_internal function moveChild(ch:IDisplayEntity,delta:Point=null):void
		{
			if(delta) changeChild(ch);
			//如果group不需要自动深度排序，不处理
			if((_owner as IDisplayGroup).autoLayout==false) return;
			//对于GameScene，非直接子元素改变不要引起tileMovedChildren变化，因为这个东西用来排序，而排序只有直接父容器才有权利
			if(ch.parent!=this._owner) return;
			if(_tileMovedChildren.indexOf(ch)>-1) return;
			_tileMovedChildren.push(ch);
		}
		long_internal function bringToTop(ch:IDisplayEntity):void
		{
			if(_alwaysInTopChildren.indexOf(ch)>-1) return;
			if(!(_owner as IDisplayGroup).contains(ch)) return;
			_alwaysInTopChildren.push(ch);
		}
		long_internal function notBringToTop(ch:IDisplayEntity):void
		{
			var i:int=_alwaysInTopChildren.indexOf(ch);
			if(i>-1){
				_alwaysInTopChildren.splice(i,1);
				this.moveChild(ch);
			}
		}
		/**
		 * 每个tile的唯一标志
		 * */
		private function getUniqueKey(x:int,y:int):String
		{
			return x+"_"+y;
		}
		public function get tileMovedChildren():Vector.<IDisplayEntity>
		{
			return _tileMovedChildren;
		}
		public function get alwaysInTopChildren():Vector.<IDisplayEntity>
		{
			return _alwaysInTopChildren;
		}
        public function get width():int
		{
			return (_owner as IDisplayGroup).tileBounds.width;
		}
		public function get height():int
		{
			return (_owner as IDisplayGroup).tileBounds.length;
		}
		/**
		 * 获取x,y处tile的8个邻居tile，会以Direction定义的顺序返回
		 * */
		public function getNeighbours(x:int,y:int):Array
		{
			var dx:int;
			var dy:int;
			var max:int=7;//includeDiagnal?7:3;
			var ns:Array=new Array(max);
			for(var i:int=0;i<=max;i++){
				dx=Direction.dx[i];
				dy=Direction.dy[i];
				var tile:EntityTile=this.getTile(x+dx,y+dy) as EntityTile;
				ns[i]=tile;
			}
			return ns;
		}
		/**
		 * 寻找x,y处tile的8个邻居tile，找到可行走的邻居
		 * includeDiagnal是否包括对角的邻居
		 * */
		public function getWalkableNeighbours(x:int,y:int,includeDiagnal:Boolean=true):Array
		{
			var dx:int;
			var dy:int;
			var max:int=includeDiagnal?7:3;
			var ns:Array=new Array(max);
			for(var i:int=0;i<=max;i++){
				dx=Direction.dx[i];
				dy=Direction.dy[i];
				var tile:EntityTile=this.getTile(x+dx,y+dy) as EntityTile;
				if(tile&&tile.walkable) ns[i]=tile;
			}
			return ns;
		}
		/**
		 * 获取x,y单元格为中心矩形区域
		 * @param x:     x索引
		 * @param y:     y索引
		 * @param steps: 获取几层的区域，第一层是它周围的8个，第二层是8+16个，以此类推
		 * @param onlyWalkable:只返回可行走的tile
		 * */
		public function getNeighbourArea(x:int,y:int,steps:int=1,onlyWalkable:Boolean=false):Array
		{
			if(steps<1) throw new Error("steps must >=1");
			var ts:Array=[];
			var t:EntityTile;
			for(var i:int=-steps;i<=steps;i++){
				for(var j:int=-steps;j<=steps;j++){
					//x，y本身的话忽略
					if((i==0)&&(j==0)) continue;
					t=this.getTile(i,j) as EntityTile;
					if(t&&(!onlyWalkable ||(t.walkable))) ts.push(t);
				}
			}
			return ts;
		}
		/**
		 * 获取x,y单元格为中心矩形边缘
		 * @param x:     x索引
		 * @param y:     y索引
		 * @param steps: 获取几层的边缘，第一层是它周围的8个，第二层是16个，以此类推
		 * @param onlyWalkable:只返回可行走的tile
		 * */
		public function getNeighbourFrame(x:int,y:int,steps:int=1,onlyWalkable:Boolean=false):Array
		{
			if(steps<1) throw new Error("steps must >=1");
			var ts:Array=[];
			var t:EntityTile;
			for(var i:int=-steps;i<=steps;i++){
				t=this.getTile(x+i,y-steps) as EntityTile;
				if(t&&(!onlyWalkable ||(t.walkable))) ts.push(t);
				t=this.getTile(x+i,y+steps) as EntityTile;
				if(t&&(!onlyWalkable ||(t.walkable))) ts.push(t);
			}
			for(i=-steps+1;i<=steps-1;i++){
				t=this.getTile(x-steps,y+i) as EntityTile;
				if(t&&(!onlyWalkable ||(t.walkable))) ts.push(t);
				t=this.getTile(x+steps,y+i) as EntityTile;
				if(t&&(!onlyWalkable ||(t.walkable))) ts.push(t);
			}
			return ts;
		}
		/**
		 * 获取x，y单元格为中心的，往四周扩散时，最近的可行走的边缘格
		 * */
		public function getNearestWalkables(x:int,y:int,maxSteps:int=10):Array
		{
			var step:int=0;
			var ts:Array=[];
			while(++step<=maxSteps){
				ts=this.getNeighbourFrame(x,y,step,true);
				if(ts.length) break;
			}
			return ts;
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
			return (_owner as IDisplayGroup).tileBounds.contains(x,y);
		}
	}
}