package com.longame.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import com.longame.core.IDestroyable;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.ResourceManager;
	import com.longame.model.Direction;
	import com.longame.model.RenderData;
	import com.longame.resource.Resource;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.debug.Logger;
	
	import org.osflash.signals.natives.INativeDispatcher;
	import com.longame.display.core.SmartClip;

	/**
	 * 游戏中动画物品的渲染器它通常可以通过AnimatorEntity来操控，通过source可以设定很多的资源类型
	 * */
	public class GameAnimator extends GameSprite
	{
		protected var _clip:SmartClip;
		protected var _animation:AnimationData;
		
		public function GameAnimator(source:String=null)
		{
			super(source);
		}
		override public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			super.destroy();
			_source=null;
			this.destroyClip();
		}
		
		private function destroyClip():void
		{
			if(_clip){
				_clip.destroy();
				if(this.contains(_clip)) this.removeChild(_clip);
			}
			_clip=null;
			_animation=null;
		}
		
		override protected function doRender(source:*,flip:Boolean=false):void
		{
			this.destroyBitmap();
			if(this._clip==null){
				_clip=new SmartClip();
				_animation=new AnimationData(_clip);
				this.addChild(_clip);
			}
			_clip.buildFromMovieClip(source);
			if(flip) DisplayObjectUtil.flipHorizontal(_clip);
			_animation.showAnimation();
		}
		public function gotoAndPlay(frame:*,loops:int=-1,frameRate:uint=30):void
		{
			if(_clip){
				_animation.reset();
				_animation.isPlay=true;
				_animation.targetFrame=frame;
				_animation.loops=loops;
				_animation.frameRate=frameRate;
				_animation.showAnimation();
			}
		}
		public function gotoAndStop(frame:*):void
		{
			if(_clip){
				_animation.reset();
				_animation.isPlay=false;
				_animation.targetFrame=frame;
				_animation.showAnimation();
			}
		}
	}
}
import com.longame.display.core.SmartClip;

internal class AnimationData
{
	public var isPlay:Boolean=true;
	public var targetFrame:*;
	public var loops:int=-1;
	public var isReverse:Boolean=false;
	public var frameRate:uint=30;
	
	private var _clip:SmartClip;
	public function AnimationData(clip:SmartClip)
	{
		this._clip=clip;
	}
	public function reset():void
	{
		isPlay=true;
		targetFrame=null;
		loops=-1;
		isReverse=false;
		frameRate=30;
	}
	public function showAnimation():void
	{
		if(targetFrame==null) return;
		if(isPlay){
			_clip.gotoAndPlay(targetFrame,loops,frameRate);
		}else{
			_clip.gotoAndStop(targetFrame);
		}
	}
	
}