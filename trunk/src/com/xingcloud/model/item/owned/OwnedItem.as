package com.xingcloud.model.item.owned
{
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.debug.Logger;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.DBObject;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.ItemSpec;
	import com.xingcloud.model.users.AbstractUserProfile;
	import com.xingcloud.util.Reflection;

	use namespace xingcloud_internal;

//	[Bindable]
	/**
	 * 物品实例，用于表示游戏中实际存在的一个物品类。一个物品实例和一个ItemSpec相对应，在构造时使用itemId来标示。
	 * 所有继承OwnedItem的class，构造函数不要带参数
	 */
	public class OwnedItem extends DBObject
	{
		private static var _uidPoint:int=1;
		protected var _owner:ItemsCollection;
		/**
		 *创建一个物品实例
		 *
		 */
		public function OwnedItem()
		{
			_uidPoint++;
		}
		override 	protected function get propertiesNoSave():Array
		{
			return super.propertiesNoSave.concat(["owner","itemSpec","onChange"]);
		}
		override protected function whenChange(prop:String, delta:*=null):void
		{
			if(_owner){
				_owner.updateItem(this,prop);
			}
			super.whenChange(prop,delta);
		}
		public function get owner():ItemsCollection
		{
			return _owner;
		}
		public function set owner(value:ItemsCollection):void
		{
			if(_owner==value) return;
			_owner=value;
		}
		public function get user():AbstractUserProfile
		{
			if(_owner==null) return null;
			return _owner.owner as AbstractUserProfile;
		}
		/**
		 *@private
		 */
		protected var _uniqueString:String;
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
        override public function set id(value:String):void
		{
			this._id=value;
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
		protected var _count:int=1;
		public function get count():int
		{
			return _count;
		}
		public function set count(value:int):void
		{
			if(_count==value) return;
			var old:int=_count;
			_count=value;
			this.whenChange("count",_count-old);
		}
		/**
		 *对OwnedItem生成UID，同时设置OwnedItem的uniqueString，此uniqueString是用于生成UID的唯一标示
		 * @return 生成的UID
		 *
		 */
		public function autoUID():String
		{
//			var uniqueString:String=MD5.hash(UIDUtil.createUID() + "&" + Reflection.getAdress(this));
//			this.setUniqueString(uniqueString);
//			return MD5.hash(XingCloud.uid+ "&" + this.className + "&" + uniqueString);
			return this.className+"_"+_uidPoint;
		}
		/**
		 *@private
		 */
		protected var _itemSpec:ItemSpec;
		/**
		 * 此物品实例的定义
		 *
		 */
		public function get itemSpec():ItemSpec
		{
			if((_itemSpec==null)&&_itemId){
				this._itemSpec=ItemDatabase.getItem(_itemId);
			}
			return _itemSpec;
		}
		public function get itemId():String
		{
			return _itemId;
		}
		private var _itemId:String;
		public function set itemId(value:String):void
		{
			if(_itemId==value) return;
			_itemId=value;
			this._itemSpec=ItemDatabase.getItem(value);
			if(_itemSpec==null){
				Logger.warn(this,"set itemId","The item defined by id: "+value+" is null!");
			}
		}
	}
}
