//Created by Action Script Viewer - http://www.buraks.com/asv
package com.addthis.share {
    import flash.display.*;
    import flash.net.*;

    public class ShareAPI extends Sprite {

        private var username:String;

        public static const ENDPOINT:String = "http://api.addthis.com/oexchange/0.8/forward";
        private static const DEFAULT_OPTIONS:Object = {url:"", swfurl:"", width:-1, height:-1, title:"", description:"", screenshot:""};

        public function ShareAPI(_arg1:String=""){
            this.username = _arg1;
        }
        public function share(_arg1:String, _arg2:String="menu", _arg3:Object=null):void{
            var _local5:String;
            _arg3 = ((_arg3) || ({}));
            var _local4:URLVariables = new URLVariables();
            for (_local5 in DEFAULT_OPTIONS) {
                if (((DEFAULT_OPTIONS[_local5]) || (_arg3[_local5]))){
                    _local4[_local5] = ((_arg3[_local5]) || (DEFAULT_OPTIONS[_local5]));
                };
            };
            _local4.url = _arg1;
            if (stage){
                if (_local4.width == -1){
                    _local4.width = stage.stageWidth;
                };
                if (_local4.height == -1){
                    _local4.height = stage.stageHeight;
                };
            };
            if (this.username){
                _local4.username = this.username;
            };
            if (_arg2 == "menu"){
                _arg2 = "";
            };
            var _local6:URLRequest = new URLRequest(((ENDPOINT + (_arg2) ? ("/" + _arg2) : "") + "/offer"));
            _local6.data = _local4;
            navigateToURL(_local6, "_blank");
        }

    }
}//package com.addthis.share 
