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
		/**
		 * Creates a parameter on the machine. This is usually called when the cogs are created in the Machine's
		 * constructor. Use <code>createParam()</code> to expose certain values to be writable by the level XML.
		 * 
		 * @param	id The name of the parameter you are creating on the Machine.
		 * @param	target The object that the parameter actually exists on.
		 * @param	paramName If different from the <code>id</code>, the name of the parameter on the target. Not needed otherwise.
		 * 
		 * @example The following example creates a parameter on the Hero Machine so that his jump height can be set via the XML and
		 * accessed via <code>geteParam()</code>. You must call createParam() if you wish for an object's property to be settable from
		 * the XML. Please see the class definitions for various machines to see more examples of this.
		 * 
		 * <listing version="3.0">
		 * //inside the Hero's constructor...
		 * 
		 * //this exposes a parameter called jumpHeight that exists on the jumpCog
		 * createParam("jumpHeight", jumpCog);
		 * 
		 * //this exposes a parameter called "speed" that exists on a walkCog, but renames it "walkSpeed" to be more descriptive for the Hero
		 * createParam("walkSpeed", walkCog, "speed");
		 * 
		 * //this exposes the "x" parameter of the hero, which is defined on the hero class itself
		 * createParam("x", this);
		 * </listing>
		 */
		function createParam(id:String, target:Object, paramName:String = ""):void
		
		/**
		 * Destroys the specified parameter on the machine. This is useful when you have extended a machine and want to retire a parameter,
		 * either because you removed its functionality or it is irrelevant.
		 * @param	id The name of the parameter you would like to destroy.
		 */
		function destroyParam(id:String):void;
		
		/**
		 * Gets the value of a param that was created using <code>createParam()</code> and returns it in <code>Object</code> form.
		 * 
		 * @example
		 * 
		 * <listing version="3.0">
		 * private function onHeroTakeDamage(event:CollisionEvent):void
		 * {
		 * 		var health:Object = hero.getParam("health");
		 * 		trace(health);
		 * }
		 * </listing>
		 * 
		 * @param	name The name of the parameter.
		 * @return The value of the parameter as an Object.
		 */
		function getParam(name:String):Object;
		
		/**
		 * Gets a parameter and returns it as an <code>int</code>
		 * 
		 * @param	name  The name of the parameter.
		 * @return The value of the parameter as an int.
		 * @see getParam
		 */
		function getInt(name:String):int;
		
		/**
		 * Gets a parameter and returns it as a <code>Number</code>
		 * 
		 * @param	name  The name of the parameter.
		 * @return The value of the parameter as a Number.
		 * @see getParam
		 */
		function getNumber(name:String):Number;
		
		/**
		 * Gets a parameter and returns it as a <code>String</code>
		 * 
		 * @param	name  The name of the parameter.
		 * @return The value of the parameter as a String.
		 * @see getParam
		 */
		function getString(name:String):String;
		
		/**
		 * Sets a new value for a parameter that has been created using <code>createParam()</code>.
		 * 
		 * @param	name The name of the parameter which you wish to set.
		 * @param	value The value that you wish to set for the parameter.
		 */
		function setParam(name:String, value:Object):void;
	}
}