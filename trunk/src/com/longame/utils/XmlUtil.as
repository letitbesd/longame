//
// $Id: XmlUtil.as 237 2010-05-17 19:27:15Z tim $
//
// Flash Utils library - general purpose ActionScript utility code
// Copyright (C) 2007-2010 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/ooolib/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.longame.utils {
	import com.longame.utils.debug.Logger;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

public class XmlUtil
{
	/**
	 * 将define定义的xml属性解析到target对象中
	 * */
	public static function parseProperties(target:*,define:XML):void
	{
		for each(var attr:XML in define.attributes()){
			StringParser.toTarget(target,attr.localName(),attr.toString());
		}
	}
		/**
		 * 搜索指定关键字的xml
		 * @param _key: 可以是一个以“.”分割的字符串，表示要获取的层级(不用连续)，不用.则搜索第一个匹配项
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
	/**
	 * 从byteArray中读取xml
	 * */
	public static function readBytes(bytes:ByteArray):XML
	{
		var str:String =bytes.readUTFBytes(bytes.length);
		var xml:XML;
		try{
			xml=new XML(str);
		}catch(e:Error){
			Logger.error(XmlUtil,"readBytes","Bytes is not a validate XML format!");
		}
		return xml;
	}
	
}
}
