package com.longame.game.component
{
	import com.longame.core.IConditional;
	import com.longame.core.long_internal;
	import com.longame.game.core.IComponent;
	import com.longame.game.core.IEntity;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

    use namespace long_internal;
	
	public class AbstractComp implements IComponent
	{
		private static var _nextId:int=0;
		/**
		 * 索引此组件所属Entity内的某个组件，开发者标记完后，框架自动分配值
		 * 如果同一类的组件在其Entity里只有一个，那么不用写id属性，否则用id特指某一个,此变量仅做示例用
		 * 有可能是处于未激活状态的组件，注意自己判断
		 * */
		[Partner(id="this is a test component")]
		public var linkedComp:AbstractComp;
		
		public function AbstractComp(id:String=null)
		{
			if (id == null || id == "")
			{
				id=String("comp_"+_nextId++)
				useCustomId=false;
			}
			_id=id;
			_className=Reflection.tinyClassName(this);
			//将所有标记Linked元标签的变量找出来，试验了下，基本在1毫秒的样子，不算浪费，用之
			_metasWithLink=Reflection.getMetaInfos(this,"Partner");
		}
		/**
		 * 被激活时传来的参数，通常只有Entity.setState(state,param)时才会得到
		 * */
		protected var _activeParam:*;
		final public function active(owner:IEntity,param:*=null):void
		{
//			if (_actived) return;
			if (_actived&&(_activeParam==param)) return;
			var firstActive:Boolean=(_actived==false);
			_actived=true;
			_owner=owner;
			_activeParam=param;
			whenSetParam(param);
			if(firstActive){
				addSignals();
				whenActive();	
				if(_onActive) {
					_onActive.dispatch(this);
				}
			}
		}
		final public function deactive():void
		{
			if (!_actived) return;
			removeSignals();
			whenDeactive();
			_actived=false;
			_activeParam=null;
			if(_onDeactive) _onDeactive.dispatch(this);
		}
		/**
		 * 当自己被注册时会relink
		 * 注册后有别的组件添加或删除会relink
		 * */
		final public function refresh():void
		{
			this.refreshLinks();
			whenRefresh();
		}
		final public function destroy():void
		{
			if(destroyed) return;
			 if(_owner) {
				 _owner.remove(this);
			 }
			 whenDestroy();
			if(_onDestroy) {
				_onDestroy.dispatch(this);
			}
			destroyLinks();
			_id = null;
			_owner = null;	
			_metasWithLink=null;
			_onDestroy=null;
			_onActive=null;
			_onDeactive=null;
		}
		protected function addSignals():void
		{
			//tobe,override
		}
		protected function removeSignals():void
		{
			//tobe,override
		}
		/**
		 * Returns a string of the class name. 
		 */		
		public function get className():String
		{
			return _className;
		}
		
		/***getters***/
		public function get owner():IEntity
		{
			return this._owner;
		}
		
		public function get id():String
		{
			return _id;
		}
		public function get actived():Boolean
		{
			return _actived;
		}	
		public function get statesInParent():Array
		{
			return _statesInParent;
		}
		public function get destroyed():Boolean
		{
			return _id==null;
		}		
		/**signals**/
		public function get onDestroy():Signal
		{
			if((_onDestroy==null)&&!destroyed) _onDestroy=new Signal(IComponent);
			return this._onDestroy;
		}
		public function get onActive():Signal
		{
			if((_onActive==null)&&!destroyed) _onActive=new Signal(IComponent);
			return this._onActive;
		}
		public function get onDeactive():Signal
		{
			if((_onDeactive==null)&&!destroyed) _onDeactive=new Signal(IComponent);
			return this._onDeactive;
		}
		
		long_internal function setStatesInParent(states:Array):void
		{
			this._statesInParent=states;
		}
		/**private functions**/
		
		/**
		 *从owner中更新所有具有Link标签的变量值，在relink中调用，也就是组件被注册或者之后有其他组件增减时
		 * */
		private function refreshLinks():void
		{
			if(!actived) return;
			for each(var meta:* in _metasWithLink){
				//如果有id，通过id找那个component，否则通过类型查找
				if(meta.hasOwnProperty("id")) this[meta.varName]=_owner.getChild(meta.id as String,false);
				else         this[meta.varName]=_owner.getChildByType(getDefinitionByName(meta.varClass) as Class,false);
			}
		}
		private function destroyLinks():void
		{
			for each(var meta:* in _metasWithLink){
				this[meta.varName]=null;
			}
		}
		/**
		 * 当激活时调用，子类覆盖
		 * */
		protected function whenActive():void
		{
		}
		/**
		 * 当初次激活或者激活后改变参数时调用，子类覆盖,总之，其owner改变状态时，都会调用这个
		 * */
		protected function whenSetParam(param:*):void
		{
			
		}
		/**
		 * 当注销时调用，子类覆盖
		 * */
		protected function whenDeactive():void
		{
		}
		/**
		 * 当销毁时，子类覆盖
		 * */
		protected function whenDestroy():void
		{
		}
		/**
		 * 当entity的组件有删减时调用，子类覆盖
		 * */
		protected function whenRefresh():void
		{
			
		}

		/***private var**/
		protected var _owner:IEntity;
		protected var _id:String="";
		protected var _className:String;
		protected var _actived:Boolean;
		protected var _statesInParent:Array=[""];
		protected var _onDestroy:Signal;
		protected var _onActive:Signal;
		protected var _onDeactive:Signal;
		/**具有Link元标签的变量名**/
		/**所有具有Link元标签的变量信息[{varName:变量名,varClass:变量类名,id:可能指定的id},...]**/
		protected var _metasWithLink:Array=[];
		long_internal var useCustomId:Boolean=true;
	}
}