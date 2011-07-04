package com.xingcloud.items.owned
{
	import com.xingcloud.core.Config;
	import com.xingcloud.core.ModelBase;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.items.spec.ItemSpec;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	
	use namespace xingcloud_internal;
	/**
	 * 1，建立用户拥有的物品与ItemSpec之间的联系，也就是说每一个物品都拥有一个类型（也就是ItemSpec）
	 * 2，记录用户对于OwnedItem的各种改变，配合Profile计算出来变化的AuditChange，具体原理如下
	 * 当因为某一个原因修改了 active 的属性的时候，OwnedItemBase会通过PropertyChange监听到这个事件的变化，然后将OwnedItemBase设置为dirty。
	 * 当Profile需要自动save的时候，Profile会通过auditChanges获取所有的变化的ownedItem，在计算这个auditChanges的时候，我们可以通过分析每一个OwnedItemBase是不是dirty
	 * 来计算出最近一段时间里面哪些ownedItem发生了变化。
	 * 因此，请注意凡是希望这个属性能够最终影响Profile是不是“因为这个属性的变化而断定用户的数据发生变化，需要提交到服务器上去”，就需要声明[Bindable]
	 */	
	
	[Bindable]
	public class OwnedItem extends ModelBase
	{
		public var count:int=1;
		/**此物品的归属者，在后台需要用，前台自动处理，不必理会**/
		public var ownerId:String;
		protected var ownerProperty:String="ownedItems";
		/**标记物品属于哪个组，内部调用**/
		xingcloud_internal var collection:ItemsCollection;
		protected var _itemSpec:ItemSpec;
		protected var _itemId:String;
		/**
		 *物品实例的基础类，所有物品实例从此继承 
		 * @param itemId 对应的ItemSpec定义id
		 * 
		 */		
		public function OwnedItem(itemId:String)
		{
			_itemId=itemId;
			_itemSpec = ItemDatabase.getItem(itemId);
			if(_itemSpec==null){
				throw new Error("The item defined by id: "+itemId+" is null!");
			}
		}
		public function get itemId():String
		{
			return _itemId;
		}
		public function get itemSpec():ItemSpec
		{
			return _itemSpec;
		}
		public function get OwnerProperty():String
		{
			return ownerProperty;
		}
		
		/**
		 * 这个物品是否属于ownerUser
		 * */
		public function get belongOwner():Boolean
		{
			return (XingCloud.userprofile&&(XingCloud.userprofile.uid==this.ownerId));
		}
		
		/**
		 *从第三方数据源更新信息 
		 * @param data 数据
		 * @param excluded 不需要更新的属性
		 * 
		 */		
		override public function parseFromObject(data:Object,excluded:Array=null):void
		{
			//如果是当前玩家的物品从数据源更新，关闭下track
			if(this.belongOwner) XingCloud.userprofile.stopTrack();
			super.parseFromObject(data,excluded);
		}
		/**
		 * 在纯as工程中，由于用不了Bindable，需要手动发送属性改变事件，请将所有属性用get set方式来定义，在set中手动调用这个函数
		 * */
		protected function dispatchPropertyChangeEvent(prop:String,oldValue:*,newValue:*):void
		{
			if(this.collection==null) return;
			var propEvt:PropertyChangeEvent=new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,null,prop,oldValue,newValue,this);
			var evt:CollectionEvent=new CollectionEvent(CollectionEvent.COLLECTION_CHANGE,false,false,"update",-1,-1,[propEvt]);
			this.collection.dispatchEvent(evt);
		}
	}
}