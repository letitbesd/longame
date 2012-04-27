package com.longame.commands.net
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.MD5;
	import com.adobe.crypto.SHA1;
	import com.adobe.serialization.json.JSONESequenceEncoder;
	import com.adobe.serialization.json.JSONEncoder;
	import com.adobe.utils.Debug;
	import com.adobe.utils.StringUtil;
	import com.longame.commands.base.Command;
	import com.xingcloud.core.Config;
	
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.getTimer;
	
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;

	/**
	 * 后台连接任务，通常游戏数据的后台交互用这个，可以指定默认的gateway，也可以使用多个gateway，他将保持一个gateway只会连接一个
	 * example1:
	 * 		Remoting.defaultGateway="http://www.elex.com/gateway.php";
	 * 		var amf:Remoting=new Remoting("buyItem",{itemId:'1001',num:2},Remoting.AMF);
	 * 		amf.onSuccess=this.onSuccess;
	 * 		amf.onFail=this.onFail;
	 * 		amf.excute();
	 * 
	 *      function onSuccess(data:Object):void
	 * 		{
	 * 			//处理返回的数据
	 * 		}
	 *      
	 * example2:
	 * 		var amf:Remoting=new Remoting("buyItem",{itemId:'1001',num:2},Remoting.GET);
	 *      amf.addEventListener(TaskEvent.TASK_COMPLETE,onSuccess);
	 * 		amf.addEventListener(TaskEvent.TASK_ERROR,onFail);
	 * 		amf.excute();
	 *      function onSuccess(e:TaskEvent):void
	 * 		{
	 * 			var task:Remoting=e.task as Remoting;
	 *          var data:Object=task.data;
	 * 			//处理返回的数据
	 * 		}
	 *
	 * */
	public class Remoting extends Command
	{
		public static const AMF:String="amf";
		public static const GET:String="get";
		public static const POST:String="post";
		
		/**
		 * 外部回调
		 * onSuccess(data:Object);
		 * onFail(error:String);
		 * */
		public var onSuccess:Function;
		public var onFail:Function;
		
		private static const VER:String="1.0";
		
		private var _gateway:String;
		private var _command:String;
		private var _params:Object;
		private var executor:AbstractLoader;
		private var _method:String;
		private var _dataFormat:String=URLLoaderDataFormat.TEXT;
		private var  oauth:Object;
		
		/**
		 * @param command_name: 以'.'分割的方法名
		 * @param command_args: {key:value,key:value}形式的参数
		 * @param method: Remoting支持三种方式的后台请求，Remoting.AMF,Remoting.GET,Remoting.POST
		 * @param needAuth: 是否需要安全验证
		 * */
		public function Remoting(command_name:String, command_args:Object=null,method:String="amf",gateWay:String=null,needAuth:Boolean=false)
		{
			oauth ={oauth_version:VER};
			if(gateWay==null)
			{
				gateWay=(method==AMF)?Config.amfGateway:Config.restGateway;
			}
			if(needAuth)
			{
				oauth.oauth_signature_method=Config.getConfig("authMethod");
				oauth.oauth_consumer_key=Config.getConfig("consumerKey");
				oauth.realm=gateWay;
				if(oauth.oauth_signature_method=="" || oauth.oauth_consumer_key=="")
				{
					throw new Error("Remoting->Cannot get the params for Auth");
				}
			}
			_method=method;
			
			_command=command_name;
			_gateway=gateWay;
			_params=command_args;
			if(method==AMF){
				executor=new AMFConnecter(command_name,command_args,needAuth?generateHeader(ObjectUtil.copy(command_args)):"",gateWay);
			}else{
				executor=new RESTConnecter(gateWay,command_name,command_args,(needAuth&&method==Remoting.POST)?generateHeader(command_args):"");//flash 仅仅支持post方法加header
				(executor as RESTConnecter).requestMethod=(method.indexOf("get")>=0)?URLRequestMethod.GET:URLRequestMethod.POST;
			}
			executor.onComplete.add(this.onRemotingComplete);
			executor.onError.add(this.onRemotingError);
			executor.onProgress.add(this.onRemotingProgress);
		}
		override protected function doExecute():void
		{
			super.doExecute();
			if(_gateway==null) {
				this.notifyError("no gateway!");
				return;
			}
			trace("Remoting->doExecute: ","Start connect backend: "+_gateway,_command);
			executor.execute();
		}
		public function get method():String
		{
			return _method;
		}
		/**
		 * 如果是rest方法，可能需要设置下daataFormat，以确定返回数据是文本还是二进制或者URLVariables，详见URLLoaderDataFormat
		 * 如果是amf方式，此方法无意义
		 * */
		public function get dataFormat():String
		{
			return this._dataFormat;
		}
		public function set dataFormat(value:String):void
		{
			//如果是amf方式，此方法无意义
			if(this._method==AMF) return;
			(executor as RESTConnecter).loader.dataFormat=value;
		}
		private function onRemotingComplete(cmd:Command):void
		{
			trace("Remoting->onRemotingComplete: ","Connected backend: "+_gateway,_command+" successfully!");
			this.data=cmd.data;
			this.complete();
			if(this.onSuccess!=null){
				onSuccess(data);
				onSuccess=null;
			}
		}
		private function onRemotingProgress(cmd:Command):void
		{
//			this.dispatchEvent(e);
			trace("Remoting->onRemotingProgress, progress: "+cmd.completed+"/"+cmd.total);
		}
		private function onRemotingError(cmd:Command,error:String):void
		{
			trace("Remoting->onRemotingError: ","Connect backend: "+_gateway,_command,"error: "+error);
			this.notifyError(error);
		}
		override protected function notifyError(errorMsg:String):void
		{
			super.notifyError(errorMsg);
			if(!this._hasError) return;
			if(this.onFail!=null){
				onFail(errorMsg);
				onFail=null;
			}			
		}
		/**
		 * 生成加密认证所需的认证头 
		 * @param params 此次请求中的参数
		 * @return 请求头
		 * 
		 */		
		private function generateHeader(params:Object):String
		{
			oauth['oauth_timestamp']=int(Config.systemTime/1000);
			oauth['oauth_nonce']=MD5.hash(oauth['oauth_timestamp'].toString()+Math.random());
			var uri:String=_gateway;
			if(_method!=AMF)
			{
				var commands:Array = _command.split(".");
				for each(var command:String in commands)
				{
					uri += "/"+command;
				}
			}
			var parts:Array=uri.split("?");
			uri=parts[0];
			var temp:Array=[];
			var key:String="";
			for( key in oauth)
			{
				temp.push({key:key,value:oauth[key]});
			}
			if(parts[1])
			{
				var urlParams:Object=URLUtil.stringToObject(parts[1],"&");
				for( key in urlParams)
				{
					temp.push({key:key,value:urlParams[key]});
				}
			}
			temp.sortOn("key");
			var authString:String="";
			for each(var param:Object in temp)
			{
				authString+=param["key"]+"="+param["value"]+"&";
			}
			authString=authString.substr(0,authString.length-1);
			var paramString:String="";
			if(params)
			{
				var jsonEncoder:JSONESequenceEncoder=new JSONESequenceEncoder(params);
				paramString=jsonEncoder.getString();
			}
			var base:String = 'POST&'+encodeURIComponent(uri)+'&'+encodeURIComponent(authString);
			if(paramString)
				base+=('&'+encodeURIComponent(paramString));
			var signature:String =HMAC.hashToBase64(Config.getConfig("secret_key"),base,SHA1);
			oauth['oauth_signature'] = signature;
			var headerString:String="";
			for(key in oauth)
			{
				headerString+= key+'="'+oauth[key]+'",';
			}
			headerString=headerString.substr(0,headerString.length-1);
			return headerString;
		}
	}
}
import com.longame.commands.net.AbstractLoader;

