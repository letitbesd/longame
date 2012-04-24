package com.longame.model
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import starling.textures.Texture;
	
	/**
	 * Texture数据以及其注册点坐标
	 * @autor Syler
	 */
	public class TextureData
	{
		/**
		 *ID
		 * */
		public var id:String;
		/**
		 * A bitmapData object containing the rendered data of the IIsoDisplayObject
		 */
		public var texture:Texture;
		
		/**
		 * The x location in screen coordintates where this bitmapData should be placed.
		 * This value corresponds to the left-most boundaries of this object.
		 */
		public var x:Number=0;
		
		/**
		 * The y location in screen coordintates where this bitmapData should be placed.
		 * This value corresponds to the top-most boundaries of this object.
		 */
		public var y:Number=0;
		/**
		 * 源显示对象
		 * */
		public var source:DisplayObject;
	}
}