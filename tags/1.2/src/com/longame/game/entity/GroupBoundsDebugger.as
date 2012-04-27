package com.longame.game.entity
{
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.game.entity.display.primitive.LGBox;
	import com.longame.game.scene.SceneManager;
	
	public class GroupBoundsDebugger extends LGBox
	{
		public function GroupBoundsDebugger(id:String=null)
		{
			super(id);
			this._includeInBounds=false;
			this.fill=new SolidColorFill(0x00ff00,0.3);
			this._walkable=true;
		}
		override protected function whenActive():void
		{
			super.whenActive();
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
		
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			parent.onResize.remove(updateSize);
		}
	}
}