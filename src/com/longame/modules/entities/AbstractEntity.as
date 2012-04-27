package com.longame.modules.entities
{
	import com.longame.core.long_internal;
	import com.longame.model.Parameter;
	import com.longame.modules.components.AbstractComp;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.IGroup;
	import com.longame.utils.Reflection;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.osflash.signals.Signal;

	use namespace long_internal;
	
	public class AbstractEntity extends AbstractComp implements IEntity
	{
		/**
		 * 索引某个Entity，开发者标记完后，框架自动分配值
		 * 如果此类Entity只有1个，那么不用写id属性，否则用id特指某一个,此变量仅做示例用
		 * */
		[Link(id="this is a test entity")]
		public var linkedEntity:AbstractEntity;		
		
		public function AbstractEntity(id:String=null)
		{
            super(id);
		}
		
		override public function destroy():void
		{
			if (destroyed) return;
			//销毁所有add进来的元素
			foreachChildren(long_internal::destroyChild);
			//同时也销毁被删除，但是目前没有被添加到其他容器中的元素
			for each(var child:IComponent in this.removedChildren){
				if(child.owner==this) child.destroy();
			}
			_activedChildren = null;
			allChildren= null;
			allStateChildren=null;
			removedChildren=null;
			super.destroy();
		}		
		override protected function removeSignals():void
		{
			super.removeSignals();
			if(_onStateChange) _onStateChange.removeAll();
			if(_onChildAdded)  _onChildAdded.removeAll();
			if(_onChildRemoved) _onChildRemoved.removeAll();
			if(_onChildActived) _onChildActived.removeAll();
			if(_onChildDeactived) _onChildDeactived.removeAll();
		}
		public function getChildren(activedOnly:Boolean=true):Vector.<IComponent>
		{
			if(activedOnly) return _activedChildren;
			return allChildren;
		}
		public function get numChildren():uint
		{
			return _activedChildren.length;
		}
		public function get state():String
		{
			return this._state;
		}
		
		final public function set state(value:String):void
		{
			if (value == _state) return;
			//删除非当前状态的组件
			if (_state != "")
			{
				for each (var child:IComponent in allStateChildren[_state])
				{
					if(allStateChildren[value]&&(allStateChildren[value].indexOf(child)!=-1)) continue;
					deactiveChild(child,false);
				}
			}
			var oldState:String=_state;
			//set state
			_state = value;
			//注册新状态下的组件
			if (_state != "")
			{
				if (allStateChildren[_state])
				{
					for each (child in allStateChildren[_state])
						activeChild(child,false);
				}	
			}
			refreshChildren();
			this.doWhenStateChange(oldState,value);
			if(_onStateChange) _onStateChange.dispatch();			
		}
		/**
		 * 当状态改变做的事，子类覆盖
		 * */
		protected function doWhenStateChange(oldState:String,newState:String):void
		{
			//to be overrided
		}
		final public function add(child:IComponent,...states):void
		{
			if(!checkChildValidation(child)){
				throw new Error("You cannot add a child : "+child.className+" to "+this.className);
			}
			if (contains(child,true)) return;
			//先从旧owner中删除，再添加到新的owner
			if(child.owner!=null) child.owner.remove(child);
			allChildren.push(child);
			if(states==null || states.length==0) states=[""];
			for each(var state:String in states){
				if (!allStateChildren[state])
					allStateChildren[state] = new Vector.<IComponent>();
				allStateChildren[state].push(child);
			}
			(child as AbstractComp).long_internal::setStatesInParent(states);
			if((states.indexOf("")!=-1)||(states.indexOf(_state)!=-1))
				activeChild(child);
			//如果是先去删除的元素，将其从removedChildren中去掉
			var i:int=removedChildren.indexOf(child);
			if(i>-1){
				removedChildren.splice(i,1);
			}
			if(_onChildAdded) this._onChildAdded.dispatch(child);
		}
		final public function remove(child:IComponent):void
		{
			var index:int;
			for each (var a:Vector.<IComponent> in allStateChildren)
			{
				index = a.indexOf(child);
				if (index != -1)
				{
					a.splice(index, 1);
				}
			}
			index=allChildren.indexOf(child);
			if(index!=-1){
				allChildren.splice(index, 1);
				removedChildren.push(child);
				deactiveChild(child);	
				if(_onChildRemoved) this._onChildRemoved.dispatch(child);
			}
		}
		
		public function getChildByType(type:Class,activedOnly:Boolean=true):IComponent
		{
			var group:Vector.<IComponent>=activedOnly?_activedChildren:allChildren;
			for each(var child:IComponent in group){
				if(child is type) return child;
			}
			return null;
		}
		
		public function getChild(id:String,activedOnly:Boolean=true):IComponent
		{
			var group:Vector.<IComponent>=activedOnly?_activedChildren:allChildren;
			for each(var child:IComponent in group){
				if(child.id==id) return child;
			}
			return null;
		}

		public function contains(child:IComponent,checkId:Boolean=false):Boolean
		{
			for each(var ch:IComponent in allChildren){
				if(ch==child) return true;
				if(checkId&&(ch.id==child.id)) return true;
			}
			return false;
		}	
		public function setChildrenActive(active:Boolean):void
		{
			for each(var child:IComponent in _activedChildren){
				active?child.active(this):child.deactive();
			}	
			refreshChildren();
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			setChildrenActive(true);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			setChildrenActive(false);
		}
		/**
		 * 遍历所有的child,call(child);
		 * */
		public function foreachChildren(func:Function):void
		{
			for each(var child:IComponent in allChildren){
				func(child);
			}
		}
		/**signals*/
		protected var _onStateChange:Signal;
		public function get onStateChange():Signal
		{
			if(_onStateChange==null) _onStateChange=new Signal();
			return this._onStateChange;
		}
		protected var _onChildAdded:Signal;
		public function get onChildAdded():Signal
		{
			if(_onChildAdded==null) _onChildAdded=new Signal(IComponent);
			return this._onChildAdded;
		}
		protected var _onChildRemoved:Signal;
		public function get onChildRemoved():Signal
		{
			if(_onChildRemoved==null) _onChildRemoved=new Signal(IComponent);
			return this._onChildRemoved;
		}	
		protected var _onChildActived:Signal;
		public function get onChildActived():Signal
		{
			if(_onChildActived==null) _onChildActived=new Signal(IComponent);
			return this._onChildActived;
		}
		protected var _onChildDeactived:Signal;
		public function get onChildDeactived():Signal
		{
			if(_onChildDeactived==null) _onChildDeactived=new Signal(IComponent);
			return this._onChildDeactived;
		}
		/***private functions***/
		/**
		 * 检查child是否是可以被添加的类型
		 * */
		protected function checkChildValidation(child:IComponent):Boolean
		{
			//AbstractEntity不能添加IEntity
			if(child is IEntity) return false
			return true;
		}
		
		long_internal function activeChild(child:IComponent,refresh:Boolean=true):void
		{
			if(child.actived) return;
			_activedChildren.push(child);
			if(_actived) {
				child.active(this);
				if(refresh) refreshChildren();
			}
			if(this._onChildActived){
				this._onChildActived.dispatch(child);
			} 
		}
		
		long_internal function deactiveChild(child:IComponent,refresh:Boolean=true):void
		{
			if(!child.actived) return;
			_activedChildren.splice(_activedChildren.indexOf(child), 1);
			if(refresh) refreshChildren();
			child.deactive();
			if(this._onChildDeactived) this._onChildDeactived.dispatch(child);
		}
		long_internal  function destroyChild(child:IComponent):void
		{
			child.destroy();
		}
		/**
		 * 当某个组件被添加时，所有组件包括刚添加的组件会被通知relink，当某个组件被删除时，其余组件会被通知relink
		 * */
		protected function refreshChildren():void
		{
			for each (var child:IComponent in _activedChildren)
			{
				child.refresh();
			}
		}		
		
		/**private vars*/
		/**当前已经激活的的组件*/
		protected var _activedChildren:Vector.<IComponent> =new Vector.<IComponent>();
		/**所有添加进来的组件，包括激活和未激活的*/
		long_internal var allChildren:Vector.<IComponent>=new Vector.<IComponent>();
		/**按照state分组存放的所有child*/
		private var allStateChildren:Dictionary=new Dictionary(true);
		/**已经删除的子元素，存放起来*/
        private var removedChildren:Vector.<IComponent>=new Vector.<IComponent>();
		protected var _state:String = "";
		/**当IEntity被deactive时，其state被设为deactive，当重新被active时，要将状态恢复到deactive之前*/
		private var prevState:String;
	}
}