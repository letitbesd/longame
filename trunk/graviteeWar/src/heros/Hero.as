package heros
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	
	public class Hero extends HeroBase
	{
		public function Hero(team:String)
		{
			super(team);
		}
		override public function onFrame():void
		{
			
		}
		override public function active():void
		{
			super.active();
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		override public function deactive():void
		{
			super.deactive();
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if((event.keyCode==Keyboard.A)||(event.keyCode==Keyboard.D)){
				this.doAction(defaultAction);
			}
		}
		
		protected function onKeydown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.A){
				this.moveLeft();
			}else if(event.keyCode==Keyboard.D){
				this.moveRight();
			}
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			var mouseX:Number=event.stageX;
			var mouseY:Number=event.stageY;
			var p:Point=new Point(mouseX,mouseY);
//			p=this.globalToLocal(p);
			this.simulatePath(p.x,p.y);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
            this.shoot();
		}
		protected function onMouseMove(event:MouseEvent):void
		{
			var mouseX:Number=event.stageX;
			var mouseY:Number=event.stageY;
			var p:Point=new Point(mouseX,mouseY);
//			p=this.globalToLocal(p);
			this.simulatePath(p.x,p.y);

		}
	}
}