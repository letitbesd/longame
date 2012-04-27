package com.longame.game.component
{
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.IScene;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 场景拖动组件
	 * */
	public class SceneDragComp extends AbstractComp
	{
		private var _inDragging:Boolean;
		private var _oldMouseEnabled:Boolean;
		
		public function SceneDragComp(id:String=null)
		{
			super(id);
		}
		override protected function whenActive():void
		{
			if(!(_owner is BaseScene)) throw new Error("The ower must be GameScene!");
			_oldMouseEnabled=scene.mouseEnabled;
			scene.mouseEnabled=true;
			scene.onMouse.down.add(onMouseDown);
		}
		override protected function whenDeactive():void
		{
			scene.onMouse.down.remove(onMouseDown);
			scene.onMouse.move.remove(onMouseMove);
			scene.mouseEnabled=_oldMouseEnabled;
			_inDragging=false;
		}
		private function onMouseDown(evt:MouseEvent):void
		{
			//如果镜头忙，先不响应
			if(!scene.camera.idle) return;
			scene.onMouse.move.add(onMouseMove);
			scene.container.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			var mouse:Point=this.getCurrentMouse();
			this.prevMouseX=mouse.x;
			this.prevMouseY=mouse.y;
			scene.camera.moveSpeed=0;
//			scene.container.buttonMode=true;
		}
		private var prevMouseX:Number;
		private var prevMouseY:Number;
		
		private var startDragDispatched:Boolean;
		private function onMouseMove(evt:MouseEvent):void
		{
			if(!startDragDispatched){
				startDragDispatched=true;
				_inDragging=true;
//				this.onStartDrag.dispatch(evt);
			}
			if(scene==null) return;
			var mouse:Point=this.getCurrentMouse();
			var dx:Number=mouse.x-this.prevMouseX;
			var dy:Number=mouse.y-this.prevMouseY;
			scene.camera.x-=dx;
			scene.camera.y-=dy;
			this.prevMouseX=mouse.x;
			this.prevMouseY=mouse.y;
		}
		private function getCurrentMouse():Point
		{
			//必须要stage的鼠标位置，因为只有stage是没有移动的,否则会发抖
			//todo,如果场景有缩放呢？
			var x:Number=scene.container.stage.mouseX;
			var y:Number=scene.container.stage.mouseY;
			return new Point(x,y);
		}
		
		private function onMouseUp(evt:MouseEvent=null):void
		{
			if(!this.actived) return;
			scene.onMouse.move.remove(onMouseMove);
			scene.container.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
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