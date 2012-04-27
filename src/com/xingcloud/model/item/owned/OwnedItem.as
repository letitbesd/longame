package com.xingcloud.model.item.owned
{
	import com.adobe.crypto.MD5;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.ModelBase;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.ItemSpec;
	import com.xingcloud.util.Reflection;
	
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.UIDUtil;

	use namespace xingcloud_internal;

	[Bindable]
	/**
	 * 物品实例，用于表示游戏中实际存在的一个物品类。一个物品实例和一个ItemSpec相对应，在构造时使用itemId来标示。
	 */
	public class OwnedItem extends ModelBase
	{
		public  var owner:ItemsCollection;
		/**
		 *创建一个物品实例
		 * @param itemId 物品实例所对应的物品定义id
		 *
		 */
		public function OwnedItem(itemId:String)
		{
			_itemSpec=ItemDatabase.getItem(itemId);
			if(_itemSpec==null){
				throw new Error("The item defined by id: "+itemId+" is null!");
			}
		}
		/**
		 *拥有者ID
		 */
//		public var ownerId:String;
//		protected var ownerProperty:String="ownedItems";
		/**
		 *@private
		 */
		protected var _itemSpec:ItemSpec;
		/**
		 *@private
		 */
		protected var _uniqueString:String;

		/**
		 *从属的物品集
		 */
//		public function get OwnerProperty():String
//		{
//			return ownerProperty;
//		}
//		public function set OwnerProperty(value:String):void
//		{
//			ownerProperty=value;
//		}

		/**
		 *从第三方数据源更新信息
		 * @param data 数据
		 * @param excluded 不需要更新的属性
		 *
		 */
		override public function parseFromObject(data:Object, excluded:Array=null):void
		{
			super.parseFromObject(data, excluded);
		}

		/**
		 * 此物品实例的定义
		 *
		 */
		public function get itemSpec():ItemSpec
		{
			return _itemSpec;
		}
        override public function set uid(uid:String):void
		{
			this._uid=uid;
			if(this.owner) this.owner.updateItemUID(this);
		}
		/**
		 *@private
		 */
		public function get uniqueString():String
		{
			return _uniqueString;
		}

		/**
		 * @private
		 */
		public function setUniqueString(value:String):void
		{
			_uniqueString=value;
		}
		/******************************************************************************************************************/
		public var count:int=1;
		/**
		 *对OwnedItem生成UID，同时设置OwnedItem的uniqueString，此uniqueString是用于生成UID的唯一标示
		 * @return 生成的UID
		 *
		 */
		public function autoUID():String
		{
			var uniqueString:String=MD5.hash(UIDUtil.createUID() + "&" + Reflection.getAdress(this));
			this.setUniqueString(uniqueString);
			return MD5.hash(XingCloud.uid + "&" + this.className + "&" + uniqueString);
		}
		public function get itemId():String
		{
			if(this._itemSpec) return _itemSpec.id;
			return null;
		}
	}
}
