package com.longame.game.entity
{
	import com.longame.game.core.bounds.TileBounds;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
    /**
	 * 游戏中所有角色，包括玩家和怪物的分布图，方便进行角色之间的距离判定，比各个角色独立进行判断效率高
	 * */
	public class CharactersMap
	{
		private static var _characters:Dictionary=new Dictionary();
		private static var _movedCharacters:Dictionary;
		
		private static var _followedMap:Dictionary=new Dictionary(true);
		
		public function CharactersMap()
		{
		}
		public static function getCharactersWithFaction(faction:String):Vector.<Character>
		{
			return _characters[faction];
		}
		public static function getOpposedCharacters(ch:Character):Vector.<Character>
		{
			var fac:String=CharacterFaction.getOpposedFaction(ch.faction);
			if(fac){
				return getCharactersWithFaction(fac);
			}
			return null;
		}
		public static function add(ch:Character):void
		{
			var facs:Vector.<Character>=getCharactersWithFaction(ch.faction);
			if(facs==null){
				facs=new Vector.<Character>();
				_characters[ch.faction]=facs;
			}
			if(facs.indexOf(ch)==-1){
				facs.push(ch);
			}
		}
		public static function remove(ch:Character):void
		{
			var facs:Vector.<Character>=getCharactersWithFaction(ch.faction);
			if(facs==null) return;
			var i:int=facs.indexOf(ch);
			if(i>-1) facs.splice(i,1);
		}
		public static function move(ch:Character):void
		{
			//处于空闲状态的角色才会来检测
//			if(ch.state!=CharacterState.IDLE) return;
			if(ch.isBusy()) return;
			if(_movedCharacters==null){
				_movedCharacters=new Dictionary();
				_movedCharacters[CharacterFaction.ALLY]=new Vector.<Character>();
				_movedCharacters[CharacterFaction.ENEMY]=new Vector.<Character>();
				_movedCharacters[CharacterFaction.NEUTRAL]=new Vector.<Character>();
	
			}
			var facs:Vector.<Character>=_movedCharacters[ch.faction];
			if(facs.indexOf(ch)==-1){
				facs.push(ch);
			}
		}
		public static function update():void
		{
			checkVision();
	    }
		
		private static function checkVision():void
		{
			if(_movedCharacters==null) return;
			var movedAllies:Vector.<Character>=_movedCharacters[CharacterFaction.ALLY];
			var movedEnemies:Vector.<Character>=_movedCharacters[CharacterFaction.ENEMY];
			
			var allies:Vector.<Character>=getCharactersWithFaction(CharacterFaction.ALLY);
			var enemies:Vector.<Character>=getCharactersWithFaction(CharacterFaction.ENEMY);
			
			var ch:Character;
			var en:Character;
			//如果allies没有就不检查了？怪物的idle状态切换时会有问题
			for each(ch in movedAllies){
				for each(en in enemies){
					doCheck(ch,en);
				}
			}
			while(movedEnemies.length){
				en=movedEnemies[0];
				for each(ch in allies){
					if(movedAllies.indexOf(ch)>-1) continue;
					doCheck(ch,en);
				}
				movedEnemies.splice(0,1);
			}
			movedAllies.length=0;
		}
		
		private static function doCheck(ch:Character, en:Character):void
		{
			if(ch.offensive || en.offensive) {
				var chTileBounds:TileBounds=ch.tileBounds;
				var enTileBounds:TileBounds=en.tileBounds;
				var dx:int=Math.abs(chTileBounds.x-enTileBounds.x);
				var dy:int=Math.abs(chTileBounds.y-enTileBounds.y);
				var dist:int=dx*dx+dy*dy;
				if(dist<=ch.vision*ch.vision){
					if(ch.offensive&& !ch.isBusy() && !followerIsFull(en)) {
						ch.followingTarget=en;
//						updateFollowMap(en,ch);
					}
				}
				if(dist<=en.vision*en.vision)
				{
					if(en.offensive&& !en.isBusy()  && !followerIsFull(ch)) {
						en.followingTarget=ch;
//						updateFollowMap(ch,en);
					}
				}
			}
		}
//		public static function  removeFollowMap(target:Character,follower:Character):void
//		{
//			var follows:Vector.<Character>=_followedMap[target];
//			if(follows==null) return;
//			var i:int=follows.indexOf(follower);
//			if(i>-1) follows.splice(i,1);
//		}
//		private static function updateFollowMap(target:Character,follower:Character):void
//		{
//			return;
//			var follows:Vector.<Character>=_followedMap[target];
//			if(follows.indexOf(follower)==-1) follows.push(follower);
//		}
		private static function followerIsFull(target:Character):Boolean
		{
			return false;
			var follows:Vector.<Character>=_followedMap[target];
			if(follows==null){
				follows=new Vector.<Character>();
				_followedMap[target]=follows;
				return false;
			}
			return follows.length<4;
		}
		
	}
}