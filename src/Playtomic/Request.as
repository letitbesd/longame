
package Playtomic {
    import flash.events.*;
    import __AS3__.vec.*;
    import flash.utils.*;
    import flash.net.*;
    import Playtomic.*;

    final class Request extends URLLoader {

        private var urlRequest:URLRequest;
        private var callback:Function;
        private var postdata:Object;
        private var time:int;
        private var complete:Function;
        private var handled:Boolean;
        private var logging:Boolean;

        private static var URL:String;
        private static var Queue:Vector.<Request>;
        private static var Pool:Vector.<Request>;
        private static var URLStub:String;
        private static var URLTail:String;

        function Request(){
            this.urlRequest = new URLRequest();
            super();
            addEventListener("ioError", Fail);
            addEventListener("networkError", Fail);
            addEventListener("verifyError", Fail);
            addEventListener("diskError", Fail);
            addEventListener("securityError", Fail);
            addEventListener("httpStatus", HTTPStatusIgnore);
            addEventListener("complete", Complete);
        }
        public static function Escape(str:String):String{
            if (str == null){
                return ("");
            };
            str = str.split("%").join("%25");
            str = str.split(";").join("%3B");
            str = str.split("?").join("%3F");
            str = str.split("/").join("%2F");
            str = str.split(":").join("%3A");
            str = str.split("#").join("%23");
            str = str.split("&").join("%26");
            str = str.split("=").join("%3D");
            str = str.split("+").join("%2B");
            str = str.split("$").join("%24");
            str = str.split(",").join("%2C");
            str = str.split(" ").join("%20");
            str = str.split("<").join("%3C");
            str = str.split(">").join("%3E");
            str = str.split("~").join("%7E");
            return (str);
        }
        public static function Load(section:String, action:String, complete:Function, callback:Function, postdata:Object=null):void{
            var request:Request;
            var key:String;
            var pda:ByteArray;
            var postvars:URLVariables;
            var section = section;
            var action = action;
            var complete = complete;
            var callback = callback;
            var postdata = postdata;
            request = ((Pool.length > 0)) ? Pool.pop() : new (Request);
            request.time = 0;
            request.handled = false;
            request.complete = complete;
            request.callback = callback;
            request.logging = false;
            var url = (((URL + "&r=") + Math.random()) + "Z");
            var timestamp:String = String(new Date().time).substring(0, 10);
            var nonce:String = Encode.MD5(((new Date().time * Math.random()) + Log.GUID));
            var pd:Array = new Array();
            pd.push(("nonce=" + nonce));
            pd.push(("timestamp=" + timestamp));
            for (key in postdata) {
                pd.push(((key + "=") + Escape(postdata[key])));
            };
            GenerateKey("section", section, pd);
            GenerateKey("action", action, pd);
            GenerateKey("signature", (((((nonce + timestamp) + section) + action) + url) + Log.GUID), pd);
            pda = new ByteArray();
            pda.writeUTFBytes(pd.join("&"));
            pda.position = 0;
            postvars = new URLVariables();
            postvars["data"] = Escape(Encode.Base64(pda));
            request.urlRequest.url = url;
            request.urlRequest.method = "POST";
            request.urlRequest.data = postvars;
            request.postdata = postdata;
            request.load(request.urlRequest);
            //unresolved jump
            var _slot1 = s;
            request.complete(request.callback, request.postdata, null, new Response(0, 1));
            Queue.push(request);
        }
        private static function GenerateKey(name:String, key:String, arr:Array):void{
            arr.sort();
            arr.push(((name + "=") + Encode.MD5((arr.join("&") + key))));
        }
        public static function SendStatistics(complete:Function, url:String):void{
            var request:Request = ((Pool.length > 0)) ? Pool.pop() : new (Request);
            request.time = 0;
            request.handled = false;
            request.complete = complete;
            request.callback = null;
            request.logging = true;
            request.urlRequest.url = ((((((URLStub + url) + ((url.indexOf("?") > -1)) ? "&" : "?") + URLTail) + "&") + Math.random()) + "Z");
            request.urlRequest.method = "GET";
            request.urlRequest.data = null;
            request.postdata = null;
            request.load(request.urlRequest);
            Queue.push(request);
        }
        private static function HTTPStatusIgnore(e:Event):void{
        }
        private static function Fail(e:Event):void{
            trace("fail");
            var request:Request = (e.target as Request);
            trace(request.data);
            if (request.handled){
                return;
            };
            request.handled = true;
            if (request.complete == null){
                return;
            };
            if (request.logging){
                request.complete(false);
            } else {
                request.complete(request.callback, request.postdata, null, new Response(0, 1));
            };
        }
        private static function Dispose(request:Request):void{
            if (!request.handled){
                request.handled = true;
                request.close();
            };
            Pool.push(request);
        }
        private static function TimeoutHandler(e:Event):void{
            var request:Request;
            var n:int = (Queue.length - 1);
            for (;n > -1;n--) {
                request = Queue[n];
                if (!request.handled){
                    request.time++;
                    if (request.time < 40){
                        continue;
                    };
                    if (request.logging){
                        request.complete(false);
                    } else {
                        request.complete(request.callback, request.postdata, null, new Response(0, 3));
                    };
                };
                Queue.splice(n, 1);
                Dispose(request);
            };
        }
        public static function SendPEvent(p:Object):void{
            var request:Request = ((Pool.length > 0)) ? Pool.pop() : new (Request);
            request.time = 0;
            request.handled = false;
            request.complete = null;
            request.callback = null;
            request.logging = true;
            request.urlRequest.url = (((((URLStub + "/tracker/p.aspx?") + URLTail) + "&") + Math.random()) + "Z");
            request.urlRequest.method = "POST";
            var pda:ByteArray = new ByteArray();
            pda.writeUTFBytes(new JSONEncoder(p).getString());
            pda.position = 0;
            var postvars:URLVariables = new URLVariables();
            postvars["data"] = Escape(Encode.Base64(pda));
            request.urlRequest.data = postvars;
            request.load(request.urlRequest);
            Queue.push(request);
        }
        public static function Initialise():void{
            Pool = new Vector.<Request>();
            Queue = new Vector.<Request>();
            URLStub = (("http://g" + Log.GUID) + ".api.playtomic.com");
            URLTail = ("swfid=" + Log.SWFID);
            URL = ((URLStub + "/v3/api.aspx?") + URLTail);
            var reqtimer:Timer = new Timer(500);
            reqtimer.addEventListener("timer", TimeoutHandler);
            reqtimer.start();
            var i:int;
            while (i < 20) {
                Pool.push(new (Request));
                i++;
            };
        }
        private static function Complete(e:Event):void{
            trace("Request is complete");
            var request:Request = (e.target as Request);
            trace(request.data);
            if (request.handled){
                return;
            };
            request.handled = true;
            if (request.complete == null){
                return;
            };
            if (request.logging){
                request.complete(true);
                return;
            };
            var data:XML = XML(request.data);
            var status:int = parseInt(data["status"]);
            var errorcode:int = parseInt(data["errorcode"]);
            request.complete(request.callback, request.postdata, data, new Response(status, errorcode));
        }

    }
}//package Playtomic 
