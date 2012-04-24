package com.longame.commands.base
{
	public interface ICommandListener
	{
		function onCommandComplete(cmd:Command):void;
		function onCommandError(cmd:Command,msg:String):void;
		function onCommandProgress(cmd:Command):void;
		function onCommandAbort(cmd:Command):void;
	}
}