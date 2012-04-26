package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.game.component.AbstractComp;
	import com.longame.game.core.IComponent;
	import com.longame.game.core.IEntity;
	import com.longame.game.core.IGroup;
	import com.longame.model.Parameter;
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
		[Partner(id="this is a test entity")]
		public var linkedEntity:AbstractEntity;		
		
		public function AbstractEntity(id:String=null)
		{
            super(id);
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
		public function getState():String
		{
			return this._state;
		}
		public function getPrevState():String
		{
			return this._prevState;
		}
		public function get stateParam():*
		{
			return this._stateParam;
		}
		final public function setState(value:String,param:*=null):void
		{
			if(this.disposed){
				throw new Error("Entity has been destroyed!");
			}
			if((value==_state)&&(_stateParam==param)) return;
//			if (value == _state) return;
			var isNewState:Boolean=(value!=_state);
			_stateParam=param;
			if(isNewState){
				_prevState=_state;
				_state=value;
				//删除非当前状态的组件
				if (_prevState != "")
				{
					for each (var child:IComponent in allStateChildren[_prevState])
					{
						if(allStateChildren[_state]&&(allStateChildren[_state].indexOf(child)!=-1)) continue;
						deactiveChild(child,false);
					}
				}
			}
			//注册新状态下的组件,如果isNewState==false,那么让子元素更新param
			if (_state != "")
			{
				if (allStateChildren[_state])
				{
					for each (child in allStateChildren[_state])
						activeChild(child,false);
				}	
			}
			if(isNewState){
				refreshChildren();
				this.whenStateChange();
				if(_onStateChange) _onStateChange.dispatch();
			}
		}
		/**
		 * 当状态改变做的事，子类覆盖
		 * */
		protected function whenStateChange():void
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
		private function setChildrenActive(active:Boolean):void
		{
			for each(var child:IComponent in _activedChildren){
				active?child.active(this,_stateParam):child.deactive();
			}	
			refreshChildren();
		}
		override protected function whenActive():void
		{
			super.whenActive();
			setChildrenActive(true);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			setChildrenActive(false);
			this._stateParam=null;
		}
		override protected function whenDispose():void
		{
			var child:IComponent;
			//销毁被删除，但是目前没有被添加到其他容器中的元素
			while(removedChildren.length){
				child=removedChildren[0];
				if(child.owner==this) child.dispose();
				removedChildren.splice(0,1);
			}
			//销毁所有add进来的元素
			while(allChildren.length){
				child=allChildren[0];
				child.dispose();
				allChildren.splice(0,1);
			}
			_activedChildren = null;
			allChildren= null;
			allStateChildren=null;
			removedChildren=null;
			_onStateChange=null;
			_onChildAdded=null;
			_onChildRemoved=null;
			_onChildActived=null;
			_onChildDeactived=null;
			super.whenDispose();
		}
		/**signals*/
		protected var _onStateChange:Signal;
		public function get onStateChange():Signal
		{
			if((_onStateChange==null)&&!disposed) _onStateChange=new Signal();
			return this._onStateChange;
		}
		protected var _onChildAdded:Signal;
		public function get onChildAdded():Signal
		{
			if((_onChildAdded==null)&&!disposed) _onChildAdded=new Signal(IComponent);
			return this._onChildAdded;
		}
		protected var _onChildRemoved:Signal;
		public function get onChildRemoved():Signal
		{
			if((_onChildRemoved==null)&&!disposed) _onChildRemoved=new Signal(IComponent);
			return this._onChildRemoved;
		}	
		protected var _onChildActived:Signal;
		public function get onChildActived():Signal
		{
			if((_onChildActived==null)&&!disposed) _onChildActived=new Signal(IComponent);
			return this._onChildActived;
		}
		protected var _onChildDeactived:Signal;
		public function get onChildDeactived():Signal
		{
			if((_onChildDeactived==null)&&!disposed) _onChildDeactived=new Signal(IComponent);
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
//			if(child.actived) return;
			if(_activedChildren.indexOf(child)==-1)  _activedChildren.push(child);
			if(_actived) {
				child.active(this,_stateParam);
				if(refresh) refreshChildren();
				if(this._onChildActived){
					this._onChildActived.dispatch(child);
				} 
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
		protected var _prevState:String;
		protected var _state:String = "";
		/**当前状态下的特定参数，通过setState(state,param)的第二个参数设定，
		 * child.active(this,param)时传给child，child.doWhenActive(param)来获取*/
		protected var _stateParam:*;
	}
}