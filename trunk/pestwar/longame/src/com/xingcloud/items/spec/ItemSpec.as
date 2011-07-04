package com.xingcloud.items.spec
{
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.Reflection;
	
   /**
   * 单个物品定义的基类
   * */
	public class ItemSpec extends AbstractItem
	{
		public function ItemSpec()
		{
			super();
		}
		protected var _src:String;
		/**
		 * 设定显示对象的数据源，可接受的数据源有：
		 * 1. 素材库里的class名
		 * 2. 外部图像/swf的路径
		 * 3. some.swf#someSymbol，some.swf里的someSymbol元件
		 * 4. 特别的，如果对象具有多个方向，那么会用数个1-4的形式定义一组对象，可以是用","分开的字符串
		 * 如果需要和Group的source作为基路径，请在自定义类中重写
		 * */
		public function get source():String
		{
			return this._src;
		}
		public function set source(c:String):void
		{
			this._src=c;
		}
		protected var _icon:String;
		/**
		 * 小图标表示，如果没有，自动取source
		 * */
		public function get icon():String
		{
			if(this._icon==null) return this.source;
			return _icon;
		}
		public function set icon(c:String):void
		{
			this._icon=c;
		}	
		protected var _cost:Number=0;
		/**
		 * 此item的价格
		 * */
		public function get cost():Number
		{
			return _cost;
		}
		public function set cost(value:Number):void
		{
			_cost=value;	
		}
		protected var _level:Number=0;
		/**
		 * 此item对玩家的级别限制
		 * */
		public function get level():Number
		{
			return _level;
		}
		public function set level(value:Number):void
		{
			_level=value;	
		}
		public function inGroup(_group:String):Boolean
		{
			var par:ItemGroup=this.parent;
			while(par){
				if(par.name==_group) return true;
				par=par.parent;
			}
			return false;
		}
		/**
		 * 将this克隆一下，如果target不为空，则将所有的属性拷贝过去
		 * */
		public function clone(target:ItemSpec=null):ItemSpec
		{
			var cls:Class=Reflection.getClass(this);
			if(target==null) target=new cls() as ItemSpec;
			ObjectUtil.cloneProperties(this,target);
			return target;
		}
	}
}