package com.longame.modules.components
{
	import be.dauntless.astar.Astar;
	import be.dauntless.astar.AstarError;
	import be.dauntless.astar.AstarPath;
	import be.dauntless.astar.PathRequest;
	import be.dauntless.astar.analyzers.WalkableAnalyzer;
	
	import com.longame.model.Direction;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.entities.IVelocityEntity;
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.groups.organizers.GroupMap;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.INativeDispatcher;

	/**
	 * 寻路组件,只有IVelocityEntity才可以添加
	 * */
	public class PathComp extends TickedComp
	{
		public var onFound:Signal=new Signal(Array);
		public var onNotFound:Signal=new Signal();
		public var onReached:Signal=new Signal(EntityTile);
		
		private static const MIN_DISTANCE:Number=SceneManager.tileSize*0.1;
		
		private var _astar:Astar;
		
		public function PathComp(id:String=null)
		{
			super(id);
		}
		override protected function doWhenActive():void
		{
			if(owner is IVelocityEntity){
				super.doWhenActive();
			}else{
				throw new Error("PathFinder can only be used in IVelocityEntity!");
			}
			if(_astar==null) _astar=new Astar();
			_astar.onFound.add(onFoundPath);
			_astar.onNotFound.add(onNotFoundPath);
			_astar.addAnalyzer(new WalkableAnalyzer());
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			_astar.onFound.remove(onFoundPath);
			_astar.onNotFound.remove(onNotFoundPath);
			_astar=null;
			
		}
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			this.moveOnPath();
		}
		public function get astar():Astar
		{
			return _astar;
		}
		private function getMap(parent:IDisplayGroup=null):GroupMap
		{
			if(parent==null) parent=(owner as IDisplayEntity).scene;
			if(parent==null) return null;
			return parent.map;
		}
		private function get realOwner():IVelocityEntity
		{
			return owner as IVelocityEntity;
		}
		/**
		 * 按路径运动
		 * */
		private var _startTime:int;
		private var _currentPath:Array;
		private var _target:EntityTile;
		private var _next:EntityTile;
		private var _speed:Number;
		private var _direction:int;
		private var _angle:Number=0;
		private var _reached:Boolean=true;
		private var _targetWalkable:Boolean;
		/**
		 * 对象按照寻路路径走向目标方格
		 * @param targetX: 目标方格的X索引
		 * @param targetY: 目标方格的Y索引
		 * @param speed: 行走速度,2.5D不能简单的算x和y，不然对角线方向速度特别快。。。
		 * @param alwaysTo:如果目标点是不可行走的，那么走到离它最近的地方，这在场景中和物品发生交互时很有用
		 * */
		public function moveTo(targetX:int,targetY:int,speed:Number=1,alwaysTo:Boolean=false):Boolean
		{
			if(!this.actived || (realOwner.scene==null)) return false;
			var map:GroupMap=getMap();
			if(map==null) return false;
			if(_target){
				_target.walkable=_targetWalkable;
			}
			_target=map.getTile(targetX,targetY) as EntityTile;
			if(_target==null){
				Logger.error(this,"moveTo","target: "+targetX+","+targetY+" does not exist!");
				return false;
			} 
			_targetWalkable=_target.walkable;
			//临时将到达点设为可走
			if(alwaysTo){
				_target.walkable=true;
			}
			_speed=speed;
			//如果正在走路，那么以下一个目标到达点为起点
			var startX:int=_next?_next.x:realOwner.tile.x;
			var startY:int=_next?_next.y:realOwner.tile.y;
			//当前路径清空，如果没有_next对象将停止，否则继续走到_next上
			_currentPath=[];
			
			_startTime=getTimer();
//			_astar.getPath(new PathRequest(new Point(startX,startY),new Point(targetX,targetY),this.getMap()));
			try{
				_astar.getPath(new PathRequest(new Point(startX,startY),new Point(targetX,targetY),this.getMap()));
			}catch(e:Error){
				Logger.error(this,"moveTo",e.message);
				return false;
			}
			return true;
		}
		private function onFoundPath(path:AstarPath,request:PathRequest):void
		{
			_target.walkable=_targetWalkable;
			_reached=false;
			this._currentPath=path.toArray();
			_currentPath.shift();
			Logger.info(this,"onFoundPath","path found, use time: "+(getTimer()-_startTime)+"ms");
			this.onFound.dispatch(this._currentPath);
		}
		private function onNotFoundPath(request:PathRequest):void
		{
			_target.walkable=_targetWalkable;
			Logger.info(this,"onNotFoundPath","path not found!");
			this.onNotFound.dispatch();
		}
		public function get currentPath():Array
		{
			return _currentPath;
		}
		protected function moveOnPath():void
		{
			if(_reached) return;
			if(_next!=null){
				var pn:Point=_next.position;
				var dist:Number=Point.distance(new Point(realOwner.x,realOwner.y),pn);
				//到达一个节点的临界距离是_speed
				if(dist<_speed){
					_next=null;
					//停止下，以免多走一帧，这一帧的移动依靠下面的autoSnap
					realOwner.velocity.setV1(0,0,0);
					//每到一个节点，自动吸附到网格中心
					realOwner.autoSnap();
					return;
				}
			}
			if((_next==null)&&(_currentPath.length)) _next=this.getNextNode();
			//如果找不到下一个方格，表示已经到达目标点
			if(_next==null){
				_reached=true;
				this.onReached.dispatch(_target);
			}
			
		}
		private function getNextNode():EntityTile
		{
			var next:EntityTile=this._currentPath.shift();
			if(owner is SpriteEntity) {
				var direct:int=Direction.getDirectionBetweenTiles(realOwner.tile.x,realOwner.tile.y,next.x,next.y);
				_direction=direct;
				_angle=Direction.getDegree(_direction);
				try{
					(owner as SpriteEntity).direction=_direction;
				}catch(e:Error){
					Logger.error(this,"getNextNode",e.message);
				}
			}
			//如果下一个节点不可走，则终止此次行走，有两种可能性
			//1： 路径上被增加了一个路障
			//2: 角色到达了目标物（目标物是不可通过的）
			if(!next.walkable) {
				next=null;
				_currentPath=[];
			}		
			if(next) realOwner.velocity.setV(_speed,_angle);
			else     realOwner.velocity.setV1(0,0,0);
			return next;
		}
	}
}