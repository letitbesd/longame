package com.longame.modules.components
{
	import com.longame.core.long_internal;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.CharacterState;

	public class IdleStandComp extends AbstractComp
	{
		[Link]
		public var think:ThinkingComp;
		[Link]
		public var idleWalk:IdleWalkComp;
		
		private var animation:String;
		private var minTime:int;
		private var maxTime:int;
		
		private var thinked:Boolean;
		/**
		 * @param animation 播放的动画
		 * @param minTime   站立的最少时间，秒
		 * @param maxTime   站立的最久时间，秒
		 * 对象会在minTime至maxTime之间随机寻找一个时间停留，停留时间到了，如果有IdleWalkComp,则让其激活，自己消失，否则一直处于这个状态，除非owner状态改变为非idle
		 * */
		public function IdleStandComp(animation:String="stand",minTime:int=3,maxTime:int=6)
		{
			super();
			this.animation=animation;
			this.minTime=minTime;
			this.maxTime=maxTime;
		}
		override protected function doWhenActive():void
		{
			if(!(_owner is Character)) throw new Error("IdleStandComp should be added only Character!");
			super.doWhenActive();
			thinked=false;
			(_owner as Character).gotoAndPlay(this.animation);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		override protected function doWhenRefresh():void
		{
			super.doWhenRefresh();
			if(think&&idleWalk&&(!thinked)){
				var stayTime:int=minTime+Math.floor(Math.random()*(maxTime-minTime));
				stayTime=Math.max(1,stayTime)*1000;
				think.think(goWalkState,stayTime);
				thinked=true;
			} 
		}
		/**
		 * 站立时间到，让其随意行走
		 * */
		private function goWalkState():void
		{
			if(!this.actived) return;
			if(idleWalk) (_owner as Character).state=CharacterState.IDLE_WALK;
		}
	}
}