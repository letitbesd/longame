﻿/**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.command
	/**
	 * In MXML, all commands are passed to the commands setter which is an array
	 */
	[DefaultProperty(name='commands')]
	
	 * 
	 * Updated to support MXML.
		/**
		 * Add a command class or instance to the queue
		 */
			
			var command:ICommand;
			
			if(commandOrClass is Class) {
				command = new commandOrClass() as ICommand;
			} else {
				command = commandOrClass as ICommand;
				
				// make sure command instances are unique
				//command = ObjectUtil.clone( command ) as ICommand;
			}
			
			if(command==null) {
				throw new Error('Attempt to add an invalid command. Commands must implement ICommand.');
			}
			
			var action:PendingCommand = new PendingCommand( command, Delegate.create( doExecute, command, e ), priority );
			
			 
			
			// return reference to the command that was added
			command.execute( event );
		public function remove( pending:PendingCommand ):void
		{	
			var current:PendingCommand = _queue.currentActions[0];
			
			pending.command.cancel();
			
			if(pending==current) {
				advance();
			} else {
				_queue.remove(pending);
			}
		public function cancel():void
		{
			for each (var a:PendingCommand in _queue.currentActions) {
				a.command.cancel();
			}			
		
		/**
		 * When each command is completed, advance to the next
		 */
		/**
		 * Remove currently running command from the queue and check to see if we are done
		 */
			debug('advance()');
			var current:PendingCommand = _queue.currentActions[0];
			
			if(current!=null) {
				_queue.remove( current );
				current.command.removeEventListener( Event.COMPLETE, handleCommandComplete );
			} else {
				trace('current action is null?');
			}
						
		
		/**
		 * Setter used when defining queues in MXML
		 */
		public function set commands( cmds:Array ):void {
			for each ( var cmd:* in cmds ) {
				//trace('adding ' + cmd );
				add( cmd );
			}
		}