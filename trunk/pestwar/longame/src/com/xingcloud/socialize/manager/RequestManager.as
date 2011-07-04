/**
 * 请求出入口管理
 */
package com.xingcloud.socialize.manager
{
	import com.xingcloud.socialize.ElexProxy;
	import com.xingcloud.socialize.IElexRequest;
	import com.xingcloud.socialize.ProxySession;
	import com.xingcloud.socialize.mode.RequestResponder;
	import com.xingcloud.socialize.utils.Console;

	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;

	/**
	 *
	 * @author jerry li
	 *
	 */
	public class RequestManager
	{

		private var _requestQueue:Array;
		private var _requestTimeoutTimer:Timer=null;
		private var _activeRequest:IElexRequest=null;
		private var _retryCount:int;
		private const MAXRETRY:int=3;
		private const MAXTIMEEVERYREQUEST:int=5000;
		private var _lc:LocalConnection;

		public function RequestManager()
		{
			this._requestQueue=new Array();
		}

		public function addRequest(request:IElexRequest):Boolean
		{
			_requestQueue.push(request);
			processNextRequest();
			return true;
		}

		private function processNextRequest():void
		{
			if (((this._activeRequest) || ((this._requestQueue.length == 0))))
			{
				return;
			}
			;
			//停止时间计数
			this.stopRequestTimeoutTimer();
			this._retryCount=0;

			Console.print("this._requestQueue.length-------------" + this._requestQueue.length);



			this._activeRequest=this._requestQueue.shift();
			try
			{
				performSendRequest(_activeRequest);
			}
			catch (e:Error)
			{
				_activeRequest.failListener(new RequestResponder(_activeRequest.method, e.message, null, RequestResponder.ERRORCODE));
				_activeRequest=null;
				processNextRequest();
				return;
			}
			;

			this.startRequestTimeoutTimer();
		}

		private function performSendRequest(request:IElexRequest):void
		{
			Console.print("send to sdkBridge----------sdkBridge" + ElexProxy.instance.proxySession.connectId);
			Console.print("request.method-------------" + request.method);
			Console.print("request.params-------------" + request.params);
			try
			{
				if (Boolean(request.params))
				{
					getProxyConnect().send("sdkBridge" + ElexProxy.instance.proxySession.connectId, request.method, request.params);
				}
				else
				{
					getProxyConnect().send("sdkBridge" + ElexProxy.instance.proxySession.connectId, request.method);
				}
			}
			catch (e:Error)
			{
				Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(_activeRequest.method, e.message, null, RequestResponder.ERRORCODE)) : trace("fuction is null");
				_activeRequest=null;
			}

		}

		private function getProxyConnect():LocalConnection
		{
			if (!_lc)
			{
				_lc=new LocalConnection();
				_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleLocalAsyncErrorEvent);
				_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLocalSecurityErrorEvent);
				_lc.addEventListener(StatusEvent.STATUS, handleLocalStatusEvent);
				_lc.allowDomain("*");
				_lc.connect("sdkProxy" + ElexProxy.instance.proxySession.connectId);
				_lc.client=this;
			}

			return _lc;
		}

		private function handleLocalSecurityErrorEvent(e:SecurityErrorEvent):void
		{
			Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(_activeRequest.method, e.text, null, RequestResponder.ERRORCODE)) : trace("fuction is null");
			_activeRequest=null;
			processNextRequest();
			return;
		}
		//TODO 是否需要处理错误
		private function handleLocalStatusEvent(e:StatusEvent):void
		{
			if (e.level == "error")
			{
				Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(_activeRequest.method, e.code, null, RequestResponder.ERRORCODE)) : trace("fuction is null");
				_activeRequest=null;
				processNextRequest();
			}
			else
			{

			}
		}

		private function handleLocalAsyncErrorEvent(e:AsyncErrorEvent):void
		{
			Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(_activeRequest.method, e.error.message, null, RequestResponder.ERRORCODE)) : trace("fuction is null");
			_activeRequest=null;
			processNextRequest();
			return;
		}

		public function dataFromBridge(method:String, data:*, status:int=1):void
		{
			Console.print("-------------------------dataFromBridge-----------------");
			Console.print("method" + method);
			Console.print("status" + status);

			if (status == 1)
			{
				Console.print("this._activeRequest.method" + this._activeRequest.method);

				if (this._activeRequest.method == method)
				{

					if (Boolean(_activeRequest.resultListener))
					{
						_activeRequest.resultListener(new RequestResponder(method, "success", data, RequestResponder.SUCCESSRCODE))
					}
					else
					{
						Console.print("this request haven't resultlistener");
					}

					Console.print("this request " + this._activeRequest.method + "is over");
					//删除单前请求
					_activeRequest=null;
					processNextRequest();
				}
			}
			else
			{
				if (this._activeRequest.method == method)
				{
					Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(method, "failed", data, RequestResponder.ERRORCODE)) : trace("function is null");
					_activeRequest=null;
					processNextRequest();
				}
			}

		}

		private function stopRequestTimeoutTimer():void
		{
			if (this._requestTimeoutTimer)
			{
				this._requestTimeoutTimer.stop();
				this._requestTimeoutTimer.removeEventListener(TimerEvent.TIMER, onRequestTimeout);
				this._requestTimeoutTimer=null;
			}
		}

		private function startRequestTimeoutTimer():void
		{
			this._requestTimeoutTimer=new Timer(MAXTIMEEVERYREQUEST, 1);
			this._requestTimeoutTimer.addEventListener(TimerEvent.TIMER, this.onRequestTimeout);
			this._requestTimeoutTimer.start();
		}

		private function onRequestTimeout(event:TimerEvent):void
		{
			if (this._activeRequest)
			{
				if (this._retryCount < MAXRETRY)
				{
					this._retryCount++;
					this.stopRequestTimeoutTimer();
					//go on...
					performSendRequest(_activeRequest);
					this.startRequestTimeoutTimer();
				}
				else
				{
					Boolean(_activeRequest.failListener) ? _activeRequest.failListener(new RequestResponder(_activeRequest.method, "Request Time Out", null, RequestResponder.ERRORCODE)) : trace();
					this._activeRequest=null;
					processNextRequest();
				}
			}
		}


	}
}