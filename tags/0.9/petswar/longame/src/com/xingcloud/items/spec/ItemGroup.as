package com.xingcloud.items.spec
{
	import flash.utils.Dictionary;
	
	import com.longame.utils.ArrayUtil;
	import com.longame.utils.debug.Logger;

   /**
   * 定义一个物品组，这个定义无需继承，他是动态类，可以赋值任何自定义itemSpec属性，
   * 当子元素设此属性时忽略，子元素没设此属性时，用此属性赋值之，可以方便的设置整组物品的一些通用属性
   * */
	dynamic final public class ItemGroup extends AbstractItem
	{
		protected var _children:Vector.<AbstractItem>;
		
		public function ItemGroup()
		{
			super();
			_children=new Vector.<AbstractItem>();
		}
		
		public function addItem(itm:AbstractItem):void
		{
			if(this.contains(itm)) {
				Logger.error(this,"addItem","Child with id "+itm.id+"has existed!");
				return;
			}
			_children[this.length]=itm;
			itm.parent=this;
		}
		public function removeItem(itm:AbstractItem):Boolean
		{
			var i:int=_children.indexOf(itm);
			if(i>-1){
				_children.splice(i,1);
				itm.parent=null;
				return true;
			}
			return false;
		}
		
		public function getItem(id:String,deepSearch:Boolean=true):ItemSpec
		{
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var itm:AbstractItem=_children[i];
				if((itm is ItemSpec)&&(id==(itm as ItemSpec).id)) return itm as ItemSpec;
				if(deepSearch&&(itm is ItemGroup)){
					var ri:ItemSpec=(itm as ItemGroup).getItem(id);
					if(ri) return ri;
				}
			}		
			return null;
		}	
		
		/**
		 * @param deapSearch: 如果子元素是group，是否寻找底层的item
		 * **/
		public function getItemByName(name:String,deepSearch:Boolean=true):ItemSpec
		{
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var item:AbstractItem=_children[i];
				if((name==item.name)&&(item is ItemSpec)) return item as ItemSpec;
				if(deepSearch&&(item is ItemGroup)){
					var ri:ItemSpec=(item as ItemGroup).getItemByName(name);
					if(ri) return ri;
				}
			}		
			return null;
		}
		/**
		 * 获取当前group下所有的items
		 *  @param deapSearch: 如果子元素是group，是否寻找底层的item
		 *  @param arr: 赋值给他
		 * **/
		public function getAllItems(deepSearch:Boolean=false,arr:Array=null):Array
		{
			if(arr==null) arr=[];
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var itm:AbstractItem=_children[i];
				if(itm is ItemSpec){
					arr.push(itm);
				}else if(deepSearch){
					(itm as ItemGroup).getAllItems(true,arr);
				}
			}	
			return arr;				
		}
		/**
		 * 获取为group类型的所有子元素，只在当前层
		 * **/
		public function getAllGroups():Array
		{
			var arr:Array=[];
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var itm:AbstractItem=_children[i];
				if(itm is ItemGroup){
					arr.push(itm);
				}
			}	
			return arr;			
		}
		public function getChildGroup(id:String,deepSearch:Boolean=true):ItemGroup
		{
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var itm:AbstractItem=_children[i];
				if(itm is ItemGroup) {
					if((itm as ItemGroup).id==id) return itm as ItemGroup;
					if(deepSearch){
						var g:ItemGroup=(itm as ItemGroup).getChildGroup(id);
						if(g) return g;
					}
				}
			}	
			return null;					
		}		
		public function foreachItem(callBack:Function):void
		{
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var item:AbstractItem=_children[i];
				callBack(item);
			}			
		}
		public function contains(itm:AbstractItem):Boolean
		{
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				var item:AbstractItem=_children[i];
				if(item.id==itm.id){
					return true;
				}
			}		
			return false;
		}
		public function getRandomItems(len:int):Array
		{
			var items:Array=this.getAllItems(true);
			ArrayUtil.shuffle(items);
			return items.slice(0,len);
		}
		public function getRandomItem():ItemSpec
		{
			var items:Array=this.getAllItems(true);
			return ArrayUtil.getRandom(items) as ItemSpec;
		}
		public function get length():int
		{
			return _children.length;
		}
		/**
		 * 所有子元素，包括ItemSpec和所有嵌套的itemGroup
		 * */
		public function get children():Vector.<AbstractItem>
		{
			return _children;
		}
		
		public function get childrenAsArray():Array
		{
			var arr:Array=[];
			var len:uint=_children.length;
			for(var i:int=0;i<len;i++){
				arr[i]=_children[i];
			}
			return arr;
		}
	}
}