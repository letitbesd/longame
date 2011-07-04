package com.longame.modules.components
{
	import com.longame.core.long_internal;
	import com.longame.managers.ProcessManager;
	import com.longame.model.Direction;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.CharacterState;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.entities.IMovableEntity;
	import com.longame.utils.Random;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	use namespace long_internal;
	/**
	 * 没事漫无目的走动的组件
	 * */
	public class IdleWalkComp extends AbstractComp
	{
		[Link]
		public var mover:PathComp;
		[Link]
		public var stand:IdleStandComp;
//		[Link]
//		public var think:ThinkingComp;
		/**
		 * 当被卡住后，寻找可行走的最大步骤
		 * */
		public var max_steps_when_blocked:int=10;
		
		private var animation:String;
		private var minTime:int;
		private var maxTime:int;
		
		private var startTime:int;
		private var walkTime:int;
		
		public function IdleWalkComp(animation:String="walk",minTime:int=10,maxTime:int=30)
		{
			super();
			this.animation=animation;
			this.minTime=minTime;
			this.maxTime=maxTime;
			this.directWalked=new Array(8);
			for(var i:int=0;i<8;i++){
				var r:Random=new Random(i);
				this.directWalked[i]=r.nextInt(100);
			}
		}
		
		override protected function doWhenActive():void
		{
			if(!(_owner is Character)) throw new Error("IdleWalkComp should be added only Character!");
			(_owner as Character).speedScale=0.5;
//			thinked=false;
			super.doWhenActive();
			(_owner as Character).gotoAndPlay(this.animation);
			startTime=ProcessManager.virtualTime;
		}
		override protected function doWhenDeactive():void
		{
			nextTile=null;
			mover.onTileReached.remove(findNextTile);
			mover.stop(true);
			super.doWhenDeactive();
		}
//		private var thinked:Boolean;
		override protected function doWhenRefresh():void
		{
			super.doWhenRefresh();
			mover.onTileReached.add(findNextTile);
			//why?
			if(mover.currentNode) nextTile=mover.currentNode;
			//todo
			if(nextTile==null)  ProcessManager.callLater(findNextTile);
			
//			if(think&&stand&&(!thinked)){
			if(stand){
				walkTime=minTime+Math.floor(Math.random()*(maxTime-minTime));
				walkTime=Math.max(1,walkTime)*1000;
//				this.think.think(this.goStandState,walkTime);
//				thinked=true;
			} 
		}
		private var nextTile:EntityTile;
		private var directWalked:Array;
		
		private function findNextTile(t:EntityTile=null):void
		{
			if(!actived) return;
			if(ProcessManager.virtualTime-startTime>=walkTime){
				this.goStandState();
				return;
			}
			var tp:Point=(_owner as Character).parent.localToGlobal(new Vector3D((_owner as Character).tileBounds.x,(_owner as Character).tileBounds.y),true);
			//先寻找当前方向的下个节点
			var tile:EntityTile=(_owner as Character).scene.map.getNeighbour(tp.x,tp.y,(_owner as Character).direction);
			//如果找不到或者不能走，则找邻居中走的最少方向的那个，以免对象在某个方向上来回走
			if((tile==null)||(!tile.walkable)){
				var maxWalked:int=int.MAX_VALUE;
				var theDirect:int;
				
				var ts:Array=(_owner as Character).scene.map.getNearestWalkables(tp.x,tp.y,max_steps_when_blocked);
				if(ts.length){
					var r:Random=new Random();
					nextTile=ts[r.nextInt(ts.length)];
				}
//				for(var i:int=0;i<ts.length;i++){
//					tile=ts[i];
//					if(tile){
//						var d:int=Direction.getDirectionBetweenTiles(tp.x,tp.y,tile.x,tile.y);
//						if(directWalked[d]<maxWalked){
//							nextTile=tile;
//							theDirect=d;
//							maxWalked=directWalked[d];
//						}
//					}
//				}
//				if(nextTile) directWalked[theDirect]=directWalked[theDirect]+1;
			}else{
				nextTile=tile;
			}
			//需要判断下，这个tile里是否只有owner本身可行走，是的话就设为null，视为无路可走
			if(nextTile&&(nextTile.children.length==1)&&((_owner as Character).walkable)) nextTile=null;
			if(nextTile){
				mover.addNode(nextTile);
			}else{
				ProcessManager.callLater(findNextTile);
			}
		}
		/**
		 * 随意行走时间到，让其站立一会
		 * */
		private function goStandState():void
		{
			if(!this.actived) return;
			if(stand) (_owner as Character).state=CharacterState.IDLE_STAND;
		}
		
	}
}