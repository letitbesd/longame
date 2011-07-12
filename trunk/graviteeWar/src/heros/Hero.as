package heros
{
	import AMath.AVector;
	
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
		private var missileHitHeroAngle:Number;

		public function Hero(team:String)
		{
			super(team);
			temp.x=this.x;
			temp.y=this.y;
			FightSignals.onHeroHitted.add(onHitted);
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
		private function onHitted(heroIndex:int,hitAngle:Number,belowPlanet:Boolean):void
		{
				if(this.index!=heroIndex) return;
//				if(hitByMissile==true)
//				{
//					missileHitHeroAngle=hitAngle;
//					var ag:Number=missileHitHeroAngle*180/Math.PI;
//					if((ag>=60&&ag<=130)||(ag<=-50&&ag>=-120))
//					{
//						missileHitHeroAngle=hitAngle;
//					}
//					else
//					{
//						missileHitHeroAngle=Math.PI*2-missileHitHeroAngle;
//					}
//						trace(hitAngle*180/Math.PI,"子弹碰撞角度"+missileHitHeroAngle*180/Math.PI);
//					this.addEventListener(Event.ENTER_FRAME,onFrame1);
//				}
//				else
//				{
//						missileHitHeroAngle=hitAngle;
//						trace(hitAngle*180/Math.PI,"*"+missileHitHeroAngle*180/Math.PI);
//						this.addEventListener(Event.ENTER_FRAME,onFrame1);
//				 }
				if(belowPlanet){
						missileHitHeroAngle=hitAngle;
				}else{
					missileHitHeroAngle=hitAngle+Math.PI;
				}
				this.addEventListener(Event.ENTER_FRAME,onFrame1);
		}
		private function onFrame1(event:Event):void
		{
			var vx:Number=10*Math.cos(missileHitHeroAngle);
			var vy:Number=10*Math.sin(missileHitHeroAngle);
			var g:AVector=Scene.getAccelerationForBending(this.x,this.y);
			vx+=g.x*0.997*0.05;
			vy+=g.y*0.997*0.05;
//			trace("&&&"+g.x*0.997*0.05,g.y*0.997*0.05,vx,vy);
			this.x+=vx;
			this.y+=vy;
			this.rotation+=10;
				for each(var p:Planet in Scene.planets)
				{
					var checkPart:Shape = new Shape();
					checkPart.graphics.clear();
					checkPart.graphics.beginFill(0x66ccff,0.1);
					checkPart.graphics.drawCircle(this.x,this.y,4);
					checkPart.graphics.endFill();
					var cdk:CollisionData=CDK.check(checkPart,p);
					if(cdk){
						trace("重叠区域："+cdk.overlapping.length);
							var heroHitPlanetAngle:Number=cdk.angleInDegree;
							trace("人物与星球碰撞角度"+heroHitPlanetAngle);
							this.x-=cdk.overlapping.length*Math.cos(heroHitPlanetAngle*Math.PI/180)*0.05;
							this.y-=cdk.overlapping.length*Math.sin(heroHitPlanetAngle*Math.PI/180)*0.05;
							this.rotation=Math.round(heroHitPlanetAngle-90);
							this.removeEventListener(Event.ENTER_FRAME,onFrame1);
							this.doAction("stand");
						this.addEventListener(Event.ENTER_FRAME,checkFrame);
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
		
		protected function checkFrame(event:Event):void
		{
			if(this._content.graphic.currentFrame>=30){
				this.doAction("bob");
				this.removeEventListener(Event.ENTER_FRAME,checkFrame);
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