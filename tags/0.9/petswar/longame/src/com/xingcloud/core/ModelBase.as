package com.xingcloud.core
{
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.Reflection;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModelBase extends EventDispatcher
	{
		/**
		 * 唯一Id 
		 */	
		private var _uid:String;
		public function get uid():String
		{
			return _uid;
		}
		public function set uid(uid:String):void
		{
			this._uid=uid;
		}
		/**
		 *数据模型 
		 * 
		 */		
		public function ModelBase()
		{
			super();
		}
		/**
		 * 类名
		 * */
		private var _className:String=Reflection.tinyClassName(this);
		public function get className():String
		{
			return _className;
		}
		/**
		 * 将一个普通的Object数据解析到此实例，凡是字段相同的属性都覆盖过来，这时候如果是当前玩家数据更新，要停止下track,见继承
		 * 如果需要批量更新数据而又不想track，请用此方法
		 * */
		public function parseFromObject(data:Object,excluded:Array=null):void
		{
			ObjectUtil.cloneProperties(data,this,excluded);
		}
	}
}