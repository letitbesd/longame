package com.longame.game.component
{
	import com.longame.core.IQueuedObject;
	import com.longame.managers.ProcessManager;
    
    /**
     * 思考组件，简单讲就是延迟执行某个任务
     */
    public class ThinkingComp extends AbstractComp implements IQueuedObject
    {
        protected var _nextThinkTime:int;
        protected var _nextThinkCallback:Function;
        
        /**
         * Schedule the next time this component should think. 
         * @param nextCallback Function to be executed.以后可能是action
         * @param timeTillThink Time in ms from now at which to execute the function (approximately).
         */
        public function think(nextCallback:Function, timeTillThink:int):void
        {
			//没有被激活就不要执行了
			if(!this.actived) return;
            _nextThinkTime = ProcessManager.virtualTime + timeTillThink;
            _nextThinkCallback = nextCallback;
			ProcessManager.queueObject(this);
        }
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			_nextThinkCallback = null;
		}
        public function get nextThinkTime():Number
        {
            return _nextThinkTime;
        }
        
        public function get nextThinkCallback():Function
        {
            return _nextThinkCallback;
        }
        
        public function get priority():int
        {
            return -_nextThinkTime;
        }
        
        public function set priority(value:int):void
        {
            throw new Error("Unimplemented.");
        }
    }
}