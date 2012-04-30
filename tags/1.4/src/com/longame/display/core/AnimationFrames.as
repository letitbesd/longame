package com.longame.display.core
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	public class AnimationFrames
	{
		/**
		 * 所有label
		 * */
		private var _labels:Vector.<String>=new Vector.<String>();
		/**
		 *里所有label对应的frame
		 * */
		private var _labelFrames:Vector.<uint>=new Vector.<uint>();
		/**
		 * 总帧数
		 * */
		private var _totalFrames:int;
		
		public function AnimationFrames()
		{
		}
		public function parseFromMC(clip:MovieClip):void
		{
			_labelFrames.length=0;
			_labels.length=0;
			var allLabels:Array=clip.currentLabels;
			for(var i:int=0;i<allLabels.length;i++){
				var label:FrameLabel=allLabels[i];
				_labelFrames[i]=label.frame;
				_labels[i]=label.name;
			}
			_totalFrames=clip.totalFrames;
		}
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		public function hasLabel(label:String):Boolean
		{
			return _labels.indexOf(label)>-1;
		}
		public function getLabel(frame:uint):String
		{
			var i:int=_labelFrames.indexOf(frame);
			if(i==-1) return null;
			return _labels[i];
		}
		public function getFrame(label:String):uint
		{
			var i:int=_labels.indexOf(label);
			if(i==-1) return 0;
			return _labelFrames[i];
		}
		public function getLabelEnd(label:String):int
		{
			var i:int=_labels.indexOf(label);
			if(i==-1) return 0;
			if(i>=_labels.length-1){
				return _totalFrames;
			}
			return Math.max(1,_labelFrames[i+1]-1);			
			
		}
		public function destroy():void
		{
			_labels=null;
			_labelFrames=null;
		}
	}
}