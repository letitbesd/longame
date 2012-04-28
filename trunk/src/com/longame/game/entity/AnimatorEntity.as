package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.display.core.AnimationController;
	import com.longame.display.core.AnimationFrames;
	import com.longame.display.core.IFrameAnimator;
	import com.longame.display.core.RenderManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.TextureData;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MovieClipUtil;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;

	public class AnimatorEntity extends SpriteEntity implements IFrameAnimator
	{
		/**
		 * 所有的帧标签map，存储着 帧标签和帧数的相互索引
		 * 基于以下设定：所有方向的mc具有相同的动画序列,缓存呢，todo
		 * */
		protected var _frames:AnimationFrames=new AnimationFrames();
		private var animationController:AnimationController=new AnimationController(this as IFrameAnimator);
		private var _frameInvalidated:Boolean;
		
		public function AnimatorEntity(id:String=null)
		{
			super(id);
		}
		override protected function addSignals():void
		{
			super.addSignals();
			animationController.onAnimationPlayed.add(this.whenAnimationPlayed);
			animationController.onLastFrame.add(this.whenLastFrame);
		}
		override protected function removeSignals():void
		{
			super.removeSignals();
			animationController.onAnimationPlayed.remove(this.whenAnimationPlayed);
			animationController.onLastFrame.remove(this.whenLastFrame);
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			_frames.destroy();
			_frames=null;
			animationController.destroy();
			animationController=null;
		}
		override protected function  whenSourceLoaded():void
		{
			if(_sourceDisplay){
				_frames.parseFromMC(_sourceDisplay as MovieClip);
				animationController.initialize();
			}
			super.whenSourceLoaded();
		}
		override protected function renderBitmap():void
		{
			if((_bitmapInvalidated||_frameInvalidated)&&_sourceDisplay){
				RenderManager.loadTexture(this._currentSource,_currentFrame,_scaleX,_scaleY,onTextureLoaded);
				_bitmapInvalidated=false;
				_frameInvalidated=false;
			}
		}
		/**
		 * 播放某帧
		 * @param frame: 索引或标签
		 * @param loops: 如果是标签，则重播放这个标签到下个标签或这个标签到帧尾这个区间段几次，-1为无穷,0则只播一次，1则播两次，依次类推
		 * bug: 要播放gotoAndPlay的帧最好不是1帧，否则莫名其妙的问题，如果1帧为何不用gotoAndStop呢
		 */
		public function gotoAndPlay(frame:Object,loops:int=0):Boolean
		{
			return animationController.gotoAndPlay(frame,loops);
		}
		public function gotoAndStop(frame:Object):Boolean
		{
			return animationController.gotoAndStop(frame);
		}
		public function play():Boolean
		{
			return animationController.play();
		}
		public function stop():Boolean
		{
			return animationController.stop();
		}
		override protected function doRender():void
		{
			this.animationController.update();
			super.doRender();
		}
		/**
		 * 当某个动画播放完毕时
		 * */
		protected function whenAnimationPlayed(label:String):void
		{
			//can be override
		}
		/**
		 * 每当到最后一帧调用，做需要做的处理，比如有些动画播放完就消失
		 * 但是如果一直停在最后一帧，只会掉最开始那次
		 * */
		protected function whenLastFrame():void
		{
			//can be override
		}
		/**
		 * 当帧变化时
		 * */
		protected function onFrame():void
		{
			//can be override
		}
		private var _currentFrame:int=0;
		public function set currentFrame(value:int):void
		{
			if(_currentFrame==value) return;
			_currentFrame=value;
			_frameInvalidated=true;
			this.onFrame();
		}
		public function get totalFrames():int
		{
			if(_frames) return _frames.totalFrames;
			return int.MAX_VALUE;
		}
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		public function get currentLabel():String
		{
			return this.animationController.currentLabel;
		}
		public function get frames():AnimationFrames
		{
			return _frames;
		}
		/**
		 * 当一个动画播放完毕时发出,通常是通过gotoAndPlay来播放动画的时候，如果loops为-1，就不会发出这个事件
		 * @param String是动画的帧名
		 * */
		public function get onAnimationPlayed():Signal
		{
			if(this.animationController==null) return null;
			return this.animationController.onAnimationPlayed;
		}
		public function get onLastFrame():Signal
		{
			if(this.animationController==null) return null;
			return this.animationController.onLastFrame;
		}
	}
}