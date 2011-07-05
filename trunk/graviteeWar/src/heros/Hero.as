package heros
{
	import collision.CDK;
	import collision.CollisionData;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import signals.FightSignals;
	
	
	public class Hero extends HeroBase
	{
		private var leftArrow:Boolean = false;
		private var rightArrow:Boolean = false;
		private var isHit:Boolean=false;
		public function Hero(team:String)
		{
			super(team);
			
			FightSignals.onHeroHitted.add(onHitted);
			
		}
		override public function onFrame():void
		{			
			roleMove();
//			if(this.team=="blue")  trace(this.team,this.isHit);
//			trace(isHit);
		}
		
		private function roleMove():void
		{
			if(leftArrow){
				this.moveLeft();
			}
			if(rightArrow){
				this.moveRight();	
			}
		}
		private var _hitPoint:Point;
		private var an:Number;
		private function onHitted(index:int,p:Point):void
		{
				if(this.index==index){
					this._hitPoint=p;
					 an=Math.atan2((_hitPoint.y-(this.y-12)),(_hitPoint.x-this.x));
				this.addEventListener(Event.ENTER_FRAME,onFrame1);
				}
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
			if(event.keyCode==Keyboard.A){
				this.leftArrow = false;
			}else if(event.keyCode==Keyboard.D){
				this.rightArrow = false;
			}
			this.doAction(defaultAction);
		}
		
		protected function onKeydown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.A){
				this.leftArrow = true;
			}else if(event.keyCode==Keyboard.D){
				this.rightArrow = true;
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
		private function onFrame1(event:Event):void
		{
			var vx:Number=10*Math.cos(an+Math.PI);
			var vy:Number=10*Math.sin(an+Math.PI);
			this.x+=vx;
			this.y+=vy;
			if(this.x>700||this.x<0||this.y>500||this.y<0){
				this.x=550;
				this.y=278;
				this.removeEventListener(Event.ENTER_FRAME,onFrame1);
				return;
			}
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