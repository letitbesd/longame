package com.longame.modules.groups
{
	import com.longame.core.long_internal;
	import com.longame.managers.ProcessManager;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.core.IGroup;
	import com.longame.modules.entities.AbstractEntity;
	import com.longame.modules.groups.organizers.IGroupOrganizer;
	import com.longame.modules.scenes.IScene;
	import com.longame.utils.Reflection;
	
	use namespace long_internal;
	
	public class AbstractGroup extends AbstractEntity implements IGroup
	{
		public function AbstractGroup(id:String)
		{
			super(id);
		}
		
		public function addOrganizer(mgr:IGroupOrganizer):void
		{
			var i:int=_organizers.indexOf(mgr);	
			if(i>=0) return;
			_organizers.push(mgr);			
		}
		
		public function removeOrganizer(mgr:IGroupOrganizer):void
		{
			var i:int=_organizers.indexOf(mgr);	
			if(i<0) return;
			_organizers.splice(i,1);
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			ProcessManager.addAnimatedObject(this);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			ProcessManager.removeAnimatedObject(this);
		}
		public function onFrame(deltaTime:Number):void
		{
			this.updateOrganizers();
			for each(var organizer:IGroupOrganizer in _organizers){
				if(organizer.actived) organizer.update();
			}
		}
		public function updateOrganizers():void
		{
			//to be overrided
		}
		override public function destroy():void
		{
			if(destroyed) return;
			for each(var organizer:IGroupOrganizer in _organizers){
				organizer.destroy();
			}
			_organizers=null;
			super.destroy();
		}
//		public function setOrganizersActive(active:Boolean):void
//		{
//			for each(var organizer:IGroupOrganizer in _organizers){
//				active?organizer.active(this):organizer.deactive();
//			}			
//		}
		public function get organizers():Vector.<IGroupOrganizer>
		{
			return _organizers;
		}
		override protected function checkChildValidation(child:IComponent):Boolean
		{
			//AbstractGroup不能添加IComponent,IScene和ILayer，可以添加IEntity和IGroup
			return ((child is IEntity)&& !(child is IScene));
		}
		/**private vars*/
		protected var _organizers:Vector.<IGroupOrganizer>=new Vector.<IGroupOrganizer>();
	}
}