package com.longame.game.group
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.IComponent;
	import com.longame.game.core.IEntity;
	import com.longame.game.core.bounds.GroupBounds;
	import com.longame.game.core.bounds.IBounds;
	import com.longame.game.core.bounds.TileBounds;
	import com.longame.game.entity.AnimatorEntity;
	import com.longame.game.entity.DisplayEntity;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.SpriteEntity;
	import com.longame.game.entity.display.primitive.LGGrid;
	import com.longame.game.entity.display.primitive.LGRectangle;
	import com.longame.game.entity.display.primitive.TileHilighter;
	import com.longame.game.group.component.GroupLayouter;
	import com.longame.game.group.component.TileMap;
	import com.longame.game.scene.IScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.consts.Registration;
	import com.longame.utils.ArrayUtil;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.model.item.ItemDatabase;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.media.Video;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;


    use namespace long_internal;
	/**
	 * 显示组基类
	 * 注意DisplayGroup总是以左上角为注册点，切记，所有加在其中的entity都得注意这个问题，另外，DisplayGroup的left和back边界总是其x，y所决定，所有子对象都应当加在其x，y都为正的扇形范围内
	 * */
	public class DisplayGroup extends DisplayEntity implements IDisplayGroup
	{
		/**
		 * @param id: ID
		 * @param autoLayout:是否自动深度排序
		 * */
		public function DisplayGroup(id:String=null,autoLayout:Boolean=false)
		{
			super(id);
			this.autoLayout=autoLayout;
			_registration=Registration.TOP_LEFT;
			this._walkable=true;
		}
		protected var _gridShowing:Boolean;
		private var _settedGridWidth:int;
		private var _settedGridHeight:int;
		public function showGrid(width:uint=0,height:uint=0):void
		{
			if(_gridShowing) return;
			_gridShowing=true;
			if(_grid==null) {
				_grid=new LGGrid();
				_grid.tileSize=SceneManager.tileSize;
			}
			this.add(_grid);
			_settedGridWidth=width;
			_settedGridHeight=height;
			this.updateGrid();
		}
		public function hideGrid():void
		{
			if(!_gridShowing) return;
			_gridShowing=false;
			if(_grid==null) return;
			this.remove(_grid);
		}
		protected function updateGrid():void
		{
			if(!_gridShowing||(_grid==null)) return;
			_grid.setGridSize(Math.max(_settedGridWidth,this.tileBounds.width),Math.max(_settedGridHeight,this.tileBounds.length));
			_grid.snapToTile(this.tileBounds.left,this.tileBounds.back);
		}
		public function addLayer(id:String=null,index:int=int.MAX_VALUE,state:String=""):DisplayGroup
		{
			var g:DisplayGroup=new DisplayGroup(id);
			g.includeInLayout=false;
			this.add(g,state);
			if(index!=int.MAX_VALUE) this.setChildIndex(g,index);
			return g;
		}
		public function addSimpleLayer(itemIdOrSource:*,id:String=null,index:int=int.MAX_VALUE,state:String=""):SpriteEntity
		{
			var entity:SpriteEntity=new SpriteEntity(id);
			entity.includeInLayout=false;
			if(itemIdOrSource){
				var item:EntityItemSpec=ItemDatabase.getItem(itemIdOrSource) as EntityItemSpec;
				if(item) entity.itemSpec=item;
				else{
					entity.source=itemIdOrSource;
					entity.registration=Registration.TOP_LEFT;
				}
			}
			this.add(entity,state);
			if(index!=int.MAX_VALUE) this.setChildIndex(entity,index);
			return entity;
		}
		private var _tempEntity:SpriteEntity;
		private var _tempTile:EntityTile;
		private var _tempVistedTile:Dictionary;
		public function fillBlankArea(x:int,y:int,itemSpec:EntityItemSpec):void
		{
			_tempVistedTile=new Dictionary();
			this.doFillBlankArea(x,y,itemSpec);
			_tempEntity=null;
			_tempTile=null;
			_tempVistedTile=null;
		}
		private function doFillBlankArea(x:int,y:int,itemSpec:EntityItemSpec):void
		{
			if(_tempVistedTile[x+"_"+y]===true) return;
			if(!this.map.isValidTile(x,y)) return;
			_tempVistedTile[x+"_"+y]=true;
			_tempTile=this.map.getTile(x,y) as EntityTile;
			if((_tempTile==null)||(_tempTile&&_tempTile.isEmpty())){
				_tempEntity=new itemSpec.entityClass();
				(_tempEntity as SpriteEntity).itemSpec=itemSpec;
				_tempEntity.snapToTile(x,y);
				this.add(_tempEntity);
			}else{
				return;
			}
			var nx:int;
			var ny:int;
			for (var i:int=0;i<Direction.maxDirection;i++){
				nx=x+Direction.dx[i];
				ny=y+Direction.dy[i]
				doFillBlankArea(nx,ny,itemSpec);
			}
		}
        override long_internal function activeChild(child:IComponent, refresh:Boolean=true):void
		{
			if(child is IDisplayGroup){
				_groupChildren.push(child as IDisplayGroup);
			}
			if(child is IDisplayEntity){
				_displayChildren.push(child as IDisplayEntity);
				if((bounds as GroupBounds).update(child as IDisplayEntity)){
					_childBoundsInvalidated=true;
				}
				(child as IDisplayEntity).onResize.add(this.checkBoundsWhenChildChanged);
				(child as IDisplayEntity).onMove.add(this.checkBoundsWhenChildChanged);
				//记录顶层对象
				if((child as IDisplayEntity).alwaysInTop){
					this.map.bringToTop(child as IDisplayEntity);
				}
			}
			super.activeChild(child,refresh);
		}
		override long_internal function deactiveChild(child:IComponent, refresh:Boolean=true):void
		{
			if(child is IDisplayGroup){
				var i:int=_groupChildren.indexOf(child as IDisplayGroup);
				if(i>-1) _groupChildren.splice(i,1);
			}
			if(child is IDisplayEntity){
				i=_displayChildren.indexOf(child as IDisplayEntity);
				if(i>-1) _displayChildren.splice(i,1);
				
				if((this.bounds as GroupBounds).update(child as IDisplayEntity,true)){
					_childBoundsInvalidated=true;
				}
				(child as IDisplayEntity ).onResize.remove(this.checkBoundsWhenChildChanged);
				(child as IDisplayEntity).onMove.remove(this.checkBoundsWhenChildChanged);	
			}
			super.deactiveChild(child,refresh);
		}
		long_internal function checkBoundsWhenChildChanged(child:IDisplayEntity):void
		{
			if((bounds as GroupBounds).update(child)){
				_childBoundsInvalidated=true;
			}
		}
		override protected function validateSize():void
		{
			if(!_childBoundsInvalidated) return;
			_childBoundsInvalidated=false;
			_sizeInvalidated=((_width!=bounds.width)||(_length!=bounds.length)||(_height!=bounds.height));
			if(!_sizeInvalidated) return;
			_width=bounds.width;
			_length=bounds.length;
			_height=bounds.height;	
			this.tileBounds.resize();
			super.validateSize();
//			this.updateGrid();
		}
		override protected function doRender():void
		{
			var childInBuilding:Boolean=false;
			for each(var display:IDisplayEntity in this._displayChildren){
				display.render();
				if(childInBuilding==true) continue;
				if(display is SpriteEntity){
					if((display as SpriteEntity).inBuilding) childInBuilding=true;
				}
			}
			this.updateLayouter();
			super.doRender();
			if(childInBuilding!==_inBuilding){
				if(!childInBuilding){
					this.whenBuild();
				}
				_inBuilding=childInBuilding;
			}
		}
		override protected function whenActive():void
		{
			super.whenActive();
			_inBuilding=true;
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			_inBuilding=false;
		}
		/**
		 * 当所有子元素加载并渲染完毕后调用，覆盖重写,可能多次触发
		 * */
		protected function whenBuild():void
		{
			if(_onBuild) _onBuild.dispatch(this);
		}
		override long_internal function notifyTileMove(delta:Point):void
		{
			super.notifyTileMove(delta);
			this.updateGrid();
		}
		override long_internal function notifyTileBoundsChange():void
		{
			super.notifyTileBoundsChange();
			this.updateGrid();
		}
		protected function updateLayouter():void
		{
			//根据是否指定自动深度排序，来开启或关闭深度排序
            if(_autoLayout){
				if(_layouter==null){
					_layouter=new GroupLayouter();
				}  
				this.add(this._layouter);
			}else if(_layouter){
				this.remove(this._layouter);
			}
			//to be add more...
		}
//		override public function destroy():void
//		{
//			if(destroyed) return;
//			if(_bounds) {
//				(_bounds as GroupBounds).destroy();
//				_bounds=null;
//			}
//			if(this._entityMap){
//				this._entityMap.destroy();
//				_entityMap=null;
//			}
//			if(this._layouter){
//				_layouter.destroy();
//				_layouter=null;
//			}
//			if(_grid){
//				_grid.destroy();
//				_grid=null;
//			}
//			super.destroy();
//			_groupChildren=null;
//			_displayChildren=null;
//		}
		override protected function whenDispose():void
		{
			if(_bounds) {
				(_bounds as GroupBounds).destroy();
				_bounds=null;
			}
			if(this._entityMap){
				this._entityMap.dispose();
				_entityMap=null;
			}
			if(this._layouter){
				_layouter.dispose();
				_layouter=null;
			}
			if(_grid){
				_grid.dispose();
				_grid=null;
			}
			super.whenDispose();
			_groupChildren=null;
			_displayChildren=null;
		}
		public function getDisplays(activedOnly:Boolean=true,basicEntity:Boolean=false):Vector.<IDisplayEntity>
		{
			var all:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
			var children:*=activedOnly?_displayChildren:allChildren;
			for each(var child:IComponent in children){
				if(child&&(child is IDisplayEntity)){
					if(basicEntity){
						if(child is IDisplayGroup){
							all=all.concat((child as IDisplayGroup).getDisplays(activedOnly,true));
						}else if(child is IDisplayEntity){
							all.push(child);
						}	
					}else if(child is IDisplayEntity){
						all.push(child);
					}
				}
			}
			return all;
		}
		public function foreachDisplay(callBack:Function,activedOnly:Boolean=true,basicEntity:Boolean=false):void
		{
			var children:*=activedOnly?_displayChildren:allChildren;
			for each(var child:IComponent in children){
				if(child&&(child is IDisplayEntity)){
					if(basicEntity){
						if(child is DisplayGroup){
							(child as DisplayGroup).foreachDisplay(callBack,activedOnly,true);
						}else{
							callBack(child);
						}	
					}else{
						callBack(child);
					}
				}
			}
		}
		public function addAt(child:IDisplayEntity, state:String = "",index:uint=uint.MAX_VALUE):void
		{
			if(this.contains(child)){
				Logger.error(this,"addAt",child+",id:"+child.id+" has existed!");
				return;
			}
			this.add(child,state);
			//是否有更高效的方法呢
			this.setChildIndex(child,index);
		}
		public function removeAt(index:uint):IDisplayEntity
		{
			var child:IDisplayEntity=_displayChildren[index] as IDisplayEntity;
			if(child){
				this.remove(child);
				_displayChildren.splice(index,1);
				var i:int=_activedChildren.indexOf(child);
				if(i>-1) _activedChildren.splice(i,1);
				return child;
			}
			return null;
		}
		public function setChildIndex(child:IDisplayEntity,index:int):int
		{
			var oldIndex:int=getChildIndex(child);
			if(oldIndex==-1) return -1;
			if((index<0)||(index>_displayChildren.length-1)){
				throw new Error("index out of bounds!");
			}
			index=Math.min(index,_displayChildren.length-1);
			index=Math.max(0,index);
			if(oldIndex==index) return index;
			_displayChildren.splice(oldIndex,1);
			_displayChildren.splice(index,0,child)
			container.setChildIndex(child.container,index);
			child.onDepthChanged.dispatch(child,oldIndex,index);
			return index;
		}
		public function getChildIndex(child:IDisplayEntity):int
		{
			return _displayChildren.indexOf(child);
		}
		public function getChildAt(index:int):IDisplayEntity
		{
			return _displayChildren[index] as IDisplayEntity;
		}
		override public function get invalidated():Boolean
		{
			return super.invalidated||_childBoundsInvalidated;
		}
		override public function get bounds():IBounds
		{
			if(_bounds==null) {
				_bounds=new GroupBounds(this);
			}
			return _bounds;
		}
		protected var internal_set_size:Boolean;
		/**
		 * group手动设定size是没意义的，依靠他里面的child来决定其size
		 * */
		override public function set width(value:Number):void
		{
           if(internal_set_size) super.width=value;
		}
		override public function set length(value:Number):void
		{
			if(internal_set_size) super.length=value;
		}
		override public function set height(value:Number):void
		{
			if(internal_set_size) super.height=value;
		}
		
		public function get numDisplay():int
		{
			return _displayChildren.length;
		}
		protected var _groupChildren:Vector.<IDisplayGroup>=new Vector.<IDisplayGroup>();
		public function get groupChildren():Vector.<IDisplayGroup>
		{
			return _groupChildren;
		}
		protected var _displayChildren:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
		public function get displayChildren():Vector.<IDisplayEntity>
		{
			return _displayChildren;
		}
		long_internal var _entityMap:TileMap;
		public function get map():TileMap
		{
			if(!SceneManager.useTileMap) return null;
			if(_entityMap==null) {
				_entityMap=new TileMap();
				this.add(_entityMap);
			}
			return _entityMap;
		}
		protected var _autoLayout:Boolean=true;
		public function get autoLayout():Boolean
		{
			return _autoLayout;
		}
		public function set autoLayout(value:Boolean):void
		{
			if(_autoLayout==value) return;
			_autoLayout=value;
//			this.updateLayouter();
		}
		override protected function checkChildValidation(child:IComponent):Boolean
		{
			return !(child is IScene);
			//to think,放开添加child的所有限制
			if((child is IEntity)&& !(child is IScene)){
				//只能添加IDisplayRenderer
				if(child is IDisplayRenderer) return true;
				throw new Error("DisplayGroup can only add IDisplayRenderer!");
			}
			return false;
		}
		override public function get registration():String
		{
			return Registration.TOP_LEFT;
		}
		override public function set registration(value:String):void
		{
			//do nothing
		}
		/**
		 * 当所有子元素的资源加载完毕并渲染完后触发，有可能多次触发
		 * onBuild(DisplayGroup);
		 * */
		public function get onBuild():Signal
		{
			if((_onBuild==null)&&!disposed) _onBuild=new Signal(DisplayGroup);
			return _onBuild;
		}
		/**
		 * 是否创建完成，包括所有子元素的资源加载和渲染
		 * */
		public function get inBuilding():Boolean
		{
			return _inBuilding;
		}
		/**优化的动态景深排序，当场景中有显示对象发生移动时自动调用**/
		protected var _layouter:GroupLayouter;
		
		protected var _childBoundsInvalidated:Boolean;
		
		protected var _grid:LGGrid;
		
		private var _inBuilding:Boolean;
		
		protected var _onBuild:Signal;
	}
}