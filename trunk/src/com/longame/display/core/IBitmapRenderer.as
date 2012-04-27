package com.longame.display.core
{
	import flash.display.Bitmap;

	/**
	 * 供RenderManager渲染位图的画布
	 * */
	public interface IBitmapRenderer
	{
		/**
		 * 提供一个bitmap画布供RenderManager渲染
		 * **/
		function get bitmap():Bitmap;
	}
}