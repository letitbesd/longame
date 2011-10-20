package com.longame.modules.components
{
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.IScene;
	
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
		override protected function doWhenActive():void
		{
			if(!(_owner is GameScene)) throw new Error("The ower must be GameScene!");
			_oldMouseEnabled=scene.mouseEnabled;
			scene.mouseEnabled=true;
			scene.onMouse.down.add(onMouseDown);
		}
		override protected function doWhenDeactive():void
		{
			scene.onMouse.down.remove(onMouseDown);
			scene.onMouse.move.remove(onMouseMove);
			scene.mouseEnabled=_oldMouseEnabled;
			_inDragging=false;
		}
		private function onMouseDown(evt:MouseEvent):void
		{
			scene.onMouse.move.add(onMouseMove);
			scene.container.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			var mouse:Point=this.getCurrentMouse();
			this.prevMouseX=mouse.x;
			this.prevMouseY=mouse.y;
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
		private function get scene():GameScene
		{
			return _owner as GameScene;
		}
	}
}