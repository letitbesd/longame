package com.xingcloud.items.owned
{
	import com.longame.commands.net.Remoting;
	import com.longame.utils.Reflection;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.XingCloudEvent;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.users.AbstractUserProfile;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	use namespace xingcloud_internal;
	[Event(name="items_loaded",type="com.xingcloud.core.XingCloudEvent")]
	
	public class ItemsCollection extends ArrayCollection
	{
		/**
		 * 是否需要加载详细信息
		 * */
		xingcloud_internal var needLoad:Boolean;
		
		/**此数组只允许itemType制定的class名作为元素，防止误操作,会严格考虑类型，继承的类都不算**/
		xingcloud_internal var itemType:String;
		/**此组物品属于哪个玩家***/
		xingcloud_internal var owner:AbstractUserProfile;
		/**key:uid,value:OwnedItem**/
		protected var itemsMap:Dictionary=new Dictionary();
		protected var _itemClass:Class;
		public var OwnerProperty:String="ownedItems";
		/**
		 *物品实例集合,用于储存一类物品实例 
		 * @param source
		 * 
		 */		
		public function ItemsCollection(source:Array=null)
		{
			super(source);
		}
	
		protected var loadOkCallback:Function;
		protected var loadFailCallback:Function;
		/**
		 * 向服务器请求物品数据详情，并更新相应数据
		 * */
		public function load(successCallback:Function=null,failCallback:Function=null):Boolean
		{
			if(!needLoad){
				if(successCallback!=null) successCallback(null)
				return false;
			}
			this.loadOkCallback=successCallback;
			this.loadFailCallback=failCallback;
			var amf:Remoting=new Remoting(Config.ITEMSLOAD_SERVICE,{user_uid:owner.uid,property:OwnerProperty},XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			amf.onSuccess=onDataUpdated;
			amf.onFail=onDataUpdateFail;
			amf.execute();
			return true;
		}

		protected function onDataUpdated(result:Object):void
		{
			if((result==null)||(result.data==null)){
				trace("ItemsCollection->onDataUpdated: ","The "+OwnerProperty+" from server is empty!");
			}else{
				this.removeAll();
				for each(var itemData:Object in result.data){
//					var uid:String=itemData.uid;
//					var item:OwnedItem=itemsMap[uid];
//					if(item==null) continue;
					var item:OwnedItem=new itemClass(itemData.itemId);
					item.uid=itemData.uid;
					item.parseFromObject(itemData);
					this.addItem(item);
				}	
				needLoad=false;
			}
			this.dispatchEvent(new XingCloudEvent(XingCloudEvent.ITEMS_LOADED));
			if(this.loadOkCallback!=null) this.loadOkCallback(result);
		}
		protected function get itemClass():Class
		{
			if(_itemClass==null) _itemClass=getDefinitionByName(this.itemType) as Class
			return _itemClass;
		}
		protected function onDataUpdateFail(error:String):void
		{
			//todo
			if(this.loadFailCallback!=null) this.loadFailCallback(error);
		}
		/**
		 *移除一个物品 
		 * @param item 物品
		 * @return  返回此物品
		 * 
		 */		
		public function removeItem(item:OwnedItem):OwnedItem
		{
			var index:int=this.getItemIndex(item);
			if(index==-1) return null;
			item.ownerId=null;
			itemsMap[item.uid]=null;
			delete itemsMap[item.uid];
			return this.removeItemAt(index) as OwnedItem;
		}
		public function removeItemByUID(uid:String):OwnedItem
		{
			var item:OwnedItem=this.getItemByUID(uid);
			if(item==null) return null;
			return this.removeItem(item);
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
		override public function addItemAt(item:Object,index:int):void
		{
			this.checkType(item);
			(item as OwnedItem).ownerId=owner.uid;
			(item as OwnedItem).collection=this;
			if(item.uid!=null) itemsMap[item.uid]=item;
			super.addItemAt(item,index);
		}
		override public function addItem(item:Object):void
		{
			this.checkType(item);
			(item as OwnedItem).ownerId=owner.uid;
			(item as OwnedItem).collection=this;
			if(item.uid!=null) itemsMap[item.uid]=item;
			super.addItem(item);
		}
		public function updateItem(item:OwnedItem):void
		{
			var oldItem:OwnedItem=getItemByUID(item.uid);
			if(oldItem)
			{
				removeItem(oldItem);
			}
			addItem(item);
		}
		/**严格检查元素类型**/
		protected function checkType(item:Object):void
		{
			var className:String=Reflection.getClassName(item);
			if(className!=itemType){
				throw new Error("The itemType must be "+this.itemType+" only, the inherited class is not permitted!");
			}
		}
	}
}