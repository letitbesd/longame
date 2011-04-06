package com.longame.managers
{
	import com.longame.utils.debug.Logger;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class LanguageManager
	{
		public static const ENGLISH:String =   "en";
		public static const CHINESE:String=    "cn";
		public static const GERMAN:String =		"de";
		public static const JAPANESE:String =	"jp";	
		
		private static var _sources:Dictionary=new Dictionary();
		
		
		public function LanguageManager()
		{
			
		}
		/**
		 * 添加一个语言文件，我们允许用户同时存在多个语言文件，甚至实现实时切换
		 * */
		public static function addLanguage(xml:XML):void
		{
			if(!xml.hasOwnProperty("@type")){
				throw new Error("Language XML file should has a 'type' attribute to define the language type, for example 'cn' or 'en'!");
			}
			var type:String=xml.@type;
			_sources[type]=xml;
			//第一次加载的语言文件视为默认的语言
			if(_currentType==null){
				currentType=type;
			} 
		}
		private static var _currentType:String;
		/**
		 * 当前语言版本代号，cn/en...
		 * */
		public static function get currentType():String
		{
			return _currentType;
		}
		public static function set currentType(t:String):void
		{
			if(_currentType==t) return;
			_currentType=t;
			_source=_sources[t];
			if(_source==null){
				throw new Error("No language file with type: "+t);
			}
			_textXML=_source.texts[0];
			_styleXML=_source.style[0];
			if(_textXML==null){
				throw new Error("A language XML should has a texts node!");
			}
			if(_styleXML){
				if(_styles[t]) return;
				_styles[t]=new Dictionary();
				for each(var hxml:XML in _styleXML.children()){
					parseStyle(hxml);
				}
			}			
		}
		
        private static var _source:XML;
		private static var _textXML:XML;
		private static var _styleXML:XML;	
		/**
		 * 当前所用语言源
		 * */
		public static function get currentSource():XML
		{
			return _source;
		}
		/**
		 * 当前所用语言源的texts定义
		 * */		
		public static function get currentTextsXML():XML
		{
			return _textXML;
		}
		/**
		 * 当前所用语言源的style定义
		 * */		
		public static function get currentStyleXML():XML
		{
			return _styleXML;
		}
		/**
		 * TEMPLATE
		 <?xml version="1.0" encoding="GB2312"?>
			<local>
				<!--定义多语言-->
				<texts type="zh_cn">
					<dialog>
					    <!--直接在这里把style定下来,然后更有针对性的嵌入字体？-->
						<title style="H1" text="错误提示"/>
						<message><![CDATA[<font size='16'><b>{0}</b></font><font size='12'>(Lv{1})</font>]]></message>
					</dialog>
					<panel>
						<title text="你要花{0}金币购买{1}个吗？"/>
						<okButton text="确定"/>
					</panel>
				</texts>
			    <!--定义H1,H2,H3样式，暂时不知如何在ant中解析css，所以用这种方式，所有的属性均参照TextFormat的属性-->
			    <style>
					<H1 size="16" color="0xff0000" bold="true"  italic="false" underline="true align="left">
					    <!--定义要嵌入的字体文件路径和字体名字，字体名字是在as中要引用的-->
						<font url="../fonts/song.ttf">宋体</font>
					</H1>
					<H2  size="15" color="0x00f000" bold="false"  italic="false">
						<font url="../fonts/heiti.ttf">黑体</font>	
					</H2>
					<H3  size="12" color="0x000fff" bold="false"  italic="false">
					    <!--如果此字体已经在前面定义过，不用写路径-->
						<font>宋体</font>
					</H3>		
				</style>	
			</local>
		 * **/
		/**
		 * 语言文件可以用value，也可以用text属性，优先后者
		 * @param _key: 获取key名字对应的语言字符串（参照上面的模板,"panel.title"获取第二个title，如果只是"title"，将返回第一个）
		 * @param ...args: 用于替换文本中{0},{1}...字样的字符串
		 * */
		public static function getText(_key:String,...args):String
		{
			if(_textXML==null){
				throw new Error("Language resource is not loaded!");
			}			
			var result:XML=searchFor(_key,_textXML)[0];
			var text:String="undefined";
			if(result==null) return text;
			//优先选择text属性作为目标值
			if(result.hasOwnProperty("@text")) text=result.@text;
			//其次选value，如果要用cdata，用这种方式
			else text=result.toString();
			
			if(args&&(args.length>0)){
				for(var i:int=0;i<args.length;i++){
					var replaceTxt:String=String(args[i]);
					text=text.replace("{"+i+"}",replaceTxt);
				}
			}
			return text;
		}		
		/**
		 * 获取H1,H2,H3...定义的TextFormat
		 * @param name: H1,H2,H3...
		 * */
		public static function getStyle(name:String):TextFormat
		{
			return _styles[_currentType][name];
		}
		private static var _styles:Dictionary=new Dictionary();
		public static function get styles():Dictionary
		{
			return _styles[_currentType];
		}
		/**
		 * 将形如	<H2  size="15" color="0x00f000" bold="false"  italic="false">
						<font url="../fonts/heiti.ttf">黑体</font>	
					</H2>
		        的xml描述的TextFormat解析成真正的TextFormat，没有完全解析，好多用不着
		 * */
		private static function parseStyle(hXML:XML):TextFormat
		{
			if(hXML==null) return null;
			var tf:TextFormat;
			//可能会出现用户定义的属性不合法
			try{
				tf=new TextFormat(hXML.font.toString(),hXML.@size,hXML.@color,hXML.@bold,hXML.@italic,hXML.@underline,null,null,hXML.@align);
			}catch(e:Error){
				Logger.error("LanuageManager","parseStyle",e.message);
			}
			
			_styles[_currentType][hXML.localName()]=tf;
			_styles[_currentType][tf]=hXML.localName();
			return tf;			
		}
		//todo 下面几个函数可做一个util
		/**
		 * 搜索指定关键字的xml
		 * @param _key: 可以是一个以"."分割的字符串，表示要获取的层级(不用连续)，不用.则搜索第一个匹配项
		 * 如 dialogue.error.moneyNotEnough，也可以moneyNotEnough,遇到不同层具有相同键的时候加上路径
		 * */
		public static function searchFor(_key:String,source:XML):XMLList
		{
			var keys:Array=_key.split(".");
			var tempResult:XMLList=source.descendants(keys[keys.length-1]);
			if(keys.length==1) return tempResult;
			var parentKeys:Array=keys.concat();
			parentKeys.pop();
			parentKeys.reverse();
			var result:XMLList=new XMLList();
			for each(var xml:XML in tempResult){
				var i:int=0;
				var tempXml:XML=xml.copy();
				while(i<parentKeys.length){
					xml=xml.parent();
					if(xml==null) break;
					if(xml.name()==parentKeys[i]){
						i++;
					}		
				}
				if(i==parentKeys.length){
					result=appendXmlList(result,tempXml);
				}
			}
			return result;
		}
		/**
		 * 将若干个个xmllist合并，不更改原先的
		 * **/
		public static function concatXmlList(...lists):XMLList
		{
			var listString:String="";
			for each(var list:XMLList in lists){
				for each(var child:XML in list){
					listString+=child.toXMLString();
				}				
			}
			return new XMLList(listString);
		}
		/**
		 * 给一个xmlList添加一个元素
		 * **/
		public static function appendXmlList(list:XMLList,xml:XML):XMLList
		{
			var listString:String=list.toXMLString()+xml.toXMLString();
			return new XMLList(listString);
		}
	}
}