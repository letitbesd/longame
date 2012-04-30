package com.xingcloud.tasks{	import com.longame.display.BusyCursor;	import com.xingcloud.util.Reflection;		import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.utils.Timer;
	
	/**	 * 在任务完成后进行派发	 * @eventType com.xingcloud.tasks.TaskEvent	 */	[Event(type="com.xingcloud.tasks.TaskEvent",name="task_complete")]	/**	 * 在任务执行进程中进行派发，用以报告执行进度。	 * @eventType com.xingcloud.tasks.TaskEvent	 */	[Event(type="com.xingcloud.tasks.TaskEvent",name="task_progress")]	/**	 * 在任务出错后进行派发	 * @eventType com.xingcloud.tasks.TaskEvent	 */	[Event(type="com.xingcloud.tasks.TaskEvent",name="task_error")]	/**	 *在任务重试执行时派发	 * @eventType com.xingcloud.tasks.TaskEvent 	 */		[Event(type="com.xingcloud.tasks.TaskEvent",name="task_retry")]	/**	 * 命令的抽象类,无法被直接实例化,具体的命令需要继承此类.	 * <p>当需要执行一系列的命令时,这些命令有一定的执行顺序,或是某些会在同一时间执行,	 * 使用此类来扩展命令队列中的单个命令.</p>	 */	public class Task extends EventDispatcher	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////		/**		 *命令名称 		 */				public var name:String;		/**		 *@private 		 */		protected var _isAborted:Boolean;		/**		 *@private 		 */		protected var _isCompleted:Boolean;		/**		 *@private 		 */		protected var _isExecute:Boolean;		/**		 *@private 		 */		protected var _delay:uint=0;		/**		 *@private 		 */		protected var _timeout:uint =999999;		/**		 *@private 		 */		protected var _retryCount:uint =0;		/**		 *@private 		 */		protected var _completeNum:Number=0;		/**		 *@private 		 */		protected var _totalNum:Number=0;				private var _currentRetry:int=0;		private var _executeTimer:Timer;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 *此类不能直接被实例化,请继承实现所需的命令. 		 * @param delay 延迟执行时间		 * @param timeOut 超时时间		 * @param retryCount 重试次数		 * 		 */				public function Task(delay:uint=0,timeOut:uint=999999,retryCount:uint=0)		{			super();			this._delay=delay;			this._timeout=timeOut;			this._retryCount=retryCount			_isAborted = false;			_isCompleted=false;			_completeNum = 0;			_currentRetry=0;		}		/**		 *终止任务执行 		 * 		 */				public function abort():void		{			clear();			_isAborted=true;		}		/**		 *执行此任务.此方法不可被覆盖,具体执行逻辑请覆盖<code>doExecute()</code>方法		 * 来实现.		 */				final public function execute():void		{			if(_isAborted||_isExecute||_isCompleted)				return;			if(_delay<=0) 				this.doExecute();			else 			{				var t:Timer=new Timer(_delay,1);				t.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);				t.start();			}		}							////////////////////////////////////////////////////////////////////////////////////////		// Protected Methods                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 *实际执行逻辑,请在继承类中重写此方法来实现任务执行. 		 * 		 */				protected function doExecute():void		{//			BusyCursor.show();			_isExecute=true;			if(this._timeout>0) 				this.startTimer();		}				/**		 *@private 		 * 		 */				protected function startTimer():void 		{			_executeTimer = new Timer(timeout * 1000, 1);			_executeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);			_executeTimer.start();		}				/**		 *任务执行成功 		 *@param t 成功的任务		 */				protected function notifyComplete(t:Task):void		{			if(_isExecute)			{				clear();				_isExecute=false;				_isCompleted=true;				dispatchEvent(new TaskEvent(TaskEvent.TASK_COMPLETE,t));//				BusyCursor.hide();			}		}		/**		 *任务执行进度 		 * @param t 通知进度的任务		 */				protected function notifyProgress(t:Task):void		{			dispatchEvent(new TaskEvent(TaskEvent.TASK_PROGRESS, t));		}				/**		 *任务执行失败 		 * @param t 失败的任务		 */				protected function notifyError(t:Task):void		{			if(_isExecute)			{				clear();				_isExecute=false;				this._currentRetry++;				if(needRetry)				{					this.doExecute();					dispatchEvent(new TaskEvent(TaskEvent.TASK_RETYR,t));					return;					}				dispatchEvent(new TaskEvent(TaskEvent.TASK_ERROR,t));//				BusyCursor.hide();			}		}		/**		 *需要重写此方法,在重试,放弃,完成,失败的时候,清理释放数据.包括移除监听,关闭连接,删除引用等. 		 * 如果不进行处理则会造成内存泄露或相应异常.		 */				protected function clear():void		{			_executeTimer.stop();			_executeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);		}		/**		 * 		 * 是否需要重试		 * 		 */				protected function get needRetry():Boolean		{			return _currentRetry<=_retryCount;		}				////////////////////////////////////////////////////////////////////////////////////////		// Override Method                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @inheritDoc 		 */				override public function toString():String		{			return "[" + Reflection.tinyClassName(this)+"]";		}				////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				//延迟执行相应		private function onTimerComplete(event:TimerEvent):void		{			event.target.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);			if(!_isAborted)				doExecute();		}		//超时相应		private function onTimeOut(event:TimerEvent):void 		{			notifyError(this);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////		/**		 * 任务完成率		 * 		 */				public function get completeRate():Number		{			if(_totalNum!=0)				return _completeNum/_totalNum;			else				return 0;		}		/**		 *任务是否完成 		 */				public function get isCompleted():Boolean		{			return _isCompleted;		}							/**		 *超时时间.任务开始执行后一段时间内没有成功或失败的返回,则为超时,任务失败. 		 */				public function get timeout():uint 		{			return _timeout;		}		/**		 * @private		 */				public function set timeout(t:uint):void		{			this._timeout=t;		}		/**		 * 重试的次数.任务执行失败后,再次进行尝试的次数,0为不重试.		 */				public function get retryCount():uint 		{			return _retryCount;		}		/**		 * @private		 */				public function set retryCount(r:uint):void		{			this._retryCount=r;		}		/**		 * 任务延迟执行的时间.触发执行函数后,延迟一段时间再真正开始执行.		 */				public function get delay():uint 		{			return _delay;		}		/**		 * @private		 */				public function set delay(d:uint):void		{			this._delay=d;		}				/**		 *总量		 */		public function get totalNum():Number
		{
			return _totalNum;
		}		/**		 *已完成量		 */		public function get completeNum():Number
		{
			return _completeNum;
		}			}}