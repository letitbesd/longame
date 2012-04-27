package com.longame.modules.groups
{
	import com.longame.core.long_internal;
	import com.longame.managers.ProcessManager;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.entities.AbstractEntity;
	import com.longame.modules.scenes.IScene;
	import com.longame.utils.Reflection;
	
	use namespace long_internal;
	
	public class AbstractGroup extends AbstractEntity implements IGroup
	{
		public function AbstractGroup(id:String)
		{
			super(id);
		}
		public function onFrame(deltaTime:Number):void
		{
			
		}
		override protected function checkChildValidation(child:IComponent):Boolean
		{
			//AbstractGroup不能添加IComponent,IScene和ILayer，可以添加IEntity和IGroup
//			return ((child is IEntity)&& !(child is IScene));
			//to think
			return !(child is IScene);
		}
	}
}