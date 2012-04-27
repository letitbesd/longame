package com.longame.game.component.fight
{
	import com.longame.game.core.EntityTile;
	import com.longame.game.core.bounds.TileBounds;
	import com.longame.game.entity.Character;
	import com.longame.game.entity.CharacterState;
	import com.longame.game.entity.CharactersMap;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.Pet;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import com.longame.game.component.AbstractComp;
	import com.longame.game.component.PathComp;

	/**
	 * 跟随另一对象移动的组件，可以是跟随同一阵营的，如宠物，也可以是跟随敌对阵营的，这个时候如果在跟踪过程中距离到了攻击距离，对象会自动转入攻击状态
	 * */
	public class FollowComp extends AbstractComp
	{
		[Partner]
		public var mover:PathComp;
		private var animation:String;
		
		public function FollowComp(animation:String="walk")
		{
			super();
			this.animation=animation;
		}
		override protected function whenActive():void
		{
			if(!(_owner is Character)) throw new Error("FollowComp can only be added to Character!");
			super.whenActive();
			theOwner.speedScale=1;
			theOwner.gotoAndPlay(animation);
			theOwner.onFollowingChanged.add(onFollowingChanged);
			theOwner.followingTarget.onTileMove.add(onTargetMoved);
		}
		/**
		 * 当跟踪对象发生变化时，信号侦听也相应变化，删除旧的，添加新的
		 * */
		private function onFollowingChanged(oldFollowing:Character):void
		{
			if(oldFollowing) oldFollowing.onTileMove.remove(onTargetMoved);
			theOwner.followingTarget.onTileMove.add(onTargetMoved);
		}
		
		override protected function whenDeactive():void
		{
			theOwner.followingTarget.onTileMove.remove(onTargetMoved);
			theOwner.onFollowingChanged.remove(onFollowingChanged);
			this.mover.stop();
			this.mover.onReached.remove(onReached);
			this.mover.onNotFound.remove(onPathNotFound);
			
			super.whenDeactive();
		}
		//每次刷新都调用？todo
		override protected function whenRefresh():void
		{
			super.whenRefresh();
			this.mover.onReached.add(onReached);
			this.mover.onNotFound.add(onPathNotFound);
			this.doFollow();
		}
		private function checkDistance(tile:EntityTile=null):void
		{
			var targetBounds:TileBounds=theOwner.followingTarget.tileBounds;
			var ownerBounds:TileBounds=theOwner.tileBounds;
			var dx:int=Math.abs(targetBounds.x-ownerBounds.x);
			var dy:int=Math.abs(targetBounds.y-ownerBounds.y);
			if(dx*dx+dy*dy>theOwner.vision*theOwner.vision){
				//如果跟随的是敌对角色，超出视距则休息
				if(isOpposed()) {
					theOwner.setState(CharacterState.IDLE_WALK);
				}
					
				//否则继续跟随
				else this.doFollow();
			//对角线位置暂不攻击
			}else if(dx+dy>=2){
				this.doFollow();
//			}else if(dx+dy==1){
			}else{
				//如果是敌对玩家，则停止跟随状态，进入攻击状态，否则啥也不干，停在那里
				if(isOpposed()){
					theOwner.setState(CharacterState.ATTACK);
				}
			}
		}
		private function isOpposed():Boolean
		{
			return theOwner.faction!=(theOwner.followingTarget as Character).faction;
		}
		private function doFollow():void
		{
			this.mover.stop();
			var tp:Point=theOwner.followingTarget.parent.localToGlobal(new Vector3D(theOwner.followingTarget.tileBounds.x,theOwner.followingTarget.tileBounds.y),true);
			var tiles:Array=theOwner.scene.map.getWalkableNeighbours(tp.x,tp.y,false);
			if(tiles.length){
				var i:int=Math.floor(tiles.length*Math.random());
				var tile:EntityTile=tiles[i];
				this.mover.moveToPoint(tile.x,tile.y,false);
			}else{
				onPathNotFound();
			}
		}
		private function onPathNotFound():void
		{
			if(this.isOpposed()) theOwner.setState(CharacterState.IDLE_WALK);
		}
		private function onReached(tile:EntityTile):void
		{
			this.checkDistance();
		}
		private function onTargetMoved(entity:IDisplayEntity=null,delta:Point=null):void
		{
			this.checkDistance();
		}
		private function get theOwner():Character
		{
			return (_owner as Character);
		}
	}
}