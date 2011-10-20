package com.longame.resource
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class LocalFile
	{
		private static var filer:FileReference;
		
		private static var completeCallBack:Function;
		private static var progressCallBack:Function;
		private static var selectedCallBack:Function;
		private static var onErrorCallBack:Function;
		
		public function LocalFile()
		{
			super();
		}
		private static function init():void
		{
			filer=new FileReference();
			filer.addEventListener(Event.SELECT,loadFile);
			filer.addEventListener(ProgressEvent.PROGRESS,onProgress);
			filer.addEventListener(Event.COMPLETE,onComplete);
			filer.addEventListener(IOErrorEvent.IO_ERROR,onError);
			
		}
		/**
		 * 打开本地文件
		 * @param fileTypes: 用","隔开的文件后缀，如"swf,jpg"
		 * @param onComplete: 加载完文件后的回调函数，会把FileReference传给它
		 * @param onSelected: 打开文件时的回调函数
		 * @param onProgress: 加载文件的进程回调，会把ProgressEvent传给它
		 * **/
		public static function open(fileTypes:String,onComplete:Function,onSelected:Function=null,onProgress:Function=null,onError:Function=null):FileReference
		{
			if(filer==null) 
				init();
			completeCallBack=onComplete;
			selectedCallBack=onSelected
			progressCallBack=onProgress;
			onErrorCallBack=onError;
			filer.browse(parseTypes(fileTypes));	
			return filer;
		}
		/**
		 * 存储本地文件
		 * @param data: 文件数据
		 * @param fileName:文件名
		 * @param onComplete: 保存完文件后的回调函数，会把filer传给它
		 * @param onProgress: 保存文件的进程回调，会把progressEvent传给它
		 * **/
		public static function save(data:*,fileName:String,onComplete:Function=null,onProgress:Function=null,onError:Function=null):FileReference
		{
			if(filer==null) 
				init();
			completeCallBack=onComplete;
			progressCallBack=onProgress;
			onErrorCallBack=onError;
			filer.save(data,fileName);
			return filer;
		}
		private static function loadFile(e:Event):void
		{
			try{
				filer.load();
				if(selectedCallBack!=null) selectedCallBack();				
			}catch(e:Error){
			}

		}
		private static function onProgress(e:ProgressEvent):void
		{
			if(progressCallBack!=null) progressCallBack(e);
		}
		private static function onComplete(e:Event):void
		{
			if(completeCallBack!=null) completeCallBack(filer);
		}
		private static function parseTypes(ts:String):Array
		{
			var types:Array=ts.split(",");
			var fts:Array=[];
			for each(var t:String in types){
				var t1:String="*."+t;
				fts.push(new FileFilter(t.toUpperCase()+" File",t1));
			}
			return fts;
		}
		private static function onError(e:IOErrorEvent):void
		{
			if(onErrorCallBack!=null) onErrorCallBack();
		}
	}
}