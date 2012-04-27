package com.xingcloud.model.users
{
	import com.adobe.crypto.MD5;
	import com.longame.utils.Reflection;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.event.ServiceEvent;
	import com.xingcloud.model.ModelBase;
	import com.xingcloud.model.item.owned.ItemsCollection;
	import com.xingcloud.model.item.owned.OwnedItem;
	import com.xingcloud.quests.QuestManager;
	import com.xingcloud.services.ProfileService;
	import com.xingcloud.services.ServiceManager;
	import com.xingcloud.tasks.TaskEvent;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.UIDUtil;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;

	/**
	 * 在UserProfile信息成功加载后进行派发。
	 * @eventType com.xingcloud.core.ServiceEvent
	 */
	[Event(name="get_profile_success", type="com.xingcloud.event.ServiceEvent")]
	/**
	 * 在UserProfile信息加载出错后进行派发。
	 * @eventType com.xingcloud.core.ServiceEvent
	 */
	[Event(name="get_profile_error", type="com.xingcloud.event.ServiceEvent")]
	/**
	 * 物品加载成功后进行派发。
	 * @eventType com.xingcloud.core.ServiceEvent
	 */
	[Event(name="item_load_success", type="com.xingcloud.event.ServiceEvent")]
	/**
	 * 物品加载失败后进行派发
	 * @eventType com.xingcloud.core.ServiceEvent
	 */
	[Event(name="item_load_error", type="com.xingcloud.event.ServiceEvent")]
	[Bindable]
	/**
	 * 用户信息基类
	 */
	public class AbstractUserProfile extends ModelBase
	{
		/**
		 * 某个属性发生了变化
		 * */
		public var onChange:Signal=new Signal(String);
		/**
		 *是否在登录成功后自动加载用户物品的详情。
		 * @see com.xingcloud.model.item.owned.ItemsCollection#load()
		 * @default true
		 */
		public static var autoLoadItems:Boolean=true;

		/**
		 *用户信息
		 * @param isOwner 是否是用户本身
		 * @param autoLogin 是否自动登录，缺省为是
		 * @param changeMode 是否打开auditChange模式，缺省为是
		 *
		 */
		public function AbstractUserProfile()
		{
			createItemCollection();
		}
		protected var _coins:int=10000;
		protected var _money:int=0;
		protected var _exp:int=0;
		protected var _level:int=1;
		public function get coins():int
		{
			return _coins;
		}
		public function set coins(value:int):void
		{
			value=Math.max(0,value);
			if(_coins==value) return;
			_coins=value;
			onChange.dispatch("coins");
		}
		public function get money():int
		{
			return _money;
		}
		override public function set money(value:int):void
		{
			value=Math.max(0,value);
			if(_money==value) return;
			_money=value;
			onChange.dispatch("money");
		}
		public function get exp():int
		{
			return _exp;
		}
		public function set exp(value:int):void
		{
			value=Math.max(0,value);
			if(_exp==value) return;
			_exp=value;
			onChange.dispatch("exp");
		}
		public function get level():int
		{
			return _level;
		}
		public function set level(value:int):void
		{
			value=Math.max(0,value);
			if(_level==value) return;
			_level=value;
			onChange.dispatch("level");
		}
		/**
		 * 一个UserProfile可能包含多种ownedItem
		 * */
		public var ownedItems:ItemsCollection=new ItemsCollection();
		/**
		 * 用户物品实例集合
		 */
		public var itemsBulk:Array=[];
		/**
		 * 平台应用ID
		 */
		public var platformAppId:String;
		/**
		 *平台用户ID
		 */
		public var platformUserId:String;

		/**
		 *物品实例字段名
		 */
		protected var itemFields:Array=[];
		private var loadedNum:int;
		private var needLoadNum:int;

		public function get isOwner():Boolean
		{
			return uid == XingCloud.uid;
		}

		/**
		 * 加载用户信息。如果操作当前用户。
		 */
		public function load():void
		{
			ServiceManager.instance.send(new ProfileService([this], onProfileLoaded, onProfileError));
		}

		override public function parseFromObject(data:Object, excluded:Array=null):void
		{
			super.parseFromObject(data, itemFields);
			for each (var key:String in itemFields)
			{
				(this[key] as ItemsCollection).needLoad=(data[key] != null);
			}
			QuestManager.init(this.quests);
		}

		/**
		 *加载物品详情
		 * @return 是否需要加载，true则需要，false则不需要
		 *
		 */
		public function loadItemDetail():Boolean
		{
			needLoadNum=0;
			loadedNum=0;
			for each (var items:ItemsCollection in itemsBulk)
			{
				if (items.load())
				{
					items.addEventListener(ServiceEvent.ITEM_LOAD_SUCCESS, onItemsLoaded);
					items.addEventListener(ServiceEvent.ITEM_LOAD_ERROR, onItemsLoadedError);
					needLoadNum++;
				}
			}
			if (needLoadNum == 0)
				return false;
			else
				return true;
		}
		public function addItem(item:OwnedItem):void
		{
			var className:String=Reflection.getClassName(item);
			var collection:ItemsCollection=this[itemToItems[className]] as ItemsCollection;
			collection.addItem(item);
		}

		public function updateItem(item:OwnedItem):void
		{
			var className:String=Reflection.getClassName(item);
			var collection:ItemsCollection=this[itemToItems[className]] as ItemsCollection;
			collection.updateItem(item);
		}

		public function removeItem(item:OwnedItem):void
		{
			var className:String=Reflection.getClassName(item);
			var collection:ItemsCollection=this[itemToItems[className]] as ItemsCollection;
			collection.removeItem(item);
		}

		public function getItem(uid:String):OwnedItem
		{
			for each (var collection:ItemsCollection in itemsBulk)
			{
				var item:OwnedItem=collection.getItemByUID(uid);
				if(item) return item;
			}
			return null;
		}
		protected function createItemCollection():void
		{
			this.addCollection("ownedItems", "com.xingcloud.items.owned.OwnedItem");
		}
		protected var itemToItems:Dictionary=new Dictionary();
		/**
		 * 添加一个ownedItems和ownedItem的映射，IDE自动完成
		 * @param name: items字段的名字，如ownedItems
		 * @param itemType: items对应的ownedItem类名，全路径
		 * */
		protected function addCollection(name:String, itemType:String):void
		{
			itemFields.push(name);
			var items:ItemsCollection=this[name] as ItemsCollection;
			items.itemType=itemType;
			var dex:int=itemType.lastIndexOf(".");
			items.itemClassName=itemType.substring(dex + 1);
			items.OwnerProperty=name;
			items.owner=this;
			itemsBulk.push(items);
			itemToItems[itemType]=name;
		}
		protected function onProfileLoaded(s:ProfileService):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.PROFILE_LOADED, s));
			if (autoLoadItems)
			{
				if (!loadItemDetail())
					dispatchEvent(new ServiceEvent(ServiceEvent.ITEM_LOAD_SUCCESS, null));
			}
		}

		protected function onProfileError(s:ProfileService):void
		{
			this.dispatchEvent(new ServiceEvent(ServiceEvent.PROFILE_ERROR, s));
		}

		protected function onItemsLoaded(evt:ServiceEvent):void
		{
			loadedNum++;
			if (loadedNum == needLoadNum)
			{
				dispatchEvent(new ServiceEvent(ServiceEvent.ITEM_LOAD_SUCCESS, null));
			}
		}

		protected function onItemsLoadedError(evt:ServiceEvent):void
		{
			dispatchEvent(new ServiceEvent(ServiceEvent.ITEM_LOAD_ERROR, null));
		}
		
		/*****************************************************************************************************/
		/**
		 * 任务完成情况
		 *  =>id
		 *    =>steps=[2,3]
		 *    =>isCompleted=true
		 *  =>id1
		 * */
		public var quests:Object={};
		/**
		 * 根据服务器返回的itemObj数据来创建一个本地对应的OwnedItem
		 * */
		public function createItemFromObject(itemObj:Object):OwnedItem
		{
			var itemsProp:String=itemObj.ownerProperty;
			if(itemsProp==null) throw new Error("Invalid data from server!");
			var items:ItemsCollection=this[itemsProp] as ItemsCollection;
			if(items==null) throw new Error("The collection does not exist!");
			var item:OwnedItem=this.createItem(items.itemType,itemObj.itemId,itemObj.uid);
			item.parseFromObject(itemObj);
			return item;
		}
		/**
		 * 根据服务器返回的itemObj数据来添加一个本地对应的OwnedItem
		 * */
		public function addItemFromObject(itemObj:Object):OwnedItem
		{
			var itemsProp:String=itemObj.ownerProperty;
			if(itemsProp==null) throw new Error("Invalid data from server!");
			var items:ItemsCollection=this[itemsProp] as ItemsCollection;
			if(items==null) throw new Error("The collection does not exist!");
			var item:OwnedItem=this.createItem(items.itemType,itemObj.itemId,itemObj.uid);
			item.parseFromObject(itemObj);
			items.addItem(item);
			return item;
		}
		/**
		 * 根据以下参数添加一个物品
		 * @param itemId: 物品的定义id
		 * @param itemType:物品所属物品组，如"cropItems"
		 * @param uid: 物品的uid，如果不指定uid，会尝试堆叠到已有的物品中，count累加
		 * @param count：物品数量
		 * */
		public function addItemFromItemId(itemId:String,itemType:String,uid:String=null,count:int=1):OwnedItem
		{
			var items:ItemsCollection=this[itemType] as ItemsCollection;
			if(items==null) throw new Error("The collection does not exist!");
			
			var has:Boolean;
			if(uid==null){
				for each(var item:OwnedItem in items){
					if(item.itemSpec.id==itemId){
						item.count+=count;
						has=true;
						break;
					}
				}
			}
			if(!has){
				if(uid){
					item=this.createItem(items.itemType,itemId,uid);
					item.count=count;
					items.addItem(item);
				}else{
					item=null;
				}
			}
			return item;
		}
		protected function createItem(type:String,itemID:String,uid:String=null):OwnedItem
		{
			var cls:Class=getDefinitionByName(type) as Class;
			if(cls==null) return null;
			var item:OwnedItem=new cls(itemID) as OwnedItem;
			if(uid) item.uid=uid;
			else    item.autoUID();
			return item;
		}
	}
}
