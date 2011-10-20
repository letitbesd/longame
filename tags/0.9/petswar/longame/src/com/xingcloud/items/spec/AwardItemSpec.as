package com.xingcloud.items.spec
{
	/**
	 * 给用户的奖励，目前有三种奖励类型：经验，金钱和物品，更多的奖励措施自由扩展。。。
	 * */
	public class AwardItemSpec extends ItemSpec
	{
		/**
		 * 经验值奖励
		 * */
		public var exp:int=0;
		/**
		 * 金钱奖励
		 * */
		public var coins:int=0;
		/**
		 * 物品奖励，意指一个ownedItem物品类型，如CropItem
		 * */
		public var itemType:String;
		/**
		 * 物品的ItemSpec ID
		 * */
		public var itemId:String;
		/**
		 * 物品奖励个数
		 * */
		public var itemCount:uint=1;
		
		public function AwardItemSpec()
		{
			super();
		}
	}
}