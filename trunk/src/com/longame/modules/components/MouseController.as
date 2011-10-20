package com.longame.modules.components
{
	import com.longame.modules.core.IMouseObject;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.scenes.SceneManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class MouseController extends AbstractComp
	{
		public var speed:Number=3;
		public var alwaysTo:Boolean=true;
		/**
		 * 鼠标控制行走，寻路
		 * @param speed: 行进速度
		 * @param alwaysTo:不管目标点是否可行走，都走到旁边
		 * */
		public function MouseController(speed:Number=3,alwaysTo:Boolean=true)
		{
			this.speed=speed;
			this.alwaysTo=alwaysTo;
			super();
		}
		override protected function doWhenActive():void
		{
			if(!(_owner is Character)) throw new Error("The mouseController component is only for Character!");
			(_owner as Character).scene.mouseEnabled=true;
			(_owner as Character).scene.onMouse.click.add(findPath);
		}
		
		private function findPath(e:MouseEvent):void
		{
			var p:Vector3D=(_owner as Character).scene.globalToLocal(new Point(e.stageX,e.stageY));
			var t:Point=SceneManager.getTileIndex(p.x,p.y);
			(_owner as Character).path.moveToPoint(t.x,t.y,alwaysTo);
		}
		
		override protected function doWhenDeactive():void
		{
			(_owner as Character).scene.onMouse.click.remove(findPath);
		}
	}
}