package com.xingcloud.socialize
{
	public interface IElexRequest
	{
		function get method():String;
		function get params():*;
		function get resultListener():Function;
		function get failListener():Function;
	}
}