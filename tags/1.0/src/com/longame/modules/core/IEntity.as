package  com.longame.modules.core
{
	import com.longame.core.IDestroyable;
	import com.longame.core.IState;
	
	import org.osflash.signals.Signal;
	
	public interface IEntity extends  IComponent, IState
	{
		/**
		 * Gets all of the components
		 * @param activedOnly:只返回actived=true的子元素
		 */
		function getChildren(activedOnly:Boolean=true):Vector.<IComponent>;
		
		/**
		 * Dispatched when a machine changes the "state" property. 
		 */		
		function get onStateChange():Signal;
		
		/**
		 * 新的子组件被添加时
		 * */
		function get onChildAdded():Signal;
		/**
		 * 子组件被删除时
		 * */
		function get onChildRemoved():Signal;	
		/**
		 * 子组件被被激活时
		 * */
		function get onChildActived():Signal;
		/**
		 * 子组件被被禁止时
		 * */
		function get onChildDeactived():Signal;	
		
		/**
		 * Adds a cog to the list of cog on the Machine.
		 * 
		 * <p>If a string is specified in the second parameter, then that cog will only be active during the
		 * specified state. If nothing is specified, then the cog will be active during every state.</p>
		 * 
		 * @param	cog The cog to add to the Machine.
		 * @param	state A specific state that the cog should be active in. The cog will not be active in any other state.
		 */
		function add(child:IComponent, ...states):void;
		
		/**
		 * Removes a cog from the list of components on the Entity.
		 * @param	cog The component to remove from the Entity.
		 */
		function remove(child:IComponent):void;
		
		/**
         *找出类型为type的组件
		 * @param type: 类型
		 * @activedOnly:true则只返回激活的组件
		 */		
		function getChildByType(type:Class,activedOnly:Boolean=true):IComponent;
		
		/**
		 *从所有组件中，找出名为id的组件
		 * @param id: id
		 * @activedOnly:true则只返回激活的组件
		 */			
		function getChild(id:String,activedOnly:Boolean=true):IComponent;
		/**
		 * @inheritDoc
		 * 激活和未激活的组件中是否child
		 * @param child:目标child
		 * @param checkId:是否检查和child同id的对象
		 */	
		function contains(child:IComponent,checkId:Boolean=false):Boolean;
	}
}