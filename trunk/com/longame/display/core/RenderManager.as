package com.longame.display.core
{
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
	
	import com.longame.display.effects.BitmapEffect;
	import com.longame.managers.AssetsLibrary;
	import com.longame.resource.ResourceManager;
	import com.longame.model.RenderData;
	import com.longame.resource.Resource;
	import com.longame.utils.DictionaryUtil;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MemoryInfo;
	import com.longame.utils.MovieClipUtil;
	import com.longame.utils.debug.Logger;
	

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
		protected static var renderDatas:Dictionary=new Dictionary();

		/**
		 * 用source所指定的源来直接渲染canvas
		 * @param canvas: 目标容器,实现IBitmapRenerer即可,canvas的bitmap不要在销毁的时候尝试bitmap.bitmapData.dispose(),因为所有的bitmapData放在缓存池里的
		 * @param source: 渲染源，可以是class或者url或者DisplayObject实例，支持特殊的描述： assets.swf#symbol1，表示assets.swf里面的名为symbol1的元件
		 * @param effects:一组位图特效
		 * @param frame: 如果source代表的是一个MovieClip，frame代表渲染某一帧，可以是label，也可以是index
		 * @param flip:是否水平翻转
		 * */
		public static function render(canvas:IBitmapRenderer,source:*,effects:Vector.<BitmapEffect>=null,frame:*=null):void
		{
			loadRender(source,effects,frame,
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
			for(var key:* in renderDatas){
				render=renderDatas[key];
				if(render) render.bitmapData.dispose();
				delete renderDatas[key];
			}
			renderDatas=null;
		}
		/**
		 * 获取source指定的显示对象
		 * @param source:可以是class或者url或者DisplayObject实例，支持特殊的描述： assets.swf#symbol1，表示assets.swf里面的名为symbol1的元件
		 * @param successCallback:如果是url地址动态加载，成功回调，参数是显示对象 function  onSuccess(render:RenderData):void;
		 * @param failCallback:如果是url地址动态加载，失败回调 function onFail():void;
		 * */
		public static function getDisplayFromSource(source:*,successCall:Function,failCall:Function=null):void
		{
			//src是字符串的话，先尝试获取其类，如果不是个类名，尝试加载之
			if(source is String){
				var cls:Class;
				//src中没有".",表示这是一个元件，而不是一个文件地址
				if(source.indexOf(".")==-1) {
					cls=AssetsLibrary.getClass(source as String);
					if(cls==null) throw new Error("No class named: "+source);
				}
				if(cls!=null){
					source=cls;
				}else{
					//检查是否有 assets.swf#symbol1形式的描述，表示assets.swf里面的名为symbol1的元件
					var file:String=source as String;
					var symbolName:String;
					var fs:Array=file.split("#");
					file=fs[0];
					if(fs.length>0) symbolName=fs[1];
					ResourceManager.instance.load(file,
						
						function (r:Resource):void{
							if(successCall==null) return;
							var data:*=r.content;
							if(data is DisplayObject){
								if(symbolName!=null){
									data=AssetsLibrary.getInstance(symbolName) as DisplayObject;
								}
							}
							successCall(data);
						},
						
						function (r:Resource):void{
							if(failCall!=null) failCall();
						}
					);	
					return;
				}
			}
			if(source is Class){
				source=new source();
				if(!(source is DisplayObject)){
					Logger.error("RenderManager","getDisplayFromSource","The object defined with class: "+String(source)+" is not a displayobject!");
					if(failCall!=null) failCall();
					return;
				}
			}
			if(source is DisplayObject){
				if(successCall!=null) successCall(source);
			}else{
				Logger.error("RenderManager","getDisplayFromSource","src must be a DisplayObject,String or Class!");
				if(failCall!=null) failCall();
				return;
			}
		}
		/**
		 * 获取source对应显示对象的位图数据，如果source对应的render已经存在，直接用bitmapData生成新的对象返回，
		 * 对于场景中大量重复静止对象采用此方法，可以降低游戏消耗,返回Sprite或MovieClip
		 * @param source:可以是class或者url或者DisplayObject实例，支持特殊的描述： assets.swf#symbol1，表示assets.swf里面的名为symbol1的元件
		 * @param effects:一组位图特效
		 * @param frame: 如果对象是MovieClip，指定是哪一帧，可以是label，也可以是index
		 * @param successCallback:如果是url地址动态加载，成功回调，参数是显示对象 function  onSuccess(render:RenderData):void;
		 * @param failCallback:如果是url地址动态加载，失败回调 function onFail():void;
		 * */
		public static function loadRender(source:*,effects:Vector.<BitmapEffect>=null,frame:*=null,successCallback:Function=null,failCallback:Function=null):RenderData
		{
			var key:String=getUniqueKey(source,frame,effects);
			var render:RenderData=renderDatas[key];
			if(render==null){
				RenderManager.getDisplayFromSource(source,
					function (display:DisplayObject):void{
						render=getRenderdata(display,frame,effects);
						render.id=key;
						//是否浪费内存
						render.source=display;
						renderDatas[key]=render;
						if(successCallback!=null)　successCallback(render);
					},
					function ():void
					{
						if(failCallback!=null) failCallback();
					});
			}else{
				if(successCallback!=null)　successCallback(render);
			}
			return render;
		}
		
		/**
		 * 将显示对象转换成可重复使用的renderData
		 * @param display:可以是显示对象
		 * @param frame:display是MC的话，指定渲染某一帧，否则无视
		 *  @param effects:一组位图特效
		 * **/
		private static function getRenderdata(display:DisplayObject,frame:*,effects:Vector.<BitmapEffect>):RenderData
		{
			var render:RenderData=new RenderData();
			if(display is MovieClip){
				if(frame==null) frame=1;
				render.bitmapData=DisplayObjectUtil.getFrameBitmapData(display as MovieClip,frame);
			}else{
				render.bitmapData=DisplayObjectUtil.getBitmapData(display).bmd as BitmapData;
			}
			if(effects) render.bitmapData=applyEffects(render.bitmapData,effects);
			var reg:Point=DisplayObjectUtil.getLeftTop(display);
			render.x=reg.x;
			render.y=reg.y;						
			return render;
		}
		private static function getUniqueKey(source:*,frame:*,effects:*):String
		{
			var mainKey:String=String(source);
			//如果source不是string，可能是Class或者显示对象实例，这个时候用它的class名做key，以免重复
			if(!(source is String)){
				//如果是显示对象，用它的class名作为key，以免重复
				mainKey=getQualifiedClassName(source);
			}
			if(frame!=null) mainKey+="@"+String(frame);
			if((effects!=null)&&(effects.length)) mainKey+="@"+String(effects);
			return mainKey;
		}
	}
}
