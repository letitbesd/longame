package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.display.core.IBitmapRenderer;
	import com.longame.display.core.RenderManager;
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.RenderData;
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
   /**
   * 暂不支持动画的位图渲染，用AnimatorEntity吧
   * */
	public class SpriteEntity extends DisplayEntity
	{
		protected var _onBuild:Signal;
		
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
				RenderManager.loadRender(this._currentSource,null,_scaleX,_scaleY,onBitmapLoaded);
				_bitmapInvalidated=false;
			}
		}
		override protected function validateScale():void
		{
			if(!_scaleInvalidated) return;
			//如果是位图渲染，已经在draw位图时进行的缩放处理，container就不要了
			//但是得_bitmapInvalidated=true来进行位图缩放
			if(!_renderAsBitmap){
				container.scaleX=_scaleX;
				container.scaleY=_scaleY;	
			}else{
				if(this._rawSource) _bitmapInvalidated=true;
			}
			_scaleInvalidated=false;
			if(_onScale) _onScale.dispatch(this);
		}
		//todo,原先设为true，是何想法？
		private var _sourceIsNew:Boolean;;//=true;
		protected var flipOffset:Point;
		/**
		 * 当位图渲染完毕，在方向变化或者动画播放时都会重新渲染，调用
		 * */
		protected function onBitmapLoaded(data:RenderData):void
		{
			if(!actived) return;
			this._bitmap.bitmapData=data.bitmapData;
			this._bitmap.x=data.x;
			this._bitmap.y=data.y;
			if(_sourceIsNew){
				if(this._needFlip!=this._lastFlipped){
					this.flip();
				}
				this._lastFlipped=this._needFlip;
				this._needFlip=false;
				this._sourceIsNew=false;
				this.whenBuild();
			}
		}
		/**
		 * 以对象注册点进行水平翻转
		 * */
		private function flip():void
		{
			var regPoint:Point=new Point();
			regPoint=_container.localToGlobal(regPoint);
			regPoint=this.display.globalToLocal(regPoint);
			DisplayObjectUtil.scaleAround(this.display,regPoint.x,0,-display.scaleX,display.scaleY);
		}
		override protected function whenDestroy():void
		{
			_rawSource=null;
			_sourceArr=null;
			_currentSource=null;
			_itemSpec=null;
			_sprites=null;
			_onBuild=null;
			this.destroyBitmap();
			this.destroyContent();
			super.whenDestroy();
		}
		protected var _inBuilding:Boolean;
		private function onContentLoaded(display:DisplayObject,fromPool:Boolean=false):void
		{
			if(!actived) return;
			if(display){
				this.destroyContent();
				//将左边恢复到原点
				display.x=0;
				display.y=0;
				this._sprite=display;
				this._sprites[_currentSource]=display;
				if(this._renderAsBitmap){
					this. _bitmapInvalidated=true;
					this._sourceIsNew=true;
				}else{
					this._container.addChildAt(display,0);
					//如果重用的显示对象被翻转了，恢复,否则翻转会乱，假定传来的source没有被事先翻转,一般是不会的啦
					if(fromPool&&(display.scaleX<0)) {
						this.flip();
					}
					if(this._needFlip){
						this.flip();
						this._needFlip=false;
					}
				}
				this.whenSourceLoaded();
			}
		}
		private function onContentLoadedError():void
		{
			//todo,handle error
			_inBuilding=false;
		}
		/**
		 * 当素材被加载完时，如果是多方向动画，此函数可能会被调多次
		 * 覆盖以完成素材预处理，如果只是想在渲染完毕后处理，请统一覆盖whenBuild
		 * */
		protected function whenSourceLoaded():void
		{
			if(!_renderAsBitmap) this.whenBuild();
			//tobe inherited
		}
		/**
		 * 当素材被加载完时，如果是多方向动画，此函数可能会被调多次
		 * 特别的位图渲染时，等位图渲染ok后才会调用
		 * */
		protected function whenBuild():void
		{
			_inBuilding=false;
			if(_onBuild) _onBuild.dispatch(this);
			//tobe inherited
		}
		protected function createBitmap():void
		{
			if(_bitmapContainer==null){
				_bitmapContainer=new Sprite();
				this._container.addChildAt(_bitmapContainer,0);
			}
			if(_bitmap==null){
				_bitmap=new Bitmap(new BitmapData(1,1,true,0x000000));
			}
			this._bitmapContainer.addChild(_bitmap);
		}
		protected function destroyBitmap():void
		{
			if(_bitmapContainer&&_container.contains(_bitmapContainer)){
				_container.removeChild(_bitmapContainer);
			}
			if(_bitmap&&_bitmapContainer.contains(_bitmap)){
				_bitmapContainer.removeChild(_bitmap);
			}
			_bitmapContainer=null;
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
		/**
		 * 素材加载渲染完毕,设定方向 direction或者重新设定source都会导致此事件发生
		 * */
		public function get onBuild():Signal
		{
			if((_onBuild==null)&&(!destroyed)) _onBuild=new Signal(SpriteEntity);
			return _onBuild;
		}
		/**
		 * 指示当前是否正在进行加载或位图渲染，或者设定了新的方向也会导致=true
		 * 如果当前source没有设定，也视为true
		 * */
		public function get inBuilding():Boolean
		{
			return _inBuilding||_directionInvalidated||(_rawSource==null);
		}
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_directionInvalidated||_bitmapInvalidated||_inBuilding;
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
			return this._renderAsBitmap?this._bitmapContainer:this._sprite;
		}
		
		protected var _direction:int=-1;
		protected var _rawSource:*;
		protected var _sourceArr:Array;
		protected var _renderAsBitmap:Boolean=false;

		//bitmap的容器
		protected var _bitmapContainer:Sprite;
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