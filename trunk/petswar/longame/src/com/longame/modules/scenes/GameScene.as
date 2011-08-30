package com.longame.modules.scenes
{
	import com.longame.core.long_internal;
	import com.longame.display.Camera;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.entities.CharactersMap;
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
		 * @param autoLayout:场景是否采用自动深度排序，如果场景分层，用true也无意义，如果只是一个简单的场景，里面无group嵌套，请用true
		 * */
		public function GameScene(sceneType:String=SceneManager.D2,tileSize:uint=40,autoLayout:Boolean=false)
		{
			SceneManager.init(tileSize,sceneType);
			this._type=sceneType;
			this._tileSize=tileSize;
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
			this.active(null);
			_view=view;
			view.addChild(this.container);
			_camera=new Camera(this.container,lensRect,700,500);
			this.createMask();
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
			CharactersMap.update();
		}
		override public function destroy():void
		{
			_view.removeChild(this.container);
			this.deactive();
			_view=null;
			_camera=null;
			super.destroy();
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
		override public function get indexTile():EntityTile
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
	}
}