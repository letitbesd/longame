package 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	import com.longame.commands.base.Command;
	import com.longame.managers.ConfigManager;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.resource.ResourceManager;
	import com.longame.resource.Resource;
	import com.longame.utils.debug.Logger;
	import com.longame.display.screen.ScreenManager;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import org.osflash.signals.Signal;
	
	public class Engine extends Sprite
	{
		/**
		 * singals
		 * */
		public var onInited:Signal=new Signal();
		public var onFailed:Signal=new Signal(String);
		
		protected var _resources:Array=[];
        protected var _screenContainer:Sprite;
		protected var _screenManager:ScreenManager;
		
		private static var _instance:Engine;
		private static var _stage:Stage;
		
		public function Engine()
		{
			super();
			if(_instance!=null) throw new Error("Engine should be sington!");
			_instance=this;
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		public static function get instance():Engine
		{
			return _instance;
		}
		public static function get stage():Stage
		{
			return _stage;
		}
		public static function get inWeb():Boolean
		{
            return Security.sandboxType==Security.REMOTE;
		}
		private var _inited:Boolean;
		protected function onAdded(e:Event):void
		{
			if(_inited) return;
			_inited=true;
			this.init();
			this.loadResource();
			Logger.info(this,"onAdded","Engine added to stage ok!");
		}
		protected function init():void
		{
			Logger.startup();
			_stage=_instance.stage;
			InputManager.init(this);
			ConfigManager.init(this.stage);
			this._screenManager=new ScreenManager(this.screenContainer,0.1,0,0);	
			Logger.info(this,"init","Engine begin init!");
		}
		protected function loadResource():void
		{
			var len:uint=_resources.length;
			for(var i:int=0;i<len;i++){
				ResourceManager.instance.addResource(_resources[i]);
			}
			ResourceManager.instance.onComplete.add(onResourcesLoaded);
			ResourceManager.instance.onError.add(onResourcesLoadedFail);
			ResourceManager.instance.execute();
		}
		public function showScreen(screenClass:Class, autoStart:Boolean = false,para:*=null):void
		{
			_screenManager.openScreen(screenClass, autoStart,para);
		}
		public function get screenManager():ScreenManager
		{
			return this._screenManager;
		}
		public function get screenContainer():DisplayObjectContainer
		{
			if(_screenContainer==null){
				_screenContainer=new Sprite();
				this.addChild(_screenContainer);				
			}
			return this._screenContainer;
		}
		/**
		 * 游戏从这里开始
		 * */
		protected function onResourcesLoaded(cmd:Command=null):void
		{
			Logger.info(this,"onResourcesLoaded","The resources loaded ok, game start!");
			this.onInited.dispatch();
		}
		protected function onResourcesLoadedFail(cmd:Command,msg:String):void
		{
			Logger.error(this,"OnResourceLoadedFail",msg);
			this.onFailed.dispatch(msg);
		}
		[ArrayElementType("com.longame.resource.Resource")]
		public function set resources(rs:Array):void
		{
			_resources=rs;
		}
		public function addPreloadResource(url:String,type:String=null):void
		{
			var r:Resource=new Resource(url,type);
			_resources.push(r);
		}
	}
}