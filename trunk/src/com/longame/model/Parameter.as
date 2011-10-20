package com.longame.model
{
	public class Parameter
	{
		public var target:Object;
		public var name:String;
		
		public function Parameter(target:Object, name:String)
		{
			this.target = target;
			this.name = name;
		}
		
		public function get value():Object
		{
			return target[name];
		}
		
		public function set value(v:Object):void
		{
			target[name] = v;
		}
	}
}