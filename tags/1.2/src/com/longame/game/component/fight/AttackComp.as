package com.longame.game.component.fight
{
	import com.longame.model.Direction;
	import com.longame.game.core.EntityTile;
	import com.longame.game.entity.Character;
	import com.longame.game.entity.CharacterState;
	import com.longame.game.entity.IDisplayEntity;
	
	import flash.geom.Point;
	import com.longame.game.component.AbstractComp;
    
	/**
	 * todo，这里攻击会改变生命组件的值，如果对方死亡，重新转入Idle状态
	 * */
	public class AttackComp extends AbstractComp
	{
		private var animation:String;
		
		public function AttackComp(animation:String="attack")
		{
			super();
			this.animation=animation;
		}
		override protected function whenActive():void
		{
			if(!(_owner is Character)) throw new Error("FollowComp can only be added to Character!");
			super.whenActive();
			if(theOwner.followingTarget){
				theOwner.direction=Direction.getDirectionBetweenTiles(theOwner.tileBounds.x,theOwner.tileBounds.y,theOwner.followingTarget.tileBounds.x,theOwner.followingTarget.tileBounds.y);
				theOwner.gotoAndPlay(animation);
				theOwner.followingTarget.onTileMove.add(onTargetMove);
			}
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			if(theOwner.followingTarget){
				theOwner.followingTarget.onTileMove.remove(onTargetMove);
			}
		}
		
		private function onTargetMove(target:IDisplayEntity,delta:Point):void
		{
			if(theOwner.followingTarget){
				theOwner.setState(CharacterState.FOLLOW);
			}
		}
		
		private function get theOwner():Character
		{
			return (_owner as Character);
		}
	}
}