package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.display.core.OnceClip;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.ObjectUtil;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;
	
	/**
	 * 只播放一次就over的实体，像特效。。。
	 * */
	public class OnceClipEntity extends DisplayEntity
	{
//		public static const DO_NOTHING:String="do_nothing";
		public static const AUTO_DESTROY:String="auto_destroy";
		public static const AUTO_REMOVE:String="auto_remove";
		/**
		 * 播放完毕监听
		 * */
		public var onOver:Signal=new Signal(OnceClipEntity);
		private var doWhenOver:String;
		
		/**
		 * type决定对象是否在结束时是否destroy/remove
		 * 参照OnceClipEntity.AUTO_DESTROY
		 *     OnceClipEntity.AUTO_REMOVE
		 * */
		public function OnceClipEntity(doWhenOver:String=OnceClipEntity.AUTO_DESTROY,id:String=null)
		{
			this.doWhenOver=doWhenOver;
			super(id);
		}
		override public function get container():Sprite
		{
			return _container;
		}
		public function get clip():OnceClip
		{
			return _container as OnceClip;
		}
		private function onClipOver(clip:OnceClip):void
		{
			if(doWhenOver==OnceClipEntity.AUTO_DESTROY) {
				this.destroy();
			}
			else if(doWhenOver==OnceClipEntity.AUTO_REMOVE){
				if(this.parent) this.parent.remove(this);
			}
			onOver.dispatch(this);
		}
		override protected function doWhenActive():void
		{
			if(_container) (_container as OnceClip).buildFromMovieClip(_source,_renderAsBitmap);
			super.doWhenActive();
		}
		override public function destroy():void
		{
			if(destroyed) return;
			(_container as OnceClip).destroy();
			super.destroy();
		}
		override protected function doRender():void
		{
			if(_sourceInvalidated){
				(_container as OnceClip).buildFromMovieClip(_source,_renderAsBitmap);
				_sourceInvalidated=false;
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
		public function get source():*
		{
			return _source;
		}
		public function set source(value:*):void
		{
			if(_source==value) return;
			_source=value;
			if(!(_container is SpriteEntity)) {
				createView();
			}
			_sourceInvalidated=true;
		}
		protected function createView():void
		{
			if(_source==null) throw new Error("The source for a OnceClipEntity couldn't be null!");
			_container=new OnceClip(this.doWhenOver==OnceClipEntity.AUTO_DESTROY);
			(_container as OnceClip).onOver.add(onClipOver);
			/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
			_container.mouseEnabled=_container.mouseChildren=false;	
			_container.tabEnabled=false;
		}
		override public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_sourceInvalidated;
		}
		public function set renderAsBitmap(value:Boolean):void
		{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			if(actived) (_container as OnceClip).renderAsBitmap=value;
		}
		public function get renderAsBitmap():Boolean
		{
			return _renderAsBitmap;
		}
		protected var _source:*;
		protected var _sourceInvalidated:Boolean;
		protected var _renderAsBitmap:Boolean=false;
	}
}