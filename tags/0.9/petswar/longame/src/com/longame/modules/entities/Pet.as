package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.managers.ProcessManager;
	import com.longame.modules.components.fight.AttackComp;
	import com.longame.modules.components.IdleWalkComp;
	
	import flash.geom.Point;

	use namespace long_internal;

	public class Pet extends Character
	{
		public function Pet(id:String=null)
		{
			super(id);
			_faction=CharacterFaction.ALLY;
			_offensive=true;
			
			var attack:AttackComp=new AttackComp();
			this.add(attack,CharacterState.ATTACK);
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			this.setInitialTile();
			if(_host) this.followingTarget=_host;
		}
		protected var _host:Hero;
		/***
		 * 主人
		 * */
		public function get host():Hero
		{
		    return _host;
		}
		public function set host(value:Hero):void
		{
			if(_host==value) return;
			_host=value;
			if(_host==null) {
				this.faction=CharacterFaction.NEUTRAL;
			}else{
				if(actived) this.followingTarget=_host;
				this.faction=_host.faction;
			}
		}
		private function setInitialTile():void
		{
			if(_host==null) return;
//			var tiles=_host.parent.map.getWalkableNeighbours(_host.tileBounds.x,_host.tileBounds.y);
			//todo 初始位置
			this.snapToTile(_host.tileBounds.x,_host.tileBounds.y);
		}
	}
}