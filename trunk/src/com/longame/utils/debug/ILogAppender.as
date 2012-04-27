package com.longame.utils.debug
{
	public interface ILogAppender
	{
		function addLogMessage(level:String, loggerName:String, message:String):void;
	}
}