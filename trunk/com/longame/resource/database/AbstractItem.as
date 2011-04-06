package com.longame.resource.database
{
	/**
	 * itemSpec和itemGroup的共同基类
	 * */
	public class AbstractItem
	{
		/**唯一标志，必须**/
		public var id:String;
		/**名字，不同语种可能不一样**/
		public var name:String;
		/**类型标志*/
		public var type:String;
		/**描述，不同语种可能会不一样**/
		public var description:String;
		/**父亲**/
		public var parent:ItemGroup;
		/**XML源定义**/
		public var xml:XML;
		/**所属的database**/
//		public var owner:ItemDatabase;
	}
}