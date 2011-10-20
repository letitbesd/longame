package com.xingcloud.users
{
	import com.longame.commands.net.Remoting;
	import com.longame.managers.AssetsLibrary;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.ModelBase;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.XingCloudEvent;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.owned.ItemsCollection;
	import com.xingcloud.items.owned.OwnedItem;
	import com.xingcloud.items.spec.ItemSpec;
	import com.xingcloud.quests.QuestManager;
	import com.xingcloud.users.actions.Action;
	import com.xingcloud.users.actions.ActionResult;
	import com.xingcloud.users.actions.IAction;
	import com.xingcloud.users.auditchange.AuditChange;
	import com.xingcloud.users.auditchange.AuditChangeManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	
	use namespace xingcloud_internal;
	
	/**
	 *用户信息基类
	 */	
	
	[Event(name="profile_loaded",type="com.xingcloud.core.XingCloudEvent")]
	[Event(name="login_error",type="com.xingcloud.core.XingCloudEvent")]
	[Event(name="items_loaded",type="com.xingcloud.core.XingCloudEvent")]
	[Event(name="items_loaded_error",type="com.xingcloud.core.XingCloudEvent")]
	
	[Bindable]	
	/**
	 * 用户信息基类
	 */	
	public class AbstractUserProfile extends ModelBase
	{
		public var username:String;
		public var gender:String;
		public var imageUrl:String;
		/**
		 * 任务完成情况
		 *  =>id
		 *    =>steps=[]
		 *    =>isCompleted=true
		 *  =>id1
		 * */
		public var quests:Object={};
		/**
		 * 准备向后台发送一个action
		 * @param act:               要发送的action
		 * @param successCallback:   成功回调函数,模板:  function onSuccess(result:ActionResult,detail:Array):void;
		 * @param failCallback:      失败回调函数，模板：function onSuccess(result:ActionResult,detail:Array):void;
		 * 回调模板函数说明：result是action的整体结果,需要开发者在后台对应action中自定义
		 *                  detail是action对userProfile的每项属性修改对应的ActionResult
		 * */
		public function track(auditChange:AuditChange,successCallback:Function=null,failCallback:Function=null):void
		{
			if(this.isOwner) 
			{
				AuditChangeManager.instance.start(auditChange,successCallback,failCallback);
//				this.dispatchEvent(new ElexEvent(ElexEvent.ACTION_TRACKING,act));
			}
		}
		/***暂停记录auditchange，在需要停止记录时用，如从后台返回数据后会解析到本地的UserProfile，这时需要stop一下*/
		public function stopTrack():void
		{
			if(this.isOwner) AuditChangeManager.instance.stopTrack();
		}		
		/***只是向后台提交一个action，后面不会涉及profile任何属性改变，像在track向导的某一步时，后台只需记录现在是哪一步，需要如此*/
		public function trackOnce(auditChange:AuditChange,successCallback:Function=null,failCallback:Function=null):void
		{
			this.track(auditChange,successCallback,failCallback);
			this.stopTrack();
		}
		/**立即提交改变到服务器**/
		public function commit():void
		{
			if(this.isOwner) AuditChangeManager.instance.execute();
		}
		protected var _isOwner:Boolean;
		/**
		 *用户信息 
		 * @param isOwner 是否是用户本身
		 * 
		 */		
		public function AbstractUserProfile(isOwner:Boolean=false)
		{
			this._isOwner=isOwner;
			if(this._isOwner)
			{
				if(XingCloud.changeMode&&XingCloud.inited)
					this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onPropertyChanged);
			}
			createItemCollection();
			if(XingCloud.autoLogin&&XingCloud.inited)
			{
				login();
			}
		}
		protected function onPropertyChanged(e:PropertyChangeEvent):void
		{
			AuditChangeManager.instance.appendUpdateChange(this,e.property.toString(),e.oldValue,e.newValue);
		}	
		public function get isOwner():Boolean
		{
			return this._isOwner;
		}
		/**
		 * 一个UserProfile可能包含多种ownedItem
		 * */		
		public var ownedItems:ItemsCollection=new ItemsCollection();


		/**
		 * 创建ownedItems和ownedItem的映射，IDE自动生成
		 * */
		protected function createItemCollection():void
		{
			this.addCollection("ownedItems","com.xingcloud.items.owned.OwnedItem");
		}
		/**
		 *物品实例字段名 
		 */		
		protected var itemFields:Array=[];
		/**
		 * 用户物品实例集合
		 */		
		protected var itemsBulk:Array=[];
		/**
		 * 添加一个ownedItems和ownedItem的映射，IDE自动完成
		 * @param name: items字段的名字，如ownedItems
		 * @param itemType: items对应的ownedItem类名，全路径
		 * */
		protected function addCollection(name:String,itemType:String):void
		{   
			itemFields.push(name);
			var items:ItemsCollection=this[name] as ItemsCollection;
			items.itemType=itemType;
			items.OwnerProperty=name;
			items.owner=this;
			itemsBulk.push(items);
			if(this._isOwner&&XingCloud.changeMode) 
			{
				items.addEventListener(CollectionEvent.COLLECTION_CHANGE,onItemsChange);
			}
		}

		/**
		 * 物品变化侦听
		 * e.currentTarget和 e.target均是ItemsCollection
		 * e.items       add,remove时是发生事件的元素，update时是一组PropertyChangeEvent
		 * e.kind        add ,update,remove
		 * e.location    111 ,-1    ,111
		 * e.oldLocation -1  ,-1    ,-1
		 * */
		private function onItemsChange(e:CollectionEvent):void
		{
			if(AuditChangeManager.instance==null) return;
			var items:Array=e.items;
			var max:int=items.length;
			for(var i:int=0;i<max;i++){
				var item:*=items[i];
				switch(e.kind){
					case "add":
						AuditChangeManager.instance.appendItemAddChange(item as OwnedItem);
						break;
					case "update":
						var propEvt:PropertyChangeEvent=item as PropertyChangeEvent;
						AuditChangeManager.instance.appendUpdateChange(propEvt.source as OwnedItem,propEvt.property.toString(),propEvt.oldValue,propEvt.newValue);
						break;
					case "remove":
						AuditChangeManager.instance.appendItemRemoveChange(item as OwnedItem);
						break;
				}				
			}
		}
		protected var loadOkCallback:Function;
		protected var loadFailCallback:Function;
		public function load(successCallback:Function=null,failCallback:Function=null):void
		{
			this.loadOkCallback=successCallback;
			this.loadFailCallback=failCallback;
			var amf:Remoting=new Remoting(Config.USERPROFILE_SERVICE,{user_uid:this.uid},XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			amf.onSuccess=onDataUpdated;
			amf.onFail=onDataUpdateFail;
			amf.execute();
		}
		public function login(successCallback:Function=null,failCallback:Function=null):void
		{
			if(!this.isOwner) {
				throw new Error("login service can only used by owner user!");
			}
			_loginCount=0;
			this.loadOkCallback=successCallback;
			this.loadFailCallback=failCallback;
			doLogin();
		}
		private var _loginCount:int=0;
		private var _loginState:String="idle";
		private function doLogin():void
		{
			_loginState="login";
			_loginCount++;
			var amf:Remoting=new Remoting(Config.USERLOGIN_SERVICE,{platform_uid:Config.platform_uid,platform_user_uid:Config.platform_user_uid},XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			trace("********start login: ",Config.platform_user_uid);
			amf.onSuccess=onDataUpdated;
			amf.onFail=onDataUpdateFail;
			amf.execute();
		}
		protected function onDataUpdated(result:Object):void//如果新用户来的时候挂了就是你小子害的！！
		{
			var actResult:ActionResult;
			if(result&&result.code==200)
			{
				if(result.data) 
					 actResult=ActionResult.parseFromObj(result);
				else
				{
					if(_loginState=="login")
					{
						if(_loginCount<3)
						{
							doLogin();
						}
						else
						{
							doRegister();
						}
					}
					else
					{
						if(this.loadFailCallback!=null) this.loadFailCallback("Login Error");
						this.dispatchEvent(new XingCloudEvent(XingCloudEvent.LOGIN_ERROR));
					}
					return;
				}
			}
			else
			{
				trace("login error: "+result.message);
				if(this.loadFailCallback!=null) this.loadFailCallback("Login Error");
				this.dispatchEvent(new XingCloudEvent(XingCloudEvent.LOGIN_ERROR));
				return;
			}
			if(!actResult.success){
				if(this.loadFailCallback!=null) this.loadFailCallback(result.message);
				return;
			}
			this.parseFromObject(result.data);
			this.dispatchEvent(new XingCloudEvent(XingCloudEvent.PROFILE_LOADED));
			if(this.loadOkCallback!=null) this.loadOkCallback(result);
			if(XingCloud.autoLoadItems)
			{
				UpdateUserItems();
			}
		}
		
		private function doRegister():void
		{
			_loginState="register";
			var amf:Remoting=new Remoting(Config.USERREGISTER_SERVICE,{platform_uid:Config.platform_uid,platform_user_uid:Config.platform_user_uid},XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			trace("********register: ",Config.platform_user_uid);
			amf.onSuccess=onDataUpdated;
			amf.onFail=onDataUpdateFail;
			amf.execute();
		}
		protected function onDataUpdateFail(error:String):void
		{
			if(this.loadFailCallback!=null) this.loadFailCallback(error);
			this.dispatchEvent(new XingCloudEvent(XingCloudEvent.LOGIN_ERROR));
		}
		protected var numItems:int=0;
		protected function onItemsLoaded(data:Object):void
		{
			numItems++;
			if(numItems==itemsBulk.length)
			{
				dispatchEvent(new XingCloudEvent(XingCloudEvent.ITEMS_LOADED));
			}
		}
		protected function onItemsLoadedError(data:Object):void
		{
			dispatchEvent(new XingCloudEvent(XingCloudEvent.ITEMS_LOADED_ERROR));
		}
		override public function parseFromObject(data:Object,excluded:Array=null):void
		{
			this.stopTrack();
			super.parseFromObject(data,itemFields);
			for each(var key:String in itemFields)
			{
				(this[key] as ItemsCollection).needLoad=(data[key]!=null);
			}
			return;
			//以下是老加载方式
			for (var collection:ItemsCollection in itemsBulk)
			{
				collection.removeAll();
				for each(var item:Object in data[collection.OwnerProperty])
				{
					if(item==null) continue;
					var itm:OwnedItem;
					if(item is String)
					{
						itm=this.createItem(collection.itemType,item as String,null);
					}
					else if(item.uid&&item.itemId)
					{	
						//如果传来的OwnedItem，尝试创建并解析之,item.type表示class名
						itm=this.createItem(collection.itemType,item.uid,item.itemId);
						itm.parseFromObject(item);
					}
					if(itm==null)
					{
						trace("AbstraceUserProfile->parseFromObject: ","Invalid OwnedItem!");
						continue;						
					}
					collection.addItem(itm);
				}
			}
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
			var item:OwnedItem=this.createItem(items.itemType,itemObj.uid,itemObj.itemId);
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
			var item:OwnedItem=this.createItem(items.itemType,itemObj.uid,itemObj.itemId);
			item.parseFromObject(itemObj);
			items.addItem(item);
			return item;
		}
		/**
		 * 在Userprofile发生变化后更新物品数据
		 * 
		 */		
		public function UpdateUserItems():void
		{
			for each(var items:ItemsCollection in itemsBulk)
			{
				items.load(onItemsLoaded,onItemsLoadedError);
			}
		}
		//todo,本地对象没有指定ownerProperty呢？
//		public function addItem(item:OwnedItem):void
//		{
//			var collection:ItemsCollection=this[item.ownerProperty] as ItemsCollection;
//			collection.addItem(item);
//		}
//		public function updateItem(item:OwnedItem):void
//		{
//			var collection:ItemsCollection=this[item.ownerProperty] as ItemsCollection;
//			collection.updateItem(item);
//		}
//		public function removeItem(item:OwnedItem):void
//		{
//			var collection:ItemsCollection=this[item.ownerProperty] as ItemsCollection;
//			collection.removeItem(item);
//		}
		protected function createItem(type:String,uid:String,itemID:String=null):OwnedItem
		{
			var cls:Class=AssetsLibrary.getClass(type);
			if(cls==null) return null;
			var item:OwnedItem=new cls(itemID) as OwnedItem;
			item.uid=uid;
			return item;
		}
	}
}