package
{
	import collision.CDK;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.heros.Hero;
	import com.heros.HeroBase;
	
	import com.time.CountDown;
	import com.time.CountdownEvent;
	import com.time.EnterFrame;
	import com.Scene;
	
	[SWF(width="700",height="500",backgroundColor="0x000000",frameRate="30")]
	public class Main extends Engine
	{
		public static var scene:Scene;
		private var _planet:MovieClip;
		
		private var _hero:Hero;		
		
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
//			this.addChild(AssetsLibrary.getMovieClip("background"));
			scene=new Scene();
			this.addChild(scene);
		}
	}
}