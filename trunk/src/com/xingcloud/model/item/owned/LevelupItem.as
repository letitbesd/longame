package com.xingcloud.model.item.owned
{
	/**
	 * 可以获得经验不断升级的item，比如某玩家同时拥有多只宠物，每个宠物可以获得经验升级
	 * */
	public class LevelupItem extends OwnedItem
	{
		public function LevelupItem()
		{
			super();
			this.updateWhenLevelUp();
		}
		protected var _exp:int=0;
		public function get exp():int
		{
			return _exp;
		}
		public function set exp(value:int):void
		{
			value=Math.max(0,value);
			if(_exp==value) return;
			var old:int=_exp;
			_exp=value;
			this.whenChange("exp",_exp-old);
			var newLevel:int=_level;
			var nextExp:int=this.getExpWithLevel(_level+1);
			while(_exp>=nextExp){
				newLevel++;
				nextExp=this.getExpWithLevel(newLevel+1);
			}
			if(newLevel!=_level){
				old=_level;
				_level=newLevel;
				this.updateWhenLevelUp();
				this.whenChange("level",_level-old);
			}
		}
		protected var _level:int=1;
		public function get level():int
		{
			return _level;
		}
		public function set level(value:int):void
		{
			value=Math.max(0,value);
			if(_level==value) return;
			this.exp=this.getExpWithLevel(value);
		}
		/**
		 * 当级别发生变化时，更新级别相关的属性
		 * */
		protected function updateWhenLevelUp():void
		{
			
		}
		/**
		 * 获取level级别所需的经验值，这个需要覆盖
		 * */
		public function getExpWithLevel(level:int):int
		{
			return int.MAX_VALUE;
		}
	}
}