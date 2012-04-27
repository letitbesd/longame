package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.display.core.IBitmapRenderer;
	import com.longame.display.core.RenderManager;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.RenderData;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	use namespace long_internal;

	public class SpriteEntity extends DisplayEntity
	{
		public var onBuild:Signal=new Signal(SpriteEntity);
		public var effects:Vector.<BitmapEffect>=new Vector.<BitmapEffect>();
		
		/**
		 * 存储着所有方向的显示对象，key是source，value是displayObject
		 * */
		protected var _sprites:Dictionary=new Dictionary();
		
		public function SpriteEntity(id:String=null)
		{
			super(id);
			this.updateRenderMode();
		}
		override protected function doRender():void
		{
//			if((_currentSource!=this._sourceArr[this._correctDirect])||_directionInvalidated){
			if(_directionInvalidated){
				if(!_inBuilding){
					_currentSource=this._sourceArr[this._correctDirect];
					_inBuilding=true;
					if(_sprites[_currentSource]){
						ProcessManager.callLater(onContentLoaded,[_sprites[_currentSource],true]);
					}else{
						RenderManager.getDisplayFromSource(_currentSource,onContentLoaded,onContentLoadedError,this._renderAsBitmap);
					}
					this._directionInvalidated=false;
				}

			}
			if(this._renderAsBitmap) this.renderBitmap();
			super.doRender();
		}
		protected var _bitmapInvalidated:Boolean;
		/**
		 * 位图渲染
		 * */
		protected function renderBitmap():void
		{
			if(_bitmapInvalidated)
			{
				RenderManager.loadRender(this._currentSource,effects,null,onBitmapLoaded);
				_bitmapInvalidated=false;
			}
		}
		protected var newSource:Boolean=true;
		protected var flipOffset:Point;
		/**
		 * 当位图渲染完毕，在方向变化或者动画播放时都会重新渲染，调用
		 * */
		protected function onBitmapLoaded(data:RenderData):void
		{
			this._bitmap.bitmapData=data.bitmapData;
			this._bitmap.x=data.x;
			this._bitmap.y=data.y;
			if(newSource){
				if(this._needFlip!=this._lastFlipped){
					//todo,以网格中心对应的那个点做翻转
					DisplayObjectUtil.flipHorizontal(this._canvas);
				}
				this._lastFlipped=this._needFlip;
				this._needFlip=false;
				this.newSource=false;
			}
		}
		override protected function doWhenDestroy():void
		{
			_rawSource=null;
			_sourceArr=null;
			_currentSource=null;
			effects=null;
			_itemSpec=null;
			_sprites=null;
			this.destroyBitmap();
			this.destroyContent();
			super.doWhenDestroy();
		}
		override protected function removeSignals():void
		{
			super.removeSignals();
			this.onBuild.removeAll();
			this.onBuild=null;
		}
		protected var _inBuilding:Boolean;
		private function onContentLoaded(display:DisplayObject,fromPool:Boolean=false):void
		{
			if(display){
				this.destroyContent();
				this._sprite=display;
				this._sprites[_currentSource]=display;
				if(!this._renderAsBitmap){
					this._container.addChildAt(display,0);
					//如果重用的显示对象被翻转了，恢复,否则翻转会乱，假定传来的source没有被事先翻转,一般是不会的啦
					if(fromPool&&(display.scaleX<0)) {
						//todo,以网格中心对应的那个点做翻转
						DisplayObjectUtil.flipHorizontal(display);
					}
					if(this._needFlip){
						DisplayObjectUtil.flipHorizontal(this.display);
						this._needFlip=false;
					}
				}
				this.doWhenBuild();
			}
			_inBuilding=false;
		}
		private function onContentLoadedError():void
		{
			_inBuilding=false;
		}
		protected function doWhenBuild():void
		{
			this. _bitmapInvalidated=true;
			this.newSource=true;
			this.onBuild.dispatch(this);
		}
		protected function createBitmap():void
		{
			if(_canvas==null){
				_canvas=new Sprite();
				this._container.addChildAt(_canvas,0);
			}
			if(_bitmap==null){
				_bitmap=new Bitmap(new BitmapData(1,1,true,0x000000));
			}
			this._canvas.addChild(_bitmap);
		}
		protected function destroyBitmap():void
		{
			if(_canvas&&_container.contains(_canvas)){
				_container.removeChild(_canvas);
			}
			if(_bitmap&&_canvas.contains(_bitmap)){
				_canvas.removeChild(_bitmap);
			}
			_canvas=null;
			_bitmap=null;
		}
		protected function destroyContent():void
		{
			if(_sprite){
				if(_sprite is MovieClip) (_sprite as MovieClip).stop();
				if(_container.contains(_sprite)){
					_container.removeChild(_sprite);
				}
			}
			_sprite=null;
		}
		protected var _itemSpec:EntityItemSpec;
		public function get itemSpec():EntityItemSpec
		{
			return _itemSpec;
		}
		public function set itemSpec(value:EntityItemSpec):void
		{
			if(_itemSpec==value) return;
			_itemSpec=value;
			ObjectUtil.cloneProperties(value,this);
			this.width=_itemSpec.size.x;
			this.length=_itemSpec.size.y;
			this.height=_itemSpec.size.z;
			this.offsetX=_itemSpec.offset.x;
			this.offsetY=_itemSpec.offset.y;
			this.scaleX=_itemSpec.scale.x;
			this.scaleY=_itemSpec.scale.y;
		}
		public function get source():*
		{
			return _rawSource;
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
				_sourceArr=[_rawSource];
			}else{
				_sourceArr=_rawSource as Array;
			}
			var direct:int=_direction;
			if(this.isNullDirection(direct))  direct=this.findDirectionCanUse();
			_direction=-1;
			this.direction=direct;
		}
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_directionInvalidated||_bitmapInvalidated;//||_sourceInvalidated
		}
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
			if(_direction==value) return;
			if(!Direction.isValideDirection(value)) return;
			if(_sourceArr==null) {
				this._direction=value;
				return;
			} 
			var flippedDirect:int=-1;
			if(isNullDirection(value)){
				flippedDirect=Direction.getFlippedDirection(value);			
				if(isNullDirection(flippedDirect)){
					return;				
				}	
			}
			_direction=value;
			this._needFlip=(flippedDirect>-1);
			_correctDirect=this._needFlip?flippedDirect:_direction;
			this._directionInvalidated=true;
		}
		private function isNullDirection(d:int):Boolean
		{
			return (_sourceArr[d]=="")||(_sourceArr[d]=="null")||(_sourceArr[d]==null)
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
		public function set renderAsBitmap(value:Boolean):void
		{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			this.updateRenderMode();
		}
		private function updateRenderMode():void
		{
			if(renderAsBitmap){
				this.createBitmap();
				this.destroyContent();		
			}else{
				this.destroyBitmap();
			}
		}
		public function get renderAsBitmap():Boolean
		{
			return _renderAsBitmap;
		}
		public function get flipped():Boolean
		{
			if(this.display==null) return false;
			return this.display.scaleX<0;
		}
		/**
		 * 如果是renderAsBitmap=true,返回渲染后的bitmap
		 * 否则返回source和direction所指定的现实对象，可能是图片或MovieClip
		 * */
		public function get display():DisplayObject
		{
			return this._renderAsBitmap?this._canvas:this._sprite;
		}
		
		protected var _direction:int=-1;
		protected var _rawSource:*;
		protected var _sourceArr:Array;
		protected var _renderAsBitmap:Boolean=false;

		//bitmap的容器
		protected var _canvas:Sprite;
		//二进制显示对象
		protected var _bitmap:Bitmap;
		//原始显示对象
		protected var _sprite:DisplayObject;
		
		protected var _currentSource:*;
		protected var _directionInvalidated:Boolean;
		
		protected var _needFlip:Boolean;
		protected var _lastFlipped:Boolean;
		protected var _correctDirect:int;
	}
}