package com.longame.game.component
{
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.IScene;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 场景拖动组件
	 * */
	public class SceneDragComp extends AbstractComp
	{
		private var _inDragging:Boolean;
		private var _oldTouchabled:Boolean;
		
		public function SceneDragComp(id:String=null)
		{
			super(id);
		}
		override protected function whenActive():void
		{
			if(!(_owner is BaseScene)) throw new Error("The ower must be GameScene!");
			_oldTouchabled=scene.container.touchable;
			scene.container.touchable=true;
			scene.container.addEventListener(TouchEvent.TOUCH,handleTouch);
		}
		private var dragTriggered:Boolean;
		private function handleTouch(evt:TouchEvent):void
		{
			var touch:Touch=evt.getTouch(scene.container);
			switch(touch.phase){
				case TouchPhase.BEGAN:
					dragTriggered=true;
					this.onTouchDown(touch);
					break;
				case TouchPhase.MOVED:
					if(dragTriggered) onTouchMove(touch);
					break;
				case TouchPhase.ENDED:
					dragTriggered=false;
					onTouchEnd();
					break;
			}
		}
		override protected function whenDeactive():void
		{
			scene.container.removeEventListener(TouchEvent.TOUCH,handleTouch);
			scene.container.touchable=_oldTouchabled;
			_inDragging=false;
		}
		private function onTouchDown(touch:Touch):void
		{
			//如果镜头忙，先不响应
			if(!scene.camera.idle) return;
//			scene.container.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			var mouse:Point=touch.getLocation(scene.stage);
			this.prevMouseX=mouse.x;
			this.prevMouseY=mouse.y;
			scene.camera.moveSpeed=0;
//			scene.container.buttonMode=true;
		}
		private var prevMouseX:Number;
		private var prevMouseY:Number;
		
		private var startDragDispatched:Boolean;
		private function onTouchMove(touch:Touch):void
		{
			if(!startDragDispatched){
				startDragDispatched=true;
				_inDragging=true;
//				this.onStartDrag.dispatch(evt);
			}
			if(scene==null) return;
			var mouse:Point=touch.getLocation(scene.stage);
			var dx:Number=mouse.x-this.prevMouseX;
			var dy:Number=mouse.y-this.prevMouseY;
			scene.camera.x-=dx;
			scene.camera.y-=dy;
			this.prevMouseX=mouse.x;
			this.prevMouseY=mouse.y;
		}
		private function onTouchEnd():void
		{
			if(!this.actived) return;
//			scene.onMouse.move.remove(onTouchMove);
//			scene.container.stage.removeEventListener(MouseEvent.MOUSE_UP,onTouchEnd);
//			scene.container.buttonMode=false;
			if(startDragDispatched){
				startDragDispatched=false;
			}
			_inDragging=false;
		}
		public function get inDragging():Boolean
		{
			return _inDragging;
		}
		private function get scene():BaseScene
		{
			return _owner as BaseScene;
		}
	}
}