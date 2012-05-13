package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IBitmapRenderer;
	import com.longame.display.core.RenderManager;
	import com.longame.display.effects.bitmapEffect.BitmapEffect;
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.TextureData;
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
	
	import starling.display.Image;

	use namespace long_internal;
	public class SpriteEntity extends DisplayEntity
	{
		protected var _onBuild:Signal;
		protected var _currentFrame:int=0;
		
		public function SpriteEntity(id:String=null)
		{
			super(id);
		}
		override protected function doRender():void
		{
			if(_directionInvalidated){
				if(!_inBuilding){
					_currentSource=this._sourceArr[this._correctDirect];
					_inBuilding=true;
					RenderManager.getDisplayFromSource(_currentSource,onContentLoaded,onContentLoadedError,true);
					this._directionInvalidated=false;
				}
			}
			this.renderTexture();
			super.doRender();
		}
		protected var _textureInvalidated:Boolean;
		/**
		 * 渲染一帧，如果需要在不同情况下来让同一帧同一scale的对象重新渲染(像换装），可以添加extraId来进行区别，在缓存池里也会体现出来
		 * */
		protected function renderTexture(extraId:String=null):void
		{
			if(_textureInvalidated&&_sourceDisplay)
			{
				var texture:TextureData=RenderManager.getTextureFromPool(this._currentSource,_currentFrame,_scaleX,_scaleY,extraId);
				if(texture){
					onTextureLoaded(texture);
				}else{
					this.preHandlerTexture();
					RenderManager.loadTexture(this._currentSource,_currentFrame,_scaleX,_scaleY,onTextureLoaded,null,extraId);
				}
				_textureInvalidated=false;
			}
		}
		override protected function validateScale():void
		{
			if(!_scaleInvalidated) return;
			if(this._rawSource) _textureInvalidated=true;
			_scaleInvalidated=false;
			if(_onScale) _onScale.dispatch(this);
		}
		private var _sourceIsNew:Boolean;
		/**
		 * 当位图渲染完毕，在方向变化或者动画播放时都会重新渲染，调用
		 * */
		protected function onTextureLoaded(data:TextureData):void
		{
			if(!actived) return;
			if(this._canvas==null){
				this._canvas=new Image(data.texture);
				this._container.addChild(_canvas);
			}
			this._canvas.texture=data.texture;
			this._canvas.pivotX=-data.x;
			this._canvas.pivotY=-data.y;
			if(_sourceIsNew){
				if(this._needFlip&&(this._canvas.scaleX>0)){
					this._canvas.scaleX*=-1;
				}
				this._needFlip=false;
				this._sourceIsNew=false;
				this.whenBuild();
			}
		}
		override protected function whenDispose():void
		{
			_rawSource=null;
			_sourceArr=null;
			_currentSource=null;
			_itemSpec=null;
			_onBuild=null;
			_canvas=null;
			_sourceDisplay=null;
			super.whenDispose();
		}
		protected var _inBuilding:Boolean;
		private function onContentLoaded(display:DisplayObject,fromPool:Boolean=false):void
		{
			if(!actived) return;
			if(display){
				//将左边恢复到原点
				display.x=0;
				display.y=0;
				this._sourceDisplay=display;
				if(this._sourceDisplay is MovieClip) (this._sourceDisplay as MovieClip).stop();
				this. _textureInvalidated=true;
				this._sourceIsNew=true;
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
			this.whenBuild();
			//tobe inherited
		}
		/**
		 * 当source源变化或帧变化或scale变化或其它任何需要刷新当前帧图像前，在这里处理一些逻辑，如换装。。。
		 * */
		protected function preHandlerTexture():void
		{
			//tobe overrided
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
		 * 6. some.swf#someSymbol@someInstance,some.swf中的someSymbol元件中的someInstance子元素，当然#内容为空，表示舞台上得
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
			if((_onBuild==null)&&(!disposed)) _onBuild=new Signal(SpriteEntity);
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
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_directionInvalidated||_textureInvalidated||_inBuilding;
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
		public function get flipped():Boolean
		{
			if(this.display==null) return false;
			return this.display.scaleX<0;
		}
		/**
		 * 返回渲染后的bitmap
		 * */
		public function get display():Image
		{
			return this._canvas;
		}
		
		protected var _direction:int=-1;
		protected var _rawSource:*;
		protected var _sourceArr:Array;
		//源显示对象
		protected var _sourceDisplay:DisplayObject;
		//二进制显示对象
		protected var _canvas:Image;
		
		protected var _currentSource:*;
		protected var _directionInvalidated:Boolean;
		
		protected var _needFlip:Boolean;
//		protected var _lastFlipped:Boolean;
		protected var _correctDirect:int;
	}
}