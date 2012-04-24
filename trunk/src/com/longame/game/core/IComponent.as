package com.longame.game.core
{
	import com.longame.core.IConditional;
	
	import org.osflash.signals.Signal;

	public interface IComponent extends IModule
	{
		function get id():String;
		/**
		 * 当此组件被激活时调用，子类继承建议用doWhenActive
		 * @param owner 父亲
		 * @param param 可能附加的参数
		 * */
		function active(owner:IEntity,param:*=null):void;
		/**
		 * 当此组件被禁止时调用，子类继承建议用doWhenDeactive
		 * */
		function deactive():void;
		/**
		 * 当此owner中有新的组件激活或旧的组件禁止时调用
		 * */
		function refresh():void;
		/**
		 * 此组件所属的容器IEntity，当组件destroy的时候，owner变为null
		 * */
		function get owner():IEntity;
		/**
		 * Returns true if this component is in active in a IEntity.
		 */
		function get actived():Boolean;
		/**
		 * 加入父亲的时候指定的所有状态，见IEntity.add();
		 * */
		function get statesInParent():Array;
		/**
		 * Add an <code>IConditional</code> object that will be checked against when <code>validateConditionals()</code>
		 * is called.
		 * @param conditional The conditional object that will be checked against.
		 * @param value	This is the value that the conditional must be in order for it to pass.
		 * 
		 */		
//		function addConditional(conditional:IConditional, value:Boolean):void;
		
		/**
		 * Remove a conditional from the conditional list to check against when <code>validateConditionals()</code> is called. 
		 * @param conditional The conditional to remove.
		 * 
		 */		
//		function removeConditional(conditional:IConditional):void;
		
		/**
		 * Loops through all the conditionals and validates each one. The ones that did not pass are returned in an array. 
		 * @return An array of conditionals that did not pass. To check if all conditions passed, check for <code>validateConditionals().length == 0</code>.
		 */		
//		function get validateConditionals():Vector.<IConditional>;
		/**
		 * 被销毁时
		 * onCall(IComponent);
		 * */
		function get onDestroy():Signal;
		/**
		 * 被激活时
		 * onCall(IComponent);
		 * */
		function get onActive():Signal;
		/**
		 * 被搞死时
		 * onCall(IComponent);
		 * */
		function get onDeactive():Signal;
		
		function get className():String;
		/**
		 * 清除所有信号，经常在destroy中要调用
		 * */
//		function removeSignals():void;
	}
}