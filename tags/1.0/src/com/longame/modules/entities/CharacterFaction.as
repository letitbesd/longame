package com.longame.modules.entities
{
	public class CharacterFaction
	{   
		/**
		 * 跟玩家是同一阵营
		 * */
        public static const ALLY:String="ally";
		/**
		 * 跟玩家是敌对阵营
		 * */
		public static const ENEMY:String="enemy";
		/**
		 * 中立阵营
		 * */
		public static const NEUTRAL:String="neutral";
		
		public static function getOpposedFaction(faction:String):String
		{
			varifyFaction(faction);
			if(faction=="ally") return "enemy";
			if(faction=="enemy") return "ally";
			return null;
		}
		public static function varifyFaction(faction:String):void
		{
			if((faction!="ally")&&(faction!="enemy")&&(faction!="neutral")){
				throw new Error("No faction type with name: "+faction);
			}
		}
	}
}