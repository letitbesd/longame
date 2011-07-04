package com.xingcloud.items
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import com.longame.core.IDestroyable;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.items.spec.ItemGroup;
	import com.xingcloud.items.spec.ItemSpec;
	
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
		public static function getItemsByName(_name:String,_groupName:String="all",_groupType:String=null):Array{
			var groups:Array=getGroups(_groupName,_groupType);
			var itms:Array=[];
			for each(var group:ItemGroup in groups){
				var itm:ItemSpec=group.getItemByName(_name,true);
				if(itm) itms.push(itm);
			}
			return itms;
		}
		/**
		 * 获取指定名字_groupName，并且type为_type的
		 * */
		public static function getGroups(_groupName:String="all",_type:String=null):Array
		{
			var groups:Array=[];
			if(_groupName!="all"){
				groups[0]=_groups[_groupName];
			}else{
				for each(var group:ItemGroup in _groups){
					if(_type!=null){
						if(group.type==_type) groups.push(group);
					}else{
						groups.push(group);
					}
				}
			}
			return groups;
		}
		public static function getItem(_id:String,_groupName:String="all",_groupType:String=null):ItemSpec{
			var groups:Array=getGroups(_groupName,_groupType);
			for each(var group:ItemGroup in groups){
				var itm:ItemSpec=group.getItem(_id);
				if(itm!=null) return itm;
			}
			return null;
		}
		public static function getGroup(_name:String,deepSearch:Boolean=true):ItemGroup{
			if(deepSearch){
				for each(var g:ItemGroup in _groups){
					if(g.name==_name) return g;
					var rg:ItemGroup=g.getChildGroup(_name);
					if(rg) return rg;
				}				
			}
			return _groups[_name];
		}
		public static function getRandomItem(_groupName:String):ItemSpec
		{
			var group:ItemGroup=getGroup(_groupName);
			return group.getRandomItem();
		}
		public static function getItemsInGroup(_groupName:String):Array{
			var group:ItemGroup=getGroup(_groupName);
			return group.getAllItems(true);
		}
		
		protected static var _source:XML;
		protected static var _packages:Array=[];
		protected static var _resources:Array=[];
		private static var allBases:Dictionary=new Dictionary(true);
	}
}