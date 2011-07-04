package com.longame.commands.effect {
	import com.longame.commands.base.Command;
	import com.longame.core.ITickedObject;
	import com.longame.managers.ProcessManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

    /**
	 * 某个显示对象或某些显示对象的颤动效果，比如某个给力的攻击会造成屏幕的颤动
	 * Example:
	 *   var shock:ShockEffect=new ShockEffect(1000);
	 *   shock.addTarget(layer1,11);
	 *   shock.addTarget(layer2,22);
	 *   shock.addTarget(layer3,44);
	 *   shock.onComplete.add(onShocked);
	 *   shock.execute();
	 * */
    public class ShockEffect extends Command implements ITickedObject
	{
        private var shockPool:Vector.<Vector.<Vector.<Number>>>;
        private var targets:Array=[];
        private var magnitudes:Vector.<Number>;
        private var positions:Vector.<Vector.<Number>>;
        private var theShock:Vector.<Vector.<Number>>;
        private var count:uint;
        private var _isShocking:Boolean;
        private var position:uint;
        private var length:uint;

        private static const PI:Number = 3.14159265358979;
        private static const TWO_PI:Number = 6.28318530717959;
        private static const VARIATION:Number = 0.314159265358979;
        private static const HALF_VARIATION:Number = 0.15707963267949;
		//7种移动的帧数？
        private static const DURATIONS:Vector.<uint> = Vector.<uint>([1, 1, 1, 2, 2, 3, 4]);
		//7种移动的速度？
        private static const MAGNITUDES:Vector.<Number> = Vector.<Number>([0.63, 1, 0.71, 0.51, 0.34, 0.22, 0.1]);
		//震动时发生10次位置移动，每次移动随机从上面取？
        private static const SHOCKS:uint = 10;
		/**
		 * @param delay:延迟多少毫秒执行
		 * */
        public function ShockEffect(delay:int=0){
			super(delay);
            this.shockPool = this.createShocks();
            this.magnitudes = new Vector.<Number>();
            this.positions = new Vector.<Vector.<Number>>();
            this.count = 0;
            this.length = this.shockPool[0].length;
            this.position = 0;
        }
		/**
		 * 添加一个受震动的对象
		 * @param target: 任何具有x，y属性的对象都可以，之所以不限定DisplayObject是为了兼顾IDisplayEntity
		 * @param magnitude: 震动幅度
		 * */
        public function addTarget(target:Object, magnitude:Number):void{
            this.targets[this.count] = target;
            this.magnitudes[this.count] = magnitude;
			this.count++;
        }
		override protected function doExecute():void
		{
			if (this._isShocking){
				return;
			};
			var target:* = this.targets[0];
			if (!target){
				return;
			};
			var i:int;
			while (i < this.count) {
				target = this.targets[i];
				this.positions[i] = Vector.<Number>([target.x, target.y]);
				i++;
			};
			this.theShock = this.shockPool[((Math.random() * SHOCKS) | 0)];
			this.position = 0;
			this._isShocking = true;
			ProcessManager.addTickedObject(this);
		}
        public  function onTick(deltaTime:Number):void{
            var target:*;
            var i:int;
            while (i < this.count) {
                target = this.targets[i];
                target.x = (target.x + (this.theShock[this.position][0] * this.magnitudes[i]));
                target.y = (target.y + (this.theShock[this.position][1] * this.magnitudes[i]));
                i++;
            };
            if (++this.position == this.length){
                target = this.targets[0];
                this._isShocking = false;
                this.complete();
            };
        }
        public function get isShocking():Boolean{
            return (this._isShocking);
        }
		override protected function complete():void
		{
			ProcessManager.removeTickedObject(this);
			this.targets.length=0;
			super.complete();
		}
        private function createShocks():Vector.<Vector.<Vector.<Number>>>{
            var shocks:Vector.<Vector.<Vector.<Number>>> = new Vector.<Vector.<Vector.<Number>>>(SHOCKS, true);
            var i:int;
            while (i < SHOCKS) {
                shocks[i] = this.createShock();
                i++;
            };
            return (shocks);
        }
        private function createShock():Vector.<Vector.<Number>>{
            var xx:Number;
            var yy:Number;
			var xx1:Number = 0;
			var yy1:Number = 0;
            var duration:Number;
			var duarations:uint = DURATIONS.length;
            var speed:Number;
            var angle:Number = (Math.random() * TWO_PI);
            var shock:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
            var i:int;
			var j:int;
            while (i < duarations) {
                duration = DURATIONS[i];
                if (i < (duarations - 1)){
                    speed = (MAGNITUDES[i] / duration);
                    xx = (Math.cos(angle) * speed);
                    yy = (Math.sin(angle) * speed);
                } else {
                    speed = (1 / duration);
                    xx = (-(xx1) * speed);
                    yy = (-(yy1) * speed);
                };
                j = 0;
                while (j < DURATIONS[i]) {
                    xx1 = (xx1 + xx);
                    yy1 = (yy1 + yy);
                    shock.push(Vector.<Number>([xx, yy]));
                    j++;
                };
                angle = (angle + ((PI - HALF_VARIATION) + (Math.random() * VARIATION)));
                i++;
            };
            return (shock);
        }
    }
}