package view.scene.entitles.heros
{
	import AMath.AVector;
	
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.MathUtil;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.scene.components.heroKeyboardCtrl;
	import view.scene.components.heroMouseCtrl;
	import view.scene.entitles.HeroState;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.weapons.Wep1;
	
	public class Hero extends HeroBase
	{
		public static const defaultState:String=HeroState.BOB;
		private var defaultAction:String = HeroState.BOB;
		public var arrow:MovieClip ;           //角色头上箭头
		private var isHit:Boolean=false;
		public var isWalking:Boolean = false;
		public var isMyTurn:Boolean=false;
		private var midPoint:Point=new Point();
		private var temp:Point=new Point();
		private var tempAngle:Number;
		private var keyer:heroKeyboardCtrl;
        /**
		 * 子弹击中人物角度
		 * */
		private var missileHitHeroAngle:Number;  
		/**
		 * 子弹爆炸点是否在HERO中点上方
		 * */
		private var _hitPointAboveMid:Boolean = false; 
		private var _isHit:Boolean = false;  

		public function Hero(team:String)
		{
			super(team);
			temp.x=this.x;
			temp.y=this.y;
			tempAngle=this.rotation;
			FightSignals.onHeroHitted.add(onHitted);

			//添加鼠标控制组件
			var mouseCtrl:heroMouseCtrl = new heroMouseCtrl();
			this.add(mouseCtrl,HeroState.NOTAIMING);
			//添加键盘控制组件
			keyer = new heroKeyboardCtrl();
			this.add(keyer,HeroState.NOTAIMING);
			
			arrow =  AssetsLibrary.getMovieClip("arrow");
			this.container.addChild(arrow);
			arrow.visible = false;
			
		}
		
		override protected function  doWhenActive():void
		{
			super.doWhenActive();
			if(isMyTurn)
			{
				this.state = HeroState.NOTAIMING;
				this.arrow.visible = true;
				this.arrow.cndtext.visible = false;
			}
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			this.doAction(defaultAction);
			this.clear();
		}
		
		override protected function doRender():void
		{
			super.doRender();
			if(isHit)
			{
				this.hit();
			}
			
			if(!this.isAiming)
			{
				roleMove();
			}
		}
		
		private function roleMove():void
		{
			if(keyer.leftArrow){
				moveLeft();
			}else	if(keyer.rightArrow)
			{
				moveRight();	
			}
		}
		
		private function onHitted(heroIndex:int,hitAngle:Number,belowPlanet:Boolean,hitPointAboveMid:Boolean):void
		{
				if(this.heroIndex!=heroIndex) return;
				var rotationAngle:Number = this.rotation;
				if(rotationAngle<0) rotationAngle += 360;
				missileHitHeroAngle=hitAngle+Math.PI+rotationAngle*Math.PI/180;
				this._hitPointAboveMid=hitPointAboveMid;
				isHit=true;
//				EnterFrame.addObject(this);
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
					var cd1:CollisionData=CDK.check(checkPart,this._currentPlanet.container);
					var heroMove:Boolean;
					if(cd1){
						this.doAction("stand");
						check=false;
						//如果人物修正了位移，旋转角度用CDK返回的碰撞角度
						if(heroMove==true){
							this.rotation=cd1.angleInDegree-90;
							this._heroRotation=this.rotation+360;
							heroMove=false;
						}
					}
					else{
						if(MathUtil.getDistance(this.x,this.y,this._currentPlanet.x,this._currentPlanet.y)>this._currentPlanet.radius+5){
								check=false;
						}else{
							this.x+=5*Math.cos((this.rotation+90)*Math.PI/180);
							this.y+=5*Math.sin((this.rotation+90)*Math.PI/180);
						}
							heroMove=true;
						}
				}
//				this.container.addEventListener(Event.ENTER_FRAME,checkFrame);
				isHit=false;
			 }
//			Hero 飞走
			else
			{
//				InputManager.onKeyDown.remove(onKeydown);
				//被子弹击中后的加速度
				var vx:Number=10*Math.cos(missileHitHeroAngle);
				var vy:Number=10*Math.sin(missileHitHeroAngle);
				//Hero脱离当前星球，受到场景内所有星球引力影响 
				if(MathUtil.getDistance(this.x,this.y,this._currentPlanet.x,this._currentPlanet.y)>this._currentPlanet.radius+5)
				{
					var g:AVector=BattleScene.getAcceleration(this.x,this.y);
					vx+=g.x*0.997*0.0285;
					vy+=g.y*0.997*0.0285;
				}
				this.x+=vx;
				this.y+=vy;
				this.rotation+=10;
				this.doAction("aiming9");
				//飞出去与Scene内所有星球做碰撞检测
					for each(var p:Planet in BattleScene.planets)
					{
						var checkPart1:Shape = new Shape();
						checkPart1.graphics.clear();
						checkPart1.graphics.beginFill(0x66ccff,1);
						checkPart1.graphics.drawCircle(this.x,this.y,5);
						checkPart1.graphics.endFill();
						var cdk:CollisionData=CDK.check(checkPart1,p.container);
						if(cdk){
								var heroHitPlanetAngle:Number=cdk.angleInDegree;
								if(cdk.overlapping.length>20)
								 {
									this.x-=cdk.overlapping.length*Math.cos(heroHitPlanetAngle*Math.PI/180)*0.08;
									this.y-=cdk.overlapping.length*Math.sin(heroHitPlanetAngle*Math.PI/180)*0.08;
								 }
								this.rotation = heroHitPlanetAngle-90;
								this._heroRotation=this.rotation+360;
								isHit=false;
								this.doAction("stand");
//								checkFrame();
								this._currentPlanet=p;
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
			}
		}
		
//		protected function checkFrame():void
//		{
//			if(this._content.graphic.currentFrame>=30){
//				this.doAction("bob");
//				this.container.removeEventListener(Event.ENTER_FRAME,checkFrame);
//				this.hp.hurtNum=5;
//				isAiming=false;
//			}
//		}
		override public function shoot():void
		{
			super.shoot();
			if(isMyTurn)  FightSignals.turnNextHero.dispatch(this.heroIndex,true);
		}
		private function clear():void
		{
			this.currentPath=null;
			this.simulator=null;
			BattleScene.pathCanvas.graphics.clear();
		}
	}
}