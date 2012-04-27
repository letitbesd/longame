package com.bumpslide.ui
{
	import com.longame.utils.Align;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 水平或垂直排序的空盒子
	 * */
	public class Box extends BaseClip
	{
		protected var _padding:uint;
		protected var _vertical:Boolean;
		protected var _children:Array=[];
		
		public function Box(padding:uint=2,vertical:Boolean=true)
		{
			super();
			this._padding=padding;
			this._vertical=vertical;
		}
		public function updateAlign():void
		{
			_vertical?Align.vbox(_children,_padding):Align.hbox(_children,_padding);
		}
		public function get padding():uint
		{
			return _padding;
		}
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var child:DisplayObject=super.addChild(child);
			if(_children.indexOf(child)==-1) _children.push(child);
			this.updateAlign();
			return child;
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var child:DisplayObject=super.removeChild(child);
			var i:int=_children.indexOf(child);
			if(i>-1) _children.splice(i,1);
			this.updateAlign();
			return child;
		}
		override protected function doDestroy():void
		{
			super.doDestroy();
			_children=null;
		}
		public function clear():void
		{
			while(_children.length){
				this.removeChild(_children[0]);
			}
		}
	}
}