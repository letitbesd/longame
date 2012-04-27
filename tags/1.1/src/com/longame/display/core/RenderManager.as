package com.longame.display.core
{
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.game.entity.Character;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.model.RenderData;
	import com.longame.resource.Resource;
	import com.longame.resource.ResourceManager;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MemoryInfo;
	import com.longame.utils.MovieClipUtil;
	import com.longame.utils.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	

    /**
	 * 为显示对象提供统一的bitmapData渲染管理，性能需要进一步测试，对于MovieClip，如果本身就是位图构建的，这个渲染没什么意义，
	 * 意义在于矢量图形的位图话会提升性能，当然内存占用会增高，可以在场景退出或其它合适的时机，RenderManager.dispose();
	 * @autor Syler
	 * */
	public class RenderManager
	{
		/**
		 * RenderData缓存池
		 * */
		protected static var renderPool:Dictionary=new Dictionary();
		/**
		 * 显示对象缓存池
		 * */
		protected static var displayPool:Dictionary=new Dictionary();

		/**
		 * 用source所指定的源来直接渲染canvas
		 * @param canvas: 目标容器,实现IBitmapRenerer即可,canvas的bitmap不要在销毁的时候尝试bitmap.bitmapData.dispose(),因为所有的bitmapData放在缓存池里的
		 * @param source: 渲染源，可以是class或者url或者DisplayObject实例，支持特殊的描述： assets.swf#symbol1@content，表示assets.swf里面的名为symbol1的元件中的content子元素
		 * @param frame: 如果source代表的是一个MovieClip，frame代表渲染某一帧，可以是label，也可以是index
		 * @param scaleX:指定x缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * @param scaleY:指定y缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * */
		public static function render(canvas:IBitmapRenderer,source:*,frame:*=null,scaleX:Number=1.0,scaleY:Number=1.0):void
		{
			loadRender(source,frame,scaleX,scaleY,
				function(renderData:RenderData):void
				{
					canvas.bitmap.bitmapData=renderData.bitmapData;
					canvas.bitmap.x=renderData.x;
					canvas.bitmap.y=renderData.y;
				},
				function ():void
				{
					Logger.error("RenderManager","render","The renderData defined with"+source+" and frame: "+frame+" does not exist!");
				}
			);
		}
		/**
		 * 给位图添加特效
		 * @param bmd: 目标位图
		 * @param effects:一组位图特效
		 * */
		public static function applyEffects(bmd:BitmapData,effects:Vector.<BitmapEffect>):BitmapData
		{
			var len:uint=effects.length;
			if((effects==null)||(len==0)) return bmd;
			//clone并不会有太多消耗
			var bitmapdata:BitmapData=bmd.clone();
			for(var i:int=0;i<len;i++){
				bitmapdata=(effects[i]).apply(bitmapdata);
			}
			return bitmapdata;
		}
		/**
		 * 将 renderData的bitmapdata取出来，生成Bitmap
		 **/
		public static function createBitmap(render:RenderData,pixelSnapping:String="auto",smooth:Boolean=true):Bitmap
		{
			var bmp:Bitmap=new Bitmap(render.bitmapData,pixelSnapping,smooth);
			bmp.x=render.x;
			bmp.y=render.y;
			return bmp;
		}
		/**
		 * 销毁掉，注意在场景退出时进行,每个场景destroy的时候，可以调用下这个
		 * */
		public static function dispose():void
		{
			var render:RenderData;
			for(var key:* in renderPool){
				render=renderPool[key];
				if(render) {
					if(render.bitmapData) render.bitmapData.dispose();
					render.source=null;
				}
				renderPool[key]=null;
				delete renderPool[key];
			}
			for(key in displayPool){
				displayPool[key]=null;
				delete displayPool[key];
			}
		}
		/**
		 * 获取source指定的显示对象
		 * @param source:可以是class或者url，支持特殊的描述： assets.swf#symbol1@content?t=2012，表示assets.swf里面的名为symbol1的元件中的content子元素
		 *                           ?参数用于强制加载
		 * @param successCallback:如果是url地址动态加载，成功回调，参数是显示对象 function  onSuccess(display:DisplayObject):void;
		 * @param failCallback:如果是url地址动态加载，失败回调 function onFail():void;
		 * @param fromPool:如果source决定的素材之前调用过，是否从缓存池里拿，默认false,注意...
		 * */
		public static function getDisplayFromSource(source:*,successCall:Function,failCall:Function=null,fromPool:Boolean=false):void
		{
			var key:String=getUniqueKey(source);
			var oldDisplay:DisplayObject=displayPool[key] as DisplayObject;
			if(fromPool&&oldDisplay){
				//todo,没延时回调，可能有问题？
//				ProcessManager.callLater(successCall,[oldDisplay]);
				successCall(oldDisplay);
				return;
			}
			//src是字符串的话，先尝试获取其类，如果不是个类名，尝试加载之
			if(source is String){
				var cls:Class;
				//src中没有".","#","@",表示这是一个元件，而不是一个文件地址
				if((source.indexOf(".")==-1)&&(source.indexOf("#")==-1)&&(source.indexOf("@")==-1)) {
					cls=AssetsLibrary.getClass(source as String);
					if(cls==null) throw new Error("No class named: "+source);
				}
				if(cls!=null){
					source=cls;
				}else{
					//检查是否有 assets.swf#symbol1形式的描述，表示assets.swf里面的名为symbol1的元件
					var file:String=source as String;
					//?参数
					var param:String
					var fs:Array=file.split("?");
					file=fs[0];
					if(fs.length) param=fs[1];
					//@代表的实例名
					var contentName:String;
					fs=file.split("@");
					file=fs[0];
					if(fs.length>0) contentName=fs[1];
					//#代表的class名
					var symbolName:String;
					fs=file.split("#");
					file=fs[0];
					if(fs.length>0) symbolName=fs[1];
					if(param) file+="?="+param;
					ResourceManager.instance.load(file,
						function (r:Resource):void{
							var data:*=r.content;
							if(data is DisplayObject){
								if(symbolName!=null){
									data=AssetsLibrary.getInstance(symbolName) as DisplayObject;
								}
								if(data&&(contentName!=null)){
									data=data[contentName] as DisplayObject;
								}
							}
							displayPool[key]=data;
							ProcessManager.callLater(successCall,[data]);
						},
						function (r:Resource):void{
							if(failCall!=null) ProcessManager.callLater(failCall);
						}
					);	
					return;
				}
			}
			if(source is Class){
				source=new source();
				if(!(source is DisplayObject)){
					Logger.error("RenderManager","getDisplayFromSource","The object defined with class: "+String(source)+" is not a displayobject!");
					if(failCall!=null) {
						ProcessManager.callLater(failCall);
					}
					return;
				}
			}
			if(source is DisplayObject){
				displayPool[key]=source;
				ProcessManager.callLater(successCall,[source]);
			}else{
				Logger.error("RenderManager","getDisplayFromSource","src must be a DisplayObject,String or Class: "+source);
				if(failCall!=null){
					ProcessManager.callLater(failCall);
				}
				return;
			}
		}
		/**
		 * 获取source对应显示对象的位图数据，如果source对应的render已经存在，直接用bitmapData生成新的对象返回，
		 * 对于场景中大量重复静止对象采用此方法，可以降低游戏消耗,返回Sprite或MovieClip
		 * @param source:可以是class或者url或者DisplayObject实例，支持特殊的描述： assets.swf#symbol1，表示assets.swf里面的名为symbol1的元件
		 * @param frame: 如果对象是MovieClip，指定是哪一帧，可以是label，也可以是index
		 * @param scaleX:指定x缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * @param scaleY:指定y缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * @param successCallback:如果是url地址动态加载，成功回调，参数是显示对象 function  onSuccess(render:RenderData):void;
		 * @param failCallback:如果是url地址动态加载，失败回调 function onFail():void;
		 * @param extraId:额外参数，作为id的后缀
		 * */
		public static function loadRender(source:*,frame:*=null,scaleX:Number=1.0,scaleY:Number=1.0,successCallback:Function=null,failCallback:Function=null,extraId:String=null):RenderData
		{
			var key:String=getUniqueKey(source,frame,scaleX,scaleY);
			if(extraId) key+="%"+extraId;
			var render:RenderData=renderPool[key];
			if(render==null){
				RenderManager.getDisplayFromSource(source,
					function (display:DisplayObject):void{
						render=getRenderdata(display,frame,scaleX,scaleY);
						render.id=key;
						//是否浪费内存
						render.source=display;
						renderPool[key]=render;
						//如果源是一个带@标志的对象，那将其调整至本来的注册点
//						if((source is String)&&((source as String).indexOf("@")!=-1)){
//							render.x+=display.x;
//							render.y+=display.y;
//						}
						if(successCallback!=null)　successCallback(render);
					},
					function ():void
					{
						if(failCallback!=null) failCallback();
					},
					true
					);
			}else{
				if(successCallback!=null)　successCallback(render);
			}
			return render;
		}
		/**
		 * 将显示对象转换成可重复使用的renderData
		 * @param display:可以是显示对象
		 * @param frame:display是MC的话，指定渲染某一帧，否则无视
		 * @param scaleX:指定x缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * @param scaleY:指定y缩放，如果要位图渲染放大的矢量图，在矢量图放大后进行draw就会得到清晰的图像
		 * **/
		public static function getRenderdata(display:DisplayObject,frame:*,scaleX:Number=1.0,scaleY:Number=1.0):RenderData
		{
			var render:RenderData=new RenderData();
			if(display is MovieClip){
				if(frame==null) frame=1;
				render.bitmapData=DisplayObjectUtil.getFrameBitmapData(display as MovieClip,frame,scaleX,scaleY);
			}else{
				render.bitmapData=DisplayObjectUtil.getBitmapData(display,null,scaleX,scaleY).bmd as BitmapData;
			}
//			render.bitmapData=DisplayObjectUtil.getBitmapData(display,null,scaleX,scaleY).bmd as BitmapData;
			var reg:Point=DisplayObjectUtil.getLeftTop(display);
			render.x=reg.x*scaleX;
			render.y=reg.y*scaleY;		
			return render;
		}
		private static function getUniqueKey(source:*,frame:*=null,scaleX:Number=1.0,scaleY:Number=1.0):String
		{
			var mainKey:String=String(source);
			//如果source不是string，可能是Class或者显示对象实例，这个时候用它的class名做key，以免重复
			if(!(source is String)){
				//如果是显示对象，用它的class名作为key，以免重复
				mainKey=getQualifiedClassName(source);
			}
			if(frame!=null) mainKey+="@"+String(frame);
			mainKey+="#"+scaleX+"#"+scaleY;
//			if((effects!=null)&&(effects.length)) mainKey+="@"+String(effects);
			return mainKey;
		}
	}
}