import flash.events.AsyncErrorEvent;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.net.Responder;
import flash.utils.Dictionary;

internal class AMFConnecter extends AbstractLoader
{
	protected var _netConnection:NetConnection;
	protected var _gatewayUrl:String;
	protected var _commandName:String;
	protected var _header:String;
	public var objectEncoding:uint=ObjectEncoding.AMF3;
	public var commandArgs:Object;
	
	// Active connections
	static protected var activeConnections:Dictionary=new Dictionary();
	/**
	 * 如果gateWay为null，请确保设置了defaultGateway属性
	 * */
	public function AMFConnecter(command_name:String, command_args:Object=null,header:String="",gateWay:String=null)
	{
		this._timeout=60;
		//this._retryCount=3;
		this._gatewayUrl=gateWay;
		this._commandName = command_name;
		this.commandArgs = command_args;
		_header=header;
		super(null);
		//如果没有传递gateway，那么使用默认的gateway
		if(this._gatewayUrl==null){
			throw new Error("Please give me a gateway!");
		}
	}
	/**
	 * 保证一个gateWay地址只有一个连接
	 */
	static protected function getActiveConnection( url:String):NetConnection {
		if(activeConnections[url]==null) {
			var nc:NetConnection = new NetConnection();	
			//nc.connect(url);
			activeConnections[url] = nc;
		}
		return activeConnections[url];
	}
	static protected function closeActiveConnection(url:String):void
	{
			var nc:NetConnection = activeConnections[url];
			if(nc!=null && nc.connected) {
				nc.close();
				delete activeConnections[url];
			}
	}
	override protected function doLoad():void
	{
			if(_netConnection==null) 
			{
				_netConnection =new NetConnection();
				if(!_netConnection.connected)
				{
					this.addListeners();
					_netConnection.connect(_gatewayUrl);
				}
				
				_netConnection.objectEncoding = objectEncoding;
				var _amfResponder:Responder = new Responder(onCallSuccess, onCallError);
				var args:Array = [commandName, _amfResponder];
				args.push(commandArgs);
				_netConnection.addHeader("Authorization",false,_header);
				_netConnection.call.apply( _netConnection,args ); 	
			}
	}
	override protected function doCancel():void
	{
		AMFConnecter.closeActiveConnection( _gatewayUrl);
	}
	override protected function addListeners():void
	{
			if(_netConnection==null) return;
			_netConnection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatusEvent );
			_netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadError );
			_netConnection.addEventListener( IOErrorEvent.IO_ERROR,onLoadError );
			_netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onLoadError );		
	}
	override protected function removeListeners():void
	{
			if(_netConnection==null) return;
			_netConnection.removeEventListener( NetStatusEvent.NET_STATUS, onNetStatusEvent );
			_netConnection.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadError );
			_netConnection.removeEventListener( IOErrorEvent.IO_ERROR, onLoadError );
			_netConnection.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, onLoadError );
	}
	private function onCallSuccess(data:Object):void
	{
		this.data=data;
		this.complete();
	}
	private function onCallError(error:Object):void
	{
		var errMsg:String=(error==null)?"Undefined amf error!":String(error.faultString+" in "+error.faultDetail);
		this.notifyError(errMsg);
	}
	private function onNetStatusEvent(event:NetStatusEvent):void
	{
		if(event.info.level=='error') {
			if(this._hasError) return;
			var errorInfo:String="AMF error code: "+event.info.code;
			trace(this.gatewayUrl,_commandName);
			for(var key:String in event.info){
				trace("    "+key+":"+event.info[key]);
			}
			removeListeners();
			this.notifyError(errorInfo);
		} else {
			//Logger.info(this,"onNetStatusEvent","NetStatus Event: " + event.info.code );
		}
	}
	public function get gatewayUrl():String {
		return _gatewayUrl;
	}		
	public function get netConnection():NetConnection {
		return _netConnection;
	}		
	public function get commandName():String {
		return _commandName;
	}
}


