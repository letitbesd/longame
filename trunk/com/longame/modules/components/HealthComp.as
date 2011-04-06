package com.longame.modules.components
{
    import com.longame.managers.ProcessManager;
    import com.longame.modules.core.IEntity;
    import com.longame.modules.entities.IHealthEntity;
    
    import com.longame.utils.debug.Logger;

    /**
     * 生命值组件，推荐IHealthEntity添加
     */
    public class HealthComp extends AbstractComp
    {
		/**
		 * 满生命值
		 * */
        public var maxHealth:Number = 100;
		/**
		 * 如果死亡，是否自动清除显示个体，IEntity
		 * */
        public var destroyOnDeath:Boolean = true;
		/**
		 * 所有伤害都具备的伤害加成，默认1，就是不加成
		 * */
        public var hurtMagnitude:Number = 1.0;
		public var healMagnitude:Number = 1.0;
		/**
		 * 不同伤害方式的特定伤害加成
		 * */
		public var hurtModifier:Array = new Array();
		public var healModifier:Array = new Array();
		/**
		 * 暂不知用途
		 * */
		public var lastHurtTimeFade:Number = 200;
        
        override protected function doWhenActive():void
        {
            _health = maxHealth;
            _timeOfLastHurt = -1000;
        }
		
		override protected function doWhenDeactive():void
		{
			
		}
        /**
         * 多少毫秒没有受到攻击了
         */
        public function get timeSinceLastHurt():Number
        {
            return ProcessManager.virtualTime - _timeOfLastHurt;
        }
		/**
		 * 多少毫秒没有受到治疗了
		 * */
		public function get timeSinceLastHeal():Number
		{
			return ProcessManager.virtualTime - _timeOfLastHeal;
		}
        
        /**
         * A value which fades from 1 to 0 as time passes since the last hurt.
		 *暂不知用途
         */
        public function get lastHurtFade():Number
        {
            var f:Number = 1.0 - (timeSinceLastHurt / lastHurtTimeFade);
            f *= hurtMagnitude;
            if(f<0) return 0;
			if(f>1) return 1;
			return f;
        }
        
        /**
         * 伤害总值
         */
        public function get totalHurt():Number
        {
			return _totalHurt;
//            return maxHealth - _health;
        }
		/**
		 * 治疗总值
		 * */
		public function get totalHeal():Number
		{
			return _totalHeal;
		}
        /**
		 * 当前生命值
		 * */
        public function get health():Number
        {
            return _health;
        }
        public function set health(value:Number):void
        {
            // Clamp the amount of hurt.
            if(value < 0)
                value = 0;
            if(value > maxHealth)
                value = maxHealth;
            
			if(owner is IHealthEntity){
				//受伤害分发
				if(value<_health)                  (owner as IHealthEntity).onHurted.dispatch(owner,_health-value,_lastOriginator);
				//受治疗分发
				if(_health > 0 && value > _health) (owner as IHealthEntity).onHealed.dispatch(owner,value,_lastOriginator);
				//死亡分发
				if(_health > 0 && value == 0)      (owner as IHealthEntity).onDied.dispatch(owner,_health,_lastOriginator);
				//复活分发
				if(_health == 0 && value > 0)      (owner as IHealthEntity).onResurrected.dispatch(owner,value,_lastOriginator);
			}
            if(value<health) _totalHurt+=_health-value;
			else             _totalHeal+=value-_health;
            // Set new health value.
            //Logger.print(this, "Health becomes " + _Health);
            _health = value;
            
            // Handle destruction...
            if(destroyOnDeath && _health <= 0)
            {
                // Kill the owning container if requested.
                owner.destroy();
            }
        }
        
        /** 
         * 受伤害
         * @param amount 伤害值，只能为负
		 * @param originator： 伤害发起对象
         * @param hurtType： 伤害类型
		 * todo， 会触发相应的action
         */
        public function hurt(amount:Number, originator:IEntity=null, hurtType:String = null):void
        {
			if(amount==0) return;
			if(amount>0) {
				Logger.error(this,"hurt","You meant to heal the uint? use heal method please!");
				return;
			}
            this.changeTheHealth(amount,originator,hurtType);
        }
		/** 
		 * 受治疗
		 * @param amount 治疗值，只能为正
		 * @param originator： 治疗发起对象
		 * @param hurtType： 治疗类型
		 * todo， 会触发相应的action
		 */
		public function heal(amount:Number,originator:IEntity=null,healType:String=null):void
		{
			if(amount==0) return;
			if(amount<0) {
				Logger.error(this,"heal","You meant to hurt the uint? use hurt method please!");
				return;
			}
			this.changeTheHealth(amount,originator,healType);
		}
		/**
		 * 改变生命值
		 * @param amount:     改变值
		 * @param originator: 发起者，通常是对手或者队友 
		 * @param type:       促使改变的类型
		 * */
		private function changeTheHealth(amount:Number,originator:IEntity=null,type:String=null):void
		{
			_lastOriginator = originator;
			var modifier:Array=(amount>0)?healModifier:hurtModifier;
			// Allow modification of hurt based on type.
			if(type && modifier.hasOwnProperty(type))
			{
				//Logger.print(this, "Hurt modified by entry for type '" + hurtType + "' factor of " + HurtModifier[hurtType]);
				amount *= modifier[type];
			}
			
			// For the flash magnitude, average in preceding fade. 
			//do what？
			if(amount<0) {
				hurtMagnitude = Math.min(1.0 , (amount / _health) * 4);
				_timeOfLastHurt = ProcessManager.virtualTime;
			}else{
				healMagnitude = Math.min(1.0 , (amount / _health) * 4);
				_timeOfLastHeal = ProcessManager.virtualTime;
			}        
			// Apply the hurt.
			health -= amount;
			
			// If you wanted to do clever things with the last guy to hurt you,
			// you might want to keep this value set. But since it can have GC
			// implications and also lead to stale data we clear it.
			_lastOriginator = null;
		}
		/**
		 * 复活
		 * */
        public function resurrect():void
		{
			this.health=this.maxHealth;
		}
		/**
		 * 直接弄死
		 * */
		public function dead():void
		{
			this.health=0;
		}
		/**
		 * 是否已经死了
		 * */
        public function get isDead():Boolean
        {
            return _health <= 0;
        }
        
        private var _health:Number = 100;
        private var _timeOfLastHurt:Number = 0;
		private var _timeOfLastHeal:Number=0;
		private var _totalHurt:Number = 0;
		private var _totalHeal:Number = 0;
		/**
		 * 最近发起治疗或伤害的个体对象
		 * */
        private var _lastOriginator:IEntity = null;
        
    }
}
