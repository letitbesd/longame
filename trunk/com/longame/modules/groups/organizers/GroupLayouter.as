package com.longame.modules.groups.organizers
{
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.Direction;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.core.bounds.GroupBounds;
	import com.longame.modules.core.bounds.TileBounds;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.modules.scenes.utils.TileHilightUtil;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.INativeDispatcher;

	/**
	 * 经过优化的场景层次排序，当场景新添加物品时需要全局排序用LazySceneLayouter
	 * 一般情况下，只需对移动对象进行操作
	 * */
	public class GroupLayouter extends GroupLayouterBase
	{
		//需要重新排序的对象
		protected var invalidtatedChildren:Vector.<IDisplayEntity>;
		protected var cellsVisited:Dictionary;
		
		private var map:GroupMap;
		private var bounds:TileBounds;
		private var numberChildren:uint;
		
		public function GroupLayouter()
		{
			super();
		}
		override protected function doUpdate():void
		{
			super.doUpdate();
			map=displayGroup.map;
			//当场景中只有几个物品发生移动时，只对他们进行排序，大大降低消耗
			invalidtatedChildren=map.tileMovedChildren;
			if(invalidtatedChildren.length==0) {
				map=null;
				invalidtatedChildren=null;
				return;
			}
			numberChildren=displayGroup.numChildren;
			bounds=displayGroup.tileBounds;
			var child:IDisplayEntity;
			childVisited=new Dictionary();
			//排序一个，删除一个
			while(invalidtatedChildren.length){
				child=invalidtatedChildren[0];
				//每个物品放置前，先将这个临时数据清空
				cellsVisited=new Dictionary();
				this.place(child);
				childVisited[child]=true;
				invalidtatedChildren.splice(0,1);
			}
			childVisited =null;
			cellsVisited=null;
			invalidtatedChildren=null;
			map=null;
			bounds=null;
		}
		/**
		 * 确定child的层次
		 * */
		override protected function place(child:IDisplayEntity):void
		{
			var upper:IDisplayEntity=findUpperObject(child);
			//如果upper没找到，放到最上层
			if(upper==null) {
				TileHilightUtil.dehilight(child.scene);
				//对于同时有多个移动对象或刚加进来的对象，最高层应该是所有的对象总和减去还没有排序的物品长度，没有排序的物品不算其中
				var maxDepth:int=numberChildren-invalidtatedChildren.length;
				displayGroup.setChildIndex(child,maxDepth);
				return;
			}else{
				TileHilightUtil.hilightTile(child.scene,upper.tile.x,upper.tile.y);
			}
			var childDepth:int=child.depth;
			var upperDepth:int=upper.depth;
			var newIndex:int;
			//目的是要将child放到upper的下一层，所以要判断下，如果是child本身在upper的下面，那么目标层会是upperDepth-1
			if(childDepth>upperDepth){
				newIndex=upperDepth;
			}else {
				newIndex=upperDepth-1;
			}
			displayGroup.setChildIndex(child,newIndex);
		}
		/**
		 * 寻找child所占单元格y方向以下，最近那个物体，把child插到这里就可以了
		 * 这里考虑了多格大物体的情形 
		 * */			
		protected function findUpperObject(child:IDisplayEntity):IDisplayEntity
		{
			if(SceneManager.sceneType==SceneManager.D2) return this.searchToBottom(child);
			else return this.searchToFront(child,child.tileBounds.left,child.tileBounds.back);

		}
		/**
		 * 2D场景中，从child最左边所占方格到最右边所占方格的水平范围，一直向y方向搜索，找到层次最低的那个对象，插入之
		 * 
		 * */
		protected function searchToBottom(child:IDisplayEntity):IDisplayEntity
		{
			//计算对象y坐标线上实际覆盖的单元格
			var startTile:Point=SceneManager.getTileIndex(child.bounds.left,child.y);
			var endTile:Point=SceneManager.getTileIndex(child.bounds.right,child.y);	
			var startX:int=Math.max(0,startTile.x);
			var startY:int=Math.max(0,startTile.y);
			var endX:int=Math.min(bounds.right,endTile.x+1);//Math.min(SceneSpace.sizeX,endTile.x+1);
			var endY:int=bounds.front;//SceneSpace.sizeY;
			//y坐标线上实际覆盖的单元格往下寻找层次最浅的那个对象，插入之
			var theNearestChild:IDisplayEntity;
			var upperChild:IDisplayEntity;
			for(var ty:int=startY;ty<endY;ty++){
				upperChild=null;
				for (var tx:int=startX;tx<endX;tx++){
					var ucell:EntityTile=map.getTile(tx,ty) as EntityTile;
					upperChild=this.findUpperChildInCell(ucell,child);
					if(upperChild)  break;
				}
				if(upperChild==null) continue;
				if(theNearestChild==null) theNearestChild=upperChild;
				if((upperChild.depth<theNearestChild.depth)) {
					theNearestChild=upperChild;
				}
			}	
			return theNearestChild;			
		}
		/**
		 * 2.5D场景中，以cell为出发点，向右，向前及右前方寻找最近的object
		 * **/
		private static const fronts:Array=[Direction.RIGHT,Direction.RIGHT_DOWN,Direction.DOWN];
		private function searchToFront(target:IDisplayEntity,x:int,y:int):IDisplayEntity
		{
			//搜到头了，停止搜索
			if((x>bounds.right)||(y>bounds.front)){
				return null;
			}
			var cell:EntityTile=map.getTile(x,y) as EntityTile;
			cellsVisited[x+"_"+y]=true;
			var result:IDisplayEntity=this.findUpperChildInCell(cell,target);
			//在x，y中找到了就返回，不再继续搜索
			if(result) return result;
			var result1:IDisplayEntity;
			var nextCell:EntityTile;
			var nx:int;
			var ny:int;
			//遍历三个邻居
			for each(var direct:int in fronts){
				nx=x+Direction.dx[direct];
				ny=y+Direction.dy[direct];
				nextCell=map.getTile(nx,ny) as EntityTile;
				if(cellsVisited[nx+"_"+ny]===true) continue;
				result1=this.searchToFront(target,nx,ny);
				if(result==null) result=result1;
				else if((result1!=null)&&(result1.depth<result.depth)) result=result1;
			}
			return result;
		}
		/**
		 * 搜需cell格子里的所有物品，找出层次最低而又在target上层的那个物品
		 * */
		private function findUpperChildInCell(cell:EntityTile,target:IDisplayEntity):IDisplayEntity
		{
			if(cell==null) return null;
			var max:int=cell.numChildren;
			if(max==0) return null;
			var cellChildren:Vector.<IDisplayEntity>=cell.children;
			cellChildren.sort(compareDepth);
			//这个对象要满足几个条件
			//不能是本身；y坐标在target之下;不能是当前在更新序列里并且是还没有更新的	
			//并且includeInLayout=true
			for(var i:int=0;i<max;i++){
				var ch:IDisplayEntity=cellChildren[i];
				if((ch==target)||(ch.includeInLayout==false)||(this.backCompare(target,ch))||((invalidtatedChildren.indexOf(ch)>-1)&&(!childVisited[ch]))) {
					continue;
				}
				return ch;
			}	
			return null;
		}
		private function compareDepth(a:IDisplayEntity,b:IDisplayEntity):int
		{
			if(a.depth>b.depth) return 1;
			else if(a.depth<b.depth) return -1;
			return 0;
		}
	}
}