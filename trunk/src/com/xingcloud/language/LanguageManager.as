package com.xingcloud.language
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 *语言管理器，用于多语言文本的管理 
	 * @author Admin
	 * 
	 */	
	public class LanguageManager
	{
		public function LanguageManager()
		{
			
		}
		public static const ENGLISH:String =   "en";
		public static const CHINESE:String=    "cn";
		public static const GERMAN:String =	   "de";
		public static const JAPANESE:String =  "jp";	
		
		public static var languageSource:XML;
		public static var styleSheet:StyleSheet;
		
		
		/**
		 * TEMPLATE
			<?xml version="1.0" encoding="utf-8"?>
			<language type="cn">
			   <string name="dialog.title">错误提示</string>
			   <string name="dialog.message"><![CDATA[<font size='16'><b>{0}</b></font><font size='12'>(Lv{1})</font>]]></string>
			   <string name="panel.title">你要花{0}金币购买{1}个吗？</string>
			   <string name="panel.okButton">确定</string>
			</language>
		 * **/
		
		/**
		 * 语言文件可以用value，也可以用text属性，优先后者
		 * @param _key: 获取key名字对应的语言字符串,以"."分割开的关键字（参照上面的模板,"panel.title"获取第二个title，如果只是"title"，将返回第一个）
		 * @param ...args: 用于替换文本中{0},{1}...字样的字符串
		 * */
		public static function getText(_key:String,...args):String
		{
			if(languageSource==null){
				throw new Error("Language resource is not loaded!");
			}			
			var result:XML=searchFor(_key,languageSource)[0];
			var text:String="undefined";
			if(result==null) return text;
			if(result.hasOwnProperty("@text")) text=result.@text;
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
		 * 获取H1,H2,H3...定义的TextFormat，如果需要嵌入字体，别忘记将目标textField.embedFonts=true;
		 * @param name: H1,H2,H3...
		 * */
		public static function getStyle(name:String):TextFormat
		{
			if(name != null)
			{
				if(name.indexOf(".")==-1) name="."+name;
				var style:Object = styleSheet.getStyle(name);
				return styleSheet.transform(style);
			}
			return null;
		}
		/**
		 * 创建一个样式名为style的文本框，style为在css里定义的样式，如H1,H2,...
		 * @param style: 例如H1,H2,...
		 * @param embedFont:是否自动嵌入字体
		 * @param textOrKey:一个字符串或者是key
		 * @param getText: 当getText=true时会用LanguageManager.getText(textOrKey)来显示文本
		 * */
		public static function createText(style:String,embedFont:Boolean=true,textOrKey:String="",getText:Boolean=false):TextField
		{
			var tf:TextField=new TextField();
			tf.defaultTextFormat=getStyle(style);
			if(getText&&textOrKey&&textOrKey.length) textOrKey=LanguageManager.getText(textOrKey);
			tf.text=textOrKey;
			tf.embedFonts=embedFont;
			return tf;
		}
		
		
		
		
		/**
		 * 搜索指定关键字的xml
		 * @param _key: 可以是一个以“.”分割的字符串，表示要获取的层级(不用连续)，不用.则搜索第一个匹配项
		 * 如 dialogue.error.moneyNotEnough，也可以moneyNotEnough,遇到不同层具有相同键的时候加上路径
		 * */
		public static function searchFor(_key:String,source:XML):XMLList
		{
			return source.children().(@name==_key);
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