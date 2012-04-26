/**
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

package com.bumpslide.events {	    import flash.events.Event;    import flash.events.IEventDispatcher;        /**     * Generic Bubbling Event to be broadcast from UI Components      *      * - bubbles by default (to send from display objects)     * - contains generic data object     * - unlike a cairngorm event, there is no central dispatcher      *   (helps us keep view components decoupled form underlying framework)     *      * @author David Knape     */    public class UIEvent extends Event {    	    	static public var debug:Boolean = false;    	    	public var data:*;    	        public function UIEvent(type:String, data:Object=null ) {        	super(type, true);        	if(debug && type!='onComponentRedraw') trace('[UIEvent] "'+type+'"  ('+data+')');        	this.data = data;        }                override public function clone():Event {        	return new UIEvent( type, data );        }                // Send Bubbling UIEvent        static public function send( dispatcher:IEventDispatcher, type:String, data:Object=null ) : void {            dispatcher.dispatchEvent( new UIEvent( type, data) );        }                	override public function toString() : String {       		return '[UIEvent] "' + type + '" data=' + data;       	}    }}