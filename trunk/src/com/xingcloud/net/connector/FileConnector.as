package com.xingcloud.net.connector
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONDecoder;
	import com.xingcloud.core.XingCloud;
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

	/**
	 * 文件请求连接器，用于创建请求文件的连接器
	 */
	public class FileConnector extends RESTConnector
	{
		/**
		 *创建文件连接器
		 * @param gateway 请求地址
		 * @param command_name 请求接口
		 * @param params 请求参数
		 * @param needAuth 是否需要安全验证
		 * @param format 请求结果格式，详见<code>URLLoaderDataFormat</code>
		 *
		 */
		public function FileConnector(gateway:String,
			command_name:String,
			params:Object=null,
			method:String=URLRequestMethod.POST,
			needAuth:Boolean=false,
			format:String=URLLoaderDataFormat.TEXT)
		{
			super(command_name, params, needAuth, 0, gateway, method, format);
		}

		/**
		 *   @private
		 */
		override protected function onCompleteHandler(evt:Event):void
		{
			var uncompress:Object;
			if (XingCloud.needCompress)
				uncompress=Util.unCompressData(_urlLoader.data, _format == URLLoaderDataFormat.TEXT);
			else
				uncompress=_urlLoader.data;
			try
			{
				var result:Object=new JSONDecoder(uncompress as String, true ).getValue();
				_data=MessageResult.createResult(result);
				notifyError(this);
			}
			catch (e:Error)
			{
				_data=new MessageResult(msgId, MessageResult.SUCCESS_CODE, "", uncompress);
				notifyComplete(this);
			}
		}
	}
}
