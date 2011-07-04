package com.xingcloud.socialize.requests
{
	import com.xingcloud.socialize.AbstractElexRequest;
	import com.xingcloud.socialize.MethodEnum;
	
	public class ShowPaymentRequest extends AbstractElexRequest
	{
		public function ShowPaymentRequest(resultListener:Function, failListener:Function=null)
		{
			this._params=null;
			this._resultListener=resultListener;
			this._method=MethodEnum.SHOW_PAYMENT;
			this._failListener=failListener;
		}
	}
}