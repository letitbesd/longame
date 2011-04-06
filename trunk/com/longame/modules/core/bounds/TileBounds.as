package com.longame.modules.core.bounds
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.consts.Registration;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.ArrayUtil;
	
	use namespace long_internal;
	/**
	 * 以方格为单位来表示显示对象的边界
	 * */
	public class TileBounds
	{
		private var _target:IDisplayEntity;
		private var _noDispatch:Boolean;
		public function TileBounds(target:IDisplayEntity)
		{
			this._target=target;
			this._target.onMove.add(onTargetMoved);
			this._target.onResize.add(onTargetResized);
			_noDispatch=true;
			this.onTargetMoved(_target);
			this.onTargetResized(_target)
			_noDispatch=false;
		}
		/**
		 * x,y所在的单元格是否在bounds区域内
		 * */
		public function contains(x:int,y:int):Boolean
		{
			return (x>=_left)&&(x<=_right)&&(y>=_back)&&(y<=_front);
		}
		private var _x:int;
		/**
		 * 对象原点对应的方格x方向上的索引
		 * */
		public function get x():int
		{
			return _x;
		}
		private var _y:int;
		/**
		 * 对象原点对应的方格y方向上的索引
		 * */
		public function get y():int
		{
			return _y;
		}
		private var _width:int;
		/**
		 * 对象所占方格在x方向上的个数，最少算1
		 * */
		
		public function get width():int
		{
			return _width;
		}
		private var _length:int;
		/**
		 * 对象所占方格在y方向上的个数，最少算1
		 * */
		public function get length():int
		{
			return _length;
		}
		private var _left:int;
		/**
		 * 最左边界的方格在x方向上的索引
		 * */
		public function get left():int
		{
			return _left;
		}
		private var _right:int;
		/**
		 * 最右边界的方格在x方向上的索引
		 * */
		public function get right():int
		{
			return _right;
		}
		private var _back:int;
		/**
		 * 最后边界的方格在y方向上的索引
		 * */
		public function get back():int
		{
			return _back;
		}
		private var _front:int;
		/**
		 * 最前边界的方格在y方向上的索引
		 * */
		public function get front():int
		{
			return _front;
		}
		
		protected var _tiles:Vector.<Point>=new Vector.<Point>();
		/**
		 * 对象图像覆盖的所有单元格列表
		 * */
		public function get tiles():Vector.<Point>
		{
			return _tiles;
		}
		/**
		 * 对象尺寸发生变化时，重新计算
		 * */
		private function onTargetResized(target:IDisplayEntity):void
		{
			var newWidth:int=SceneManager.getTiledLength(target.width);
			var newLength:int=SceneManager.getTiledLength(target.length);
			//确实发生了变化才计算
			if((newWidth!=_width)||(newLength!=_length)) {
				_width=newWidth;
				_length=newLength;
				this.calTiles();
			}
		}
		/**
		 * 当对象位置变化时，计算其单元格索引
		 * */
		protected function onTargetMoved(target:IDisplayEntity):void
		{
			var tp:Point=SceneManager.getTileIndex(target.x,target.y);
			var dtx:int=tp.x-this._x;
			var dty:int=tp.y-this._y;
			if(dtx!=0||dty!=0){
				_x=tp.x;
				_y=tp.y;
				this.calTiles();
				var delta:Point=new Point(dtx,dty);
				_target.onTileMove.dispatch(this._target,delta);
				if(_target is DisplayGroup){
					if(!_noDispatch) (_target as DisplayGroup).notifyAllChildrenTileMoved(delta);
				}
			}
		}
		private function calTiles():void
		{
			var oldTiles:Vector.<Point>=ArrayUtil.clonePointArray(_tiles);
			_tiles=SceneManager.getTargetTiles(this._target);
			calEage();
			if(!_noDispatch) _target.onTileBoundsChange.dispatch(this._target,_tiles,oldTiles);
		}
		private function calEage():void
		{
			_left=int.MAX_VALUE;
			_back=int.MAX_VALUE;
			_right=int.MIN_VALUE;
			_front=int.MIN_VALUE;
			for each(var t:Point in _tiles){
				_left=Math.min(t.x,_left);
				_back=Math.min(t.y,_back);
				_right=Math.max(t.x,_right);
				_front=Math.max(t.y,_front);
			}
		}
	}
}