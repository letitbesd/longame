package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.game.component.AbstractComp;
	import com.longame.game.component.IdleWalkComp;
	import com.longame.game.component.KeyboardController;
	import com.longame.game.component.MouseController;
	import com.longame.game.component.PathComp;
	import com.longame.game.component.SpeakComp;
	import com.longame.game.component.ThinkingComp;
	import com.longame.game.component.fight.FollowComp;
	import com.longame.game.component.fight.HealthComp;
	import com.longame.game.core.EntityTile;
	
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

    use namespace long_internal;
    /**
	 * 游戏中人物和怪物的基类
	 * */
	public class Character extends AnimatorEntity implements IHealthEntity, IMovableEntity
	{
		public function Character(id:String=null)
		{
			super(id);
			//添加生命值组件
			_health=new HealthComp();
			this.add(_health);
			//寻路组件
			_path=new PathComp();
			this.add(_path);
			//思考组件
			_thinker=new ThinkingComp();
			this.add(_thinker);
			//追随组件
			var follower:FollowComp=new FollowComp();
			this.add(follower,CharacterState.FOLLOW);
		}
		protected var speakComp:SpeakComp;
		/**
		 * 说话
		 * @param title:标题
		 * @param content:内容
		 * @param showTime:显示时间，秒
		 * */
		public function speak(title:String,content:String=null,showTime:int=3,offsetX:Number=0,offsetY:Number=0):SpeakComp
		{
			if(speakComp==null){
				speakComp=new SpeakComp();
				this.add(speakComp);
			}
			speakComp.speak(title,content,showTime,offsetX,offsetY);
			return speakComp;
		}
		public var onFollowingChanged:Signal=new Signal(Character);
		protected var _followingTarget:Character;
		public function get followingTarget():Character
		{
			return _followingTarget;
		}
		public function set followingTarget(value:Character):void
		{
//			if(_followingTarget==value) return;
			if(value==null){
				
			}else{
				if(_followingTarget !=value) {
					var old:Character=_followingTarget;
					_followingTarget=value;
					onFollowingChanged.dispatch(old);
				}
				this.setState(CharacterState.FOLLOW);
			}
		}
		/**
		 * 对象是否处于忙碌状态，忙碌状态不会进行目标探测，也不会轻易改变状态
		 * */
		public function isBusy():Boolean
		{
			//任何处于Idle状态下的都是不忙碌的
			if ((this.getState()==CharacterState.IDLE_STAND)||(this.getState()==CharacterState.IDLE_WALK)) return false;
			//任何处于攻击，死亡，逃跑状态的角色都是忙碌的
			if ((this.getState()==CharacterState.ATTACK)||(this.getState()==CharacterState.DIE)||(this.getState()==CharacterState.ESCAPE)) return true;
			//处于follow状态并且follow的对象是敌人，也是忙碌的
			if ((this.getState()==CharacterState.FOLLOW)&&(this.followingTarget&&(this.followingTarget.faction!=this.faction))) return true;
			
			return false;
		}
		protected var _path:PathComp;
		/**
		 * 寻路组件
		 * */
		public function get path():PathComp
		{
			return _path;
		}
		
		protected var _thinker:ThinkingComp;
		public function get thinker():ThinkingComp
		{
			return _thinker;
		}
		protected var _health:HealthComp;
		public function get health():HealthComp
		{
			return _health;
		}
		protected var _speed:Number=1;
		public function get speed():Number
		{
			return _speed*_speedScale;
		}
		public function set speed(value:Number):void
		{
			_speed=value;
		}
		protected var _speedScale:Number=1;
		public 	function get speedScale():Number
		{
			return _speedScale;
		}
		public function set speedScale(value:Number):void
		{
			_speedScale=value;
		}
		/**signals**/
		protected var _onHurted:Signal;
		public function get onHurted():Signal
		{
			if(_onHurted==null) _onHurted=new Signal(IHealthEntity,Number,AbstractEntity);
			return _onHurted;
		}
		
		protected var _onHealed:Signal;
		public function get onHealed():Signal
		{
			if(_onHealed==null) _onHealed=new Signal(IHealthEntity,Number,AbstractEntity);
			return _onHealed;
		}
		protected var _onDied:Signal;
		public function get onDied():Signal
		{
			if(_onDied==null) _onDied=new Signal(IHealthEntity,Number,AbstractEntity);
			return _onDied;
		}
		protected var _onResurrected:Signal;
		public function get onResurrected():Signal
		{
			if(_onResurrected==null) _onResurrected=new Signal(IHealthEntity,Number,AbstractEntity);
			return _onResurrected;
		}
		protected var _faction:String=CharacterFaction.ALLY;
		/**
		 * 阵营
		 * */
		public function get faction():String
		{
			return _faction;
		}
		public function set faction(value:String):void
		{
			CharacterFaction.varifyFaction(value);
			_faction=value;
		}
		protected var _offensive:Boolean=true;
		/**
		 * 是否具有进攻性，主动攻击敌方阵营,默认为true
		 * */
		public function get offensive():Boolean
		{
			return _offensive;
		}
		public function set offensive(value:Boolean):void
		{
			_offensive=value;
		}
		protected var _vision:int=4;
		/**
		 * 发现敌人的视力范围，以网格为单位的园的半径
		 * */
		public function get vision():int
		{
			return _vision;
		}
		public function set vision(value:int):void
		{
			_vision=value;
		}
		override protected function whenActive():void
		{
			super.whenActive();
			CharactersMap.add(this);
		}
		override  protected function  whenDeactive():void
		{
			super.whenDeactive();
			CharactersMap.remove(this);
		}
		override long_internal function notifyTileMove(delta:Point):void
		{
			super.notifyTileMove(delta);
			CharactersMap.move(this);
		}
	}
}