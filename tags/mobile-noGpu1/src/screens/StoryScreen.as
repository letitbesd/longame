package screens
{
	import com.longame.core.IAnimatedObject;
	import com.longame.display.screen.McScreen;
	import com.longame.managers.ProcessManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import model.PlayerData;
	
	public class StoryScreen extends McScreen implements IAnimatedObject
	{
		[Child]
		public var skipper:MovieClip;
		
		public function StoryScreen()
		{
			super("Story"+_g.playerData.stats[1]+".swf@ani_"+_g.playerData.stats[1]);
		}
		public function onFrame(time:Number):void
		{
			if((skin as MovieClip).currentFrame>=(skin as MovieClip).totalFrames){
				this.toGame();
			}
		}
		override protected function initSkinParts():void
		{
			(skin as MovieClip).play();
			ProcessManager.addAnimatedObject(this);
			super.initSkinParts();
		}
		override protected function addEvents():void
		{
			skipper.addEventListener(MouseEvent.CLICK,toGame);
		}
		override protected function removeEvents():void
		{
			skipper.removeEventListener(MouseEvent.CLICK,toGame);
		}	
		protected function toGame(event:MouseEvent=null):void
		{
			ProcessManager.removeAnimatedObject(this);
			_g.changeLevel=true;
			(skin as MovieClip).stop();
			RenderEngine.renderPlane();
			Engine.showScreen(GameScreen);
		}
	}
}