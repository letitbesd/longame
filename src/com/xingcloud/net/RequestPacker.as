package com.xingcloud.net
{
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.net.connector.Connector;
	import com.xingcloud.net.connector.MessageResult;
	import com.xingcloud.tasks.TaskEvent;
	import com.xingcloud.tasks.tick.ITick;
	import com.xingcloud.tasks.tick.TickManager;
	import com.xingcloud.util.Debug;
	import com.xingcloud.util.Reflection;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *同步开始时进行派发
	 * @eventType com.xingcloud.net.SyncEvent
	 */
	[Event(type="com.xingcloud.net.SyncEvent", name="sync_start")]
	/**
	 *同步完成时进行派发
	 * @eventType com.xingcloud.net.SyncEvent
	 */
	[Event(type="com.xingcloud.net.SyncEvent", name="sync_complete")]
	/**
	 *同步重试时派发
	 * @eventType com.xingcloud.net.SyncEvent
	 */
	[Event(type="com.xingcloud.net.SyncEvent", name="sync_retry")]
	/**
	 *同步失败时派发
	 * @eventType com.xingcloud.net.SyncEvent
	 */
	[Event(type="com.xingcloud.net.SyncEvent", name="sync_error")]
	/**
	 *
	 * 请求打包,用于将一系列请求按照规则进行打包发送.在增加请求的时候即自动开始,在达到最大队列长度或超过时间周期后自动发送.
	 * 也可以调用<code>send</code>立即发送.
	 *
	 */
	public class RequestPacker extends EventDispatcher implements ITick
	{
		/**
		 *新建一个请求打包类.
		 * @param service 指定请求的地址
		 *
		 */
		public function RequestPacker(service:String)
		{
			if (!service)
				throw new Error("A request gateway should be given.");
			_mainService=service;
			_requests=[];
			_requestCache=new Dictionary();
		}

		/**
		 * 请求队列达到这个长度后就会向服务器发送
		 * @default 5
		 * */
		public var minLength:uint=5;
		/**
		 * 请求发送的最短时间周期,单位为毫秒
		 * @default 2000
		 * */
		public var minPeriod:uint=2000;
		/**
		 *请求发送失败后重试的次数
		 * @default 3
		 */
		public var retryTime:int=3;

		//上次发送时间
		private var _latestSendTime:int=0;

		//请求接口
		private var _mainService:String;

		//发送后的请求缓存
		private var _requestCache:Dictionary;

		//待发送的请求
		private var _requests:Array;

		//是否开始发送
		private var _started:Boolean=false;

		/**
		 *增加一个请求
		 * @param request 新增的请求对象
		 *
		 */
		public function addRequest(request:IPackableRequest):void
		{
			_requests.push(request);
			if (!_started)
			{
				_started=true;
				TickManager.addTick(this);
			}
		}

		/**
		 *移除一个请求
		 * @param request 移除的请求对象
		 *
		 */
		public function removeRequest(request:IPackableRequest):void
		{
			var index:int=_requests.indexOf(request);
			if (index != -1)
			{
				_requests.splice(index, 1);
			}
		}

		/**
		 *清除队列
		 *
		 */
		public function clear():void
		{
			_requests=[];
		}

		/**
		 *立即发送当钱队列中所有请求
		 *
		 */
		public function send():void
		{
			dispatchEvent(new SyncEvent(SyncEvent.SYNC_START));
			var batch:Array=[];
			var index:int=0;
			for each (var request:IPackableRequest in _requests)
			{
				var requestData:Object=request.data;
				requestData.index=index++;
				batch.push(requestData);
			}
			var connector:Connector=new XingCloud.defaultConnector(_mainService, batch, XingCloud.needAuth, retryTime);
			_requestCache[connector.msgId]=_requests;
			connector.addEventListener(TaskEvent.TASK_COMPLETE, onComplete);
			connector.addEventListener(TaskEvent.TASK_RETYR, onRetry);
			connector.addEventListener(TaskEvent.TASK_ERROR, onError);
			connector.execute();
			_requests=[];
		}

		/**
		 * 停止发送进程
		 * */
		public function stop():void
		{
			if (_started)
			{
				_started=false;
				TickManager.removeTick(this);
			}
		}

		public function tick():void
		{
			if ((_requests.length >= minLength) || (_latestSendTime && (getTimer() - _latestSendTime >= minPeriod)))
			{
				_latestSendTime=getTimer();
				send();
			}
		}

		protected function onRetry(event:TaskEvent):void
		{
			dispatchEvent(new SyncEvent(SyncEvent.SYNC_RETYR));
		}


		protected function onComplete(event:TaskEvent):void
		{
			var result:MessageResult=(event.task as Connector).data;
			var cache:Array=_requestCache[result.id];
			var batch:Array=result.data as Array;
			if (batch && cache && batch.length <= cache.length)
			{
				dispatchEvent(new SyncEvent(SyncEvent.SYNC_COMPLETE));
				for (var i:int=0; i < batch.length; i++)
				{
					var obj:Object=batch[i];
					(cache[obj.index] as IPackableRequest).handleDataBack(obj);
				}
			}
			else
			{
				dispatchEvent(new SyncEvent(SyncEvent.SYNC_ERROR));
				Debug.error("Server return a invalid data.", this);
			}
			delete _requestCache[result.id];
		}

		protected function onError(event:TaskEvent):void
		{
			dispatchEvent(new SyncEvent(SyncEvent.SYNC_ERROR));
			Debug.error("Sync Error:" + (event.task as Connector).data.errorMsg, this);
		}
	}
}

