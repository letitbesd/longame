package com.longame.modules.entities
{
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.modules.entities.display.primitive.LGBox;
	import com.longame.modules.scenes.SceneManager;
	
	public class GroupBoundsDebugger extends LGBox
	{
		public function GroupBoundsDebugger(id:String=null)
		{
			super(id);
			this._includeInLayout=false;
			this.fill=new SolidColorFill(0x00ff00,0.3);
			this._walkable=true;
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			this.updateSize();
			parent.onResize.add(updateSize);
		}
		
		private function updateSize(target:IDisplayEntity=null):void
		{
			this.width=parent.width||SceneManager.tileSize;
			this.length=parent.length||SceneManager.tileSize;
			this.height=parent.height||SceneManager.tileSize;
			this.x=parent.bounds.left;
			this.y=parent.bounds.back;
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			parent.onResize.remove(updateSize);
		}
	}
}