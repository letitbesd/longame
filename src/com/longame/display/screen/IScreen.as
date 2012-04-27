package com.longame.display.screen
{
	import com.longame.core.IDestroyable;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	public interface IScreen extends IDestroyable
	{
		/**
		 * 当屏幕创建好
		 * */
		function get onCreate():Signal;
		/**
		 * 场景层
		 * */
		function get sceneLayer():Sprite;
		/**
		 * UI层
		 * */
		function get uiLayer():Sprite;
		/**
		 * Used to load any assets that the display might require. On screens ScreenManager
		 * calls this method automatically after the screen has been instantiated. If the
		 * display doesn't need to load any assets this method doesn't need to be overriden
		 * since AbstractScreen will automatically progress to setup the display without any
		 * loading operation.
		 * <p>
		 * If you need to load any assets for the display you should override this method
		 * and use a command which loads all the necessary display assets, e.g.:
		 * 
		 * @example <pre>
		 * public function load():void
		 * {
		 * 		Main.commandManager.execute(new LoadDisplayAssetsCommand(),
		 * 			onDisplayAssetsLoadComplete, onDisplayAssetsLoadError);
		 * }
		 * </pre>
		 */
		function load():void
		/**
		 * Updates the view. This method should be called only if children of the view need
		 * to be updated, e.g. after localization has been changed or if the display
		 * children need to be re-layouted.
		 */
		function update(para:Object=null):void;
	}
}