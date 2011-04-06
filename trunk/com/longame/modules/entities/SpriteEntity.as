package com.longame.modules.entities
{
	import flash.display.Sprite;
	
	import com.longame.core.long_internal;
	import com.longame.display.GameSprite;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.resource.database.ItemDatabase;
	import com.longame.utils.ObjectUtil;

	use namespace long_internal;

	public class SpriteEntity extends DisplayEntity
	{
		public function SpriteEntity(id:String=null)
		{
			super(id);
		}
		override public function get container():Sprite
		{
			if(_container==null)
			{
				if(_source==null) throw new Error("The source for a SpriteEntity couldn't be null!");
				_container=new GameSprite(_source);
				/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
				_container.mouseEnabled=_container.mouseChildren=false;	
				_container.tabEnabled=false;
			}
			return _container;
		}
		override protected function doRender():void
		{
			if(_sourceInvalidated){
				(_container as GameSprite).source=_source;
				_sourceInvalidated=false;
			}
			if(_directionInvalidated){
				(_container as GameSprite).direction=_direction;
				_directionInvalidated=false;
			}
			super.doRender();
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
		public function get source():String
		{
			return _source;
		}
		public function set source(value:String):void
		{
			if(_source==value) return;
			_source=value;
			_sourceInvalidated=true;
		}
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_directionInvalidated||_sourceInvalidated;
		}
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
			if(_direction==value) return;
			_direction=value;
			_directionInvalidated=true;
		}
		protected var _direction:int=Direction.UP;
		protected var _directionInvalidated:Boolean;
		protected var _source:String;
		protected var _sourceInvalidated:Boolean;
	}
}