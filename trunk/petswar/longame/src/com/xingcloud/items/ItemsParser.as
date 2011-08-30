package com.xingcloud.items
{
	import com.longame.resource.Resource;
	import com.longame.utils.Reflection;
	import com.longame.utils.StringParser;
	import com.longame.utils.XmlUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.items.spec.AbstractItem;
	import com.xingcloud.items.spec.ItemGroup;
	import com.xingcloud.items.spec.ItemSpec;
	
    /**
	 * items database 解析器
	 * */
	internal class ItemsParser
	{
		private static const defaultItemClass:Class=ItemSpec;
		private static const defaultGroupClass:Class=ItemGroup;		

		private static var _xml:XML;
		/**
		 * 从database的 xml中解析
		 * */		
		public static function deserialize(xml:XML):void
		{
			_xml=xml;
			if(_xml==null) throw new Error("The XML source of the database can not be null!");
			//解析包括packages在内的属性
			XmlUtil.parseProperties(ItemDatabase,_xml);	
			if(xml.hasOwnProperty("@packages")) ItemDatabase.addPackages(StringParser.toArray(xml.@packages));
			parseBody();
			
			_xml=null;
		}		
		/**
		 * 和database关联的资源包
		 * <resources>
		 *   <resource id="" src=""/>.......详见Resource
		 * </resources>
		 * */
		protected static function parseResources():Array
		{
			var rsSpec:XMLList=_xml.Resources;
			if(rsSpec.length()==0) return [];
			var rses:XMLList=rsSpec.Resource;
			var rsEntries:Array=[];
			for each(var xml:XML in rses){
				var entry:Resource=Resource.fromXml(xml);
				rsEntries.push(entry);
			}
			return rsEntries;
		}	
		protected static function parseBody():void
		{
			//物品分组列表，组以group为节点
//			var groupList:XMLList = _xml.group;
			var groupList:XMLList = _xml.children();
			var len:uint=groupList.length();
			for(var i:int=0;i<len;i++){
				var group:ItemGroup=new ItemGroup();
				parseChild(group,groupList[i] as XML);
				ItemDatabase.addGroup(group);
			}
		}
		private static function parseChild(item:AbstractItem,xml:XML,parent:ItemGroup=null):void
		{
			item.xml=xml;
//			item.owner=_database;
			/**如果有父节点，将父节点所有可复制属性赋值给子节点，然后再解析子节点自己定义的属性，
			 * 目的是父节点定义的属性会覆盖到所有没有定义该属性的子节点，这对于需要定义一组物品的共同属性很有用**/
			if(parent) copyParentProps(item,parent);
			parseProps(item);
			if(!(item is ItemGroup)) return;
			var children:XMLList=item.xml.children();
			var len:uint=children.length();
			for(var i:int=0;i<len;i++){
				var itemXml:XML=children[i];
				var model:AbstractItem=getModel(itemXml);
				if(model==null){
					throw new Error("The database xml is not validated!");
				}
				parseChild(model,itemXml,item as ItemGroup);
				(item as ItemGroup).addItem(model);
			}
		}
		/**
		 * 节点只要包含group字符，我们视为group类型，如果没有找到对应类，用默认的ItemGroup，
		 * 节点只要包含item字符，我们视为item类型，如果没有找到对应类，用默认的ItemSpec
		 * */
		private static function getModel(xml:XML):AbstractItem
		{
			var clsName:String=xml.localName();
			if(clsName=="AwardItemSpec"){
				trace("wokao");
			}
			var cls:Class;
			var packs:Array=ItemDatabase.packages;
			for each(var pak:String in packs){
				cls=Reflection.getClassByName(pak+"."+clsName);
				if(cls!=null) break;
			}
			if(cls==null){
				if(isGroupType(xml)){
					cls=defaultGroupClass;
				}else if(isItemType(xml)){
					cls=defaultItemClass;
				}else{
					throw new Error("The class "+clsName+" is not defined!");
				}
			}
			return new cls() as AbstractItem;
			
			
		}
		private static function isGroupType(xml:XML):Boolean
		{
			var node:String=String(xml.localName()).toLowerCase();
			return (node.indexOf("group")>=0);
		}
		private static function isItemType(xml:XML):Boolean
		{
			var node:String=String(xml.localName()).toLowerCase();
			return (node.indexOf("item")>=0);			
		}
		/**不需要复制的属性**/
		private static const excludedParentAtrrs:Array=["id","name","resource"];
		/**
		 * 从父节点获取属性
		 * */
		private static function copyParentProps(child:AbstractItem,parent:ItemGroup):void
		{
			for each(var attr:XML in parent.xml.attributes()){
				var attrName:String=attr.localName();
				if((excludedParentAtrrs.indexOf(attrName)==-1)){
					XmlUtil.parseProperty(child,attr);
				}
			}
		}	
		/**
		 * itemSpec的定义规则
		 * id   作为数据库关键字，必须，
		 * name 可选，可同名，没有则取id
		 * */
		protected static function parseProps(target:AbstractItem,source:XML=null):void
		{
			if(source==null) source=target.xml;
			XmlUtil.parseProperties(target,source);
			if(target.id==null) throw new Error("The item "+target.xml+" must have a id property!");
			if(target.name==null) target.name=target.id;
		}			
	}
}