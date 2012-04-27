package com.longame.utils
{
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import com.longame.model.Range;

	public class MovieClipUtil
	{
		/**
		 * 找到帧标签为 label 的对象，包括clip和其子对象
		 * **/
		public static function findClipWithLabel(clip:MovieClip,label:String):MovieClip
		{
			if(hasOwnLabel(clip,label)) return clip;
			for (var j:int=0; j<clip.numChildren; j++)
			{
				var mc:MovieClip = clip.getChildAt(j) as MovieClip;
				if(!mc)
					continue;
				if(hasOwnLabel(mc,label)) return mc;
			}
			return null;			
		}		
		/**
		 * 找出clip及其子元素里最长帧数
		 */
		public static function findMaxFrames(clip:MovieClip, currentMax:int=-1):int
		{
			if(currentMax==-1) currentMax=clip.totalFrames;
			for (var j:int=0; j<clip.numChildren; j++)
			{
				var mc:MovieClip = clip.getChildAt(j) as MovieClip;
				if(!mc)
					continue;
				
				currentMax = Math.max(currentMax, mc.totalFrames);            
				
				findMaxFrames(mc, currentMax);
			}
			
			return currentMax;
		}
		/***
		 * 目标movieClip是否有标签
		 * **/
		public static function hasOwnLabel(mc:MovieClip,label:String):Boolean
		{
            return (getFrame(mc,label)>0);
		}
		/***
		 * mc的frame对应的标签
		 * **/
		public static function getLabel(mc:MovieClip,frame:int):String
		{
			var labels:Array=mc.currentLabels;
			for each(var l:FrameLabel in labels){
				if(l.frame==frame) return l.name;
			}
			return null;
		}	
		/***
		 * mc的label对应的帧
		 * **/
		public static function getFrame(mc:MovieClip,label:String):int
		{
			var labels:Array=mc.currentLabels;
			for each(var l:FrameLabel in labels){
				if(l.name==label) return l.frame;
			}
			return 0;
		}	
		/***
		 * mc所有的帧标签
		 * **/
		public static function getAllLabels(mc:MovieClip):Array
		{
			var arr:Array=[];
			var labels:Array=mc.currentLabels;
			for (var i:int=0;i<labels.length;i++){
				arr.push(FrameLabel(labels[i]).name);
			}
			return arr;
		}
		/***
		 * mc所有带标签的帧编号
		 * **/
		public static function getAllFramesWithLabel(mc:MovieClip):Array
		{
			var arr:Array=[];
			var labels:Array=mc.currentLabels;
			for (var i:int=0;i<labels.length;i++){
				arr.push(FrameLabel(labels[i]).frame);
			}
			return arr;			
		}
		/**
		 * mc某帧标签的帧索引范围
		 * **/
		public static function getLabelRange(mc:MovieClip,label:String):Range
		{
			var start:int=getFrame(mc,label);
			var end:int=getLabelEnd(mc,label);
			return new Range(start,end);
		}
		/***
		 * mc某帧标签持续的长度
		 * **/
		public static function getLabelLength(mc:MovieClip,label:String):int
		{
			var r:Range=getLabelRange(mc,label);
			return (r.max-r.min);
		}			
		/**
		 * mc某帧标签的结束位置
		 * **/
		public static function getLabelEnd(mc:MovieClip,label:String):int
		{
			var index:int=getAllLabels(mc).indexOf(label);
			if(index==-1) return 0;
			var frames:Array=getAllFramesWithLabel(mc);
			var framePosition:int=frames[index];
			if(index>=(frames.length-1)){
				return mc.totalFrames;
			}
			return frames[index+1]-1;			
		}
		
		/**
		 * Recursively advances all child clips to the specified frame.
		 * If the child does not have a frame at the position, it is skipped.
		 */
//		public static function advanceChildClips(parent:MovieClip, frame:int):void
//		{
//			for (var j:int=0; j<parent.numChildren; j++)
//			{
//				var mc:MovieClip = parent.getChildAt(j) as MovieClip;
//				if(!mc)
//					continue;
//				
//				if (mc.totalFrames >= frame)
//					mc.gotoAndStop(frame);
//				else
//					mc.gotoAndStop(mc.totalFrames);
//				
//				advanceChildClips(mc, frame);
//			}
//		}
	
	}
}