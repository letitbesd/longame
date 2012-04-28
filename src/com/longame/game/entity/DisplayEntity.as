package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.IComponent;
	import com.longame.game.core.IEntity;
	import com.longame.game.core.IGroup;
	import com.longame.game.core.bounds.EntityBounds;
	import com.longame.game.core.bounds.IBounds;
	import com.longame.game.core.bounds.TileBounds;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.IScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.managers.InputManager;
	import com.longame.model.consts.Registration;
	import com.longame.utils.StringParser;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	
	use namespace long_internal;

	/**
	 * 具有图形元素的个体，如场景中的显示个体，当active时，此对象被添加到现实列表，deactive时，此对象被删除，待考虑，这样可能有点不好
	 * 注意：为了提高效率，默认鼠标是被禁止了的，如果要用鼠标，请用mouseEnabled=true
	 * */
	public class DisplayEntity extends AbstractEntity implements IDisplayEntity
	{
		/**
		 * 是否用场景到屏幕的坐标转换，除了IScene之外，其它一定是true，不用改之
		 * */
		long_internal var useAxisTransformation:Boolean=true;
		/**
		 * @param id:id
		 * @param source:图像来源，见GameDisplay的source
		 * */
		public function DisplayEntity(id:String=null)
		{
			super(id);
			_container=new Sprite();
		}
		final public function render():void
		{
			if((!_actived)||(!_visible)) return;
			this.doRender();
		}
		protected function doRender():void
		{
			this.validatePosition();
			this.validateScale();
		    this.validateRotation();
            this.validateSize();
		}
		protected function validatePosition():void
		{
			if(!_positionInvalidated)  return;
			var screenPt:Vector3D=new Vector3D(_x,_y,_z);
			if(useAxisTransformation) screenPt=SceneManager.sceneToScreen(screenPt);
			container.x=screenPt.x+_offsetX;
			container.y=screenPt.y+_offsetY;
			_positionInvalidated=false;	
			if(_onMove) _onMove.dispatch(this);
		}
		protected function validateScale():void
		{
			if(!_scaleInvalidated) return;
			container.scaleX=_scaleX;
			container.scaleY=_scaleY;	
			_scaleInvalidated=false;
			if(_onScale) _onScale.dispatch(this);
		}
		protected function validateRotation():void
		{
			if(!_rotationInvalidated) return;
			container.rotation=_rotation;
			_rotationInvalidated=false;
			if(_onRotate) _onRotate.dispatch(this);
		}
		protected function validateSize():void
		{
			if(!_sizeInvalidated) return;
			_sizeInvalidated=false;
			if(_onResize) _onResize.dispatch(this);
		}
//		override public function destroy():void
//		{
//			if(destroyed) return;
//			super.destroy();
//			this.mouseEnabled=false;
//			this._container=null;
//			if(this._tileBounds) {
//				this._tileBounds.destroy();
//				this._tileBounds=null;
//			}
//		}
		
		public function globalToLocal(p:Point,tiled:Boolean=false):Vector3D
		{
			var p0:Vector3D=new Vector3D();
			if(tiled){
				p0.x=p.x;
				p0.y=p.y;
				if( !(this is IScene) ){
					var dp:Point=localToGlobal(new Vector3D(this.tileBounds.x,this.tileBounds.y),true);
					p0.x-=dp.x;
					p0.y-=dp.y;					
				}
			}else{
				p= this.container.globalToLocal(p);
				p0.x=p.x;
				p0.y=p.y;
				p0=SceneManager.screenToScene(p0);
			}
			return p0;
		}
		public function localToGlobal(p:Vector3D,tiled:Boolean=false):Point
		{
			var p0:Point=new Point();
			if(tiled){
				var dp:Point=SceneManager.getTileOffsetBetween(this,this.scene);
				p0.x=p.x+dp.x+this.tileBounds.x;
				p0.y=p.y+dp.y+this.tileBounds.y;
			}else{
				p=SceneManager.sceneToScreen(p);
				p0.x=p.x;
				p0.y=p.y;
				p0=this.container.localToGlobal(p0);				
			}
			return p0;
		}
		override protected function whenActive():void
		{
			_scene=getScene();
			//如果是单个显示个体，将其添加到scene的map中
			if(_scene&&(!(this is IDisplayGroup))){
				if(_scene.map) _scene.map.addChild(this);
			}
			//如果父亲是要自动深度排序的，将其添加到map中
			if(parent&&(parent!=_scene)&&parent.autoLayout) {
				if(this.parent.map) this.parent.map.addChild(this);
			}
			super.whenActive();
			if((_owner is IDisplayRenderer)){//&&(!(_owner as IDisplayRenderer).container.contains(this.container))){
				(_owner as IDisplayRenderer).container.addChild(container);
			} 
			//如果发现物体尺寸为-1，自动给默认的尺寸为场景的tile大小
			if(this._width==-1)  this.width=SceneManager.tileSize;
			if(this._length==-1) this.length=SceneManager.tileSize;
			if(this._height==-1) this.height=SceneManager.tileSize;
			
			if(parent is BaseScene) (parent as BaseScene).updateParallaxChild(this);
		}
		override protected function whenDeactive():void
		{
			if(_owner is IDisplayRenderer){
				var con:Sprite=(_owner as IDisplayRenderer).container;
				if(con.contains(container)) con.removeChild(container);
			}
			//如果是单个显示个体，将其从scene的map中删除
			if(_scene&&(!(this is IDisplayGroup))){
				if(_scene.map) _scene.map.removeChild(this);
			}
			//如果父亲是要自动深度排序的，将其从map中删除
			if(parent&&(parent!=_scene)&&parent.autoLayout) {
				if(this.parent.map) this.parent.map.removeChild(this);
			}
			super.whenDeactive();
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			this._container.dispose();
			this._container=null;
			if(this._tileBounds) {
				this._tileBounds.destroy();
				this._tileBounds=null;
			}
			_onRotate=null;
			_onScale=null;
			_onMove=null;
			_onResize=null;
			_scene=null;
		}
		/**
		 * 通过tileBounds控制onTileMove信号分发
		 * @param delta: x，y方向上的移动量
		 * */
		long_internal function notifyTileMove(delta:Point):void
		{
			//如果是单个显示个体，将其在scene中的map中更新
			if(_scene&&(!(this is IDisplayGroup)))
			{
				if(_scene.map) _scene.map.moveChild(this,delta);
			}
			if(parent&&(parent!=_scene)&&parent.autoLayout) {
				if(this.parent.map) this.parent.map.moveChild(this,delta);
			}
			if(_onTileMove) _onTileMove.dispatch(this,delta);
		}
		/**
		 * 通过tileBounds控制onTileBoundsChange信号分发
		 * */
		long_internal function notifyTileBoundsChange():void
		{
			//如果是单个显示个体，将其在scene中的map中更新
			if(_scene&&(!(this is IDisplayGroup))){
				if(this._scene.map) _scene.map.changeChild(this);
			}
			if(parent&&(parent!=_scene)&&parent.autoLayout) {
				if(this.parent.map) this.parent.map.changeChild(this);
			}
			if(this._onTileBoundsChange) this._onTileBoundsChange.dispatch(this);
		}
		/***getters**/
		public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_sizeInvalidated;
		}
		public function get container():Sprite
		{
			return _container;
		}
		public function get scene():IScene
		{
			return _scene;
		}
		public function get parent():IDisplayGroup
		{
			return _owner as IDisplayGroup;
		}
		public function get stage():Stage
		{
			return _container.stage;
		}
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x==value) return;
			_x=value;
			this.tileBounds.move();
			this._positionInvalidated=true;
		}
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y==value) return;
			_y=value;
			this.tileBounds.move();
			this._positionInvalidated=true;
		}
		public function get z():Number
		{
			return _z;
		}
		public function set z(value:Number):void
		{
			if(_z==value) return;
			_z=value;
			this.tileBounds.move();
			this._positionInvalidated=true;
		}
		public function get offsetX():Number
		{
			return _offsetX;
		}
		public function set offsetX(value:Number):void
		{
			if(_offsetX==value) return;
			_offsetX=value;
			this.tileBounds.move();
			this._positionInvalidated=true;
		}
		public function get offsetY():Number
		{
			return _offsetY;
		}
		public function set offsetY(value:Number):void
		{
			if(_offsetY==value) return;
			_offsetY=value;
			this.tileBounds.move();
			this._positionInvalidated=true;
		}
		public function get rotation():Number
		{
			return _rotation;
		}
		public function set rotation(value:Number):void
		{
			if(_rotation==value) return;
			_rotation=value;
			_rotationInvalidated=true;
		}
		public function get scaleX():Number
		{
			return _scaleX;
		}
		public function set scaleX(value:Number):void
		{
			if(_scaleX==value) return;
			_scaleX=value;
			this.offsetX*=value;
			this._scaleInvalidated=true;
		}
		public function get scaleY():Number
		{
			return _scaleY;
		}
		public function set scaleY(value:Number):void
		{
			if(_scaleY==value) return;
			_scaleY=value;
			this.offsetY*=value;
			this._scaleInvalidated=true;
		}
		public function get visible():Boolean
		{
			return _visible;
		}
		public function set visible(value:Boolean):void
		{
			if(_visible==value) return;
			_visible=value;
			_container.visible=_visible
		}
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if(value==_width) return;
			_width=value;
			this.tileBounds.resize();
			this._sizeInvalidated=true;
		}
		public function get length():Number
		{
			return _length;
		}
		public function set length(value:Number):void
		{
			if(value==_length) return;
			_length=value;
			this.tileBounds.resize();
			this._sizeInvalidated=true;
		}
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			if(value==_height) return;
			_height=value;
			this.tileBounds.resize();
			this._sizeInvalidated=true;
		}
		public function get depth():int
		{
			if(parent==null) return -1;
			return parent.getChildIndex(this);
		}
		/**tile about**/
		public function get indexTile():EntityTile
		{
			//todo,貌似有时候拿不到
			return this.parent.map.getTile(tileBounds.x,tileBounds.y) as EntityTile;
		}
		protected var _tileBounds:TileBounds;
		public function get tileBounds():TileBounds
		{
			if(_tileBounds==null) _tileBounds=new TileBounds(this);
			return _tileBounds;
		}
		protected var _includeInLayout:Boolean=true;
		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}
		public function set includeInLayout(value:Boolean):void
		{
			if(_includeInLayout==value) return;
			_includeInLayout=value;
		}
		protected var _alwaysInTop:Boolean=false;
		public function get alwaysInTop():Boolean
		{
			return _alwaysInTop;
		}
		public function set alwaysInTop(value:Boolean):void
		{
			if(_alwaysInTop==value) return;
			if(this.parent){
				if(value){
					this.parent.map.bringToTop(this);
				}else{
					this.parent.map.notBringToTop(this);
				}
			}
			_alwaysInTop=value;
		}
		protected var _includeInBounds:Boolean=true;
		public function get includeInBounds():Boolean
		{
			return _includeInBounds;
		}
		public function set includeInBounds(value:Boolean):void
		{
			if(_includeInBounds==value) return;
			_includeInBounds=value;
		}
		public function getSnappedPosition():Point
		{
			return SceneManager.getTiledPosition(new Point(this.x,this.y),this.centerWhenSnapToX,this.centerWhenSnapToY);
		}
		public function getSnappedPositionInTile(tx:int,ty:int):Point
		{
			return SceneManager.getTilePosition(tx,ty,this.centerWhenSnapToX,this.centerWhenSnapToY);
		}
		public function autoSnap():void
		{
			var p0:Point=this.getSnappedPosition();
			this.x=p0.x;
			this.y=p0.y;
		}
		public function snapToTile(tx:int,ty:int):void
		{
			var p0:Point=getSnappedPositionInTile(tx,ty);
			this.x=p0.x;
			this.y=p0.y;
		}
		/**
		 * 如果x方向上的尺寸是奇数个单元格，则吸附到单元格x方向上的几何中点
		 * 否则，吸附到单元格原点
		 * todo 在size发生改变的时候计算，不然每次都计算？
		 * */
		private function get centerWhenSnapToX():Boolean
		{
			//奇数个cell尺寸，则居中，否则不居中
			var centerX:Boolean;
			//游戏物品注册点要求在几何中心，地图编辑器也是要调整到这种状态的
			if(this.registration==Registration.CENTER){
				centerX=(Math.round(this.width/SceneManager.tileSize)%2!=0);
			}	
			return centerX;
		}
		/**
		 * 如果y方向上的尺寸是奇数个单元格，则吸附到单元格y方向上的几何中点
		 * 否则，吸附到单元格原点
		 * */
		private function get centerWhenSnapToY():Boolean
		{
			//奇数个cell尺寸，则居中，否则不居中
			var centerY:Boolean;
			//游戏物品注册点要求在几何中心，地图编辑器也是要调整到这种状态的
			if(this.registration==Registration.CENTER){
				centerY=(Math.round(this.length/SceneManager.tileSize)%2!=0);				
			}		
			return centerY;
		}
		/**tile about**/
		public function get registration():String
		{
			return _registration;
		}
		public function set registration(value:String):void
		{
			if(_registration==value) return;
			Registration.validate(value);
			_registration=value;
			//todo
		}	
		public function get walkable():Boolean
		{
			return _walkable;
		}
		public function set walkable(value:Boolean):void
		{
			if(_walkable==value) return;
			_walkable=value;
			//dispatch?
		}
		public function get bounds():IBounds
		{
			if(_bounds==null) _bounds=new EntityBounds(this);
			return _bounds;
		}
		public function get parallax():Number
		{
			return _parallax;
		}
		public function set parallax(value:Number):void
		{
			if(_parallax==value) return;
			_parallax=value;
			if(this.parent is BaseScene) (this.parent as BaseScene).updateParallaxChild(this);
		}
		public function get mouseTile():Point
		{
			//TODO
			return null;
//			var mx:Number=this.container.mouseX;
//			var my:Number=this.container.mouseY;
//			var pt:Vector3D=SceneManager.screenToScene(new Vector3D(mx,my,0));
//			return SceneManager.getTileIndex(pt.x,pt.y);
		}
		protected var _onMove:Signal;
		public function get onMove():Signal
		{
			if((_onMove==null)&&!disposed) _onMove=new Signal(IDisplayEntity);
			return _onMove;
		}
		protected var _onTileMove:Signal;
		public function get onTileMove():Signal
		{
			if((_onTileMove==null)&&!disposed) _onTileMove=new Signal(IDisplayEntity,Point);
			return _onTileMove;
		}
		protected var _onRotate:Signal;
		public function get onRotate():Signal
		{
			if((_onRotate==null)&&!disposed) _onRotate=new Signal(IDisplayEntity);
			return _onRotate;
		}
		protected var _onScale:Signal;
		public function get onScale():Signal
		{
			if((_onScale==null)&&!disposed) _onScale=new Signal(IDisplayEntity);
			return _onScale;
		}
		protected var _onResize:Signal;
		public function get onResize():Signal
		{
			if((_onResize==null)&&!disposed) _onResize=new Signal(IDisplayEntity);
			return _onResize;
		}
		protected var _onTileBoundsChange:Signal;
		public function get onTileBoundsChange():Signal
		{
			if((_onTileBoundsChange==null)&&!disposed) _onTileBoundsChange=new Signal(IDisplayEntity);
			return _onTileBoundsChange;
		}
		protected var _onDepthChanged:Signal;
		public function get onDepthChanged():Signal
		{
			if((_onDepthChanged==null)&&!disposed) _onDepthChanged=new Signal(IDisplayEntity,int,int);
			return _onDepthChanged;
		}
		/**private functions*/
		private function getScene():IScene
		{
			var p:IDisplayGroup=this.parent;
			while(p){
				if(p is IScene) return p as IScene;
				p=p.parent;
			}
			return null;
		}
		/**private vars**/
		protected var _container:Sprite;
		protected var _index:int=0;
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _z:Number=0;
		protected var _width:Number=-1;
		protected var _length:Number=-1;
		protected var _height:Number=-1;
		protected var _scaleX:Number=1;
		protected var _scaleY:Number=1;
		protected var _offsetX:Number=0;
		protected var _offsetY:Number=0;
		protected var _rotation:Number=0;
		protected var _visible:Boolean=true;
		protected var _parallax:Number=1.0;
		
		protected var _registration:String=Registration.CENTER;
		long_internal var _bounds:IBounds;
		
		protected var _positionInvalidated:Boolean;
		protected var _scaleInvalidated:Boolean;
		protected var _rotationInvalidated:Boolean;
		protected var _sizeInvalidated:Boolean;
		protected var _scene:IScene;
		
		protected var _walkable:Boolean;
	}
}