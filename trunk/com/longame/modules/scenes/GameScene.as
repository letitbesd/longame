package com.longame.modules.scenes
{
	import com.longame.core.long_internal;
	import com.longame.display.Camera;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.entities.display.primitive.LGRectangle;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	use namespace long_internal;
	/**
	 * 场景基类
	 * */
	public class GameScene extends DisplayGroup implements IScene
	{
		protected var _mask:Shape;
		
		/**
		 * 游戏场景
		 * @param sceneType: 场景类型，目前有GameScene.D2和GameScene.D25两种，既2D场景和2.5D场景
		 * @param tileSize:  场景采用方格管理，根据场景类物体的大小尺寸来设定这个单元格尺寸，这个在2.5D场景很重要
		 * @param autoLayout:场景是否采用自动深度排序，这个对于2.5D场景很重要
		 * */
		public function GameScene(sceneType:String=SceneManager.D2,tileSize:uint=40,autoLayout:Boolean=true)
		{
			SceneManager.init(tileSize,sceneType);
			this._type=sceneType;
			this._tileSize=tileSize;
//			this._physicsEnabled=physicsEnabled;
			super("scene",autoLayout);
			useAxisTransformation=false;
		}
		protected var _view:DisplayObjectContainer;
		public function setup(view:DisplayObjectContainer,lensRect:Rectangle):void
		{
			if(_view!=null) {
				Logger.warn(this,"setup","The scene has setupped!");
				return;
			}
			_view=view;
			view.addChild(this.container);
			_camera=new Camera(this.container,lensRect,880,440);
			this.createMask();
			this.active();
		}
		private var _origin:SceneOrigin;
		public function setOriginVisible(value:Boolean):void
		{
			if(value){
				if(_origin==null) {
					_origin=new SceneOrigin("origin");
					this.add(_origin);
				}
			}else{
				if(_origin){
					_origin.destroy();
					_origin=null;
				}
			}
		}
		override protected function doRender():void
		{
			super.doRender();
			if(_camera) _camera.render();
		}
		override public function destroy():void
		{
			this.deactive();
			_view.removeChild(this.container);
			_view=null;
			_camera=null;
//			if(_box2dWorld) this._box2dWorld.destroy();
//			_box2dWorld=null;
			super.destroy();
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
//			if(this._physicsEnabled){
//				if(_box2dWorld==null) _box2dWorld=new Box2DWorld(this.container);
//				_box2dWorld.start();
//			}
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
//			if(_box2dWorld) _box2dWorld.stop();
		}
		protected var _camera:Camera;
		public function get camera():Camera
		{
			return _camera;
		}
		/**
		 * 只显示镜头范围类的东西
		 * */
		private function createMask():void
		{
			_mask=new Shape();
			_mask.graphics.beginFill(0x0);
			_mask.graphics.drawRect(_camera.bounds.x,_camera.bounds.y,_camera.bounds.width,_camera.bounds.height);
			_mask.graphics.endFill();
			_view.addChild(_mask);
			_container.mask=_mask;
		}
		override public function get tile():EntityTile
		{
			throw new Error("You can not access this property of IScene!");
		}
//		override public function get scene():IGameScene
//		{
//			return this;
//		}
		protected var _type:String;
		public function get type():String
		{
			return _type;
		}
		protected var _tileSize:uint;
		public function get tileSize():uint
		{
			return _tileSize;
		}
//		protected var _physicsEnabled:Boolean;
//		public function get physicsEnabled():Boolean
//		{
//			return _physicsEnabled;
//		}
//		protected var _box2dWorld:Box2DWorld;
//		
//		public function get box2dWorld():Box2DWorld
//		{
//			if(!_physicsEnabled) {
//				Logger.warn(this,"get box2dWorld","If you want to use box2dWorld,please set phyiscsEnabled property to true when you create the GameScene!");
//				return null;
//			}
//			return _box2dWorld;
//		}
	}
}