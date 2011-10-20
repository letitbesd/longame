package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.display.GameSprite;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.ObjectUtil;
	import com.xingcloud.items.ItemDatabase;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	use namespace long_internal;

	public class SpriteEntity extends DisplayEntity
	{
		public var effects:Vector.<BitmapEffect>=new Vector.<BitmapEffect>();
		
		public function SpriteEntity(id:String=null)
		{
			super(id);
			_container=null;
		}
		override public function get container():Sprite
		{
			return _container;
		}
		protected function createView():void
		{
			if(_source==null) throw new Error("The source for a SpriteEntity couldn't be null!");
			_container=new GameSprite(_renderAsBitmap);
			/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
			_container.mouseEnabled=_container.mouseChildren=false;	
			_container.tabEnabled=false;
		}
		override protected function doRender():void
		{
//			if(_sourceInvalidated){
//				(_container as GameSprite).source=_source;
//				_sourceInvalidated=false;
//			}
			(_container as GameSprite).source=_source;
//			if(_directionInvalidated){
//				(_container as GameSprite).direction=_direction;
//				_directionInvalidated=false;
//			}
			(_container as GameSprite).direction=_direction;
			(_container as GameSprite).effects=this.effects;
			super.doRender();
		}
		override public function destroy():void
		{
			if(destroyed) return;
			(_container as GameSprite).destroy();
			super.destroy();
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
			return _source;
		}
		public function set source(value:*):void
		{
//			if(_source==value) return;
			_source=value;
			if(!(_container is GameSprite)) this.createView();
//			_sourceInvalidated=true;
		}
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated;//||_directionInvalidated||_sourceInvalidated;
		}
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
//			if(_direction==value) return;
			_direction=value;
//			_directionInvalidated=true;
		}
		public function set renderAsBitmap(value:Boolean):void
		{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			if(actived) (_container as GameSprite).renderAsBitmap=value;
		}
		public function get renderAsBitmap():Boolean
		{
			return _renderAsBitmap;
		}
		protected var _direction:int=-1;
//		protected var _directionInvalidated:Boolean;
		protected var _source:*;
//		protected var _sourceInvalidated:Boolean;
		protected var _renderAsBitmap:Boolean=false;
	}
}