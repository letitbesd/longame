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
		 * 背景层
		 * */
		function get backLayer():Sprite;
		/**
		 * 场景层
		 * */
		function get sceneLayer():Sprite;
		/**
		 * UI层
		 * */
		function get uiLayer():Sprite;
		/**
		 * 弹出窗口层
		 * */
		function get popupLayer():Sprite;
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
		 * Can be used to start the display, if this is a requirement of the display. E.g. a
		 * display may contain animated display children that should not start playing right
		 * after the display was opened but after the start method was called.
		 */
		function start():void;
		
		
		/**
		 * Can be used to stop the display after it has been started by calling start().
		 */
		function stop():void;
		
		/**
		 * Determines if the display is enabled or disabled. On a disabled display any
		 * display children are disabled so that no user interaction may take place until
		 * the display is enabled again. Set this property to either true (enabled) or false
		 * (disabled).
		 */
		function set enabled(v:Boolean):void;
		function get enabled():Boolean;
		
		
		/**
		 * Determines if the display has been started, i.e. if it's start method has been
		 * called. Returns true if the display has been started or false if the display
		 * has either been stopped or was not yet started.
		 */
		function get started():Boolean;
		/**
		 * Updates the view. This method should be called only if children of the view need
		 * to be updated, e.g. after localization has been changed or if the display
		 * children need to be re-layouted.
		 */
		function update(para:Object=null):void;
		
		
		/**
		 * Returns a String Representation of the view.
		 * 
		 * @return A String Representation of the view.
		 */
		function toString():String;
	}
}