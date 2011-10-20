package com.longame.display.screen
{
	import com.longame.managers.AssetsLibrary;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * 用一个movieClip做screen
	 * 在做小游戏时，经常用到就需要几个按钮的screen
	 * */
	public class MovieClipScreen extends AbstractScreen
	{
		protected var _ui:MovieClip;
		
		/**
		 * @param src: MC屏幕的元件名
		 * */
		public function MovieClipScreen(src:String)
		{
			super();
			_ui=AssetsLibrary.getMovieClip(src);
		}
		override protected function createChildren():void
		{
			super.createChildren();
			if(_ui){
				this._uiLayer.addChild(_ui);
			}
		}
		public function get ui():MovieClip
		{
			return _ui;
		}
	}
}