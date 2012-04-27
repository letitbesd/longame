package com.longame.commands.other
{
	import com.longame.commands.base.Command;
	import com.longame.core.IAnimatedObject;
	import com.longame.display.core.RenderManager;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.model.RenderData;
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

	/**
	 * 动画预先渲染，用于给位图渲染和stage3d渲染提供素材
	 * */
	public class AnimaionPreRenderer extends Command implements IAnimatedObject
	{
		private static const MAX_FRAME_TIME:int=50;
		protected var source:*;
		protected var scaleX:Number;
		protected var scaleY:Number;
		protected var extraParam:*;
		protected var clip:MovieClip;
		protected var frameTime:int;
		protected var frameIndex:int=1;
		protected var _renders:Vector.<RenderData>=new Vector.<RenderData>();
		
		public function AnimaionPreRenderer(source:*,scaleX:Number=1.0,scaleY:Number=1.0,extraParam:*=null)
		{
			this.source=source;
			this.scaleX=scaleX;
			this.scaleY=scaleY;
			this.extraParam=extraParam;
		}
		override protected function doExecute():void
		{
			super.doExecute();
			RenderManager.getDisplayFromSource(source,onGotClip);
		}
		private function onGotClip(mc:MovieClip):void
		{
			this.clip=mc;
			ProcessManager.addAnimatedObject(this);
		}
		public function onFrame(deltaTime:Number):void
		{
			frameTime=getTimer();
			while(getTimer()-frameTime<MAX_FRAME_TIME){
				this.customFrame(frameIndex);
				_renders.push(RenderManager.loadRender(source,frameIndex,scaleX,scaleY,null,null,this.getExtraId()));
				if(frameIndex==clip.totalFrames){
					this.complete();
					break;
				}
				frameIndex++;
				if(getTimer()-frameTime>=MAX_FRAME_TIME) {
					break;
				}
			}
		}
		/**
		 * 对每帧进行个性化处理
		 * */
		protected function customFrame(frame:int):void
		{
		}
		protected function getExtraId():String
		{
			//to be override
			return this.extraParam;
		}
		override protected function complete():void
		{
			ProcessManager.removeAnimatedObject(this);
			super.complete();
			this.source=null;
			this.extraParam=null;
			this.clip=null;
			this._renders=null;
		}
		public function get renders():Vector.<RenderData>
		{
			return _renders;
		}
	}
}