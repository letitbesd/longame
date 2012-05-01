﻿package Playtomic {	import flash.events.Event;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.net.URLVariables;	import flash.utils.Timer;	import flash.utils.ByteArray;	import flash.utils.describeType;		internal final class PRequest extends URLLoader	{		private static var Pool:Vector.<PRequest>;		private static var Queue:Vector.<PRequest>;		private static var URLStub:String;		private static var URLTail:String;		private static var URL:String;				private var urlRequest:URLRequest = new URLRequest();		private var complete:Function;		private var callback:Function;		private var handled:Boolean;		private var logging:Boolean;		private var postdata:Object;		private var time:int;				public static function Initialise():void		{			//trace("*** WARNING .DEV URL IS ON ***");			Pool = new Vector.<PRequest>();			Queue = new Vector.<PRequest>();			URLStub = "http://g" + Log.GUID + ".api.playtomic.com";			URLTail = "swfid=" + Log.SWFID;			URL = URLStub + "/v3/api.aspx?" + URLTail;// + "&debug=yes";									var reqtimer:Timer = new Timer(500);			reqtimer.addEventListener("timer", TimeoutHandler);			reqtimer.start();						for(var i:int=0; i<20; i++)				Pool.push(new PRequest());		}				public static function SendStatistics(complete:Function, url:String):void		{			//trace("*** WARNING DEBUGGING IS ON ***");			var request:PRequest = Pool.length > 0 ? Pool.pop() : new PRequest();			request.time = 0;			request.handled = false;			request.complete = complete;			request.callback = null;			request.logging = true;			request.urlRequest.url = URLStub + url + (url.indexOf("?") > -1 ? "&" : "?") + URLTail + "&" + Math.random() + "Z";			request.urlRequest.method = "GET";			request.urlRequest.data = null;			request.postdata = null;			request.load(request.urlRequest);			Queue.push(request);		}				public static function SendPEvent(p:Object):void		{			//trace("*** WARNING DEBUGGING IS ON ***");			var request:PRequest = Pool.length > 0 ? Pool.pop() : new PRequest();			request.time = 0;			request.handled = false;			request.complete = null;			request.callback = null;			request.logging = true;			request.urlRequest.url = URLStub + "/tracker/p.aspx?" + URLTail + "&" + Math.random() + "Z";			request.urlRequest.method = "POST";						var pda:ByteArray = new ByteArray();			pda.writeUTFBytes(new JSONEncoder(p).getString());			pda.position = 0;									var postvars:URLVariables = new URLVariables();			postvars["data"] = Escape(Encode.Base64(pda))							request.urlRequest.data = postvars;			request.load(request.urlRequest);			Queue.push(request);		}				public static function Load(section:String, action:String, complete:Function, callback:Function, postdata:Object = null):void		{			var request:PRequest = Pool.length > 0 ? Pool.pop() : new PRequest();			request.time = 0;			request.handled = false;			request.complete = complete;			request.callback = callback;			request.logging = false;			var url:String = URL + "&r=" + Math.random() + "Z";			var timestamp:String = String(new Date().time).substring(0, 10);			var nonce:String = Encode.MD5(new Date().time * Math.random() + Log.GUID);								//trace(url);						var pd:Array = new Array();			pd.push("nonce=" + nonce);			pd.push("timestamp=" + timestamp);						for(var key:String in postdata)				pd.push(key + "=" + Escape(postdata[key]));			//trace("\npresig: " + pd.join("&"));							GenerateKey("section", section, pd);			GenerateKey("action", action, pd);			GenerateKey("signature", nonce + timestamp + section + action + url + Log.GUID, pd);												//trace("\nposting\n" + pd.join("\n"));						var pda:ByteArray = new ByteArray();			pda.writeUTFBytes(pd.join("&"));			pda.position = 0;						var postvars:URLVariables = new URLVariables();			postvars["data"] = Escape(Encode.Base64(pda));						request.urlRequest.url = url;			request.urlRequest.method = "POST";			request.urlRequest.data = postvars;			request.postdata = postdata;						//trace("posting data to " + url);						try			{				request.load(request.urlRequest);			}			catch(s:Error)			{				//trace("failed")				request.complete(request.callback, request.postdata, null, new Response(0, 1));			}						Queue.push(request);		}				public static function Escape(str:String):String		{			if(str == null)				return "";						str = str.split("%").join("%25");			str = str.split(";").join("%3B");			str = str.split("?").join("%3F");			str = str.split("/").join("%2F");			str = str.split(":").join("%3A");			str = str.split("#").join("%23");			str = str.split("&").join("%26");			str = str.split("=").join("%3D");			str = str.split("+").join("%2B");			str = str.split("$").join("%24");			str = str.split(",").join("%2C");			str = str.split(" ").join("%20");			str = str.split("<").join("%3C");			str = str.split(">").join("%3E");			str = str.split("~").join("%7E");			return str;		}				private static function GenerateKey(name:String, key:String, arr:Array):void		{			arr.sort();			arr.push(name + "=" + Encode.MD5(arr.join("&") + key));		}		private static function TimeoutHandler(e:Event):void		{			var request:PRequest;			for(var n:int=Queue.length-1; n>-1; n--)			{				request = Queue[n];				if(!request.handled)				{					request.time++;						if(request.time < 40)						continue;											if(request.logging)						request.complete(false);					else						request.complete(request.callback, request.postdata, null, new Response(0, 3));				}								Queue.splice(n, 1);				Dispose(request);			}		}		public function PRequest()		{			addEventListener("ioError", Fail);			addEventListener("networkError", Fail);			addEventListener("verifyError", Fail);			addEventListener("diskError", Fail);			addEventListener("securityError", Fail);			addEventListener("httpStatus", HTTPStatusIgnore);			addEventListener("complete", Complete);		}						private static function Complete(e:Event):void		{			//trace("Request is complete");							var request:PRequest = e.target as PRequest;						trace(request.data);			if(request.handled)				return;							request.handled = true;						if(request.complete == null)				return;						if(request.logging)			{				request.complete(true);				return;			}												var data:XML = XML(request.data);			var status:int = parseInt(data["status"]);			var errorcode:int = parseInt(data["errorcode"]);			request.complete(request.callback, request.postdata, data, new Response(status, errorcode));		}				private static function Fail(e:Event):void		{			//trace("fail");			var request:PRequest = e.target as PRequest;			//trace(request.data);						if(request.handled)				return;							request.handled = true;						if(request.complete == null)				return;						if(request.logging)				request.complete(false);			else				request.complete(request.callback, request.postdata, null, new Response(0, 1));		}		private static function HTTPStatusIgnore(e:Event):void		{		}				private static function Dispose(request:PRequest):void		{			if(!request.handled)			{				request.handled = true;				request.close();			}			Pool.push(request);		}			}}