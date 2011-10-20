package view.scene.entitles.heros
{
	import AMath.AVector;
	import AMath.Vector2D;
	
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.longame.display.core.Clip;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.modules.components.MouseController;
	import com.longame.modules.components.fight.HealthComp;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.CharactersMap;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IHealthEntity;
	import com.longame.modules.entities.IMovableEntity;
	import com.longame.modules.entities.SpriteEntity;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.scene.components.heroMouseCtrl;
	import view.scene.entitles.HealthDisplay;
	import view.scene.entitles.IFrameObject;
	import view.scene.entitles.Missile;
	import view.scene.entitles.PathNode;
	import view.scene.entitles.PathSimulator;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.weapons.*;
	import view.scene.entitles.missiles.MissileBase;
	
	public class HeroBase extends AnimatorEntity
	{
		public static const speed:Number=2;
		public static const teams:Array=["white","red","blue","green","yellow"]; 	
		private static const collideRadius:Number = 5;
		private var vr:Number = 0.0005;
		
		public var accurate:int=50;				//玩家的射击精确度，实际就是显示子弹运行路径的长短      TODO：
		public var _content:MovieClip;
		public var danceID:int = 0;
		private var _onTopHalf:Boolean;   //人物是否在上半球
		public var unitName:String = "";
		public var killReg:int = -1;
		public var timeSince:int = 0;
		public var healthShown:int = 25;		
		public var isAiming:Boolean = false;
		public var atRight:Boolean=false;
		public var isTurn:Boolean=false;
		public var heroIndex:int;	
		protected var _team:String;
		protected var shootAngle:Number;
		protected var _currentPlanet:Planet;
		protected var _angle:Number;
		protected var _heroRotation:Number=0;          //人物旋转角度，人物变化后的导弹的发射角偏移量
		protected var cdCheck:Boolean = false;
		protected var _heroName:String = "";
		protected var hp:HealthDisplay;
		protected var _health:HealthComp;
		protected var currentWepID:int=1;
//		protected var wep:WepBase=new Wep1(1);
		protected var wep:WepBase;
		protected var isTeleport:Boolean=false;
		public var fireAction:String="aiming1";
	    public var unfireAction:String="notaiming1"
		private var isInCheck:Boolean;
		private var maxHealth:Number;
		private var currentHealth:Number;
		private var mass:int = 0;
		private var _checkPart:Shape;
		public function HeroBase(team:String)
		{
			super();
			//添加生命值组件
			_health=new HealthComp();
			this.add(_health);
			this.health.init(maxHealth,currentHealth);
			
			_content= AssetsLibrary.getMovieClip("hero");
			this.source = _content;
			this.animator.clip.onBuild.add(onBuilded);
			this.team=team;
			this.defaultAnimation="bob";
			this.doAction(defaultAnimation);

			//血量
			hp=new HealthDisplay(teams.indexOf(team),team);
			this.container.addChild(hp);
			
			var i:int=Math.floor(Math.random()*BattleScene.planets.length);
			_currentPlanet=BattleScene.planets[i];
			
			var angle:Number=Math.random()*360;
			this.angle = angle;
			 wep = new Wep1(this);
			 FightSignals.changWep.add(changeWep);
			 FightSignals.heroPoisoned.add(onPoisoned)
		}
		private function onBuilded(clip:Clip):void
		{
			this.updateColor();
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
		}
		override  protected function  doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		
		override protected function doRender():void
		{
			super.doRender();
			if(isTeleport){
				this.checkTeleport();
			}
		   
		}
		/**
		 * 检测传送动作完成程度，调整HERO的位置
		 * */
		private function checkTeleport():void
		{
			if(this._content.graphic.currentFrame>=40&&isInCheck==false) //如果第一个动作做完了
			{
				//调整HERO位置
				var circle:Shape=new Shape();
				circle.graphics.beginFill(0xFFFFFF,0.3);
				circle.graphics.drawCircle(_checkPart.x,_checkPart.y,7);
				circle.graphics.endFill();
				this.scene.container.addChild(circle);
				if(_checkPart.parent) _checkPart.parent.removeChild(_checkPart);  //移除检测圆球
				//获得CIRCLE与星球碰撞角度既人物ROTATION
				var cd1:CollisionData=CDK.check(circle,currentPlanet.container);
				if(cd1){
					angle=cd1.angleInDegree-90;
					if(circle.parent) circle.parent.removeChild(circle);
				}
				this.rotation=angle;
				this.x=_checkPart.x;
				this.y=_checkPart.y;
				this.doAction("teleportin");
				isInCheck=true;
			}
			if(this._content.graphic.currentFrame>=40&&isInCheck==true)  //如果第二个动作做完了
			{
				this.doAction("bob");
				isTeleport=false;
				isInCheck=false;
			}
		}
		/**
		 * 人物中毒
		 * */
		private function  onPoisoned(index:int):void
		{
			if(this.heroIndex!=index) return;
			var poisonEffect:MovieClip=AssetsLibrary.getMovieClip("poisonEffect");
			var p:Point=this._content.globalToLocal(new Point(this.x,this.y));
			poisonEffect.x=p.x;
			poisonEffect.y=p.y-25;
			this._content.addChild(poisonEffect);
			//回合结束，扣除5HP 更新HP显示
//			FightSignals.roundEnd.add(updateHp);
		}
		
		public function teleport(checkPart:Shape):void
		{
		   _checkPart=checkPart;
		  	isTeleport=true;
		}
		public function aimAt(angle:uint):void  //攻击角度，1-180度
		{
			this.isAiming = true;
			this.doAction(fireAction);
			if(angle <= 0) angle = 1;
			if(angle > 180) angle = 180;
			this._content.graphic.gotoAndStop(angle);
		}
		
		public function doAction(name:String):void
		{
			this.gotoAndStop(name);
			this.updateColor();
		}
		
		private function updateColor():void
		{
			try{
				var frame:uint=teams.indexOf(_team)+1;
				this.animator.clip.realMc.graphic.head.col.gotoAndStop(frame);
				this.animator.clip.realMc.graphic.body.col.gotoAndStop(frame);
				this.animator.clip.realMc.graphic.lefthand.col.gotoAndStop(frame);
				this.animator.clip.realMc.graphic.righthand.col.gotoAndStop(frame);
				this.animator.clip.realMc.graphic.leftfoot.col.gotoAndStop(frame);
				this.animator.clip.realMc.graphic.rightfoot.col.gotoAndStop(frame);
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		public function moveLeft():void  
		{
			this.turnLeft();
			this.doAction("walk");

			var an:Number;
			if(this.rotation > 180)                                         //根据人物当前的rotation计算下一步位置，下一步在保持人物当前倾斜角度的直线上运动，再对下一步位置做碰撞检测
			{
				an = this.rotation - 180;
			}else
			{
				an = this.rotation + 180;
			}
			var moveDirection:Number = an*Math.PI/180;  //移动方向垂直于rotation 实际方向会相差90度 原因不明
			var moveOnce:Point = new Point();                  //移动一步位移量
			moveOnce.x = Math.cos(moveDirection)*speed;         
			moveOnce.y = Math.sin(moveDirection)*speed;
			
			var p:Point = new Point();
			p = this.parent.container.globalToLocal(new Point(this.x,this.y));
			
			collideCheck(new Point(p.x + moveOnce.x,p.y + moveOnce.y));
			
			_heroRotation=0;
			_heroRotation=this.rotation+360;
			if(_heroRotation>360) _heroRotation-=360;
		}
		
		public function moveRight():void
		{
			this.turnRight();
			this.doAction("walk");

			var moveDirection:Number = this.rotation*Math.PI/180;  
			var moveOnce:Point = new Point();   //移动一步位移量
			moveOnce.x = Math.cos(moveDirection)*speed;
			moveOnce.y = Math.sin(moveDirection)*speed;
			
			var p:Point = new Point();
			p = this.parent.container.globalToLocal(new Point(this.x,this.y));
			
			collideCheck(new Point(p.x + moveOnce.x,p.y + moveOnce.y));
			
			_heroRotation=0;
			_heroRotation=this.rotation+360;
			if(_heroRotation>360) _heroRotation-=360;
		}
		
		private function collideCheck(point:Point):void  //参数是碰撞测试点  检查该点是否和星球碰撞 若不碰撞 向下调 若碰撞太多 向上调 调整后再执行检查
		{						
			var checkCell:Shape = new Shape();
			var moveDirection:Number;
			var moveOnce:Point;
			cdCheck = true;		
			while(cdCheck)
			{					
				checkCell.graphics.clear();
				checkCell.graphics.beginFill(0xFFFFFF,1);
				checkCell.graphics.drawCircle(point.x,point.y,collideRadius);
				checkCell.graphics.endFill();
//				_currentPlanet.parent.container.addChild(checkCell);
				
				var cd:CollisionData=CDK.check(checkCell,_currentPlanet.container);
//				trace(_planet.x,_planet.y+"****",_planet.container.x,_planet.container.y+ point);
				var checkCell1:Shape = new Shape();
				checkCell1.graphics.clear();
				checkCell1.graphics.beginFill(0xFFFFFF,1);
				checkCell1.graphics.drawCircle(_currentPlanet.container.x,_currentPlanet.container.y,collideRadius);
				checkCell1.graphics.endFill();
//				_currentPlanet.parent.container.addChild(checkCell1);
				
				if(cd)		//有碰撞这时point与星球球面有接触了  设置小人位置和方向
				{
					if(cd.overlapping.length>collideRadius*10)			//测试点进入星球太多了 需要调整 使overlapping.length维持在一个值以下
					{
						moveDirection = (this.rotation - 90)*Math.PI/180; 		 //向站立垂直向上移动一步
						moveOnce = new Point();   								//移动一步位移量
						moveOnce.x = Math.cos(moveDirection)*speed;
						moveOnce.y = Math.sin(moveDirection)*speed;
						point.x += moveOnce.x;
						point.y += moveOnce.y;
					}
					else
					{
						point = this.parent.container.globalToLocal(point);
						this.x = point.x;
						this.y = point.y;
						this.rotation = Math.round(cd.angleInDegree-90);  		
						//用测试点与星球的碰撞角度给小人的rotation赋值	 得出的这个rotation值Y轴负方向是为0  范围在-180到+180之间  顺时针为正
						//trace("this.rotation"+this.rotation);
						cdCheck = false;
					}					
				}				
				else		//没有碰撞  移动point再检测
				{
					moveDirection = (this.rotation + 90)*Math.PI/180;  //向垂直站立向下方向移动
					moveOnce = new Point();   								//移动一步位移量
					moveOnce.x = Math.cos(moveDirection)*speed;
					moveOnce.y = Math.sin(moveDirection)*speed;
					point.x += moveOnce.x;
					point.y += moveOnce.y;
				}
			}
		}
		
		protected function turnLeft():void
		{
			if(this.scaleX==1) return;
			this.scaleX=1;
			this.hp.scaleX=1;
			atRight=false;
		}
		
		protected function turnRight():void
		{
			if(this.scaleX==-1) return;
			this.scaleX=-1;
			this.hp.scaleX=-1;
			atRight=true;			
		}
		
		protected function isLeft():Boolean
		{
			return this.scaleX==1;
		}
		public function changeWep(wepID:int):void
		{
			trace(isTurn,wepID);
			if(this.isTurn==false) return;
			this.fireAction="aiming"+wepID;
			this.unfireAction="notaiming"+wepID;
			this.doAction(unfireAction);
			currentWepID=wepID;
			this.updateWep(currentWepID);
			//如果武器不具备攻击性 禁止Hero鼠标行为
			if(this.wep.isAssist==true){
				wep.setWepPos();
//				this.deactive();
			}
		}
		private function updateWep(id:int):void
		{
			switch(id)
			{
				case 1: this.wep=new Wep1(this);
					break;
				case 2: this.wep=new Wep2(this);
					break;
				case 3: this.wep=new Wep3(this);
					break;
				case 4: this.wep=new Wep4(this);
					break;
				case 5: this.wep=new Wep5(this);
					break;
				case 6 :this.wep=new Wep6(this);
					break;
				case 7: this.wep=new Wep7(this);
					break;
				case 8: this.wep=new Wep8(this);
					break;
				case 9: this.wep=new Wep9(this);
					break;
				case 10:this.wep=new Wep10(this);
					break;
			}
		}
		public  function shoot():void
		{
//			if((currentPath==null)||(currentPath.length==0)) return;
//			this.state = "";
////			var missile:Missile=new Missile(this.currentPath,simulator.planet,simulator.heroShootIndex);
//			var missile:MissileBase=new MissileBase(this.currentPath,this.currentPlanet,1,1);
//			BattleScene.pathCanvas.graphics.clear();
//			this.scene.add(missile);
			//如果当前武器是地雷，记录HERO当前的位置
			if(currentWepID==5){
				var info:Object={x:this.x,y:this.y,rotation:this.rotation}
				wep.heroInfo=info;
			}
			wep.shoot();
			this.doAction(fireAction);
			if(wep.changeAction==true){
				this.unfireAction="bob";
			}
		}
		
		public  var simulator:PathSimulator;
		
		public function simulatePath(shootX:Number,shootY:Number):void
		{
			var inLeft:Boolean=pointIsLeft(shootX,shootY);
			//以炮管注册点为中心，炮管的发射方向
			var p:Point=new Point(shootX,shootY);
			p=this.container.globalToLocal(p);
			this.shootAngle=Math.atan2(p.y+16,p.x);
			var angleInDegree:int=Math.round(shootAngle*180/Math.PI);
			//目标发射方向在炮筒的右边，人向右转
			if(!inLeft) {
				var an:int=angleInDegree-90;
				if(an<0) an+=360;
				this.aimAt(an);
				this.turnRight();
				this.shootAngle=Math.PI-this.shootAngle;
			//目标发射方向在炮筒的左边，人向左转
			}else{
				an=angleInDegree-90;
				if(an<0) an+=360;
				this.aimAt(an);
				this.turnLeft();
			}
			var param:Object=this.calMissileSate(p.x,p.y);
			wep.simulatePath(param);
//			if(param==null) return;
//			simulator=new PathSimulator(param.strength,param.angle,param.startPos,this.index);
//			currentPath=simulator.simulate(accurate,BattleScene.pathCanvas.graphics);
		}
		
		private function pointIsLeft(x:Number,y:Number):Boolean		
		{
			//更简单的算法  实际上 只取决于鼠标横坐标
			var p0:Point=new Point(x,y);
			p0=this.container.globalToLocal(p0);	
			var numberX:Number=p0.x;
			if(atRight==true) p0.x=-numberX;
			return p0.x <= 0;
		}
		
		protected var currentPath:Vector.<PathNode>;
		/**
		 * 计算子弹发射的初始参数，包括力度，角度和初始位置
		 * */
		
		protected function calMissileSate(shootX:Number,shootY:Number):Object
		{
			var wep:MovieClip=this._content.graphic.wep;
			//如果子弹没有拖尾效果
			if(wep.start==null) return {};
			var startPos:Point=wep.localToGlobal(new Point(wep.start.x,wep.start.y));
			var dx:Number=shootX-startPos.x;
			var dy:Number=shootY-startPos.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			var ag:Number=_heroRotation*Math.PI/180;
			//trace("_heroRotation"+_heroRotation.toString())
			return {strength:dist/60,angle:shootAngle+ag,startPos:startPos};			
		}
		
		public function updateMass():void
		{
			mass = this._health.health * 5;
			if (mass < 100)
			{
				mass = 100;
			}
		}
		
		public function get health():HealthComp
		{
			return _health;
		}
		public function set team(value:String):void
		{
			if(_team==value) return;
			_team=value;
//			this.updateColor();
		}
		public function get team():String
		{
			return _team;
		}
		
		public function get heroName():String
		{
			return _heroName;
		}
		
		public function set heroName(value:String):void
		{
			_heroName = value;
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			if(this._angle==value) return;
			this._angle=value;
			var radiusAngle:Number=value*Math.PI/180;
			this.x=_currentPlanet.radius*Math.cos(radiusAngle)+_currentPlanet.x;
			this.y=_currentPlanet.radius*Math.sin(radiusAngle)+_currentPlanet.y;
			this.rotation = value + 90;
			
			_heroRotation=0;
			_heroRotation=this.rotation+360;
			if(_heroRotation>360) _heroRotation-=360;
		}

		public function get onTopHalf():Boolean
		{
			if(this.y > this._currentPlanet.y)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		public function get currentPlanet():Planet
		{
		   return _currentPlanet;
		}
		
		public function set currentPlanet(value:Planet):void
		{
		    this._currentPlanet = value;
		}
	}
}