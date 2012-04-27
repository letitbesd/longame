/** * This code is part of the Bumpslide Library by David Knape * http://bumpslide.com/ *  * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc. *  * Released under the open-source MIT license. * http://www.opensource.org/licenses/mit-license.php * see LICENSE.txt for full license terms */ package com.bumpslide.ui {	import com.longame.core.IDisposable;
	    /**     * Grid Item Interface     *      * This interface should be implemented by clips that      * are controlled by a GridLayout instance.     *      * @author David Knape     */    public interface IGridItem extends IDisposable	{    	    	// cancel any pending loader activity, remove event listeners, and die    	// this is implemented alredy in Component, and thus Button//    	function destroy () : void;    	    	// setter used to assign grid index to your grid item    	function set gridIndex (n:int):void;    	function get gridIndex () : int;    	    	// setter used to pass in the data for this position in the dataprovider    	function set gridItemData (d:*):void;    	function get gridItemData () : *;    	    	    	    	// standard display object stuff (most likely already implemented)    	function set x (n:Number) : void;    	    	function set y (n:Number) : void;    		    	function set visible (val:Boolean) : void;    	function get visible () : Boolean;    	    }}