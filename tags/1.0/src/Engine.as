package 
{
	import com.longame.commands.base.Command;
	import com.longame.display.screen.ScreenManager;
	import com.longame.managers.CursorManager;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.managers.SoundManager;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import com.longame.utils.debug.Logger;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import org.osflash.signals.Signal;
	
	public class Engine extends Sprite
	{
		/**
		 * singals
		 * */
//		public var onInited:Signal=new Signal();
//		public var onFailed:Signal=new Signal(String);
		
        protected var _screenContainer:Sprite;
		protected var _screenManager:ScreenManager;
		
		private static var _instance:Engine;
		private static var _stage:Stage;
		
		public function Engine()
		{
			super();
			if(_instance!=null) throw new Error("Engine should be sington!");
			_instance=this;
			if(this.stage) onAdded();
			else this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		public static function get instance():Engine
		{
			return _instance;
		}
		public static function get stage():Stage
		{
			return _stage;
		}
		public static function registerClass(cls:Class):void
		{
			//do nothing
		}
		public static function get inWeb():Boolean
		{
            return Security.sandboxType==Security.REMOTE;
		}
		private var _inited:Boolean;
		protected function onAdded(e:Event=null):void
		{
			if(_inited) return;
			_inited=true;
			this.init();
			Logger.info(this,"onAdded","Engine added to stage ok!");
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		protected function init():void
		{
			Logger.startup();
			_stage=_instance.stage;
			InputManager.init(this);
			SoundManager.init();
			ProcessManager.start();
			CursorManager.init(this.stage);
			this._screenManager=new ScreenManager(this.screenContainer,0.1,0,0);	
			Logger.info(this,"init","Engine begin init!");
		}
		public static function showScreen(screenClass:Class, autoStart:Boolean = false,para:*=null):void
		{
			_instance._screenManager.openScreen(screenClass, autoStart,para);
		}
		private function get screenContainer():DisplayObjectContainer
		{
			if(_screenContainer==null){
				_screenContainer=new Sprite();
				this.addChild(_screenContainer);				
			}
			return this._screenContainer;
		}
		public static function get screenManager():ScreenManager
		{
			return _instance._screenManager;
		}
	}
}