package com.xingcloud.model
{
	import com.longame.core.IDisposable;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.Reflection;
	
	import flash.net.SharedObject;
	
	import org.osflash.signals.Signal;

	/**
	 *可存储数据库的基础类
	 */
	public class DBObject implements IDisposable
	{
		public function DBObject()
		{
			_className= Reflection.tinyClassName(this);
		}
		/**
		 * 当一个属性被改变时
		 * */
		protected function whenChange(prop:String,delta:*=null):void
		{
			if(_onChange) _onChange.dispatch(prop,delta);
		}
		/**
		 *从一个Object中解析出此实例。根据实例的已存在属性来解析Object。
		 * @param data 数据源
		 * @param excluded 不用解析的字段集合
		 *
		 */
		public function parseFromObject(data:Object, excluded:Array=null):void
		{
			ObjectUtil.cloneProperties(data,this,excluded);
		}
		/**
		 * 将对象解析成普通的object，具有所有this所具备的属性
		 * */
       final public function parseToObject():Object
	   {
		   var result:Object={};
		   ObjectUtil.cloneProperties(this,result,propertiesNoSave);
		   return result;
	   }
	   /**
		* 不希望被输出存储的属性
		 * todo,自动不存储只有get没有set的属性
		* */
	   protected function get propertiesNoSave():Array
	   {
		   return [];
	   }
	   protected var _id:String;
		/**
		 * 唯一Id
		 */
		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			if(this._id==value) return;
			this._id=value;
//			this.whenChange("id");
		}
		protected var _className:String;
		/**
		 * 此类的名称
		 * */
		public function get className():String
		{
			return _className;
		}
		protected var _onChange:Signal;
		/**
		 * 某个属性发生了变化
		 * */
		public function get onChange():Signal
		{
			if(_onChange==null) _onChange=new Signal(String,Object);
			return _onChange;
		}
		protected var _onLoaded:Signal;
		public function get onLoaded():Signal
		{
			if(_onLoaded==null) _onLoaded=new Signal();
			return _onLoaded;
		}
		protected var _onLoadedError:Signal;
		public function get onLoadedError():Signal
		{
			if(_onLoadedError==null) _onLoadedError=new Signal(String);
			return _onLoadedError;
		}
		protected var _destroyed:Boolean;
		public function get disposed():Boolean
		{
			return _destroyed;
		}
		final public function dispose():void
		{
			if(this._destroyed) return;
			this._destroyed=true;
			this.doDestroy();
		}
		protected function doDestroy():void
		{
			if(_onChange){
				_onChange.removeAll();
				_onChange=null;
			}
			if(_onLoaded){
				_onLoaded.removeAll();
				_onLoaded=null;
			}
			if(_onLoadedError){
				_onLoadedError.removeAll();
				_onLoadedError=null;
			}
		}
	}
}