import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import mx.rpc.http.HTTPService;
import flash.net.URLRequestHeader;
import flash.display.JointStyle;
import com.longame.commands.net.DataLoader;
import com.adobe.serialization.json.JSONESequenceEncoder;
import com.adobe.serialization.json.JSON;
import com.longame.utils.debug.Logger;
import com.adobe.serialization.json.JSONDecoder;

internal class RESTConnecter extends DataLoader
{
	protected var _gatewayUrl:String;
	protected var _commandName:String;
	protected var _header:String;
	public var requestMethod:String=URLRequestMethod.GET;
	public var commandArgs:Object;
	/**
	 * 一个rest请求
	 * @param url: 请求的rest地址
	 * @param command: 请求的rest服务名，为了和amfConnect统一起来，服务用"."分割，如local.fonts.get 等同于  local/fonts/get
	 * @param params: Object的key-value形式定义的服务请求参数
	 * @param format:  返回数据的格式，见URLLoaderDataFormat
	 * */
	public function RESTConnecter(url:String,command:String, params:Object=null,header:String="",format:String=URLLoaderDataFormat.TEXT)
	{
		super(null,format);
		_timeout=60;
		_gatewayUrl=url;
		_header=header;
		if(_gatewayUrl==null){
			throw new Error("Please give me a gateway!");
		}
		_commandName = command;
		commandArgs = params;
	}
	override protected function doLoad():void
	{
		if(_urlRequest==null)
		{
			_urlRequest = new URLRequest();
		}
		var commands:Array = this.commandName.split(".");
		_urlRequest.url = _gatewayUrl;
		for each(var command:String in commands)
		{
			_urlRequest.url += "/"+command;
		}
		_urlRequest.method=this.requestMethod;
		_urlRequest.requestHeaders=[new URLRequestHeader("Authorization",_header)];
		this.createParams();
		super.doLoad();
	}
	private function createParams():void
	{
		if(this.requestMethod==URLRequestMethod.GET){
			for (var key:String in this.commandArgs){
				if(_urlRequest.url.indexOf("?")==-1) _urlRequest.url+="?";
				_urlRequest.url+=(key+"="+this.commandArgs[key])
			}
		}else{
			_urlRequest.data=new JSONESequenceEncoder(commandArgs).getString();
		}
	}
	override protected function complete():void
	{
		try
		{
			var result:Object=new JSONDecoder(content, true ).getValue();
			if(result.hasOwnProperty("code"))
			{
				if(parseInt(result.code)!=200)
				{
					this.notifyError(result.code+":"+result.message);
				}
				else
				{
					this.data=result;
					super.complete();
				}
			}
			else
			{
				this.data=result;
				super.complete();
			}
		}
		catch (e:Error)
		{
			this.data=this.content;
			super.complete();
		}
	}
	public function get gatewayUrl():String {
		return _gatewayUrl;
	}
	public function get commandName():String {
		return _commandName;
	}
}