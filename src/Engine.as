package 
{
	import com.longame.commands.base.Command;
	import com.longame.core.long_internal;
	import com.longame.display.screen.IScreen;
	import com.longame.display.screen.ScreenManager;
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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;

	use namespace long_internal;
	
	public class Engine extends flash.display.Sprite
	{
		/**
		 * 是否在本地存储数据
		 * */
		public static var saveInLocal:Boolean;
		/**
		 * 游戏名，可用于存储本地数据时的local name
		 * */
		public static var appName:String="longames_app";
	    /**
		 * 当前是否在运行向导系统
		 * */
		public static var inTutorial:Boolean;
		
		protected var _screenManager:ScreenManager;
		
		private static var _instance:Engine;
		private static var _nativeStage:flash.display.Stage;
		
		public function Engine()
		{
			super();
			if(_instance!=null) throw new Error("Engine should be sington!");
			_instance=this;
			if(this.stage) onAdded();
			else this.addEventListener(flash.events.Event.ADDED_TO_STAGE,onAdded);
		}
		public static function get instance():Engine
		{
			return _instance;
		}
		public static function get nativeStage():flash.display.Stage
		{
			return _nativeStage;
		}
		public static function get gpuStage():starling.display.Stage
		{
			return Starling.current.stage;
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
		private function onAdded(e:flash.events.Event=null):void
		{
			if(_inited) return;
			_inited=true;
			Logger.startup();
			_nativeStage=this.stage;
			_nativeStage.scaleMode=StageScaleMode.NO_SCALE;
			_nativeStage.align=StageAlign.TOP_LEFT;
			new Starling(null,_nativeStage,null,null,"auto");
			Starling.current.addEventListener(starling.events.Event.CONTEXT3D_CREATE,onStage3dReady);
			Logger.info(this,"onAdded","Engine added to stage ok!");
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE,onAdded);
		}
		private  function onStage3dReady(evt:starling.events.Event):void
		{
			this.init();
		}
		protected function init():void
		{
//			InputManager.init(this);
			SoundManager.init();
//			CursorManager.init(this.stage);
			gpuStage.addChild(gpuScreenContainer);
			nativeStage.addChild(nativeScreenContainer);
			this._screenManager=new ScreenManager(null,0.1,0,0);	
			Engine.start();
			Logger.info(this,"init","Engine is ready!");
		}
		public static function showScreen(screenClass:Class,para:*=null):void
		{
			_instance._screenManager.openScreen(screenClass,para);
		}
		private static var _started:Boolean;
		public static function start():void
		{
			if(_started) return;
			_started=true;
			ProcessManager.start();
			Starling.current.start();
		}
		public static function stop():void
		{
			if(!_started) return;
			_started=false;
			ProcessManager.stop();
			Starling.current.stop();
		}
		public static function get screenManager():ScreenManager
		{
			return _instance._screenManager;
		}
		private static var gpuScreenContainer:starling.display.Sprite=new starling.display.Sprite();
		private static var nativeScreenContainer:flash.display.Sprite=new flash.display.Sprite();
		long_internal static function addScreen(screen:IScreen):void
		{
			try{
				gpuScreenContainer.addChild(screen as starling.display.Sprite);
			}catch(e:Error){
				nativeScreenContainer.addChild(screen as flash.display.Sprite);
			}
		}
	}
}