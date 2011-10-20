/**
 * 
 * Embedder
 * 
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 馬鹿なことでも全力で (www.bk-zen.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
package com.longame.resource.embedder
{
	/**
	 * 全ての Embed したファイルの準備が整ったら送出されます。
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")] 
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	/**
	 * Embedder クラスはめんどくさい Embed の処理を気持ち楽にしてくれるクラスです。
	 * 
	 * Embed タグは使用すると便利ですが、どうしてもコードが長くなったりごちゃごちゃしがちです。
	 * 中でも SWF を Embed する場合で、さらに SWF の中にアクセスする場合。
	 * 
	 * <listing> 
	 * 	[Embed (source = '/../asset/hello.swf')]
	 * 	private var EmbedClass: Class;
	 * 	private var embedSwfRoot: MovieClip;
	 * 	
	 * 	private function init(): void
	 * 	{
	 * 		var mc: MovieClip = new EmbedClass();
	 * 		Loader(mc.getChildAt(0)).contentLoaderInfo.addEventListener(Event.INIT, onInit);
	 * 	}
	 * 	
	 * 	private function onInit(e: Event): void
	 * 	{
	 * 		embedSwfRoot = event.target.content;
	 * 	}
	 * </listing>
	 * 
	 * このような長いコードを書かなくてはいけない。
	 * Embedder を使用すれば以下のような形でアクセスできる。
	 * 
	 * <listing> 
	 * 	embedSwfRoot = embedder.getMc(embedder.EmbedClass);
	 * </listing>
	 * 
	 * Embedder が対応しているのは 以下の形式のファイルになる。
	 * 
	 * ファイルタイプ
	 * <ul>
	 * <li>イメージ(mimeType は省略できる)</li>
	 * <li>Flash(mimeType は省略できる)</li>
	 * <li>オーディオ(mimeType は省略できる)</li>
	 * <li>フォント(mimeType は省略できる)</li>
	 * <li>その他(mimeType は省略できない)</li>
	 * </ul>
	 * 
	 * イメージ
	 * <ul>
	 * <li>GIF (mimeType = 'image/gif')</li>
	 * <li>JPG, JPEG (mimeType = 'image/jpeg')</li>
	 * <li>PNG (mimeType = 'image/png')</li>
	 * <li>SVG (mimeType = 'image/svg' or 'image/svg-xml')</li>
	 * </ul>
	 * 
	 * Flash
	 * <ul>
	 * <li>SWF (mimeType = 'application/x-shockwave-flash')</li>
	 * <li>SWF ファイルに保存されたシンボル (mimeType = 'application/x-shockwave-flash')</li>
	 * </ul>
	 * 
	 * オーディオ
	 * <ul>
	 * <li>MP3 (audio/mpeg)</li>
	 * </ul>
	 * 
	 * フォント
	 * <ul>
	 * <li>TTF(trueTypeFont) (mimeType = 'application/x-font-truetpe')</li>
	 * <li>FON(システムフォント) (mimeType = 'application/x-font')</li>
	 * </ul>
	 * 
	 * その他
	 * <ul>
	 * <li>XML などは mimeType = 'application/octet-stream' などで Embed する。</li>
	 * </ul>
	 * 
	 * <p>使い方</p>
	 * 
	 * Embedder は継承をして使います。
	 * 例) この例では Embedder を継承して MyEmbedder を作り、Main クラスから使用してみます。
	 * 
	 * <listing> 
	 * // MyEmbedder.as
	 * package
	 * {
	 * 	import com.bkzen.utils.Embedder;
	 * 	public class MyEmbedder extends Embedder
	 * 	{
	 * 		[Embed(source = '/../asset/embedpng.png')]
	 *		public const Png: Class;
	 * 		[Embed(source = '/../asset/embedswf.swf')]
	 *		public const Swf: Class;
	 * 	}
	 * }
	 * 
	 * // Main.as
	 * package
	 * {
	 * 	import flash.display.BitmapData;
	 * 	import flash.display.Sprite;
	 * 	import flash.display.MovieClip;
	 * 	import flash.events.Event;
	 * 	public class Main extends Sprite
	 * 	{
	 * 		private var em: MyEmbedder;
	 * 		public function Main() 
	 * 		{
	 * 			em = new MyEmbeder();
	 * 			em.addEventListener(Event.COMPLETE, onCompleteEmbedder);
	 * 		}
	 * 		public function onCompleteEmbedder(e: Event): void
	 * 		{
	 * 			em.removeEventListener(Event.COMPLETE, onCompleteEmbedder);
	 * 			// embed した PNGファイルを BitmapData として取得する。
	 * 			var bmd: BitmapData = em.getBmd(em.Png);
	 * 			// embed した SWFファイルの root を取得する。
	 * 			var swfRoot: MovieClip = em.getMc(em.Swf);
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * 
	 * 
	 * 
	 * @author jc at bk-zen.com
	 */
	public class Embedder extends EventDispatcher
	{
		private var embedObjects: Array = [];
		private var initializingChildren: Array = [];
		private var initializedChildren: Dictionary = new Dictionary();
		private var timer: Timer;
		private var initializing: Boolean = false;
		
		public function Embedder() 
		{
			super();
			addEventListener(Event.INIT, onInit);
			timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComp);
			timer.start();
		}
		
		/**
		 * Embedder に登録された Class から作成されたインスタンスを MovieClip で返します。
		 * 対応ファイル: SWF ファイル(メインクラスが MovieClip のもの)
		 * @param	embedClass : <Class> Embed されたクラス(SWF ファイルで Main が MovieClip を継承していなければならない)
		 * 			embedClass が MovieClip を継承しているかわからない場合は getIns() または getDo() を使用する方法もあります。
		 * @return	embedClass によって生成されたインスタンスの root (メインクラス): <MovieClip>
		 */
		public function getMc(embedClass: Class): MovieClip
		{
			return MovieClip(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを Sprite で返します。
		 * 対応ファイル: SWF ファイル(メインクラスが Sprite のもの), SVG ファイル
		 * @param	embedClass : <Class> Embed されたクラス(SWF ファイルで Main が Sprite を継承していなければならない、またはSVGファイル)
		 * 			embedClass が Sprite を継承しているかわからない場合は getIns() または getDo() を使用する方法もあります。
		 * @return	embedClass によって生成されたインスタンスの root (メインクラス): <Sprite>
		 */
		public function getSp(embedClass: Class): Sprite
		{
			return Sprite(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを Bitmap で返します。
		 * 対応ファイル: 画像ファイル(JPG/JPEG, BMP, PNG, GIF)
		 * @param	embedClass : <Class> Embed されたクラス(画像ファイルのみです)
		 * 			embedClass が 画像ファイルかどうかわからない場合は getIns() または getDo() を使用する方法もあります。
		 * @return	embedClass によって生成された Bitmap インスタンス。: <Bitmap>
		 */
		public function getBmp(embedClass: Class): Bitmap
		{
			return Bitmap(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを BitmapData で返します。
		 * 対応ファイル: 画像ファイル(JPG/JPEG, BMP, PNG, GIF)
		 * @param	embedClass : <Class> Embed されたクラス(画像ファイルのみです)
		 * @return	embedClass によって生成された Bitmap インスタンス の BitmapData: <BitmapData>
		 */
		public function getBmd(embedClass: Class): BitmapData
		{
			return Bitmap(EmbedderChild(initializedChildren[embedClass]).classObj).bitmapData;
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを Sound で返します。
		 * 対応ファイル: 音楽ファイル (MP3)
		 * @param	embedClass : <Class> Embed されたクラス(音楽ファイルのみです)
		 * @return	embedClass によって生成された Sound インスタンスです。
		 */
		public function getSnd(embedClass: Class): Sound
		{
			return Sound(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを Font で返します。
		 * 対応ファイル: フォントファイル(TTF, OTF, TTC)(True Type Font)
		 * @param	embedClass : <Class> Embed されたクラス(Font ファイルのみです)
		 * @return	embedClass によって生成された Font インスタンスです。
		 */
		public function getFnt(embedClass: Class): Font
		{
			return Font(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder に登録された Class から生成された SWF のインスタンスに登録された一般定義を取得します。
		 * リンケージからオブジェクトを new すると思ってください。
		 * 対応ファイル: SWF ファイル
		 * @param	embedClass		: <Class> Embed されたクラス(SWF ファイルのみです。)
		 * @param	libClassName	: <String> リンケージに登録したリンケージ名です。
		 * @return	libClassName で指定されたオブジェクト。存在しない場合や、 Embed されたものが DisplayObject じゃない場合は null を返します。
		 */
		public function getLib(embedClass: Class, libClassName: String): *
		{
			var child: EmbedderChild = EmbedderChild(initializedChildren[embedClass]);
			if (child.classObj is DisplayObject && 
				DisplayObject(child.classObj).loaderInfo.applicationDomain.hasDefinition(libClassName)) 
			{
				var clazz: Object = DisplayObject(child.classObj).loaderInfo.applicationDomain.getDefinition(libClassName);
				var obj: Object;
				try
				{
					obj = new clazz();
				}
				catch (e:Error)
				{
					obj = new clazz(null, null);
				}
				return obj;
			}
			return null;
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを XML で返します。
		 * 対応ファイル: XML ファイル
		 * XML ファイルを Embed する時は mimeType を 'application/octet-stream' にしておくか
		 * XML ファイル内の <?xml version="1.0" encoding="utf-8" ?> を取り除いておく必要があります。
		 * おまけです。
		 * @param	embedClass	: <Class> Embed されたクラス(XML ファイルのみです)
		 * @return	XML を返します。
		 */
		public function getXml(embedClass: Class): XML
		{
			if (EmbedderChild(initializedChildren[embedClass]).classObj is ByteArray)
			{
				return XML(EmbedderChild(initializedChildren[embedClass]).classObj);
			}
			else 
			{
				return EmbedderChild(initializedChildren[embedClass]).clazz["data"];
			}
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを返します。
		 * 対応ファイル: 全て
		 * @param	embedClass	: <Class> Embed されたクラス
		 * @return	new されたインスタンスを返します。
		 */
		public function getIns(embedClass: Class): *
		{
			return EmbedderChild(initializedChildren[embedClass]).classObj;
		}
		
		/**
		 * Embedder に登録された Class から生成されたインスタンスを DisplayObject 返します。
		 * 対応ファイル: SWF ファイル, 画像ファイル
		 * @param	embedClass	: <Class> Embed されたクラス(SWF ファイルか画像ファイルのみです)
		 * @return	DisplayObject を返します。
		 */
		public function getDo(embedClass: Class): DisplayObject
		{
			return DisplayObject(EmbedderChild(initializedChildren[embedClass]).classObj);
		}
		
		/**
		 * Embedder をもう使わない時に中身をクリアする。
		 * あんまり使わないと思いますが・・・。
		 */
		public function clear(): void
		{
			var n: int = embedObjects.length;
			for (var i: int = 0; i < n; i++) 
			{
				var obj: EmbedderChild = embedObjects[i];
				delete initializedChildren[obj.clazz]
				obj.clear();
			}
			embedObjects = [];
			initializingChildren = [];
			initializing = false;
		}
		
		
		private function timerComp(e: TimerEvent): void 
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComp);
			//
			var xmllist: XMLList = describeType(this).constant.(@type == "Class");
			for each (var item: XML in xmllist)
			{
				setup(this[item.@name]);
			}
			dispatchEvent(new Event(Event.INIT));
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, checkComp);
			timer.start();
		}
		
		private function onInit(e: Event): void 
		{
			removeEventListener(Event.INIT, onInit);
			//
			var n: int = embedObjects.length;
			for (var i: int = 0; i < n; i++) 
			{
				var obj: EmbedderChild = embedObjects[i];
				obj.addEventListener(Event.COMPLETE, completeChild);
				initializingChildren.push(obj);
				obj.init();
			}
			initializing = true;
			check();
		}
		
		private function completeChild(e: Event): void 
		{
			var child: EmbedderChild = EmbedderChild(e.target);
			child.removeEventListener(Event.COMPLETE, completeChild);
			//
			initializedChildren[child.clazz] = child;
			var i: int = initializingChildren.indexOf(child);
			if (i >= 0) initializingChildren.splice(i, 1);
			check();
		}
		
		private function checkComp(e: TimerEvent): void 
		{
			if (initializingChildren.length > 0)
			{
				var n: int = initializingChildren.length;
				for (var i:int = 0; i < n; i++) 
				{
					var child: EmbedderChild = initializingChildren[i];
					child.reInit();
				}
			}
		}
		
		private function check(): void
		{
			if (!initializing) return;
			if (initializingChildren.length == 0)
			{
				if (timer)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, checkComp);
					timer = null;
				}
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function setup(clazz: Class): void
		{
			var child: EmbedderChild = new EmbedderChild(clazz, getClassName(clazz));
			embedObjects.push(child);
		}
		
		private function getClassName(clazz: Class): String {
			var clazzName: String = getQualifiedClassName(clazz).split("::")[1];
			if (clazzName == null) clazzName = getQualifiedClassName(clazz);
			var mainClassNames: Array = clazzName.split("_");
			if (mainClassNames.length > 1) {
				mainClassNames.shift();
			}
			return mainClassNames.join("_");
		}
	}
	
}


