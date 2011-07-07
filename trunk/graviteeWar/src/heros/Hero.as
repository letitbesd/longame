package heros
{
	import collision.CDK;
	import collision.CollisionData;
	
	import com.xingcloud.core.xingcloud_internal;
	
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
		private var midPoint:Point=new Point();
		private var temp:Point=new Point();

		public function Hero(team:String)
		{
			super(team);
			FightSignals.onHeroHitted.add(onHitted);
			temp.x=this.x;
			temp.y=this.y;
		}
		override public function onFrame():void
		{			
			if(!isAiming)
			{
			roleMove();
			}
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
//					midPoint.x=this.x+15*Math.cos(this.rotation*Math.PI/180);
//					midPoint.y=this.y+15*Math.sin(this.rotation*Math.PI/180);
					 an=Math.atan2((this.y-_hitPoint.y),(this.x-_hitPoint.x));
//					 an=Math.atan2((_hitPoint.y-this.y),(_hitPoint.x-this.x));
					 trace(an*180/Math.PI);
				this.addEventListener(Event.ENTER_FRAME,onFrame1);
				}
		}
		override public function active():void
		{
			super.active();
			this.doAction("notaiming7");
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		override public function deactive():void
		{
			super.deactive();
			this.doAction(defaultAction);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.A){
				this.leftArrow = false;
			}else if(event.keyCode==Keyboard.D){
				this.rightArrow = false;
			}
			if(!isAiming){
				this.doAction("notaiming7");
			}
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
			this.isAiming = true;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
//			var mouseX:Number=event.stageX;
//			var mouseY:Number=event.stageY;
//			var p:Point=new Point(mouseX,mouseY);
//			p=this.globalToLocal(p);
//			this.simulatePath(p.x,p.y);	
		}
		
		private function onFrame1(event:Event):void
		{
			var vx:Number;
			var vy:Number;
			var ag:Number=an*180/Math.PI;
			if((ag>=60&&ag<=120)||(ag>=150&&ag<=180)){
				vx=10*Math.cos(Math.PI*2-an);
				vy=10*Math.sin(an);
			}else{
			 vx=10*Math.cos(Math.PI*2-an);
			 vy=10*Math.sin(Math.PI*2-an);
//			 this.rotation=(Math.PI*2-an)*180/Math.PI;
			}
			this.x+=vx;
			this.y+=vy;
			for each(var p:Planet in Scene.planets){
				var checkPart:Shape = new Shape();
				checkPart.graphics.clear();
				checkPart.graphics.beginFill(0x66ccff,0.1);
				checkPart.graphics.drawCircle(this.x,this.y,5);
				checkPart.graphics.endFill();
				var cdk:CollisionData=CDK.check(checkPart,p);
				if(cdk){
					this.removeEventListener(Event.ENTER_FRAME,onFrame1);
					trace("collisioned");
//					var an:Number=cdk.angleInRadian;
					var an1:Number=cdk.angleInDegree;
					trace("*"+cdk.overlapping.length,an1);
					this.x-=cdk.overlapping.length*Math.cos(an1*Math.PI/180)*0.1;
					this.y-=cdk.overlapping.length*Math.sin(an1*Math.PI/180)*0.1;
					trace(cdk.overlapping.length*Math.cos(an)*0.01,cdk.overlapping.length*Math.sin(an)*0.01);
					if(an1<0||an1>=180){
						this.rotation=an1-180;
					}else{
						this.rotation=an1-90;
					}
//					trace(this.rotation);
					return;
				}
			}
			if(this.x>700||this.x<0||this.y>500||this.y<0){
				this.x=temp.x;
				this.y=temp.y;
				this.rotation=0;
				this.removeEventListener(Event.ENTER_FRAME,onFrame1);
				return;
			}
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			this.isAiming = false;
			this.doAction("notaiming7");
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