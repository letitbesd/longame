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
			foreachChildren(destroyChild);
			_activedChildren = null;
			allChildren= null;
			_params = null;
			super.destroy();
		}		
		override public function removeSignals():void
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
			var all:Vector.<IComponent>=new Vector.<IComponent>();
			for each (var a:Vector.<IComponent> in allChildren)
			{
				for each(var child:IComponent in a){
					all.push(child);
				}
			}
			return all;
		}
		public function get numChildren():uint
		{
			return _activedChildren.length;
		}
		public function get state():String
		{
			return this._state;
		}
		
		public function set state(value:String):void
		{
			if (value == _state) return;
			//删除非当前状态的组件
			if (_state != "")
			{
				for each (var child:IComponent in allChildren[_state])
				{
					deactiveChild(child,false);
				}
			}
			//set state
			_state = value;
			//注册新状态下的组件
			if (_state != "")
			{
				if (allChildren[_state])
				{
					for each (child in allChildren[_state])
						activeChild(child,false);
				}	
			}
			refreshChildren();
			if(_onStateChange) _onStateChange.dispatch();			
		}
		
		public function add(child:IComponent, state:String=""):void
		{
			if(!checkChildValidation(child)){
				throw new Error("You cannot add a child : "+child.toString()+" to "+this.toString());
			}
			if (contains(child,true)) return;
//				throw new Error("You cannot add a child to more than one entity, or to the same entity twice.");
			//先从旧owner中删除，再添加到新的owner
			if(child.owner!=null) child.owner.remove(child);
			if (!allChildren[state])
				allChildren[state] = new Vector.<IComponent>();
			
			allChildren[state].push(child);
			if (state == "" || _state == state)
				activeChild(child);	
			if(_onChildAdded) this._onChildAdded.dispatch(child);
		}
		
		public function remove(child:IComponent):void
		{
			for each (var a:Vector.<IComponent> in allChildren)
			{
				var index:int = a.indexOf(child);
				if (index != -1)
				{
					a.splice(index, 1);
					deactiveChild(child);	
					if(_onChildRemoved) this._onChildRemoved.dispatch(child);
					return;
				}
			}
		}
		
		public function getChildByType(type:Class,activedOnly:Boolean=true):IComponent
		{
			if(activedOnly){
				if(!_actived) return null;
				for each (var child:IComponent in _activedChildren)
				{
					if (child is type)
						return child;
				}
				return null;
			}
			for each (var a:Vector.<IComponent> in allChildren)
			{
				for each(child in a){
					if(child is type) return child;
				}
			}
			return null;
		}
		
		public function getChild(id:String,activedOnly:Boolean=true):IComponent
		{
			if(activedOnly){
				if(!_actived) return null;
				for each (var child:IComponent in _activedChildren)
				{
					if (child.id==id)
						return child;
				}
				return null;
			}
			for each (var a:Vector.<IComponent> in allChildren)
			{
				for each(child in a){
					if(child.id==id) return child;
				}
			}
			return null;
		}

		public function contains(child:IComponent,checkId:Boolean=false):Boolean
		{
			for each (var a:Vector.<IComponent> in allChildren)
			{
				for each(var ch:IComponent in a){
					if(ch==child) return true;
					if(checkId&&(ch.id==child.id)) return true;
				}
			}
			return false;
		}	
		public function setChildrenActive(active:Boolean):void
		{
			for each(var child:IComponent in _activedChildren){
				active?child.active(this):child.deactive();
			}	
			//有需要否
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
			for each (var a:Vector.<IComponent> in allChildren)
			{
				for each(var child:IComponent in a){
					func(child);
				}
			}			
		}
		public function createParam(id:String, target:Object, paramName:String=""):void
		{
			if (paramName == "")
				paramName = id;
			_params[id] = new Parameter(target, paramName);
		}
		
		public function destroyParam(id:String):void
		{
			delete _params[id];	
		}
		
		public function getParam(name:String):Object
		{
			return _params[name].value;
		}
		
		public function getInt(name:String):int
		{
			return _params[name].value as int;
		}
		
		public function getNumber(name:String):Number
		{
			return _params[name].value as Number;
		}
		
		public function getString(name:String):String
		{
			return _params[name].value as String;
		}
		
		public function setParam(name:String, value:Object):void
		{
			if (_params[name])
				_params[name].value = value;
			else
				throw new Error("There is no parameter on " + this.id + " with the name " + name + ".");			
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
		
		protected function activeChild(child:IComponent,refresh:Boolean=true):void
		{
			_activedChildren.push(child);
			if(_actived) {
				child.active(this);
				if(refresh) refreshChildren();
			}
			if(this._onChildActived){
				this._onChildActived.dispatch(child);
			} 
		}
		
		protected function deactiveChild(child:IComponent,refresh:Boolean=true):void
		{
			_activedChildren.splice(_activedChildren.indexOf(child), 1);
			child.deactive();
			if(refresh) refreshChildren();
			if(this._onChildDeactived) this._onChildDeactived.dispatch(child);
		}
		protected function destroyChild(child:IComponent):void
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
		long_internal var allChildren:Dictionary = new Dictionary(true);
		protected var _params:Dictionary = new Dictionary(true);
		protected var _state:String = "";
		/**当IEntity被deactive时，其state被设为deactive，当重新被active时，要将状态恢复到deactive之前*/
		private var prevState:String;
	}
}