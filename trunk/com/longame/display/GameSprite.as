package com.longame.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import com.longame.core.IDestroyable;
	import com.longame.model.Direction;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.debug.Logger;
	import com.longame.display.core.IBitmapRenderer;
	import com.longame.display.core.RenderManager;
	

	/**
	 * 游戏中静止物品渲染器，通过外部图片或内部显示对象定义的游戏物品，可以通过DisplayEntity来操控
	 * */
	public class GameSprite extends Sprite implements IDestroyable, IBitmapRenderer
	{
		public function GameSprite(source:*=null)
		{
			super();
			this.source=source;
		}
		/**
		 * 设定显示对象的数据源，可接受的数据源有：
		 * 1. 视觉元素实例
		 * 2. 视觉元素class
		 * 3. 视觉元素class名
		 * 4. 外部图像/swf的路径
		 * 5. some.swf#someSymbol，some.swf里的someSymbol元件
		 * 6. 特别的，如果对象具有多个方向，那么会用数个1-4的形式定义一组对象，可以是用","分开的字符串，或者是一个数组
		 * */
		public function set source(value:*):void
		{
			//如果是数组，这个==准确么，todo
			if(_rawSource==value)  return;
			_rawSource=value;
			if(_rawSource is String){
				if((_rawSource as String).indexOf(",")>-1) _rawSource=(_rawSource as String).split(",");
			}
			if(!(_rawSource is Array)){
				_source=[_rawSource];
			}else{
				_source=_rawSource as Array;
			}
			var direct:int=_direction;
			if(direct==-1)  direct=Direction.DEFAUTL;
			_direction=-1;
			this.direction=direct;
		}
		public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			_rawSource=null;
			this.destroyBitmap();
		}
		/**getters**/
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
			if(_direction==value) return;
			if(!Direction.isValideDirection(value)) return;
			if(_source==null) {
				Logger.warn(this,"set direction","Please give me a source to display!");
				return;
			} 
			var flippedDirect:int=-1;
			if(_source[value]==null){
				flippedDirect=Direction.getFlippedDirection(value);			
				if(_source[flippedDirect]==null){
					Logger.error(this,"set direction","The direction does not exist: "+value);
					return;				
				}	
			}
			_direction=value;
			var _flipped:Boolean=(flippedDirect>-1);
			var correctedDirect:int=_flipped?flippedDirect:_direction;
			this.doRender(_source[correctedDirect],_flipped);
		}
		/**
		 * 渲染
		 * */
		protected function doRender(source:*,flip:Boolean=false):void
		{
			if(_bitmap==null){
				_bitmap=new Bitmap(new BitmapData(1,1));
				this.addChildAt(_bitmap,0);
			}
			RenderManager.render(this,source);
			if(flip) DisplayObjectUtil.flipHorizontal(_bitmap);
		}
		protected function destroyBitmap():void
		{
			if(_bitmap&&this.contains(_bitmap)){
				this.removeChild(_bitmap);
				_bitmap=null;
			}
		}
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		/**
		 * 元件数组
		 * */
		public function get source():*
		{
			return _source;
		}
		
		protected var _source:Array;
		protected var _direction:int=-1;
		protected var _destroyed:Boolean;
		protected var _rawSource:*;
		protected var _bitmap:Bitmap;
	}
}