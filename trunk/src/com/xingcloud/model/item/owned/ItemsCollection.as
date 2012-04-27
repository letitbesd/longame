package com.xingcloud.model.item.owned
{
	import com.longame.managers.ProcessManager;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.action.Action;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.event.ServiceEvent;
	import com.xingcloud.model.users.AbstractUserProfile;
	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;

	/**
	 * 物品组，继承Array，增删物品用addItem,removeItem，数组的方法push,splice,pop,shift等不要用，todo
	 * 心的：因为Array是动态对象，所以继承Array也要指定dynamic，否则会出莫名其妙的问题
	 * */
	dynamic public class ItemsCollection extends Array
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
		public var OwnerProperty:String="ownedItems";
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
				ProcessManager.callLater(updateFromObject,[getLocal().data]);
			}else{
				var act:Action=new Action({user:this.owner.id,types:[this.OwnerProperty]},updateFromObject,onDataUpdateFail,Action.LOAD_ITMES);
				act.execute();
//				ServiceManager.instance.send(new ItemsCollectionService(this, updateFromObject, onDataUpdateFail));
			}
			return true;
		}
		/**
		 * 	物品组在本地存放和其owner也就是UserProfile的名称有直接关系
		 * 如UserProfile.localName="someGameUser",其cropItems物品组会被存在“someGameUser.cropItems"的SharedObject中
		 * */
		private function get localName():String
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
			for each(var item:OwnedItem in this){
				if(item.id==uid) return item;
			}
			return null;
		}
		/**
		 * 通常某个itemId和某种OwnedItem具有一一对应的关系，获取物品组中指定itemId的那个物品
		 * */
		public function getItemByItemId(itemId:String):OwnedItem
		{
			for each(var item:OwnedItem in this){
				if(item.itemId==itemId) return item;
			}
			return null;
		}
		/**
		 *增加一个物品
		 * @param item 物品
		 * @param index 插入的位置
		 *
		 */
		public function addItem(item:OwnedItem):OwnedItem
		{
			if(item.id==null) {
				if(owner.localName==null) throw new Error("Owned item must has uid!");
				else item.id=item.autoUID();
			}
			this.checkType(item);
			//如果uid的item存在，只更新数量
			var oldItem:OwnedItem=this.getItemByUID(item.id);
			if(oldItem){
				oldItem.count+=item.count;
				Logger.info(this,"addItem","Adding item count: "+oldItem.count);
				return oldItem;
			}
			this.push(item);
			if(item.owner){
				item.owner.removeItem(item);
			}
			item.owner=this;
			var local:SharedObject=this.getLocal();
			if(local){
				local.data[item.id]=item.parseToObject();
				local.flush();
			}
			return item
		}
		/**
		 *移除一个物品
		 * @param item 物品，如果不指定物品，随便删一个
		 * @return  返回此物品
		 *
		 */
		public function removeItem(item:OwnedItem=null):OwnedItem
		{
			var index:int=0;
			if(item==null)  {
				item=this[0];
			}else{
				index=this.indexOf(item);
			}
			if(index>=0){
				item.owner=null;
				this.splice(index,1);
				var local:SharedObject=this.getLocal();
				if(local){
					//如果有本地缓存，删除之
					delete local.data[item.id];
					local.flush();
				}
				return item;
			}
			return null;
		}
		public function removeAll():void
		{
			this.length=0;
		}
		public function updateItem(item:OwnedItem,prop:String=null):void
		{
			if(item.count<=0){
				this.removeItem(item);
				return;
			}
			var newItem:Boolean=(getItemByUID(item.id)==null);
			if (!newItem)
			{
				if(prop){
					var local:SharedObject=this.getLocal();
					if(local) local.data[item.id][prop]=item[prop];
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
		public function updateFromObject(result:Object):void
		{
			noSave=true;
			this.removeAll();
			result=result[0];
			for each (var itemData:Object in result)
			{
				var item:OwnedItem=new itemClass();
				item.itemId=itemData.itemId;
				item.id=itemData.id;
				item.parseFromObject(itemData);
				this.addItem(item);
			}
			needLoad=false;
			noSave=false;
			if(this._onLoadCallBack!=null) {
				_onLoadCallBack();
				_onLoadCallBack=null;
			}
			this.onLoaded.dispatch(this);
		}

		protected function onDataUpdateFail():void
		{
			Logger.error(this,"onDataUpdateFail",itemClassName+" loaded error!");
			this.onLoadedError.dispatch(this);
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
			var className:String=Reflection.getClassName(item);
			if (className != itemType)
			{
				throw new Error("The itemType must be " + this.itemType + " only, the inherited class is not permitted!");
			}
		}
	}
}
