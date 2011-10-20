package com.longame.commands.base
{
	import com.longame.commands.base.Command;

	public class ParallelCommand extends CompositeCommand
	{
		public function ParallelCommand(delay:uint=0,timeOut:uint=999999,retryCount:uint=0)
		{
			super(delay,timeOut,retryCount);
		}
		override protected function doExecute():void
		{
			super.doExecute();
			if(_total==0) {
				this.complete();
				return;
			}
			//复制一个，以免实时执行命令后_commands被删一个后出错
			var tempCommands:Vector.<Command>=_commands.concat();
			for(var i:int=0;i<_total;i++){
				var cmd:Command=tempCommands[i];
				cmd.addListener(this);
				cmd.execute();
			}
			tempCommands=null;
		}
		
		
		/**
		 * Aborts the command's execution.
		 */
		override public function abort():void
		{
			super.abort();
			for each (var t:Command in _commands){
				t.abort();
			}
		}
		/**
		 * Executes the next enqueued Action.
		 * @private
		 */
		override protected function next(oldCmd:Command=null):Boolean
		{
			if(oldCmd){
				var i:int=_commands.indexOf(oldCmd);
				if(i>=0) _commands.splice(i,1);
			}
			return super.next(oldCmd);
		}
		/**
		 * The name identifier of the action.
		 */
		override public function get name():String
		{
			return "parallelAction";
		}
	}
}