package com.longame.modules.groups.organizers
{
	import com.longame.modules.groups.IDisplayGroup;
    
	public class AbstractGroupOrganizer implements IGroupOrganizer
	{
		public function AbstractGroupOrganizer()
		{
			
		}
		
		public function get group():IDisplayGroup
		{
			return _group;
		}
		public function active(owner:IDisplayGroup):void
		{
			if(actived) return;
			_group=owner;
		}
		
		public function deactive():void
		{
			if(!actived) return;
			_group=null;
		}
		
		public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			this.deactive();
		}
		
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		public function get actived():Boolean
		{
			return _group!=null;
		}
		final public function update():void
		{
			if(!actived) return;
			this.doUpdate();
		}
		protected function doUpdate():void
		{
			//to be overrided
		}
		protected var _group:IDisplayGroup;
		protected var _destroyed:Boolean;
	}
}