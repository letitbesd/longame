package com.longame.modules.core.bounds
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.consts.Registration;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.ArrayUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	use namespace long_internal;
	/**
	 * 以方格为单位来表示显示对象的边界
	 * */
	public class TileBounds
	{
		private var _target:IDisplayEntity;
		private var _oldTile:Point=new Point();
		
		public function TileBounds(target:IDisplayEntity)
		{
			this._target=target;
		}
		/**
		 * x,y所在的单元格是否在bounds区域内
		 * */
		public function contains(x:int,y:int):Boolean
		{
			return (x>=left)&&(x<=right)&&(y>=back)&&(y<=front);
		}
		/**
		 * 对象上一个方格位置
		 * */
		public function get oldTile():Point
		{
			return _oldTile;
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
		/**
		 * 最左边界的方格在x方向上的索引
		 * */
		public function get left():int
		{
			if(this._target.registration==Registration.CENTER) return _x-Math.floor(_width/2);
			if(_target is IDisplayGroup) return SceneManager.getTileIndex(_target.bounds.left+SceneManager.tileSize*0.5,0).x;
			return _x;
		}
		/**
		 * 最右边界的方格在x方向上的索引
		 * */
		public function get right():int
		{
			return left+width-1;
		}
		/**
		 * 最后边界的方格在y方向上的索引
		 * */
		public function get back():int
		{
			if(this._target.registration==Registration.CENTER) return _y-Math.floor(_length/2);
			if(_target is IDisplayGroup) return SceneManager.getTileIndex(0,_target.bounds.back+SceneManager.tileSize*0.5).y;
			return _y;
		}
		/**
		 * 最前边界的方格在y方向上的索引
		 * */
		public function get front():int
		{
			return back+length-1;
		}
		/**
		 * 遍历每个方格，callBack(x:int,y:int):void
		 * */
		public function foreachTile(callBack:Function):void
		{
			for(var i:int=left;i<=right;i++){
				for(var j:int=back;j<=front;j++){
					callBack(i,j);
				}
			}
		}
		/**
		 * 对象尺寸发生变化时，重新计算
		 * */
		long_internal function resize():void
		{
			var newWidth:int=SceneManager.getTiledLength(_target.width);
			var newLength:int=SceneManager.getTiledLength(_target.length);
			//确实发生了变化才计算
			if((newWidth!=_width)||(newLength!=_length)) {
				_width=newWidth;
				_length=newLength;
				(_target as DisplayEntity).notifyTileBoundsChange();
			}
		}
		/**
		 * 当对象位置变化时，计算其单元格索引
		 * */
		long_internal function move():void
		{
			var tp:Point=SceneManager.getTileIndex(_target.x,_target.y);
			_oldTile.x=_x;
			_oldTile.y=_y;
			var dtx:int=tp.x-this._x;
			var dty:int=tp.y-this._y;
			if(dtx!=0||dty!=0){
				_x=tp.x;
				_y=tp.y;
				(_target as DisplayEntity).notifyTileMove(new Point(dtx,dty));
			}
		}
	}
}