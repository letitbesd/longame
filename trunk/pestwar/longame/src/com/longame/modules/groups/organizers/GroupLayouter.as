package com.longame.modules.groups.organizers
{
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.Direction;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.core.bounds.GroupBounds;
	import com.longame.modules.core.bounds.TileBounds;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.modules.scenes.utils.TileHilightUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.INativeDispatcher;

	/**
	 * 经过优化的场景层次排序，当场景新添加物品时需要全局排序用LazySceneLayouter
	 * 一般情况下，只需对移动对象进行操作
	 * */
	public class GroupLayouter extends AbstractGroupOrganizer
	{
		//需要重新排序的对象
		protected var invalidtatedChildren:Vector.<IDisplayEntity>;
		protected var childVisited:Dictionary;
		
		private var map:TileMap;
		private var bounds:TileBounds;
		private var numberChildren:int;
		public function GroupLayouter()
		{
			super();
		}
		protected function get displayGroup():IDisplayGroup
		{
			return group as IDisplayGroup;
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
//				trace("place child: "+child,child.tileBounds.x,child.tileBounds.y);
				this.place(child);
				childVisited[child]=true;
				invalidtatedChildren.splice(0,1);
			}
			childVisited =null;
			invalidtatedChildren=null;
			map=null;
			bounds=null;
		}
		/**
		 * 确定child的层次
		 * */
		protected function place(target:IDisplayEntity):void
		{
			var targetDepth:int=target.depth;
			//对于同时有多个移动对象或刚加进来的对象，最高层应该是所有的对象总和减去还没有排序的物品长度，没有排序的物品不算其中
			var maxDepth:int=numberChildren-invalidtatedChildren.length;;
			var newIndex:int;
			var resultDepth:int;
			//初始化本次搜索
			initSearch(target);
			(SceneManager.sceneType==SceneManager.D2)?this.searchInD2(target):this.searchInD25(target);
			//如果找到了下方物品，插入到下面一层
			if(upperChild){
				resultDepth=upperChild.depth;
				//目的是要将child放到upper的下一层，所以要判断下，如果是child本身在upper的下面，那么目标层会是upperDepth-1
				if(targetDepth>resultDepth){
					newIndex=resultDepth;
				}else {
					newIndex=resultDepth-1;
				}
//				TileHilightUtil.hilightTile(target.scene,upperChild.tileBounds.x,upperChild.tileBounds.y);
				upperChild=null;
			//如果找到了上方物品，插入到其上面一层
			}else if(lowerChild){
				resultDepth=lowerChild.depth;
				if(targetDepth>resultDepth){
					newIndex=resultDepth+1;
				}else{
					newIndex=resultDepth;
				}
//				TileHilightUtil.hilightTile(target.scene,lowerChild.tileBounds.x,lowerChild.tileBounds.y);
				lowerChild=null;
			}else{
				newIndex=maxDepth;
				//没找到放于最上层
//				TileHilightUtil.dehilight(target.scene);
			}
			displayGroup.setChildIndex(target,newIndex);
		}
		/**
		 * 2.5D场景中，以target所在单元格为出发点，在其right和down方向之间的扇形区域寻找最浅的那个对象，maxSteps是最大寻找步数
		 * **/
		private function searchInD25(target:IDisplayEntity):void
		{
			while(++searchStep<maxSteps){
				//如果向前搜索没有到group的前部边界，则继续搜
				if(!outOfFrontBounds){
					upperChild=this.searchToFrontOnce(target);
					if(upperChild) break;
				}
				//如果向前搜索没有找到物品，则searchStep=1的情况下，向后搜索一次，这样做是解决完全向前搜时遇到的bug
				//以后如果场景中排序仍然不完美，会考虑前后各搜一次，直到搜到位置或者到达边界
                if(!outOfBackBounds&&(searchStep==1)){
					lowerChild=this.searchToBackOnce(target);
					if(lowerChild) break;
				}
				if((searchStep>=1) &&outOfFrontBounds) break;
			}
		}
		private function searchToFront1(target:IDisplayEntity):IDisplayEntity
		{
			var result:IDisplayEntity;
			while(++searchStep<maxSteps){
				result=this.searchToFrontOnce(target);
				if(result) break;
				if(outOfFrontBounds) break;
				//如果向下的第一圈没找到，应该找找和target紧挨着的上面的物品，如果找到了
				if((searchStep==1)&&(result==null)){
					var nx:int;
					var ny:int;
					var tile:EntityTile;
					var child0:IDisplayEntity;
					var child:IDisplayEntity;
					for each(var d:int in updirections){
						nx=targetLeft+Direction.dx[d];
						ny=targetBack+Direction.dy[d];
						tile=map.getTile(nx,ny) as EntityTile;
						if(tile==null) continue;
						child=this.findChildInCell(tile,target,false);
						if(child0==null) child0=child;
						else if(child&&(child.depth>child0.depth)) child0=child;
					}
					if(child0){
						lowerChild=child0;
						return null;
					}
				}
			}
			return result;
		}
		private var searchStep:int;
		private var targetLeft:int;
		private var targetBack:int;
		private static const maxSteps:int=8;
		//向前搜索时是否到了边界
		private var outOfFrontBounds:Boolean;
		//往后搜索时是否到了边界
		private var outOfBackBounds:Boolean;
		private static const updirections:Array=[Direction.LEFT,Direction.LEFT_UP,Direction.UP];
		private var lowerChild:IDisplayEntity;
		private var upperChild:IDisplayEntity;
		/**
		 * 向前寻找前，初始化参数
		 * */
		private function initSearch(target:IDisplayEntity):void
		{
			searchStep=-1;
			targetLeft=target.tileBounds.left;
			targetBack=target.tileBounds.back;
			outOfFrontBounds=false;
			outOfBackBounds=false;
			lowerChild=null;
			upperChild=null;
		}
		/**
		 * 以target所在单元格为出发点，在其right和down方向之间的扇形区域寻找最浅的那个对象，每向前推进一步，调用一次此函数
		 * */
		private function searchToFrontOnce(target:IDisplayEntity):IDisplayEntity
		{
			var tile:EntityTile;
			var result0:IDisplayEntity;
			var result:IDisplayEntity;
			
			var xLine:int=targetLeft+searchStep;
			var yLine:int=targetBack+searchStep;
			outOfFrontBounds=(xLine>bounds.right)&&(yLine>bounds.front);
			if(outOfFrontBounds) return null;
			var xNow:int;
			var yNow:int;
//			trace("start search to front: ",searchStep,group.tileBounds.left,group.tileBounds.right,group.tileBounds.back,group.tileBounds.front);
			if(xLine<=bounds.right){
				for(var yy:int=0;yy<=searchStep;yy++){
					yNow=targetBack+yy;
					if(yNow>bounds.front) break;
//					trace("searching: ",xLine,yNow);
					tile=map.getTile(xLine,yNow) as EntityTile;
//					if(tile) trace("searched ok!");
					result0=this.findChildInCell(tile,target);
//					if(result0) trace("found child: ",result0.depth);
					if(result==null) result=result0;
					else if(result0&&(result0.depth<result.depth)) result=result0;
				}
			}
			if(yLine<=bounds.front){
				for(var xx:int=0;xx<searchStep;xx++){
					xNow=targetLeft+xx;
					if(xNow>bounds.right) break;
//					trace("searching: ",xNow,yLine);
					tile=map.getTile(xNow,yLine) as EntityTile;
//					if(tile) trace("searched ok!");
					result0=this.findChildInCell(tile,target);
//					if(result0) trace("found child: ",result0.depth);
					if(result==null) result=result0;
					else if(result0&&(result0.depth<result.depth)) result=result0;
				}	
			}
			return result;
		}
		/**
		 * 以target所在单元格为出发点，在其left和up方向之间的扇形区域寻找最顶层的那个对象，每向前推进一步，调用一次此函数
		 * */
		private function searchToBackOnce(target:IDisplayEntity):IDisplayEntity
		{
			var tile:EntityTile;
			var result0:IDisplayEntity;
			var result:IDisplayEntity;
			
			var xLine:int=targetLeft-searchStep;
			var yLine:int=targetBack-searchStep;
			outOfBackBounds=(xLine<bounds.left)&&(yLine<bounds.back);
			if(outOfBackBounds) return null;
			var xNow:int;
			var yNow:int;
//			trace("start search to back: ",searchStep,group.tileBounds.left,group.tileBounds.right,group.tileBounds.back,group.tileBounds.front);
			if(xLine>=bounds.left){
				for(var yy:int=0;yy<=searchStep;yy++){
					yNow=targetBack-yy;
					if(yNow<bounds.back) break;
//					trace("searching: ",xLine,yNow);
					tile=map.getTile(xLine,yNow) as EntityTile;
//					if(tile) trace("searched ok!");
					result0=this.findChildInCell(tile,target,false);
//					if(result0) trace("found child: ",result0.depth);
					if(result==null) result=result0;
					else if(result0&&(result0.depth>result.depth)) result=result0;
				}
			}
			if(yLine>=bounds.back){
				for(var xx:int=0;xx<searchStep;xx++){
					xNow=targetLeft-xx;
					if(xNow<bounds.left) break;
//					trace("searching: ",xNow,yLine);
					tile=map.getTile(xNow,yLine) as EntityTile;
//					if(tile) trace("searched ok!");
					result0=this.findChildInCell(tile,target,false);
//					if(result0) trace("found child: ",result0.depth);
					if(result==null) result=result0;
					else if(result0&&(result0.depth>result.depth)) result=result0;
				}	
			}
			return result;
		}
		/**
		 * 2D场景中，从child最左边所占方格到最右边所占方格的水平范围，一直向y方向搜索，找到层次最低的那个对象，插入之
		 * 
		 * */
		protected function searchInD2(target:IDisplayEntity):void
		{
			//计算对象y坐标线上实际覆盖的单元格
			var startTile:Point=SceneManager.getTileIndex(target.bounds.left,target.y);
			var endTile:Point=SceneManager.getTileIndex(target.bounds.right,target.y);	
			var startX:int=Math.max(0,startTile.x);
			var startY:int=Math.max(0,startTile.y);
			var endX:int=Math.min(bounds.right,endTile.x+1);//Math.min(SceneSpace.sizeX,endTile.x+1);
			var endY:int=bounds.front;//SceneSpace.sizeY;
			//y坐标线上实际覆盖的单元格往下寻找层次最浅的那个对象，插入之
			var result:IDisplayEntity;
			for(var ty:int=startY;ty<endY;ty++){
				result=null;
				for (var tx:int=startX;tx<endX;tx++){
					var ucell:EntityTile=map.getTile(tx,ty) as EntityTile;
					result=this.findChildInCell(ucell,target);
					if(result)  break;
				}
				if(result==null) continue;
				if(upperChild==null) upperChild=result;
				if((result.depth<upperChild.depth)) {
					upperChild=result;
				}
			}	
		}
		/**
		 * 搜需tile格子里的所有物品，找出层次最低或层次最高的那个物品，当然这个物品不是target本身，而且includeInLayout=true
		 * @param tile: 搜寻的格子
		 * @param target: 此次排序的目标对象
		 * @param lowDepth:是搜索层次最低的还是层次最高的
		 * */
		private function findChildInCell(tile:EntityTile,target:IDisplayEntity,lowDepth:Boolean=true):IDisplayEntity
		{
			if(tile==null) return null;
			var max:int=tile.numChildren;
			if(max==0) return null;
			var tileChildren:Vector.<IDisplayEntity>=tile.children;
			tileChildren.sort(getLowestDepth);
			if(!lowDepth) tileChildren=tileChildren.reverse();
			//这个对象要满足几个条件
			//不能是本身；includeInLayout=true,不能是当前在更新序列里并且是还没有更新的	
			for(var i:int=0;i<max;i++){
				var ch:IDisplayEntity=tileChildren[i];
				if((ch==target)||(ch.includeInLayout==false)||((invalidtatedChildren.indexOf(ch)>-1)&&(!childVisited[ch]))) {
					continue;
				}
				return ch;
			}	
			return null;
		}
		private function getLowestDepth(a:IDisplayEntity,b:IDisplayEntity):int
		{
			if(a.depth>b.depth) return 1;
			else if(a.depth<b.depth) return -1;
			return 0;
		}
	}
}