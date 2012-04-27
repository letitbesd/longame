/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */
 package com.bumpslide.ui 
{
	import com.longame.utils.Align;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Labeled Button with Background
	 * 
	 * This is an abstract class that assumes label_txt is on the stage.
	 * 
	 * see GenericButton for code-only implementation.
	 * 
	 * @author David Knape
	 */
	public class LabelButton extends Button {
		[Child]
		public var label_txt:TextField;		
		protected var _label:String = "";
		protected var _autoSizeWidth:Boolean = true;
		public function LabelButton():void
		{
			super();
		}
		override protected function addChildren():void {		
			super.addChildren();
		}
		override protected function init():void
		{
			super.init();
			if(label_txt){
				label_txt.autoSize = TextFieldAutoSize.CENTER;
				label_txt.multiline = label_txt.wordWrap = false;
				label_txt.selectable = false;
				label_txt.mouseEnabled = false;
				label_txt.mouseWheelEnabled = false;
			}
		}
		override protected function render(e:Event=null):void {		
			// render label before rendering the background
			renderLabel();
			renderBackground();
		}
		
		protected function renderLabel() : void {
			if(label_txt!=null) {
				label_txt.text = _label;
				if(!autoSizeWidth) {
					Align.center( label_txt, width );
				}
			}
		}

		/**
		 * Override the width getter so background is sized to match 
		 * label when autosizeWidth is true
		 */		
		override public function get width():Number {
			if(autoSizeWidth && label_txt!=null && label!="") {
				var b:Rectangle = label_txt.getBounds( this );
				return Math.round( b.left*2 + b.width );
			} else {
				return super.width;
			}
		}

		/**
		 * The label string
		 */
		public function get label():String {
			return _label;
		}
		
		public function set label(label:String):void {
			_label = label;
			invalidate();
		}
		
		/**
		 * Autosize the component width based on label size
		 * 
		 * If this is set to false, the label will be centered horizontally. 
		 */
		public function get autoSizeWidth():Boolean {
			return _autoSizeWidth;
		}
		
		public function set autoSizeWidth(centerLabel:Boolean):void {
			_autoSizeWidth = centerLabel;
			invalidate();
		}
		override protected function whenSkinned():void
		{
			super.whenSkinned();
//			this.label_txt.selectable = false;
		}
		override protected function draw():void
		{
			super.draw();
//			this.label_txt.text = this._label;
		}
	}
}
