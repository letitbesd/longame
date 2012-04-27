package com.xingcloud.model.users
{
	import com.longame.managers.ProcessManager;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.action.Action;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.event.ServiceEvent;
	import com.xingcloud.model.DBObject;
	import com.xingcloud.model.item.owned.ItemsCollection;
	import com.xingcloud.model.item.owned.OwnedItem;
	import com.xingcloud.quests.QuestManager;
	import com.xingcloud.services.ProfileService;
	import com.xingcloud.services.ServiceManager;
	import com.xingcloud.tasks.TaskEvent;
	import com.xingcloud.tutorial.Tutorial;
	import com.xingcloud.tutorial.TutorialManager;
	
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;
	/**
	 * 用户信息基类
	 */
	public class AbstractUserProfile extends DBObject
	{
		/**
		 * 当前本机用户
		 * */
		public static var ownerUser:AbstractUserProfile;
		/**
		 *是否在登录成功后自动加载用户物品的详情。
		 * @see com.xingcloud.model.item.owned.ItemsCollection#load()
		 * @default true
		 */
		public static var autoLoadItems:Boolean=true;
		/**
		 *用户信息
		 * @param isOwner 是否是用户本身
		 */
		public function AbstractUserProfile(isOwner:Boolean=false)
		{
			this._isOwner=isOwner;
			if(this._isOwner){
				ownerUser=this;
			}
			createItemCollection();
			this.updateWhenLevelUp();
		}
		protected var _name:String;
		protected var _coins:int=0;
		protected var _money:int=0;
		protected var _exp:int=0;
		protected var _level:int=1;
		public function get coins():int
		{
			return _coins;
		}
		/**
		 * 数据模型用于本地存储时的名称
		 * */
		public function get localName():String
		{
			if(!Engine.saveInLocal) return null;
			return Engine.appName;
		}
		/**
		 * 当一个属性被改变时
		 * */
		override protected function whenChange(prop:String,delta:*=null):void
		{
			if(localName){
				//将所有的改变存储到本地
				var sb:SharedObject=SharedObject.getLocal(localName);
				sb.data[prop]=this[prop];
				sb.flush();
			}
			super.whenChange(prop,delta);
		}
		public function set name(value:String):void
		{
			if(_name==value) return;
			_name=value;
			this.whenChange("name");
		}
		public function get name():String
		{
			return _name;
		}
		public function set coins(value:int):void
		{
			value=Math.max(0,value);
			if(_coins==value) return;
			var old:int=_coins;
			_coins=value;
			this.whenChange("coins",_coins-old);
		}
		public function get money():int
		{
			return _money;
		}
		public function set money(value:int):void
		{
			value=Math.max(0,value);
			if(_money==value) return;
			var old:int=_money;
			_money=value;
			this.whenChange("money",_money-old);
		}
		public function get exp():int
		{
			return _exp;
		}
		public function set exp(value:int):void
		{
			value=Math.max(0,value);
			if(_exp==value) return;
			var old:int=_exp;
			_exp=value;
			this.whenChange("exp",_exp-old);
			var newLevel:int=_level;
			var nextExp:int=this.getExpWithLevel(_level+1);
			while(_exp>=nextExp){
				newLevel++;
				nextExp=this.getExpWithLevel(newLevel+1);
			}
			if(newLevel!=_level){
				old=_level;
				_level=newLevel;
				this.updateWhenLevelUp();
				this.whenChange("level",_level-old);
			}
		}
		public function get level():int
		{
			return _level;
		}
		public function set level(value:int):void
		{
			value=Math.max(0,value);
			if(_level==value) return;
			this.exp=this.getExpWithLevel(value);
		}
		/**
		 * 当级别发生变化时，更新级别相关的属性
		 * */
		protected function updateWhenLevelUp():void
		{
			
		}
		/**
		 * 获取level级别所需的经验值，这个需要覆盖
		 * */
		public function getExpWithLevel(level:int):int
		{
			return int.MAX_VALUE;
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

		public var creationDate:Date;
		public var lastActive:Date;
		public var online:Boolean=true;
		/**
		 *物品实例字段名
		 */
		protected var itemFields:Array=[];
		private var loadedNum:int;
		private var needLoadNum:int;
        private var _isOwner:Boolean;
		public function get isOwner():Boolean
		{
			return _isOwner;
		}
		/**
		 * 加载用户信息。如果操作当前用户。
		 */
		public function load(fromLocal:Boolean=false):void
		{
			if(fromLocal){
				var sb:SharedObject=SharedObject.getLocal(Engine.appName);
				if(sb.data){
					this.parseFromObject(sb.data);
					ProcessManager.callLater(onProfileLoaded,[sb.data]);
				}
			}else{
				var act:Action=new Action({loadItems:false,ids:[this.id]},onProfileLoaded,null,Action.LOAD_USER);
				act.execute();
			}
		}

		override public function parseFromObject(data:Object, excluded:Array=null):void
		{
//			super.parseFromObject(data, itemFields);
			super.parseFromObject(data, excluded);
			for each (var key:String in itemFields)
			{
				(this[key] as ItemsCollection).needLoad=(data[key] != null);
			}
			if(this.isOwner){
				QuestManager.init(this.quests);
				TutorialManager.init(this.tutorials);
			}
		}

		/**
		 *加载全部物品详情
		 * @return 是否需要加载，true则需要，false则不需要
		 *
		 */
		public function loadItems():Boolean
		{
			needLoadNum=0;
			loadedNum=0;
//			var act:Action=new Action({user:this.id,types:this.itemFields},onItemsLoaded,onItemsLoadedError,Action.LOAD_ITMES);
//			act.execute();
			for each (var items:ItemsCollection in itemsBulk)
			{
				if (items.load())
				{
					items.onLoaded.addOnce(onItemsLoaded);
					items.onLoadedError.addOnce(onItemsLoadedError);
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

//		public function updateItem(item:OwnedItem):void
//		{
//			var className:String=Reflection.getClassName(item);
//			var collection:ItemsCollection=this[itemToItems[className]] as ItemsCollection;
//			collection.updateItem(item);
//		}

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
			items.OwnerProperty=name;
			items.owner=this;
			itemsBulk.push(items);
			itemToItems[itemType]=name;
		}
		protected function onProfileLoaded(data:*):void
		{
			this.parseFromObject(data[0]);
			Logger.info(this,"onProfileLoaded","UserProfile base info loaded!");
			if (autoLoadItems)
			{
				if (!loadItems()){
					if(this._onLoaded) this._onLoaded.dispatch();
				}
			}
		}
		protected function onItemsLoaded(items:ItemsCollection):void
		{
			loadedNum++;
			if (loadedNum == needLoadNum)
			{
				if(this._onLoaded) this._onLoaded.dispatch();
			}
		}

		protected function onItemsLoadedError(items:ItemsCollection):void
		{
			if(this._onLoadedError) this._onLoadedError.dispatch();
		}
		
		/*****************************************************************************************************/
		/**
		 * 任务完成情况
		 *  =>id
		 *    =>steps=[2,3]  //任务有两个行为，分别完成了多少次
		 *    =>isCompleted=true  //是否完成
		 *  =>id1
		 * */
		public var quests:Object={};
		/**
		 * 向导完成情况
		 * =>id
		 *    =>index=2            //完成了第几步
		 * =>id1
		 * */
		public var tutorials:Object={};
		/**
		 * 更新向导完成到了第几步
		 * @param tutorialId 向导id
		 * @param step 完成到第几步
		 * */
		public function updateTutorial(tutorialId:String,step:int):void
		{
			this.tutorials[tutorialId]={index:step};
			this.whenChange("tutorials",null);
		}
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
			var item:OwnedItem=new cls() as OwnedItem;
			item.itemId=itemID;
			if(uid) item.id=uid;
			else    item.autoUID();
			return item;
		}
	}
}
