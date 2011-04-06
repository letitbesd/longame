package com.longame.modules.entities
{
	import com.longame.modules.components.HealthComp;
	import com.longame.modules.components.PathComp;
	import com.longame.modules.components.ThinkingComp;
	import com.longame.modules.components.VelocityComp;
	
	import org.osflash.signals.Signal;

    /**
	 * 游戏中人物和怪物的基类
	 * */
	public class Character extends AnimatorEntity implements IHealthEntity, IVelocityEntity
	{
		public function Character(id:String=null)
		{
			super(id);
			//添加生命值组件
			_health=new HealthComp();
			this.add(_health);
			//添加速度组件
			_velocity=new VelocityComp();
			this.add(_velocity);
			//寻路组件
			_path=new PathComp();
			this.add(_path);
			//思考组件
			_thinker=new ThinkingComp();
			this.add(_thinker);
		}
		override protected function registerSignalBus():void
		{
			super.registerSignalBus();
		}
		override protected function unregisterSignalBus():void
		{
			super.unregisterSignalBus();
		}
		protected var _velocity:VelocityComp;
		/**
		 * 速度组件
		 * */
		public function get velocity():VelocityComp
		{
			return _velocity;
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
	}
}