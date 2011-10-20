package com.xingcloud.model
{
	import com.xingcloud.util.Reflection;
	import flash.events.EventDispatcher;
	/**
	 *基础数据模型类
	 *
	 */
	public class ModelBase extends EventDispatcher
	{

		/**
		 *数据模型
		 *
		 */
		public function ModelBase()
		{
			super();
		}

		protected var _uid:String;

		/**
		 * 此类的名称
		 * */
		public function get className():String
		{
			return Reflection.tinyClassName(this);
		}

		/**
		 *从一个Object中解析出此实例。根据实例的已存在属性来解析Object。
		 * @param data 数据源
		 * @param excluded 不用解析的字段集合
		 *
		 */
		public function parseFromObject(data:Object, excluded:Array=null):void
		{
			Reflection.cloneProperties(data, this, excluded);
		}

		/**
		 * 唯一Id
		 */
		public function get uid():String
		{
			return _uid;
		}

		public function set uid(uid:String):void
		{
			this._uid=uid;
		}
	}
}