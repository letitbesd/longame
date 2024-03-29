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

package com.bumpslide.util {	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;		
	/**	 * Replacement for AS2 Delegate 	 * 	 * Useful for making callbacks with extra args.	 * see http://wildwinter.blogspot.com/2007/04/come-back-delegate-all-is-forgiven.html* 	 * 	 * Original by Ian Thomas, Modified by David Knape	 * - fixed some things in original	 * - added callLater method for delayed delegates	 * 	 * @author Ian Thomas	 * @author David Knape 	 * @version 0.2	 */	public class Delegate {               
		// Create a wrapper for a callback function.		// Tacks the additional args on to any args normally passed to the		// callback.		public static function create(handler:Function,...args):Function {			return function(...innerArgs):void {				var handlerArgs:Array = [];				if(innerArgs != null) handlerArgs = innerArgs;				if(args != null) handlerArgs = handlerArgs.concat(args);				handler.apply(this, handlerArgs);			}		}
				public static function callLater(delayMs:int, handler:Function, ...args):Timer {			var timer:Timer = new Timer(delayMs, 1);   			var d:Function = Delegate.create(afterDelay, handler, args);            			timerDelegates[timer] = d;                     			timer.addEventListener(TimerEvent.TIMER_COMPLETE, d);			timer.start();             			return timer;		}		
		private static function afterDelay( e:TimerEvent, handler:Function, args:Array ):void {			handler.apply(null, args);			cancel(e.target as Timer);  		}		
		public static function cancel( thing:* ):void {			if(thing==null) return;			if(thing is Timer) {				var timer:Timer = thing as Timer;						timer.reset();               	                   				if(timerDelegates[timer] != null) {					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerDelegates[timer]); 					delete timerDelegates[timer];				}			} 						if(thing is Function) {				var handler:Function = thing as Function;				var delegate:Function = enterFrameDelegates[handler];				if(enterFrameDelegates[handler]!=null) {					disp.removeEventListener( Event.ENTER_FRAME, enterFrameDelegates[handler]);					delete enterFrameDelegates[handler];				}			}		}     			/**		 * Call a handler after one frame tick		 * 		 * Use Delegate.cancel( handler:Function ) to cancel a pending call		 */		public static function onEnterFrame( handler:Function, ...args):void {			var delegate:Function = Delegate.create(afterEnterFrame, handler, args);            			enterFrameDelegates[handler] = delegate;              			disp.addEventListener(Event.ENTER_FRAME, delegate);		}				private static function afterEnterFrame( e:Event, handler:Function, args:Array ):void {			handler.apply(null, args);			cancel( handler );  		}		     
		static private var timerDelegates:Dictionary = new Dictionary(true);		static private var enterFrameDelegates:Dictionary = new Dictionary(true);		static private var disp:Sprite = new Sprite();				/**		 * Creates delegate that can be passed to Array.map 		 * so you don't have to make a function that has the full 		 * signature required by array.map		 * 		 * Example:		 * // parse some shit		 * var s:String = "1, 34, 345, 56";		 * var nums:Array = s.split(',').map( Delegate.map( parseInt ) )  		 * 		 */		public static function map( f:Function ):Function {			 return function (element:*, ...otherStuff):* { 			 	return f.call( null, element ); 			 }		}				/**		 * delegate an event or callback and ignore the first param (event)		 * 		 * Example: addEventListener( MouseEvent.CLICK, Delegate.event( Link.to, 'http://yahoo.com/' ) );		 */		public static function event( f:Function, ...args ):Function {			var delegate:Function = Delegate.create.apply( null, [f].concat(args) );			return function (...rest) : void { delegate.call(); }			}	}}