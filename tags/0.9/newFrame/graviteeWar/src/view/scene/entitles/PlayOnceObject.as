package view.scene.entitles
{
	import com.longame.display.core.OnceClip;
	import com.longame.managers.AssetsLibrary;
	import com.longame.modules.entities.OnceClipEntity;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PlayOnceObject extends OnceClipEntity
	{
		private var mc:MovieClip;
		
		public function PlayOnceObject(clsName:String)
		{
			super();
			
			this.source = clsName;
		}
		public static function play(clsName:String,x:Number,y:Number,container:Sprite=null):PlayOnceObject
		{
			var obj:PlayOnceObject=new PlayOnceObject(clsName); 
			Main.scene.add(obj);  
			obj.x=x;
			obj.y=y;
			return obj;
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		
		override protected function doRender():void
		{
			if(mc.currentFrame>=mc.totalFrames){
				this.destroy();
			}
		}
	}
}