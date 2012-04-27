package com.xingcloud.model
{
	import com.longame.utils.ObjectUtil;
	import com.xingcloud.util.Reflection;
	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	import org.osflash.signals.Signal;

	/**
	 *基础数据模型类
	 *
	 */
	public class ModelBase extends EventDispatcher
	{
		private var _onChange:Signal;
		/**
		 *数据模型
		 *
		 */
		public function ModelBase()
		{
			super();
		}
		/**
		 * 某个属性发生了变化
		 * */
		public function get onChange():Signal
		{
			if(_onChange==null) _onChange=new Signal(String,Object);
			return _onChange;
		}
		/**
		 * 当一个属性被改变时
		 * */
		protected function whenChange(prop:String,delta:*=null):void
		{
			if(_onChange) _onChange.dispatch(prop,delta);
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
		 * 将对象解析成普通的object，具有所有this所具备的属性
		 * */
       final public function parseToObject():Object
	   {
		   var result:Object={};
		   ObjectUtil.cloneProperties(this,result,propertiesExcluded);
		   return result;
	   }
	   /**
		* 不希望被输出存储的属性
		 * todo,自动不存储只有get没有set的属性
		* */
	   protected function get propertiesExcluded():Array
	   {
		   return [];
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
			if(this._uid==uid) return;
			this._uid=uid;
//			this.whenChange("uid");
		}
	}
}