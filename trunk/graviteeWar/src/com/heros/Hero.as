package com.heros
{
	import AMath.AVector;
	
	import collision.CDK;
	import collision.CollisionData;
	
	import com.Planet;
	import com.Scene;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	import com.time.EnterFrame;
	import com.weapons.*;
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
	import flash.utils.setTimeout;
	
	public class Hero extends HeroBase
	{
		private var leftArrow:Boolean = false;
		private var rightArrow:Boolean = false;
		private var isHit:Boolean=false;
		public var isWalking:Boolean = false;
		private var midPoint:Point=new Point();
		private var temp:Point=new Point();
		private var hurtNum:int=10;
		public var isDead:Boolean;
		/**
		 * 子弹击中人物加速度方向
		 * */
		private var missileHitHeroAngle:Number;
		/**
		 *   子弹击中人物点是否在人物中点上方
		 * */
		private var _hitPointAboveMid:Boolean;
		private var tempAngle:Number;
		/**
		 *   是否被击中
		 * */
		private var _isHit:Boolean;
		private var _heroBelowAboveCenter:Boolean;
		private var _poisonedRound:int=0; //中毒回合次数
		public function Hero(team:String)
		{
			super(team);
			temp.x=this.x;
			temp.y=this.y;
			tempAngle=this.rotation;
			FightSignals.onHeroHitted.add(onHitted);
			FightSignals.heroPoisoned.add(onPoisoned);
		}
		override public function onFrame():void
		{	
			if(!isAiming)
			{
				roleMove();
			}
			if(isHit)
			{
				this.hit();
			}
		}
		private function roleMove():void
		{
		  if(this._heroBelowAboveCenter)
		  {
				if(leftArrow){
					this.moveLeft();
				}
				if(rightArrow){
					this.moveRight();	
				}
		  }else{
				  if(leftArrow){
					  this.moveRight();
				  }
				  if(rightArrow){
					  this.moveLeft();	
				  }
		  }
		}
		public function changeWep(wepID:int):void
		{
			if(this.isTurn==false) return;
			this.fireAction="aiming"+wepID;
			this.unfireAction="notaiming"+wepID;
			this.doAction(unfireAction);
			currentWepID=wepID;
			this.updateWep(currentWepID);
			//如果武器不具备攻击性 禁止Hero鼠标行为
			if(this.wep.startPointIsHero==false){
				this.deactive();
				wep.setWepPos();
			}
		}
		private function updateWep(id:int):void
		{
			switch(id){
				case 1: this.wep=new Wep1(id);
					break;
				case 2: this.wep=new Wep2(id);
					break;
				case 3: this.wep=new Wep3(id);
					break;
				case 4: this.wep=new Wep4(id);
					break;
				case 5: 
					this.wep=new Wep5(id,this._planet);
					break;
				case 6 :this.wep=new Wep6(id);
					break;
				case 7: this.wep=new Wep7(id);
					break;
				case 8: this.wep=new Wep8(id,this);
					break;
				case 9: this.wep=new Wep9(id);
					break;
				case 10:this.wep=new Wep10(id,this.index);
					break;
			}
		}
		//人物中毒状态
		private function  onPoisoned(index:int):void
		{
			if(this.index!=index) return;
			var poisonEffect:MovieClip=AssetsLibrary.getMovieClip("poisonEffect");
			var p:Point=this._content.globalToLocal(new Point(this.x,this.y));
			poisonEffect.x=p.x;
			poisonEffect.y=p.y-25;
			this._content.addChild(poisonEffect);
			//回合结束，扣除5HP 更新HP显示
			FightSignals.roundEnd.add(updateHp);
		}
		private function updateHp():void
		{
			_poisonedRound++;
			if(_poisonedRound>1)
			{
				this.hp.hurtNum=5;
			}
			if(this.hp.currenthp-5==0) this.die();
		}
		private function onHitted(heroIndex:int,hitAngle:Number,belowPlanet:Boolean,hitPointAboveMid:Boolean):void
		{
				if(this.index!=heroIndex) return;
				if(belowPlanet){
						missileHitHeroAngle=hitAngle;	
				}else{
					missileHitHeroAngle=hitAngle+Math.PI;
				}
//				trace("加速度角度"+missileHitHeroAngle*180/Math.PI);
				this._hitPointAboveMid=hitPointAboveMid;
				isHit=true;
				EnterFrame.addObject(this);
		}
		private function hit():void
		{
			//子弹击中HERO点在Hero中点上方 Hero停留在原始位置
			if(this._hitPointAboveMid==true)
			{
				var check:Boolean=true;
				//与人物站立星球做碰撞检测，碰到了做倒地动作，没碰到修正位移
				while(check==true)
				{
					var checkPart:Shape = new Shape();
					checkPart.graphics.clear();
					checkPart.graphics.beginFill(0xffffff,1);
					checkPart.graphics.drawCircle(this.x,this.y,4);
					checkPart.graphics.endFill();
					var cd1:CollisionData=CDK.check(checkPart,this._planet);
					var heroMove:Boolean;
					if(cd1)
					{
						check=false;
						//如果人物修正了位移，旋转角度用CDK返回的碰撞角度
						if(heroMove==true)
						{
							this.rotation=cd1.angleInDegree-90;
							this._heroRotation=this.rotation+360;
							heroMove=false;
						}
						if(this.hp.currenthp-this.hurtNum<=0)
						{
						  this.die();
						}
						else
						{
						  this.doAction("stand");
						}
					}
					else
					{
						if(MathUtil.getDistance(this.x,this.y,this._planet.x,this._planet.y)>this._planet.radius+5)
						{
								check=false;
						}else
						{
							this.x+=5*Math.cos((this.rotation+90)*Math.PI/180);
							this.y+=5*Math.sin((this.rotation+90)*Math.PI/180);
						}
							heroMove=true;
					}
				}
				this.addEventListener(Event.ENTER_FRAME,checkFrame);
				isHit=false;
			 }
//			Hero 飞走
			else
			{
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
				//被子弹击中后的加速度
				var vx:Number=10*Math.cos(missileHitHeroAngle);
				var vy:Number=10*Math.sin(missileHitHeroAngle);
				//Hero脱离当前星球，受到场景内所有星球引力影响 
				if(MathUtil.getDistance(this.x,this.y,this._planet.x,this._planet.y)>this._planet.radius+5){
					var g:AVector=Scene.getAcceleration(this.x,this.y);
					vx+=g.x*0.997*0.0285;
					vy+=g.y*0.997*0.0285;
				}
				this.x+=vx;
				this.y+=vy;
				this.rotation+=10;
				//飞出去与Scene内所有星球做碰撞检测
					for each(var p:Planet in Scene.planets)
					{
						var checkPart1:Shape = new Shape();
						checkPart1.graphics.clear();
						checkPart1.graphics.beginFill(0x66ccff,1);
						checkPart1.graphics.drawCircle(this.x,this.y,5);
						checkPart1.graphics.endFill();
						var cdk:CollisionData=CDK.check(checkPart1,p);
						if(cdk){
//								trace("人物和星球重叠区域"+cdk.overlapping.length);
								var heroHitPlanetAngle:Number=cdk.angleInDegree;
//								trace("人物碰撞星球角度"+heroHitPlanetAngle);
								if(cdk.overlapping.length>20)
								 {
									this.x-=cdk.overlapping.length*Math.cos(heroHitPlanetAngle*Math.PI/180)*0.08;
									this.y-=cdk.overlapping.length*Math.sin(heroHitPlanetAngle*Math.PI/180)*0.08;
								 }
								this.rotation = heroHitPlanetAngle-90;
								this._heroRotation=this.rotation+360;
								isHit=false;
								if(this.hp.currenthp-this.hurtNum<=0){
									this.die();
								}else{
									this.doAction("stand");
								}
								this.addEventListener(Event.ENTER_FRAME,checkFrame);
								this._planet=p;
								EnterFrame.removeObject(this);
								break;
							   }
					}
			}
			if(this.x>700||this.x<0||this.y>500||this.y<0){
				this.x=temp.x;
				this.y=temp.y;
				this.rotation=tempAngle;
				isHit=false;
				this._heroRotation=this.rotation+360;
				heroMove=false;
				EnterFrame.removeObject(this);
			}
		}
		
		private function checkFrame(event:Event):void
		{
			if(this._content.graphic.currentFrame>=30){
				this.removeEventListener(Event.ENTER_FRAME,checkFrame);
				this.hp.hurtNum=this.hurtNum;
				isAiming=false;
				if(isDead==true){
					this._content.graphic.gotoAndStop(30)
				    setTimeout(this.deadDelay,700)
				}else{
					this.doAction("bob");
				}
				
			}
		}
		private function deadDelay():void
		{
			this._planet.addHole(this.x,this.y,1);
			FightSignals.heroDead.dispatch(this.index);
		}
		override protected function die():void
		{
			isDead=true;
			this.doAction("collapse");
			this.addEventListener(Event.ENTER_FRAME,checkFrame);
			FightSignals.onHeroHitted.remove(onHitted);
			FightSignals.heroPoisoned.remove(onPoisoned);
		}
		override protected function shoot():void
		{
			super.shoot();
			if(isTurn)  FightSignals.turnNextHero.dispatch(this.index,true);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.doAction(defaultAction);
		}
		override public function active():void
		{
			super.active();
			this.doAction(unfireAction);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			FightSignals.changWep.add(changeWep);
		}
		override public function deactive():void
		{
			super.deactive();
			if(this.isHit==false) EnterFrame.removeObject(this);
			this.doAction(defaultAction);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.clear();
			FightSignals.changWep.remove(changeWep);
		}
		private function clear():void
		{
			this.currentPath=null;
			this.simulator=null;
			Scene.pathCanvas.graphics.clear();
			this.leftArrow=false;
			this.rightArrow=false;
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.A){
				this.leftArrow = false;
			}else if(event.keyCode==Keyboard.D){
				this.rightArrow = false;
			}
			if(this.rotation>=-90&&this.rotation<=90){
				this._heroBelowAboveCenter=true;
			}else{
				this._heroBelowAboveCenter=false;
			}
			if(!isAiming){
				this.doAction(unfireAction);
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
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			this.isAiming = false;
			this.doAction("notaiming7");
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
            this.shoot();
		}
		protected function onMouseMove(event:MouseEvent):void
		{
			var mouseX:Number=event.stageX;
			var mouseY:Number=event.stageY;
			var p:Point=new Point(mouseX,mouseY);
			this.simulatePath(p.x,p.y);
		}
	}
}