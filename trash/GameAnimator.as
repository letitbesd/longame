package com.longame.display
{
	import com.longame.core.IDestroyable;
	import com.longame.display.core.Clip;
	import com.longame.managers.AssetsLibrary;
	import com.longame.model.Direction;
	import com.longame.model.TextureData;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import org.osflash.signals.natives.INativeDispatcher;

	/**
	 * 游戏中动画物品的渲染器它通常可以通过AnimatorEntity来操控，通过source可以设定很多的资源类型
	 * */
	public class GameAnimator extends GameSprite
	{
		/**
		 * 某个动作完成后，或者无动作时，播放默认的动作，循环播放
		 * */
		public var defaultAnimation:String;
		
		protected var _animation:AnimationData;
		
		public function GameAnimator(defaultAnimation:String=null,renderAsBitmap:Boolean=false)
		{
			this.defaultAnimation=defaultAnimation;
			super(renderAsBitmap);
		}
		public function inLastFrame():Boolean
		{
			return clip.currentFrame==clip.totalFrames;
		}
		public function get clip():Clip
		{
			return (_content as Clip);
		}
		override public function destroy():void
		{
			if(_destroyed) return;
			super.destroy();
			_source=null;
		}
		override protected function destroyContent():void
		{
			if(_content){
				(_content as Clip).destroy();
				if(this.contains(_content)) this.removeChild(_content);
			}
			_content=null;
			_animation=null;
		}
		override protected function createContent():void
		{
			if(this._content==null){
				_content=new Clip();
				_animation=new AnimationData((_content as Clip));
				this.addChild(_content);
			}
		}
		override public function set renderAsBitmap(value:Boolean):void
		{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			this.createContent();
			clip.renderAsBitmap=value;
		}
		override protected function doRender(source:*,flip:Boolean=false):void
		{
			clip.onBuild.addOnce(showAnimation);
			clip.buildFromMovieClip(source,_renderAsBitmap);
			clip.effects=this.effects;
			this.flipContent(_content,flip);
//			_animation.showAnimation();
		}
		public function gotoAndPlay(frame:*,loops:int=-1,frameRate:int=-1):void
		{
			if(_animation.targetFrame==frame && _animation.loops==loops && _animation.frameRate==frameRate) return;
			if(clip){
				_animation.reset();
				_animation.isPlay=true;
				_animation.targetFrame=frame;
				_animation.loops=loops;
				_animation.frameRate=frameRate;
				if(clip.mcBuilded) _animation.showAnimation();
				(_content as Clip).onLooped.addOnce(showDefaultAnimation);
			}
		}
		
		private function showAnimation(clip:Clip=null):void
		{
			if(!this._animation.showAnimation()){
				this.showDefaultAnimation();
			}
		}
		private function showDefaultAnimation(clip:Clip=null):void
		{
			if(this.defaultAnimation) this.gotoAndPlay(this.defaultAnimation);
		}
		
		public function gotoAndStop(frame:*):void
		{
			if(_content){
				_animation.reset();
				_animation.isPlay=false;
				_animation.targetFrame=frame;
				_animation.showAnimation();
			}
		}
	}
}
import com.longame.display.core.Clip;
import com.longame.utils.debug.Logger;

internal class AnimationData
{
	public var isPlay:Boolean=true;
	public var targetFrame:*;
	public var loops:int=-1;
	public var isReverse:Boolean=false;
	public var frameRate:int=-1;
	
	private var _clip:Clip;
	public function AnimationData(clip:Clip)
	{
		this._clip=clip;
	}
	public function reset():void
	{
		isPlay=true;
		targetFrame=null;
		loops=-1;
		isReverse=false;
		frameRate=-1;
	}
	public function isSame(target:AnimationData):Boolean
	{
		return (target.isPlay==this.isPlay && target.targetFrame==this.targetFrame && target.loops==this.loops && target.isReverse==this.isReverse && target.frameRate==this.frameRate);
	}
	public function showAnimation():Boolean
	{
		if(targetFrame==null) return false;
		try{
			if(isPlay){
				return _clip.gotoAndPlay(targetFrame,loops,frameRate);
			}else{
				_clip.gotoAndStop(targetFrame);
			}
		}catch(e:Error){
			Logger.error(this,"showAnimation",e.message);
		}
		return true;
	}
	
}