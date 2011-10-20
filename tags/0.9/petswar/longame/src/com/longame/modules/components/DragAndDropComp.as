package com.longame.modules.components
{
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.SpriteEntity;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

	public class DragAndDropComp extends AbstractComp
	{
		public var onStartDrag:Signal=new Signal(MouseEvent);
		public var onStopDrag:Signal=new Signal(MouseEvent);
		
		private var _inDragging:Boolean;
		private var bringToTop:Boolean;
		
		/**
		 * @param bringToTop:拖动时是否保持对象在最上层
		 * */
		public function DragAndDropComp(bringToTop:Boolean=false,id:String=null)
		{
			super(id);
			this.bringToTop=bringToTop;
		}
		override protected function doWhenActive():void
		{
			if(!(_owner is DisplayEntity)) throw new Error("The ower must be DisplayEntity!");
			theOwner.onMouse.down.add(onMouseDown);
		}
		override protected function doWhenDeactive():void
		{
			theOwner.onMouse.down.remove(onMouseDown);
			theOwner.scene.onMouse.move.remove(onMouseMove);
			_inDragging=false;
			theOwner.alwaysInTop=false;
		}
		override protected function doWhenDestroy():void
		{
		}
		//鼠标和注册点的偏移，这样不会造成鼠标始终在注册点的情况
		private var mouseOffset:Vector3D;
		private function onMouseDown(evt:MouseEvent):void
		{
			mouseOffset=theOwner.globalToLocal(new Point(evt.stageX,evt.stageY));
			theOwner.scene.onMouse.move.add(onMouseMove);
			theOwner.onMouse.up.addOnce(onMouseUp);
		}
		private var startDrageDispatched:Boolean;
		private function onMouseMove(evt:MouseEvent):void
		{
			if(!startDrageDispatched){
				startDrageDispatched=true;
				_inDragging=true;
				theOwner.alwaysInTop=this.bringToTop;
				this.onStartDrag.dispatch(evt);
			}
			if(theOwner){
				var np:Vector3D=theOwner.parent.globalToLocal(new Point(evt.stageX,evt.stageY));
				theOwner.x=np.x-mouseOffset.x;
				theOwner.y=np.y-mouseOffset.y;
				theOwner.z=np.z-mouseOffset.z;
			}
		}
		private function onMouseUp(evt:MouseEvent=null):void
		{
			theOwner.scene.onMouse.move.remove(onMouseMove);
			theOwner.alwaysInTop=false;
			if(startDrageDispatched){
				this.onStopDrag.dispatch(evt);
				startDrageDispatched=false;
			}
			_inDragging=false;
		}
		public function get inDragging():Boolean
		{
			return _inDragging;
		}
		private function get theOwner():DisplayEntity
		{
			return _owner as DisplayEntity;
		}
	}
}