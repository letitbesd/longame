package com.xingcloud.model.item.owned
{
	import com.longame.managers.ProcessManager;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.event.ServiceEvent;
	import com.xingcloud.model.users.AbstractUserProfile;
	import com.xingcloud.services.ItemsCollectionService;
	import com.xingcloud.services.ServiceManager;
	import com.xingcloud.util.Reflection;
	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;

	public class ItemsCollection
	{
		public var onLoaded:Signal=new Signal(ItemsCollection);
		public var onLoadedError:Signal=new Signal(ItemsCollection);
		/**
		 *物品实例集合,用于储存一类物品实例
		 */
		public function ItemsCollection()
		{
			super();
		}
		protected var _length:int=0;
		public var OwnerProperty:String="ownedItems";
		/**key:uid,value:OwnedItem**/
		protected var itemsMap:Dictionary=new Dictionary();
		protected var _itemClass:Class;

		/**
		 * 是否需要加载详细信息
		 * */
		xingcloud_internal var needLoad:Boolean;

		/**此数组只允许itemType制定的class名作为元素，防止误操作,会严格考虑类型，继承的类都不算**/
		xingcloud_internal var itemType:String;
		/**此组物品属于哪个玩家***/
		public var owner:AbstractUserProfile;
		
		private var _onLoadCallBack:Function;

		/**
		 *从服务器加载物品的详细信息
		 * <p>向服务器请求物品详细的信息，如果此物品集合有信息可以加载，则返回true，并向服务器进行请求，
		 * 成功后派发<code>XingCloudEvent.ITEM_LOAD_SUCCESS</code>事件
		 * 失败后派发<code>XingCloudEvent.ITEM_LOAD_ERROR</code>事件
		 * 返回false，并直接调用successCallback回调函数</p>
		 * @return 如果需要加载则返回true,如果不需要则返回false
		 *
		 */
		public function load(onSuccess:Function=null):Boolean
		{
			if(owner.localName) needLoad=true;
			if (!needLoad)
			{
				if(onSuccess!=null) ProcessManager.callLater(onSuccess);
				return false;
			}
			this._onLoadCallBack=onSuccess;
			//是否从本地缓存加载
			if(owner.localName){
				ProcessManager.callLater(onDataUpdated,[getLocal().data]);
			}else{
				ServiceManager.instance.send(new ItemsCollectionService(this, onDataUpdated, onDataUpdateFail));
			}
			return true;
		}
		/**
		 * 	物品组在本地存放和其owner也就是UserProfile的名称有直接关系
		 * 如UserProfile.localName="someGameUser",其cropItems物品组会被存在“someGameUser.cropItems"的SharedObject中
		 * */
		public function get localName():String
		{
			if(owner.localName) return owner.localName+"."+OwnerProperty;
			return null;
		}
		/**
		 * 其data是个以item的uid为键值的Object
		 * */
		private function getLocal():SharedObject
		{
			if((owner.localName==null)||noSave) return null;
			return SharedObject.getLocal(this.localName);
		}
		/**
		 *通过UID返回具体物品实例
		 * @param uid 物品uid
		 *
		 */
		public function getItemByUID(uid:String):OwnedItem
		{
			return itemsMap[uid];
		}
		/**
		 * 通常某个itemId和某种OwnedItem具有一一对应的关系，获取物品组中指定itemId的那个物品
		 * */
		public function getItemByItemId(itemId:String):OwnedItem
		{
			for each(var item:OwnedItem in itemsMap){
				if(item.itemId==itemId) return item;
			}
			return null;
		}
		/**
		 * 更新item的uid，使之可以查询。一般用于新增物品之后的处理
		 * @param item
		 * @return
		 *
		 */
		public function updateItemUID(item:OwnedItem):OwnedItem
		{
			itemsMap[item.uid]=item;
			return item;
		}

		/**
		 *增加一个物品
		 * @param item 物品
		 * @param index 插入的位置
		 *
		 */
		public function addItem(item:OwnedItem):Boolean
		{
			if(item.uid==null) {
				if(owner.localName==null) throw new Error("Owned item must has uid!");
				else item.uid=item.autoUID();
			}
			this.checkType(item);
			var isNew:Boolean;
			//如果uid的item存在，只更新数量
			if(itemsMap[item.uid]){
				itemsMap[item.uid].count+=item.count;
			}else{
				isNew=true;
				itemsMap[item.uid]=item;
				if(item.owner){
					item.owner.removeItem(item);
				}
				item.owner=this;
				var local:SharedObject=this.getLocal();
				if(local){
					local.data[item.uid]=(itemsMap[item.uid] as OwnedItem).parseToObject();
					local.flush();
				}
				_length++;
			}
			return isNew;
		}
		/**
		 *移除一个物品
		 * @param item 物品，如果不指定物品，随便删一个
		 * @return  返回此物品
		 *
		 */
		public function removeItem(item:OwnedItem=null):OwnedItem
		{
			if(item==null)  {
				for (var uid:String  in itemsMap){
					item=this.itemsMap[uid];
					break;
				}
			}
			if(this.itemsMap[item.uid]){
				item.owner=null;
				delete itemsMap[item.uid];
				var local:SharedObject=this.getLocal();
				if(local){
					//如果有本地缓存，删除之
					delete local.data[item.uid];
					local.flush();
				}
				_length--;
				return item;
			}
			return null;
		}
		public function removeAll():void
		{
//			this.itemsMap=new Dictionary();
			//todo,这种删除方法有待测试,存储本地todo
			for(var uid:String in itemsMap){
				delete itemsMap[uid];
			}
			_length=0;
		}
		public function updateItem(item:OwnedItem,prop:String=null):void
		{
			if(item.count<=0){
				this.removeItem(item);
				return;
			}
			var newItem:Boolean=(getItemByUID(item.uid)==null);
			if (!newItem)
			{
				if(prop){
					var local:SharedObject=this.getLocal();
					if(local) local.data[item.uid][prop]=item[prop];
				}else {
					newItem=true;
					removeItem(item);
				}
			}
		   if(newItem){
				addItem(item);
			}
		}
		private var noSave:Boolean;
		protected function onDataUpdated(result:Object):void
		{
			noSave=true;
			this.removeAll();
			for each (var itemData:Object in result)
			{
				var item:OwnedItem=new itemClass(itemData.itemId);
				item.uid=itemData.uid;
				item.parseFromObject(itemData);
				this.addItem(item);
			}
			needLoad=false;
			noSave=false;
			if(this._onLoadCallBack!=null) _onLoadCallBack();
			this.onLoaded.dispatch(this);
		}

		protected function onDataUpdateFail():void
		{
			Logger.error(this,"onDataUpdateFail",itemClassName+" loaded error!");
			this.onLoadedError.dispatch(this);
		}
       public function get length():int
	   {
		   return _length;
	   }
	   public function get items():Dictionary
	   {
		   return itemsMap;
	   }
		protected function get itemClass():Class
		{
			if (_itemClass == null)
				_itemClass=getDefinitionByName(this.itemType) as Class
			return _itemClass;
		}
		/**
		 * 其OwnedItem元素的类名，如"CropItem"
		 * */
		public function get itemClassName():String
		{
			var dex:int=itemType.lastIndexOf(".");
			return itemType.substring(dex + 1);
		}

		/**严格检查元素类型**/
		protected function checkType(item:Object):void
		{
			var className:String=Reflection.fullClassName(item);
			if (className != itemType)
			{
				throw new Error("The itemType must be " + this.itemType + " only, the inherited class is not permitted!");
			}
		}
	}
}
