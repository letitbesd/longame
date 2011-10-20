package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class ReloadGameRequest extends AbstractElexRequest
	{
		public function ReloadGameRequest()
		{
			super();
			this._params="";
			this._resultListener=null;
			this._method=MethodEnum.RELOAD_GAME;
			this._failListener=null;
		}
	}
}