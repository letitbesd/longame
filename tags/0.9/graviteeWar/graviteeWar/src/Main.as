package
{
	import com.collision.CDK;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
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
	
	import view.scene.BattleScene;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;
	import view.screen.BattleScreen;
	import view.ui.baseComponents.GlobalUI;
	import view.ui.components.Counter;
	
	[SWF(width="700",height="500",backgroundColor="0x000000",frameRate="30")]
	public class Main extends Engine
	{
		public static const maxTeamMenber:uint=4;
		public static var scene:BattleScene;
		private var _context:ApplicationContext;
		private var _globalUI:GlobalUI;
		
		public function Main()
		{
			super();
		}
		
		override protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT;
			this._context = new ApplicationContext(this.stage);
			this.drawBack();
			this.loadResource();
			
			super.init();
		}
		
		private function drawBack():void
		{
			var back:Shape=new Shape();
			back.graphics.beginFill(0x003365);
			back.graphics.drawRect(0,0,this.stage.stageWidth,this.stage.stageHeight);
			back.graphics.endFill();
			this.addChild(back);
		}
		/**
		 * 加载资源
		 * */
		private function loadResource():void
		{
			ResourceManager.instance.load("assets.swf",onLoaded);
		}
		
		private function onLoaded(r:Resource = null):void
		{
			startGame();
		}
		
		private function startGame():void
		{
			Engine.showScreen(BattleScreen);
			_globalUI = new GlobalUI();
			this.addChild(_globalUI);
		}
		
		public function get context():ApplicationContext
		{
			return this._context;
		}
		
		public function get globalUI():GlobalUI
		{
			return this._globalUI;
		}
	}
}