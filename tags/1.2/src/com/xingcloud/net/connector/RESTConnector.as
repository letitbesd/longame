package com.xingcloud.net.connector
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.model.DBObject;
	import com.xingcloud.util.Debug;
	import com.xingcloud.util.Util;
	import com.xingcloud.util.objectencoder.ObjectEncoder;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.utils.URLUtil;

	/**
	 * REST连接器，用于创建REST连接
	 */
	public class RESTConnector extends Connector
	{

		/**
		 * 新建一个REST请求
		 * @param url: 请求地址
		 * @param command_name:  请求的接口名称，多级结构使用.号分割
		 * @param params: key-value形式定义的服务请求参数
		 * @param method: REST请求的方法,详见<code>URLRequestMethod</code>
		 * @param format:  返回数据的格式，详见<code>URLLoaderDataFormat</code>
		 * */
		public function RESTConnector(command_name:String,
			params:Object=null,
			needAuth:Boolean=false,
			retryCount:int=0,
			gateway:String="",
			method:String=URLRequestMethod.POST,
			format:String=URLLoaderDataFormat.TEXT)
		{
			if (!gateway)
				gateway=Config.restGateway;
			super(gateway, command_name, params, needAuth, retryCount);
			_requestMethod=method;
			_format=format;
			if (needAuth && method == URLRequestMethod.GET)
				throw new Error("Authentication can not be applied in GET method.");
		}

		protected var _requestMethod:String;
		protected var _format:String;
		protected var _urlLoader:URLLoader;

		protected function addLoaderEventListeners(target:IEventDispatcher):void
		{
			target.addEventListener(Event.COMPLETE, onCompleteHandler);
			target.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			target.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}

		override protected function clear():void
		{
			removeLoaderEventListeners(_urlLoader);
			super.clear();
		}

		override protected function doExecute():void
		{
			_urlLoader=new URLLoader();
			if (XingCloud.needCompress)
				_urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			else
				_urlLoader.dataFormat=_format;
			addLoaderEventListeners(_urlLoader);
			var request:URLRequest=new URLRequest(_url);
			request.method=_requestMethod;
			createParams(request);
			if (_needAuth)
				request.requestHeaders.push(new URLRequestHeader("Authorization", _header));
			if (XingCloud.needCompress)
				request.requestHeaders.push(new URLRequestHeader("Content-Encoding", "gzip"));
			_urlLoader.load(request);
			super.doExecute();
			Debug.log("Send REST request to " + _commandName + "(" + _url + ")" + ",params:", this);
			Debug.log(_commandArgs);
		}

		override protected function generateURL():void
		{
			super.generateURL();
			var commands:Array=_commandName.split(".");
			for each (var command:String in commands)
			{
				_url+="/" + command;
			}
		}

		/**
		 *   @private
		 */
		protected function onCompleteHandler(evt:Event):void
		{
			try
			{
				var result:String;
				if (XingCloud.needCompress)
					result=Util.unCompressData(_urlLoader.data as ByteArray);
				else
					result=_urlLoader.data as String;
//				_data=MessageResult.createResult(JSON.decode(result));
				_data=MessageResult.createResult(new JSONDecoder(result, true ).getValue());
				if ((_data as MessageResult).success)
				{
					notifyComplete(this);
				}
				else
				{
					notifyError(this);
				}
				Debug.log("Get REST response from " + _commandName + "(" + _url + ")" + ",result:", this);
				Debug.log(result);

			}
			catch (e:Error)
			{
				_data=new MessageResult(msgId,
					MessageResult.RESULT_DECODE_ERROR_CODE,
					"JSON decode error:" + e.message,
					_urlLoader.data);
				notifyError(this);
				Debug.log("Get REST response from " + _commandName + "(" + _url + ")" + ",result:", this);
				Debug.log("Invalid data format!");
			}
		}


		/**
		 *   @private
		 */
		protected function onErrorHandler(evt:ErrorEvent):void
		{
			Debug.log("Get REST response from " + _commandName + "(" + _url + ")" + ",result:", this);
			Debug.log(evt.text);
			_data=new MessageResult(msgId, MessageResult.NETWORK_ERROR_CODE, evt.text, evt);
			notifyError(this);
		}

		/**
		 *   @private
		 */
		protected function onProgressHandler(evt:ProgressEvent):void
		{
			this._completeNum=evt.bytesLoaded;
			this._totalNum=evt.bytesTotal;
			notifyProgress(this);
		}

		protected function removeLoaderEventListeners(target:IEventDispatcher):void
		{
			target.removeEventListener(Event.COMPLETE, onCompleteHandler);
			target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			target.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}

		private function createParams(request:URLRequest):void
		{
			if (_requestMethod == URLRequestMethod.GET)
			{
				request.data="?" + URLUtil.objectToString(_commandArgs, "&");
			}
			else
			{
				try
				{
					var json:String=new ObjectEncoder(_commandArgs, ObjectEncoder.JSON, true, [DBObject]).JsonString;
					if (XingCloud.needCompress)
						request.data=Util.compressTextData(json);
					else
						request.data=json;
				}
				catch (e:Error)
				{
					throw new Error("Can't parse parameters for the request.");
				}
			}
		}
	}
}
