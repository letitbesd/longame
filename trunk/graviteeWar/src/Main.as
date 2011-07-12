package
{
	import collision.CDK;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import heros.Hero;
	import heros.HeroBase;
	
	import time.CountDown;
	import time.CountdownEvent;
	import time.EnterFrame;
	
	[SWF(width="700",height="500",backgroundColor="0x000000",frameRate="30")]
	public class Main extends Engine
	{
		public static var scene:Scene;
		
		private var _loader:Loader;
		
		private var _planet:MovieClip;
		
		private var _hero:Hero;		
		
		private var _counter:TextField=new TextField();
		
		public function Main()
		{
			super();
		}
		
		override protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			super.init();
			this.loadResource();
		}
		
		public static function getMovieClip(name:String):MovieClip
		{
			var cls:Class=getDefinitionByName(name) as Class;
			return new cls() as MovieClip;
		}
		/**
		 * 加载资源
		 * */
		private function loadResource():void
		{
			ResourceManager.instance.load("assets.swf",onLoaded);
		}
		
		private function onLoaded(r:Resource):void
		{
			EnterFrame.start();
			this.addChild(AssetsLibrary.getMovieClip("background"));
			scene=new Scene();
			this.addChild(scene);
			
			var format:TextFormat=new TextFormat(null,30,0x00ff00,true);
			_counter.defaultTextFormat=format;
			//自动根据文字设定宽度，以显示全部文字
			_counter.autoSize=TextFieldAutoSize.LEFT;
			this.addChild(_counter);
			//			_counter.background=true;
			//			_counter.backgroundColor=0xff0000;
			//			
			//			_counter.border=true;
			//			_counter.borderColor=0x0000ff;
			_counter.filters=[new GlowFilter(0x00ff00,0.6,10,10,6,3)];
			_counter.selectable=false;
			
			var count:CountDown=new CountDown(100);
			count.addEventListener(CountdownEvent.ON_SECOND,onSecond);
			count.addEventListener(CountdownEvent.ON_COMPLETE,onComplete);
			count.start();
		}
		
		protected function onComplete(event:Event):void
		{
			// TODO Auto-generated method stub
		}
		
		protected function onSecond(event:CountdownEvent):void
		{
//			trace("还剩下： "+event.secondLeft);
			_counter.text="还剩下： "+event.secondLeft;
		}
	}
}