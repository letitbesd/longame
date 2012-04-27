package com.longame.game.component
{
	import be.dauntless.astar.Astar;
	import be.dauntless.astar.AstarError;
	import be.dauntless.astar.AstarPath;
	import be.dauntless.astar.PathRequest;
	import be.dauntless.astar.analyzers.FullClippingAnalyzer;
	import be.dauntless.astar.analyzers.WalkableAnalyzer;
	
	import com.longame.core.long_internal;
	import com.longame.model.Direction;
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.IEntity;
	import com.longame.game.entity.AnimatorEntity;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.IMovableEntity;
	import com.longame.game.entity.SpriteEntity;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.group.component.TileMap;
	import com.longame.game.scene.SceneManager;
	import com.longame.utils.Vector3DUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.INativeDispatcher;

    use namespace long_internal;
	/**
	 * 寻路组件,只有IVelocityEntity才可以添加,目前寻路算法是每次都要重构那个datamap？有点慢吧？
	 * */
	public class PathComp extends TickedComp
	{
		/**
		 * 寻路成功发送信号
		 * */
		public var onFound:Signal=new Signal(Array);
		/**
		 * 寻路失败发送信号
		 * */
		public var onNotFound:Signal=new Signal();
		/**
		 * 走完一个路径节点
		 * */
		public var onTileReached:Signal=new Signal(EntityTile);
		/**
		 * 所有路径节点都走完了
		 * */
		public var onReached:Signal=new Signal(EntityTile);
		/**
		 * 在路上遇到了障碍，这个一般是动态障碍
		 * */
		public var onBlocked:Signal=new Signal();
		
		private var _astar:Astar;
		
		public function PathComp(id:String=null)
		{
			super(id);
		}
		override protected function whenActive():void
		{
			if(owner is IMovableEntity){
				super.whenActive();
			}else{
				throw new Error("PathFinder can only be used in IMovableEntity!");
			}
			if(_astar==null) _astar=new Astar();
			_astar.onFound.add(onFoundPath);
			_astar.onNotFound.add(onNotFoundPath);
			//walkable为true才可以行走
			_astar.addAnalyzer(new WalkableAnalyzer());
			//不走斜角
			_astar.addAnalyzer(new FullClippingAnalyzer());
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			_astar.onFound.remove(onFoundPath);
			_astar.onNotFound.remove(onNotFoundPath);
			_astar=null;
			
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			this.onBlocked=null;
			this.onFound=null;
			this.onNotFound=null;
			this.onReached=null;
			this.onTileReached=null;
		}
		override protected function removeSignals():void
		{
//			this.onBlocked.removeAll();
//			this.onBlocked=null;
//			this.onFound.removeAll();
//			this.onFound=null;
//			this.onNotFound.removeAll();
//			this.onNotFound=null;
//			this.onReached.removeAll();
//			this.onReached=null;
//			this.onTileReached.removeAll();
//			this.onTileReached=null;
			super.removeSignals();
		}
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			this.doMove();
		}
		public function get astar():Astar
		{
			return _astar;
		}
		private function getMap(parent:IDisplayGroup=null):TileMap
		{
			if(parent==null) parent=(owner as IDisplayEntity).scene;
			if(parent==null) return null;
			return parent.map;
		}
		private function get theOwner():IMovableEntity
		{
			return owner as IMovableEntity;
		}
		/**
		 * 按路径运动
		 * */
		private var _startTime:int;
		private var _currentPath:Array=[];
		private var _targetTile:EntityTile;
		private var _currentNode:EntityTile;
//	    private var _targetWalkable:Boolean;
		private var _startTile:EntityTile;
		/**
		 * 对象按照寻路路径走向目标方格
		 * @param targetX: 目标方格的X索引
		 * @param targetY: 目标方格的Y索引
		 * @param alwaysTo:如果目标点是不可行走的，那么走到离它最近的地方，这在场景中和物品发生交互时很有用
		 * @param directly:不寻路，直接走过去
		 * */
		public function moveToPoint(targetX:int,targetY:int,alwaysTo:Boolean=false):void
		{
			if(!this.actived || (theOwner.scene==null)) {
				this.onNotFound.dispatch();
				return;
			}
			
			if(_targetTile){
				_targetTile.updateWalkable();
//				_targetTile.walkable=_targetWalkable;
			}
			var map:TileMap=getMap();
			_startTile=map.getTile(theOwner.tileBounds.x,theOwner.tileBounds.y) as EntityTile;
			
			_targetTile=map.getTile(targetX,targetY) as EntityTile;
			if(_targetTile==null){
				Logger.error(this,"moveToPoint","target: "+targetX+","+targetY+" does not exist!");
				this.onNotFound.dispatch();
				return;
			} 
			
//			if((_targetTile.x==_startTile.x)&&(_targetTile.y==_startTile.y)){
//				this.onReached.dispatch(_targetTile);
//				return true;
//			}
			
//			_targetWalkable=_targetTile.walkable;
			//临时将到达点设为可走
			if(alwaysTo){
				_targetTile.walkable=true;
			}
			//如果正在走路，那么以下一个目标到达点为起点
			var startX:int=_currentNode?_currentNode.x:theOwner.tileBounds.x;
			var startY:int=_currentNode?_currentNode.y:theOwner.tileBounds.y;
			//当前路径清空，如果没有_next对象将停止，否则继续走到_next上
			_currentPath=[];
			
			_startTime=getTimer();
//			_astar.getPath(new PathRequest(new Point(startX,startY),new Point(targetX,targetY),this.getMap()));
			try{
				_astar.getPath(new PathRequest(new Point(startX,startY),new Point(targetX,targetY),this.getMap()));
			}catch(e:Error){
				Logger.error(this,"moveToPoint",e.message);
				this.onNotFound.dispatch();
				return;
			}
		}
		public function moveToTarget(target:IDisplayEntity,alwaysTo:Boolean=false):void
		{
			this.moveToPoint(target.tileBounds.x,target.tileBounds.y,alwaysTo);
		}
		/**
		 * 按照指定路径path运动
		 * */
		public function moveOn(path:Array):void
		{
			_currentPath=path;
		}
		/**
		 * 不断的添加路径节点
		 * */
		public function addNode(tile:EntityTile):void
		{
			_currentPath.push(tile);
		}
		private var _velocity:Vector3D=new Vector3D();
		/**
		 * 根据八方向和length来设定物体速度，这种方式下，会自动改变SpriteEntity物体的方向
		 * todo
		 * */
		public function moveOnDirection(direct:int):void
		{
			Vector3DUtil.fromPolar(theOwner.speed,Direction.getDegree(direct),0,this._velocity)
			if(theOwner is SpriteEntity){
				(theOwner as SpriteEntity).direction=direct;
			}
		}
		/**
		 * 停止移动
		 * @param immediately: 是否立即停止，如果对象正在向某个节点移动，清除之，对象就会立即停止了
		 * */
		public function stop(immediately:Boolean=false):void
		{
			_currentPath=[];
			if(immediately&&_currentNode) {
				//自动吸附过去，todo
				if(theOwner) theOwner.snapToTile(_currentNode.x,_currentNode.y);
				_currentNode=null;
			}
		}
		private function onFoundPath(path:AstarPath,request:PathRequest):void
		{
//			_targetTile.walkable=_targetWalkable;
			_targetTile.updateWalkable();
			_targetTile=null;
			this._currentPath=path.toArray();
			Logger.info(this,"onFoundPath",theOwner+"'s path found, use time: "+(getTimer()-_startTime)+"ms");
			this.onFound.dispatch(this._currentPath);
		}
		private function onNotFoundPath(request:PathRequest):void
		{
//			_targetTile.walkable=_targetWalkable;
			_targetTile.updateWalkable();
			_targetTile=null;
			Logger.info(this,"onNotFoundPath","path not found!");
			this.onNotFound.dispatch();
		}
		public function get currentPath():Array
		{
			return _currentPath;
		}
		public function get currentNode():EntityTile
		{
			return _currentNode;
		}
		protected function doMove():void
		{
			if(_currentNode==null){
				if(_currentPath.length==0) return;
				_currentNode=this.getNextNode();
				if(_currentNode==null) return;
				//每一次前进，保证在网格中心
//				theOwner.autoSnap();
				this.moveToDirectly(_currentNode);
			}
			if(this.ifTileReached()){
				if(_currentPath.length==0){
					onReached.dispatch(_currentNode);
					//每到一个节点，自动吸附到网格中心
					theOwner.autoSnap();
				}
				onTileReached.dispatch(_currentNode);
				_currentNode=null;
			}else{
				theOwner.x+=_velocity.x;
				theOwner.y+=_velocity.y;
				theOwner.z+=_velocity.z;
			}
		}
		private function getNextNode():EntityTile
		{
			var next:EntityTile;
			//找到路线中和当前位置不同的那个节点
			while(next==null){
				if(this._currentPath.length==0) break;
				next=this._currentPath.shift();
				if((next.x==theOwner.tileBounds.x)&&(next.y==theOwner.tileBounds.y)) next=null;
			}
			//每一次前进，保证在网格中心
			theOwner.autoSnap();
			//如果下一个节点不可走，则终止此次行走，有两种可能性
			//1： 路径上被增加了一个路障
			//2: 角色到达了目标物（目标物是不可通过的）
			if(next&&(!next.walkable)) {
				//会重复播报？
				onTileReached.dispatch(_currentNode);
				//如果路径还有没走完，表示遇到了障碍
				if(_currentPath.length){
					onBlocked.dispatch();
					_currentPath=[];
				}else{
					onReached.dispatch(_currentNode);
				}
				next=null;
			}		
			return next;
		}
		/**
		 * 以speed运动到x,y指定的tile上
		 * */
		private function moveToDirectly(tile:EntityTile):void
		{
			var d:int=Direction.getDirectionBetweenTiles(theOwner.tileBounds.x,theOwner.tileBounds.y,tile.x,tile.y);
			if(d==-1) return;
			this.moveOnDirection(d);
		}
		private function ifTileReached():Boolean
		{
			var pn:Point=SceneManager.getTilePosition(_currentNode.x,_currentNode.y);
			var dist:Number=Point.distance(new Point(theOwner.x,theOwner.y),pn);
			//到达一个节点的临界距离是_speed
			if(dist<(owner as IMovableEntity).speed){
				return true;
			}
			return false;
		}
	}
}