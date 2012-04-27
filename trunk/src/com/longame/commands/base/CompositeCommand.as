package com.longame.commands.base
{
	import org.osflash.signals.Signal;

	/**
	 * A CompositeCommand is a composite command for serialCommand or parallelCommand.
	 * 
	 * @author longyangxi
	 */
	public class CompositeCommand extends Command implements ICommandListener
	{
		public var onTotalProgress:Signal=new Signal(Command);
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		/** @private */
		protected var _commands:Vector.<Command>;
		/** @private */
		protected var _messages:Vector.<String>;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new CompositeCommand instance.
		 */
		public function CompositeCommand(delay:uint=0,timeOut:uint=999999,retryCount:uint=0)
		{
			super(delay,timeOut,retryCount);
			_commands = new Vector.<Command>();
			_messages = new Vector.<String>();
			this._total=0;
		}
		
		
		/**
		 * Executes the composite command. Abstract method. Be sure to call super.execute()
		 * first in subclassed execute methods.
		 */ 
		override protected function doExecute():void
		{
            super.doExecute();
			enqueueCommands();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The name identifier of the Action.
		 */
		override public function get name():String
		{
			return "compositeAction";
		}
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function onCommandProgress(cmd:Command):void
		{
			this.notifyProgress(cmd);
//			if(this._progressPanelParent) e.action.showProgressPanel(this._progressPanelParent,this._modal);
		}
		
		
		/**
		 * @private
		 */
		public function onCommandComplete(cmd:Command):void
		{
			cmd.removeListener(this);
			notifyTotalProgress();
			next(cmd);
		}
		
		
		/**
		 * @private
		 */
		public function onCommandAbort(cmd:Command):void
		{
			cmd.removeListener(this);
			notifyTotalProgress();
			next(cmd);
		}
		/**
		 * @private
		 */
		public function onCommandError(cmd:Command,msg:String):void
		{
			cmd.removeListener(this);
			notifyTotalProgress();
			notifyError(msg);
			next(cmd);
		}
		protected function  notifyTotalProgress():void
		{
			this._completed++;
			if(this._progressPanelParent) {
//				ProgressManager.setProgress(this._progressPanelParent,this._progressMsg,this._completed,this._total);
			}
			onTotalProgress.dispatch(this);
		}
		
		/**
		 * Executes the next enqueued Command.
		 * @private
		 */
		protected function next(oldCommand:Command=null):Boolean
		{
			if(_isAborted||_commands.length==0){
				if(!_hasError) complete();
				return false;
			}
			return true;
		}
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Abstract method. This is the place where you enqueue single Commands.
		 * @private
		 */
		protected function enqueueCommands():void
		{
			
		}
		
		
		/**
		 * Enqueues a Commandfor use in the composite Command's execution sequence.
		 * @private
		 */
		public function enqueue(cmd:Command, progressMsg:String =null):void
		{
			if(cmd==null) return;
			_commands.push(cmd);
			_messages.push(progressMsg);
			_total++;
		}
		/**
		 * @private
		 */
		override protected function complete():void
		{
			_commands = new Vector.<Command>();
			_messages = new Vector.<String>();
			super.complete();
		}
	}
}
