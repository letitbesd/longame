package com.longame.game.scene
{
	import com.longame.core.long_internal;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.IComponent;
	import com.longame.game.core.IEntity;
	import com.longame.game.entity.CharactersMap;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.IParallax;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;

	use namespace long_internal;
	/**
	 * 场景基类
	 * */
	public class BaseScene extends DisplayGroup implements IScene
	{
		protected var _mask:Shape;
		
		/**
		 * 游戏场景
		 * @param sceneType: 场景类型，目前有GameScene.D2和GameScene.D25两种，既2D场景和2.5D场景
		 * @param tileSize:  场景采用方格管理，根据场景类物体的大小尺寸来设定这个单元格尺寸，这个在2.5D场景很重要
		 * @param useTileMap:场景是否使用tileMap管理，对于有人物寻路的场景一定要用true
		 * @param autoLayout:场景是否采用自动深度排序，如果场景分层，用true也无意义，如果只是一个简单的场景，里面无group嵌套，请用true
		 * */
		public function BaseScene(sceneType:String=SceneManager.D2,tileSize:uint=40,useTileMap:Boolean=true,autoLayout:Boolean=false)
		{
			SceneManager.init(tileSize,sceneType,useTileMap);
			super("scene",autoLayout);
			useAxisTransformation=false;
		}
		protected var _view:DisplayObjectContainer;
		/**
		 * 创建场景，只有执行这个之后，场景才正式运转
		 * @param view: 场景容器，
		 * @param lensRect:虚拟镜头的矩形范围，以舞台剧全局坐标为基点，不指定则以舞台大小为准
		 * 之后通过scene.camera来控制场景的移动缩放等
		 * 注意：2.5D场景最好有一个大的背景图，这样camera会将镜头的范围限制在背景图范围内，比如拖场景的时候，如果只是一个菱形的地图，范围限制会不理想
		 * */
		public function setup(view:DisplayObjectContainer,lensRect:Rectangle=null):void
		{
			if(_view!=null) {
				Logger.warn(this,"setup","The scene has setupped!");
				return;
			}
			_view=view;
			view.addChild(this.container);
			if(lensRect==null){
				lensRect=new Rectangle(0,0,Engine.nativeStage.stageWidth,Engine.nativeStage.stageHeight);
			}
			_camera=new Camera("camera");
			_camera.initialize(lensRect);
			this.add(_camera);
			this.createMask();
			this.active(null);
		}
		public function onFrame(deltaTime:Number):void
		{
			this.render();
		}
//		override long_internal function activeChild(child:IComponent, refresh:Boolean=true):void
//		{
//			super.activeChild(child,refresh);
//			if(child is IDisplayEntity){
//				if((child as IDisplayEntity).parallax!=1.0) this._parallaxChildren.push(child as IDisplayEntity);
//			}
//		}
//		override long_internal function deactiveChild(child:IComponent, refresh:Boolean=true):void
//		{
//			super.deactiveChild(child,refresh);
//			if((child is IDisplayEntity)&&((child as IDisplayEntity).parallax!=1.0)){
//				var i:int=this._parallaxChildren.indexOf(child as IDisplayEntity);
//				if(i>-1) this._parallaxChildren.splice(i,1);
//			}
//		}
		long_internal function updateParallaxChild(child:IDisplayEntity):void
		{
			var i:int=this._parallaxChildren.indexOf(child);
			if((child as IDisplayEntity).parallax!=1.0) {
				if(i==-1) this._parallaxChildren.push(child as IDisplayEntity);
			}else{
				if(i>-1) this._parallaxChildren.splice(i,1);
			}
		}
		override protected function whenActive():void
		{
			super.whenActive();
			ProcessManager.addAnimatedObject(this);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			ProcessManager.removeAnimatedObject(this);
		}
		private var _origin:SceneOrigin;
		/**
		 * 是否显示坐标系原点
		 * */
		public function setOriginVisible(value:Boolean):void
		{
			if(value){
				if(_origin==null) {
					_origin=new SceneOrigin("origin");
					this.add(_origin);
				}
			}else{
				if(_origin){
					_origin.dispose();
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
//		override public function destroy():void
//		{
//			_view.removeChild(this.container);
//			this.deactive();
//			_view=null;
//			_camera=null;
//			_parallaxChildren=null;
//			super.destroy();
//		}
		override protected function whenDispose():void
		{
			_view.removeChild(this.container);
			this.deactive();
			super.whenDispose();
			_view=null;
			_camera=null;
			_parallaxChildren=null;
		}
		protected var _camera:Camera;
		/**
		 * 虚拟镜头用于场景的缩放，聚焦，跟随，旋转甚至一些颜色滤镜效果
		 * */
		public function get camera():Camera
		{
			return _camera;
		}
		/**
		 * 只显示镜头范围类的东西
		 * */
		private function createMask():void
		{
			//TODO
//			_mask=new Shape();
//			_mask.graphics.beginFill(0x0);
//			_mask.graphics.drawRect(_camera.bounds.x,_camera.bounds.y,_camera.bounds.width,_camera.bounds.height);
//			_mask.graphics.endFill();
//			_view.addChild(_mask);
//			_container.mask=_mask;
		}
		override public function get indexTile():EntityTile
		{
			throw new Error("You can not access this property of IScene!");
		}
		private var _parallaxChildren:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		public function get parallaxChildren():Vector.<IDisplayEntity>
		{
			return _parallaxChildren;
		}
	}
}