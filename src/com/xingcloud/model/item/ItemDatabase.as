package com.xingcloud.model.item
{
	import com.longame.core.IDestroyable;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.model.item.spec.ItemGroup;
	import com.xingcloud.model.item.spec.ItemSpec;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class ItemDatabase
	{
		public function ItemDatabase()
		{
			super();

		}
		protected static var _groups:Dictionary=new Dictionary(true);
		public static function addGroup(group:ItemGroup):void
		{
			_groups[group.id]=group;
		}
		public static function get groups():Dictionary
		{
			return _groups;
		}
		public static function addXmlSource(xml:XML):void{
			ItemsParser.deserialize(xml);
		}
		/**
		 * 要用到的类包 <database packages="longsir.resource.ResourceLoader,longsir....."/>
		 * */
		public static function get packages():Array
		{
			return _packages;
		}
		public  static function addPackages(r:Array):void
		{
			_packages=_packages.concat(r);
		}	
		private static var _destroyed:Boolean;
		public  static function get destroyed():Boolean
		{
			return _destroyed;
		}
		/**
		 * 销毁这个物品数据
		 * */
		public static function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			for(var g:String in _groups){
				delete _groups[g];
			}
			_groups=null;
			_source=null;
		}
		/**
		 * 获取一组name为_name的物品，name属性对所有item来说是可以重复的
		 * */
		public static function getItemsByName(name:String,groupId:String="all",groupType:String=null):Array{
			var groups:Array=getGroups(groupId,groupType);
			var itms:Array=[];
			for each(var group:ItemGroup in groups){
				var itm:ItemSpec=group.getItemByName(name,true);
				if(itm) itms.push(itm);
			}
			return itms;
		}
		public static function getItemsByGroupType(groupType:String):Array{
			var groups:Array=getGroups("all",groupType);
			var itms:Array=[];
			for each(var group:ItemGroup in groups){
				itms=group.getAllItems(true,itms);
			}
			return itms;
		}
		/**
		 * 获取指定名字_groupName，并且type为_type的
		 * */
		public static function getGroups(groupId:String="all",type:String=null):Array
		{
			var groups:Array=[];
			if(groupId!="all"){
				groups[0]=_groups[groupId];
			}else{
				for each(var group:ItemGroup in _groups){
					if(type!=null){
						if(group.type==type) groups.push(group);
					}else{
						groups.push(group);
					}
				}
			}
			return groups;
		}
		public static function getItem(itemId:String,groupId:String="all",groupType:String=null):ItemSpec{
			var groups:Array=getGroups(groupId,groupType);
			for each(var group:ItemGroup in groups){
				var itm:ItemSpec=group.getItem(itemId);
				if(itm!=null) return itm;
			}
			return null;
		}
		public static function getGroup(id:String):ItemGroup{
			for each(var g:ItemGroup in _groups){
				if(g.id==id) return g;
				var rg:ItemGroup=g.getChildGroup(id);
				if(rg) return rg;
			}				
			return null;
		}
		public static function getRandomItem(groupId:String):ItemSpec
		{
			var group:ItemGroup=getGroup(groupId);
			if(group==null) return null;
			return group.getRandomItem();
		}
		public static function getItemsInGroup(groupId:String):Array{
			var group:ItemGroup=getGroup(groupId);
			if(group==null) return [];
			return group.getAllItems(true);
		}
		
		protected static var _source:XML;
		protected static var _packages:Array=["com.xingcloud.model.item.spec","model.item"];
		protected static var _resources:Array=[];
		private static var allBases:Dictionary=new Dictionary(true);
	}
}