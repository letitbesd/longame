package com.longame.display
{
	import com.longame.core.IDestroyable;
	import com.longame.display.core.IBitmapRenderer;
	import com.longame.display.core.RenderManager;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.model.Direction;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	/**
	 * 游戏中静止物品渲染器，通过外部图片或内部显示对象定义的游戏物品，可以通过DisplayEntity来操控
	 * */
	public class GameSprite extends Sprite implements IDestroyable, IBitmapRenderer
	{
		public function GameSprite(renderAsBitmap:Boolean=false)
		{
			_renderAsBitmap=!renderAsBitmap;
			this.renderAsBitmap=renderAsBitmap;
			super();
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
			if(this.isNullDirection(direct))  direct=this.findDirectionCanUse();///Direction.DEFAUTL;
			_direction=-1;
			this.direction=direct;
		}
		public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			_rawSource=null;
			this.destroyBitmap();
			this.destroyContent();
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
			if(isNullDirection(value)){
				flippedDirect=Direction.getFlippedDirection(value);			
				if(isNullDirection(flippedDirect)){
//					Logger.error(this,"set direction","The direction does not exist: "+value);
					return;				
				}	
			}
			_direction=value;
			var _flipped:Boolean=(flippedDirect>-1);
			var correctedDirect:int=_flipped?flippedDirect:_direction;
			if(_source[correctedDirect]){
				this.doRender(_source[correctedDirect],_flipped);
			}
		}
		private function isNullDirection(d:int):Boolean
		{
			return (_source[d]=="")||(_source[d]=="null")||(_source[d]==null)
		}
		private function findDirectionCanUse():int
		{
			var i:int=-1;
			while(i++<7){
				if(!this.isNullDirection(i)){
					return i;
				}
			}
			return -1;
		}
		/**
		 * 渲染
		 * */
		protected function doRender(source:*,flip:Boolean=false):void
		{
			if(this._renderAsBitmap){
				RenderManager.render(this,source,effects);
			}else{
				RenderManager.getDisplayFromSource(source,onDisplayLoaded);
			}
			this.flipContent(_renderAsBitmap?_bitmap:_content,flip);
		}
		protected var flipped:Boolean;
		protected function flipContent(target:DisplayObject,flip:Boolean):void
		{
			if(flip){
				if(!flipped) DisplayObjectUtil.flipHorizontal(target);
			}else{
				if(flipped) DisplayObjectUtil.flipHorizontal(target);
			}
			flipped=flip;
		}
		
		private function onDisplayLoaded(display:DisplayObject):void
		{
			if(display){
				if(this._content.numChildren) this._content.removeChildAt(0);
				this._content.addChild(display);
			}
		}
		
		protected function destroyBitmap():void
		{
			if(_bitmap&&this.contains(_bitmap)){
				this.removeChild(_bitmap);
				_bitmap=null;
			}
		}
		protected function destroyContent():void
		{
			if(_content&&this.contains(_content)){
				this.removeChild(_content);
				_content=null;
			}
		}
		/**
		 * 位图效果
		 * */
		protected var _effects:Vector.<BitmapEffect>=new Vector.<BitmapEffect>();
		public function get effects():Vector.<BitmapEffect>
		{
			return _effects;
		}
		public function set effects(value:Vector.<BitmapEffect>):void
		{
			if(_effects==value) return;
			_effects=value;
			//强制刷新
			var currentDirect:int=this._direction;
			this._direction=-1;
			this.direction=currentDirect;
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
		
		/**
		 * 是否采用二进制渲染,对于简单图形是没必要的
		 * */
		public function get renderAsBitmap():Boolean 
		{
			return _renderAsBitmap
		}
		public function set renderAsBitmap(value:Boolean):void{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			if(value){
                this.createBitmap();
				this.destroyContent();		
			}else{
				this.destroyBitmap();
                this.createContent();
			}
		}
		protected function createBitmap():void
		{
			if(_bitmap==null){
				_bitmap=new Bitmap(new BitmapData(1,1));
				this.addChildAt(_bitmap,0);
			}
		}
		protected function createContent():void
		{
			if(_content==null){
				_content=new Sprite();
				this.addChildAt(_content,0);
			}
		}
		
		protected var _source:Array;
		protected var _direction:int=-1;
		protected var _destroyed:Boolean;
		protected var _rawSource:*;
		protected var _renderAsBitmap:Boolean;
		//二进制渲染对象
		protected var _bitmap:Bitmap;
		//普通渲染容器
		protected var _content:Sprite;
	}
}