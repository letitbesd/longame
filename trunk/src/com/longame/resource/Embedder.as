package com.longame.resource
{
	import com.longame.core.long_internal;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.managers.SoundManager;
	import com.longame.utils.Reflection;
	import com.longame.utils.UrlUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.Config;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.core.BitmapAsset;
	import mx.core.ByteArrayAsset;
	import mx.core.FontAsset;
	import mx.core.MovieClipAsset;
	import mx.core.MovieClipLoaderAsset;
	import mx.core.SoundAsset;
	import mx.core.SpriteAsset;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;

	/**
	 * 继承Embedder,嵌入资源
	 * var embedder:MyEmbedder=new MyEmbedder();
	 * embedder.onComplete.addOnce(onComplete);
	 * embedder.setup();
	 * 字体会自动被注册，声音自动加入SoundManager,其他资源自动加入ResourceManager处理，这种处理方式让嵌入变得更简单和方便 
	 * 
	 * 1. 嵌入jpg,png,gif,后四个参数可设九宫格
	 *     [Embed(source="",caleGridTop="25", scaleGridBottom="125", scaleGridLeft="25", scaleGridRight="125")]
	 *     public var imgCls:Class;
	 * 
	 *     var bm:BitmapAsset=new imgCls() as BitmapAsset;
	 *     bm.bitmapData....
	 * 可加mimeType
	 * GIF (mimeType = 'image/gif')
	 * JPG, JPEG (mimeType = 'image/jpeg')
	 * PNG (mimeType = 'image/png')
	 * SVG (mimeType = 'image/svg' or 'image/svg-xml')
	 * 
	 * 2. 嵌入svg
	 *     [Embed(source"")]
	 *     public var svgCls:Class;
	 *     
	 *     var svg:SpriteAsset=new svgCls() as SpriteAsset;
	 *     ....
	 * 
	 * 3. 嵌入swf
	 *    [Embed(source="",symbol="")]
	 *    public var mcCls:Class;
	 *    var mc:MovieClipLoaderAsset=new mcCls() as MovieClipLoaderAsset;
	 * 注意：help上说单帧元件实例化后是SpriteAsset，多帧元件实例化后是MovieClipAsset,待验证，还是没看明白，但实践证明是MovieClipLoaderAsset
	 * 
	 * 4. 嵌入sound
	 *    [Embed(source="")]
	 *    public var soundCls:Class;
	 *    var snd:SoundAsset=new soundCls() as SoundAsset;

	 * 5.嵌入xml
	 * 		[Embed(source="test.xml", mimeType="application/octet-stream")]
			protected const EmbeddedXML:Class;
			var x:XML = XML(new EmbeddedXML());
			 * 
	 * 6.嵌入其他二进制文件
	 *    [Embed(source="",mimeType="application/octet-stream")]
	 *    public var dataCls:Class;
	 *    var data:ByteArrayAsset=new dataCls() as ByteArrayAsset;
	 * 
	 * 7.嵌入字体，toto,FontAsset
	 *    见:http://divillysausages.com/blog/as3_font_embedding_masterclass
	 * TTF(trueTypeFont) (mimeType = 'application/x-font-truetpe')
	 * FONT (mimeType = 'application/x-font')
	 * */
	public class Embedder
	{
		public const onComplete:Signal=new Signal();
		/***
		 * 所有的资源定义，如果涉及多语言，请设定lang属性,lang="cn"
		 * */
//		/**
//		 * 定义swf
//		 * */
//		[Resource(source="character.swf")]
//		[Embed(source="character.swf")]
//		public const mcCls:Class;
//		
//		[Resource(source="skills.swf")]
//		[Embed(source="skills.swf")]
//		public const mcCls1:Class;
//		/**
//		 * 声音定义，注意name属性是播放时的id,如果不指定,则用嵌入文件的名字
//		 * */
//		[Resource(source="fly.mp3",name="fly")]
//		[Embed(source="fly.mp3")]
//		public const sndCls:Class;
//		/**
//		 * 添加xml，如果是items，language，tutorial或quest等特殊的xml，请设定type属性
//		 * */
//		[Resource(source="Planets.xml",type="items"]
//		[Embed(source="Planets.xml", mimeType="application/octet-stream")]
//		public const xmlCls:Class;
//		/**
//		 * 定义图片，pixelSnapping和smoothing是指定对应的bitmap属性
//		 * */
//		[Resource(source="coins.png",pixelSnapping="auto", smoothing="false")]
//		[Embed(source="coins.png")]
//		public const imgCls:Class;
		
		protected var mcCount:int=0;
		protected var mcLoaded:int=0;
		protected var mcResources:Dictionary=new Dictionary();
		
		public function Embedder()
		{
//			ProcessManager.callLater(setup);
		}
		public function setup():void
		{
			var resources:Array=Reflection.getMetaInfos(this,"Resource");
			var len:int=resources.length;
			var resourceDes:Object;
			var resource:Resource;
			var content:*;
			var bmp:Bitmap;
			for(var i:int=0;i<len;i++){
				resourceDes=resources[i];
				content=new this[resourceDes.varName]();
				//声音不用加入ResourceManager
				if(content is SoundAsset){
					if(resourceDes.name==null){
						resourceDes.name=UrlUtil.getExtension(resourceDes.source);
//						throw new Error("Sond defined in Embedder should has name property!");
					}
					SoundManager.addSound(content as Sound,resourceDes.name);
					continue;
				}
				//字体不用加入ResourceManager
				if(content is FontAsset){
					//待验证
					Font.registerFont(Reflection.getClass(content));
					continue;
				}
				resource=new Resource(resourceDes.source,resourceDes.type);
				//位图处理
				if(content is BitmapAsset){
					bmp=new Bitmap((content as BitmapAsset).bitmapData,resourceDes.pixelSnapping||"auto",resourceDes.smoothing=="true");
					resource._rawContent=bmp;
				}else if(content is SpriteAsset){
					resource._rawContent=SpriteAsset(content);
				}else if(content is ByteArrayAsset){
					//xml资源也在这里
					resource._rawContent=ByteArray(content);
				}else if(content is MovieClipLoaderAsset){
					mcCount++;
					//swf是异步地,监听下
					(content.getChildAt(0) as Loader).contentLoaderInfo.addEventListener(Event.INIT,onMcInited);
					(content.getChildAt(0) as Loader).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					mcResources[(content.getChildAt(0) as Loader).contentLoaderInfo]=resource;
				}else{
					resource._rawContent=content;
				}
				if((resourceDes.lang==null)||(resourceDes.lang==Config.languageType)) ResourceManager.instance.addResource(resource);
			}
			if(mcCount==0) ProcessManager.callLater(this.onComplete.dispatch);
		}
		protected function onIOError(event:IOErrorEvent):void
		{
			Logger.error(this,"onIOError",event.text);
		}
		protected function onMcInited(event:Event):void
		{
			var r:Resource=(mcResources[event.currentTarget as LoaderInfo] as Resource);
			r._rawContent=(event.currentTarget as LoaderInfo).loader.content;
			r.failed=false;
			r.loaded=true;
			AssetsLibrary.addDomain((event.currentTarget as LoaderInfo).applicationDomain);
			(event.currentTarget as LoaderInfo).removeEventListener(Event.INIT,onMcInited);
			(event.currentTarget as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mcLoaded++;
			if(mcLoaded>=mcCount){
				this.onComplete.dispatch();
				mcResources=null;
			}
		}
	}
}