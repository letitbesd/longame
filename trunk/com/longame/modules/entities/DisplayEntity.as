package com.longame.modules.entities
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import com.longame.core.long_internal;
	import com.longame.display.GameAnimator;
	import com.longame.display.core.IAnimatorRenderer;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.managers.InputManager;
	import com.longame.model.MathVector;
	import com.longame.model.consts.Registration;
	import com.longame.model.signals.MouseSignals;
	import com.longame.model.signals.SignalBus;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.core.bounds.EntityBounds;
	import com.longame.modules.core.bounds.IBounds;
	import com.longame.modules.core.bounds.TileBounds;
	import com.longame.modules.entities.display.primitive.TileHilighter;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.IScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.StringParser;
	import com.longame.utils.debug.Logger;
	
	import org.osflash.signals.Signal;
	
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
		 * 是否注册全局信号
		 * */
		long_internal function get registerGlobalSiganl():Boolean
		{
			return true;
		}
		/**
		 * @param id:id
		 * @param source:图像来源，见GameDisplay的source
		 * */
		public function DisplayEntity(id:String=null)
		{
			super(id);
			registerSignalBus()
		}
		public function render():void
		{
			if(!_actived) return;
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
		override public function destroy():void
		{
			if(destroyed) return;
			this.mouseEnabled=false;
			super.destroy();
		}
		public function globalToLocal(p:Point,tiled:Boolean=false):Vector3D
		{
			var p0:Vector3D=new Vector3D();
			if(tiled){
				p0.x=p.x;
				p0.y=p.y;
				if( !(this is IScene) ){
					var dp:Point=localToGlobal(new Vector3D(this.tile.x,this.tile.y),true);
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
				p0.x=p.x;
				p0.y=p.y;
				var parent:IEntity=this.owner;
				while(parent){
					if(!(parent is IDisplayEntity)) break;
					if(parent is IScene) break;
					p0.x+=(parent as IDisplayEntity).tile.x;
					p0.y+=(parent as IDisplayEntity).tile.y;
					parent=parent.owner;
				}
			}else{
				p=SceneManager.sceneToScreen(p);
				p0.x=p.x;
				p0.y=p.y;
				p0=this.container.localToGlobal(p0);				
			}
			return p0;
		}
		/**
		 * 注册几个全局信号
		 * */
		protected function registerSignalBus():void
		{
			if(!registerGlobalSiganl) return;
//			SignalBus.register(this.onMove,"onDisplayEntityMove");
			SignalBus.register(this.onTileMove,"onDisplayEntityTileMove");
			SignalBus.register(this.onTileBoundsChange,"onDisplayEntityBoundsChange");
//			SignalBus.register(this.onResize,"onDsiplayEntityResize");
			SignalBus.register(this.onActive,"onDisplayEntityActive");
			SignalBus.register(this.onDeactive,"onDisplayEntityDeactive");
		}
		/**
		 * 注销几个全局信号
		 * */
		protected function unregisterSignalBus():void
		{
			if(!registerGlobalSiganl) return;
//			SignalBus.unregister(this.onMove,"onDisplayEntityMove");
			SignalBus.unregister(this.onTileMove,"onDisplayEntityTileMove");
			SignalBus.unregister(this.onTileBoundsChange,"onDisplayEntityBoundsChange");
//			SignalBus.unregister(this.onResize,"onDsiplayEntityResize");
			SignalBus.unregister(this.onActive,"onDisplayEntityActive");
			SignalBus.unregister(this.onDeactive,"onDisplayEntityDeactive");			
		}
		override public function removeSignals():void
		{
			super.removeSignals();
			this.unregisterSignalBus();
			if(_onMouse) _onMouse.removeAll();
			if(_onRotate) _onRotate.removeAll();
			if(_onScale) _onScale.removeAll();
			if(_onMove) _onMove.removeAll();
			if(_onResize) _onResize.removeAll();
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			if((_owner is IDisplayRenderer)&&(!(_owner as IDisplayRenderer).container.contains(this.container))){
				(_owner as IDisplayRenderer).container.addChild(container);
			} 
			_scene=getScene();
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			if(_owner is IDisplayRenderer){
				var con:Sprite=(_owner as IDisplayRenderer).container;
				if(con.contains(container)) con.removeChild(container);
			}
			_scene=null;
		}
		
		/***getters**/
		public function get invalidated():Boolean
		{
			return _positionInvalidated||_scaleInvalidated||_rotationInvalidated||_sizeInvalidated;
		}
		public function get container():Sprite
		{
			if(_container==null){
				_container=new Sprite();
				/**不依靠自身的mouseEnable来响应鼠标事件，禁止之，用inputManager来统一管理，提高效率**/
				_container.mouseEnabled=container.mouseChildren=false;		
				_container.tabEnabled=false;
			}
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
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x==value) return;
			_x=value;
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
			this._scaleInvalidated=true;
		}
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			if(value==_width) return;
			_width=value;
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
			this._sizeInvalidated=true;
		}
		public function get depth():int
		{
			if(parent==null) return -1;
			return parent.getChildIndex(this);
		}
		/**tile about**/
		public function get tile():EntityTile
		{
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
			if(_onLayoutStateChange) _onLayoutStateChange.dispatch(this);
		}
		public function autoSnap():void
		{
			var p0:Point=SceneManager.getTiledPosition(new Point(this.x,this.y),this.centerWhenSnapToX,this.centerWhenSnapToY);
			this.x=p0.x;
			this.y=p0.y;
		}
		public function snapToTile(tx:int,ty:int):void
		{
			var p0:Point=SceneManager.getTilePosition(tx,ty,this.centerWhenSnapToX,this.centerWhenSnapToY);
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
		protected var _onMouse:MouseSignals;
		public function get onMouse():MouseSignals
		{
			if(_onMouse==null) _onMouse=new MouseSignals();
			return _onMouse;
		}
		protected var _mouseEnabled:Boolean;
		public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}
		public function set mouseEnabled(value:Boolean):void
		{
			if(_mouseEnabled==value) return;
			_mouseEnabled=value;
			this.container.mouseEnabled=value;
			this.container.mouseChildren=value;
			if(value){
				InputManager.registerMouseObject(this,this.container);
			}else{
				InputManager.unregisterMouseObject(this);
			}
		}
		protected var _onMove:Signal;
		public function get onMove():Signal
		{
			if(_onMove==null) _onMove=new Signal(IDisplayEntity);
			return _onMove;
		}
		protected var _onTileMove:Signal;
		public function get onTileMove():Signal
		{
			if(_onTileMove==null) _onTileMove=new Signal(IDisplayEntity,Point);
			return _onTileMove;
		}
		protected var _onRotate:Signal;
		public function get onRotate():Signal
		{
			if(_onRotate==null) _onRotate=new Signal(IDisplayEntity);
			return _onRotate;
		}
		protected var _onScale:Signal;
		public function get onScale():Signal
		{
			if(_onScale==null) _onScale=new Signal(IDisplayEntity);
			return _onScale;
		}
		protected var _onResize:Signal;
		public function get onResize():Signal
		{
			if(_onResize==null) _onResize=new Signal(IDisplayEntity);
			return _onResize;
		}
		protected var _ontileBoundsChange:Signal;
		public function get onTileBoundsChange():Signal
		{
			if(_ontileBoundsChange==null) _ontileBoundsChange=new Signal(IDisplayEntity,Vector.<Point>,Vector.<Point>);
			return _ontileBoundsChange;
		}
		protected var _onLayoutStateChange:Signal;
		public function get onLayoutStateChange():Signal
		{
			if(_onLayoutStateChange==null) _onLayoutStateChange=new Signal(IDisplayEntity);
			return _onLayoutStateChange;
		}
		protected var _onDepthChanged:Signal;
		public function get onDepthChanged():Signal
		{
			if(_onDepthChanged==null) _onDepthChanged=new Signal(IDisplayEntity,int,int);
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
		long_internal var _container:Sprite;
		protected var _index:int=0;
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _z:Number=0;
		protected var _width:Number=0;
		protected var _length:Number=0;
		protected var _height:Number=0;
		protected var _scaleX:Number=1;
		protected var _scaleY:Number=1;
		protected var _offsetX:Number=0;
		protected var _offsetY:Number=0;
		protected var _rotation:Number=0;
		
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