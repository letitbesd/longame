package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PlayOnceObject extends Sprite
	{
		private var mc:MovieClip;
		
		public function PlayOnceObject(clsName:String)
		{
			super();
			
			mc=Main.getMovieClip(clsName);
			addChild(mc);
			mc.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		public static function play(clsName:String,x:Number,y:Number,container:Sprite=null):PlayOnceObject
		{
			var obj:PlayOnceObject=new PlayOnceObject(clsName); 
			if(container==null) container=Main.scene;
			container.addChild(obj);     
			obj.x=x;
			obj.y=y;
			return obj;
		}
		private function onFrame(e:Event):void
		{
			if(mc.currentFrame>=mc.totalFrames){
				this.destroy();
			}
		}
		private function destroy():void
		{
			if(this.parent) this.parent.removeChild(this);
			mc.removeEventListener(Event.ENTER_FRAME,onFrame);
		}
	}
}