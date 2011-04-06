package com.longame.modules.core
{
	import com.longame.core.IConditional;
	
	import org.osflash.signals.Signal;

	public interface IComponent extends IModule
	{
		function get id():String;
		/**
		 * 当此组件被激活时调用，子类继承建议用doWhenActive
		 * */
		function active(owner:IEntity=null):void;
		/**
		 * 当此组件被禁止时调用，子类继承建议用doWhenDeactive
		 * */
		function deactive():void;
		/**
		 * 当此owner中有新的组件激活或旧的组件禁止时调用
		 * */
		function refresh():void;
		/**
		 * 此组件所属的容器IEntity
		 * */
		function get owner():IEntity;
		/**
		 * Returns true if this component is in active in a IEntity.
		 */
		function get actived():Boolean;
		/**
		 * Add an <code>IConditional</code> object that will be checked against when <code>validateConditionals()</code>
		 * is called.
		 * @param conditional The conditional object that will be checked against.
		 * @param value	This is the value that the conditional must be in order for it to pass.
		 * 
		 */		
		function addConditional(conditional:IConditional, value:Boolean):void;
		
		/**
		 * Remove a conditional from the conditional list to check against when <code>validateConditionals()</code> is called. 
		 * @param conditional The conditional to remove.
		 * 
		 */		
		function removeConditional(conditional:IConditional):void;
		
		/**
		 * Loops through all the conditionals and validates each one. The ones that did not pass are returned in an array. 
		 * @return An array of conditionals that did not pass. To check if all conditions passed, check for <code>validateConditionals().length == 0</code>.
		 */		
		function get validateConditionals():Vector.<IConditional>;
		
		function get onDestroy():Signal;
		function get onActive():Signal;
		function get onDeactive():Signal;
		
		function toString():String;
		/**
		 * 清除所有信号，经常在destroy中要调用
		 * */
		function removeSignals():void;
	}
}