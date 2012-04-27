package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.display.core.OnceClip;
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.utils.ObjectUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;
	
	/**
	 * 只播放一次就over的实体，像特效。。。
	 * */
	public class OnceClipEntity extends AnimatorEntity
	{
//		public static const DO_NOTHING:String="do_nothing";
		public static const AUTO_DESTROY:String="auto_destroy";
		public static const AUTO_REMOVE:String="auto_remove";
		/**
		 * 决定对象是否在结束时是否destroy/remove
		 * 参照OnceClipEntity.AUTO_DESTROY
		 *     OnceClipEntity.AUTO_REMOVE
		 * */
		public var doWhenOver:String="auto_destroy";
		
		public function OnceClipEntity(id:String=null)
		{
			super(id);
		}
//		override protected function doRender():void
//		{
//			super.doRender();
//			if(this.currentFrame>=this.totalFrames){
//				onOver.dispatch(this);
//				if(doWhenOver==OnceClipEntity.AUTO_DESTROY) {
//					this.destroy();
//				}
//				else if(doWhenOver==OnceClipEntity.AUTO_REMOVE){
//					if(this.parent) this.parent.remove(this);
//				}
//			}
//		}
		override protected function whenLastFrame():void
		{
			super.whenLastFrame();
			if(doWhenOver==OnceClipEntity.AUTO_DESTROY) {
				this.dispose();
			}
			else if(doWhenOver==OnceClipEntity.AUTO_REMOVE){
				if(this.parent) this.parent.remove(this);
			}
		}
		override protected function removeSignals():void
		{
			super.removeSignals();
		}
	}
}