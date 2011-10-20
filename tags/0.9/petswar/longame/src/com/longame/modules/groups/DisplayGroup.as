package com.longame.modules.groups
{
	import com.longame.core.long_internal;
	import com.longame.display.GameAnimator;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.consts.Registration;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.bounds.GroupBounds;
	import com.longame.modules.core.bounds.IBounds;
	import com.longame.modules.core.bounds.TileBounds;
	import com.longame.modules.core.signals.MouseSignals;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.modules.entities.display.primitive.LGGrid;
	import com.longame.modules.entities.display.primitive.LGRectangle;
	import com.longame.modules.entities.display.primitive.TileHilighter;
	import com.longame.modules.groups.organizers.GroupLayouter;
	import com.longame.modules.groups.organizers.IGroupOrganizer;
	import com.longame.modules.groups.organizers.TileMap;
	import com.longame.modules.scenes.IScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.ArrayUtil;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.items.ItemDatabase;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.media.Video;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;


    use namespace long_internal;
	/**
	 * 显示组基类,一般不需继承
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
			_grid.x=this.bounds.left;
			_grid.y=this.bounds.back;
		}
		public function addLayer(id:String=null,index:int=int.MAX_VALUE,state:String=""):DisplayGroup
		{
			var g:DisplayGroup=new DisplayGroup(id);
			g.includeInLayout=false;
//			g.includeInBounds=false;
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
		public function addOrganizer(mgr:IGroupOrganizer):void
		{
			var i:int=_organizers.indexOf(mgr);	
			if(i>=0) return;
			_organizers.push(mgr);			
		}
		
		public function removeOrganizer(mgr:IGroupOrganizer):void
		{
			var i:int=_organizers.indexOf(mgr);	
			if(i<0) return;
			_organizers.splice(i,1);
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			ProcessManager.addAnimatedObject(this);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			ProcessManager.removeAnimatedObject(this);
		}
        override long_internal function activeChild(child:IComponent, refresh:Boolean=true):void
		{
			super.activeChild(child,refresh);
			
			if(child is IDisplayGroup){
				_groupChildren.push(child as IDisplayGroup);
			}
			
			if((bounds as GroupBounds).update(child as IDisplayEntity)){
				this.tileBounds.resize();
				_childBoundsInvalidated=true;
			}
			(child as IDisplayEntity).onResize.add(this.checkBoundsWhenChildChanged);
			(child as IDisplayEntity).onMove.add(this.checkBoundsWhenChildChanged);
			//记录顶层对象
			if((child as IDisplayEntity).alwaysInTop){
				this.map.bringToTop(child as IDisplayEntity);
			}
		}
		override long_internal function deactiveChild(child:IComponent, refresh:Boolean=true):void
		{
			super.deactiveChild(child,refresh);
			if(child is IDisplayGroup){
				var i:int=_groupChildren.indexOf(child as IDisplayGroup);
				if(i>-1) _groupChildren.splice(i,1);
			}
			if((this.bounds as GroupBounds).update(child as IDisplayEntity,true)){
				this.tileBounds.resize();
				_childBoundsInvalidated=true;
			}
			(child as IDisplayEntity ).onResize.remove(this.checkBoundsWhenChildChanged);
			(child as IDisplayEntity).onMove.remove(this.checkBoundsWhenChildChanged);
		}
		private function checkBoundsWhenChildChanged(child:IDisplayEntity):void
		{
			if((bounds as GroupBounds).update(child)){
				this.tileBounds.resize();
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
			super.validateSize();
			this.updateGrid();
		}
		public function onFrame(deltaTime:Number):void
		{
			if(!this._actived) return;
			this.render();
			for each(var child:IComponent in this._activedChildren){
				if(child is IDisplayRenderer) (child as IDisplayRenderer).render();
			}	
			this.updateOrganizers();
			for each(var organizer:IGroupOrganizer in _organizers){
				//todo
				if(organizer.actived) organizer.update();
			}
		}
		protected function updateOrganizers():void
		{
			//根据是否指定自动深度排序，来开启或关闭深度排序
            if(_autoLayout){
				if(_layouter==null){
					_layouter=new GroupLayouter();
					this.addOrganizer(this._layouter);
				}  
				_layouter.active(this);
			}else if(_layouter){
				_layouter.deactive();
			}
			//to be add more...
		}
		override public function destroy():void
		{
			if(destroyed) return;
			for each(var organizer:IGroupOrganizer in _organizers){
				organizer.destroy();
			}
			_organizers=null;
			if(_bounds) (_bounds as GroupBounds).destroy();
			_bounds=null;
			super.destroy();
		}
		public function getDisplays(activedOnly:Boolean=true,basicEntity:Boolean=false):Vector.<IDisplayEntity>
		{
			var all:Vector.<IDisplayEntity>=new Vector.<IDisplayEntity>();
			var children:*=activedOnly?_activedChildren:allChildren;
			for each(var child:IDisplayEntity in children){
				if(child){
					if(basicEntity){
						if(child is IDisplayGroup){
							all=all.concat((child as IDisplayGroup).getDisplays(activedOnly,true));
						}else{
							all.push(child);
						}	
					}else{
						all.push(child);
					}
				}
			}
			return all;
		}
		public function foreachDisplay(callBack:Function,activedOnly:Boolean=true,basicEntity:Boolean=false):void
		{
			var children:*=activedOnly?_activedChildren:allChildren;
			for each(var child:IDisplayEntity in children){
				if(child){
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
			var child:IDisplayEntity=_activedChildren[index] as IDisplayEntity;
			if(child){
				this.remove(child);
				_activedChildren.splice(index,1);
				return child;
			}
			return null;
		}
		public function setChildIndex(child:IDisplayEntity,index:int):int
		{
			var oldIndex:int=getChildIndex(child);
			if(oldIndex==-1) return -1;
			if((index<0)||(index>_activedChildren.length-1)){
				throw new Error("index out of bounds!");
			}
			index=Math.min(index,_activedChildren.length-1);
			index=Math.max(0,index);
			if(oldIndex==index) return index;
			_activedChildren.splice(oldIndex,1);
			_activedChildren.splice(index,0,child)
			container.setChildIndex(child.container,index);
			child.onDepthChanged.dispatch(child,oldIndex,index);
			return index;
		}
		public function getChildIndex(child:IDisplayEntity):int
		{
			return _activedChildren.indexOf(child);
		}
		public function getChildAt(index:int):IDisplayEntity
		{
			return _activedChildren[index] as IDisplayEntity;
		}
		override public function get invalidated():Boolean
		{
			return super.invalidated||_childBoundsInvalidated;
		}
		override public function get bounds():IBounds
		{
			if(_bounds==null) {
				_bounds=new GroupBounds(this);
//				_sizeInvalidated=true;
			}
			return _bounds;
		}
		/**
		 * group手动设定size是没意义的，依靠他里面的child来决定其size
		 * */
		override public function set width(value:Number):void
		{
            //do noting
		}
		override public function set length(value:Number):void
		{
			//do noting
		}
		override public function set height(value:Number):void
		{
			//do noting
		}
		
		protected var _groupChildren:Vector.<IDisplayGroup>=new Vector.<IDisplayGroup>();
		public function get groupChildren():Vector.<IDisplayGroup>
		{
			return _groupChildren;
		}
		
		long_internal var _entityMap:TileMap;
		public function get map():TileMap
		{
			if(_entityMap==null) {
				_entityMap=new TileMap();
				this.addOrganizer(_entityMap);
				_entityMap.active(this);
			}
			return _entityMap;
		}
		protected var _autoLayout:Boolean=false;
		public function get autoLayout():Boolean
		{
			return _autoLayout;
		}
		public function set autoLayout(value:Boolean):void
		{
			_autoLayout=value;
		}
		
		
		
		override protected function checkChildValidation(child:IComponent):Boolean
		{
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
		public function get organizers():Vector.<IGroupOrganizer>
		{
			return _organizers;
		}
		/**private vars*/
		protected var _organizers:Vector.<IGroupOrganizer>=new Vector.<IGroupOrganizer>();
		/**全局景深排序，只在初始化场景等场合用，费资源**/
//		protected var _lazyLayouter:LazyGroupLayouter
		/**优化的动态景深排序，当场景中有显示对象发生移动时自动调用**/
		protected var _layouter:GroupLayouter;
		/**标记onFrame前是否有新child加入，这个时候很可能需要全局排序*/
//		protected var _newChildActived:Boolean=true;
		
		protected var _childBoundsInvalidated:Boolean;
		
		protected var _grid:LGGrid;
	}
}