package com.xingcloud.socialize
{
	import com.xingcloud.socialize.manager.RequestManager;
	import com.xingcloud.socialize.utils.Console;

	public class ElexProxy implements IElexProxy
	{
		private static var _instance:ElexProxy;
		private var requestManager:RequestManager
		public var proxySession:ProxySession;
		
		public function ElexProxy()
		{
			if(_instance){
				throw new Error("ElexProxy is a single class!.Please access by ElexProxy.instance.");
			}
		
			requestManager=new RequestManager();
		}
		public function init(ps:ProxySession):Boolean{
			proxySession=ps;
			return true;
		}
		
		public function sendRequest(request:IElexRequest):Boolean
		{
			if(!proxySession){
				throw new Error("Please set the proxysession");
			}
			
			if(requestManager.addRequest(request)){
				return true;
			}
			return false;
		}
		
		public static function get instance():ElexProxy{
			if (!_instance){
				_instance = new ElexProxy();
			}
			return _instance;
		}
	
	}
}