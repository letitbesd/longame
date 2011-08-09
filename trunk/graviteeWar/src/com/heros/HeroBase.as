package com.heros
{
	import AMath.AVector;
	import AMath.Vector2D;
	
	import collision.CDK;
	import collision.CollisionData;
	
	import com.IFrameObject;
	import com.PathNode;
	import com.PathSimulator;
	import com.Planet;
	import com.Scene;
	import com.longame.managers.AssetsLibrary;
	import com.time.EnterFrame;
	import com.weapons.*;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	import com.missiles.MissileBase;
	
	public class HeroBase extends Sprite implements IFrameObject
	{
		public static const speed:Number=2;
		public static const teams:Array=["white","red","blue","green","yellow"]; 	
		public static const defaultAction:String="bob";
		private static const collideRadius:Number = 5;
		public var _planet:Planet;
		public var accurate:int=50;				//玩家的射击精确度，实际就是显示子弹运行路径的长短
		public var damageTaken:int = 0;
		public var danceID:int = 0;
		public var healthShown:int = 25;
		public var positionPlanet:int = 0;
		public var unitName:String = "";
		public var health:int = 25;
		public var killReg:int = -1;
		public var timeSince:int = 0;
		public var isTurn:Boolean=false;
		public var _content:MovieClip;
		public var arrow:MovieClip ;
		protected var _team:String;
		protected var shootAngle:Number;
		protected var atRight:Boolean=false;
		protected var _angle:Number;
		protected var _heroRotation:Number=0;          //人物旋转角度，人物变化后的导弹的发射角偏移量
		protected var cdCheck:Boolean = false;
		protected var _index:int;
		protected var isAiming:Boolean = false;
		protected var _heroName:String = "";
		protected var hp:HealthDisplay;
		protected var fireAction:String="aiming1";
		protected var unfireAction:String="notaiming1"
		protected var currentWepID:int=1;
		protected var wep:WepBase=new Wep1(1);
		private var mass:int = 0;
		private var _healthy:int  = 0;
		/**
		 * 人物旋转之后，炮筒的角度计算不对。。。。   搞定
		 * */
		public function HeroBase(team:String)
		{
			super();
			_content= AssetsLibrary.getMovieClip("hero");
			this.addChild(_content);
			this.team=team;
			this.doAction(defaultAction);
//			
			arrow =  AssetsLibrary.getMovieClip("arrow");
			this.addChild(arrow);	
			arrow.visible = false;
			//血量
			hp=new HealthDisplay(teams.indexOf(team),team);
			this.addChild(hp);
			var i:int=Math.floor(Math.random()*Scene.planets.length);
			_planet=Scene.planets[i];
			var angle:Number=Math.random()*360;
			this.angle = angle;

			this.addEventListener(MouseEvent.MOUSE_OVER,showName);
			this.addEventListener(MouseEvent.MOUSE_OUT,hideName);
		}

		protected function showName(event:MouseEvent):void
		{
			this.hp.healthMc.unitname.visible=true;;
		}
		
		protected function hideName(event:MouseEvent):void
		{
			this.hp.healthMc.unitname.visible=false;
		}
		
		public function active():void
		{
			EnterFrame.addObject(this);
			arrow.visible = true;
			arrow.cndtext.visible = false;
		}
		public function deactive():void
		{
//			EnterFrame.removeObject(this);
			arrow.visible = false;
		}
		public function doAction(name:String):void
		{
			_content.gotoAndStop(name);
			this.updateColor();
		}
		
		public function aimAt(angle:uint):void  //攻击角度，1-180度
		{
			this.isAiming = true;
			this.doAction(fireAction);
			if(angle <= 0) angle = 1;
			if(angle > 180) angle = 180;
			this._content.graphic.gotoAndStop(angle);
		}
		public function onFrame():void
		{			
		}
		
		public function moveLeft():void  
		{
			this.turnLeft();
			this.doAction("walk");
			var an:Number;
			if(this.rotation > 180)
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
			collideCheck(new Point(this.x + moveOnce.x,this.y + moveOnce.y));
			
			_heroRotation=0;
			//if(this.rotation<-360) this.rotation+=360;
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
			/*调试代码 误删
			var checkCell:Shape = new Shape();
			checkCell.graphics.clear();
			checkCell.graphics.beginFill(0xFFFFFF,0.4);
			checkCell.graphics.drawCircle(this.x + moveOnce.x,this.y + moveOnce.y,collideRadius);
			checkCell.graphics.endFill();
			_planet.parent.addChild(checkCell);*/
			
			collideCheck(new Point(this.x + moveOnce.x,this.y + moveOnce.y));
			
			_heroRotation=0;
			//if(this.rotation<-360) this.rotation+=360;
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
				var cd:CollisionData=CDK.check(checkCell,_planet);
				if(cd)		//有碰撞这时point与星球球面有接触了  设置小人位置和方向
				{
					if(cd.overlapping.length>collideRadius*10)			//测试点进入星球太多了 需要调整 使overlapping.length维持在一个值以下
					{
						moveDirection = (this.rotation - 90)*Math.PI/180; 		 //移动方向与rotation相同 实际方向会相差90度 原因不明
						moveOnce = new Point();   								//移动一步位移量
						moveOnce.x = Math.cos(moveDirection)*speed;
						moveOnce.y = Math.sin(moveDirection)*speed;	
						point.x += moveOnce.x;
						point.y += moveOnce.y;
					}
					else
					{
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
					moveDirection = (this.rotation + 90)*Math.PI/180;  //移动方向与rotation相反 实际方向会相差90度 原因不明
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
		
		private function updateColor():void
		{
			var frame:uint=teams.indexOf(_team)+1;
			_content.graphic.head.col.gotoAndStop(frame);
			_content.graphic.body.col.gotoAndStop(frame);
			_content.graphic.lefthand.col.gotoAndStop(frame);
			_content.graphic.righthand.col.gotoAndStop(frame);
			_content.graphic.leftfoot.col.gotoAndStop(frame);
			_content.graphic.rightfoot.col.gotoAndStop(frame);
		}
		
		protected function shoot():void
		{
//			if((currentPath==null)||(currentPath.length==0)) return;
//			var missile:Missile=new Missile(this.currentPath,simulator.planet);
//			Scene.pathCanvas.graphics.clear();
//			Main.scene.addChild(missile);
			if(currentWepID==5){
				var info:Object={x:this.x,y:this.y,rotation:this.rotation}
				wep.heroInfo=info;
			}
			wep.shoot();
			this.doAction(fireAction);
			if(wep.changeAction==true){
				this.unfireAction=defaultAction;
			}
		}
		
		protected var simulator:PathSimulator;
		
		protected function simulatePath(shootX:Number,shootY:Number):void
		{
			var inLeft:Boolean=pointIsLeft(shootX,shootY);
			//todo,以炮管注册点为中心
			//以炮管注册点为中心，炮管的发射方向
			var p:Point=new Point(shootX,shootY);
			p=this.globalToLocal(p);
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
			wep.simulatePath(param,this.index);
//			if(param==null) return;
//			simulator=new PathSimulator(param.strength,param.angle,param.startPos,this.index);
//			currentPath=simulator.simulate(accurate,Scene.pathCanvas.graphics);
		}
		private function pointIsLeft(x:Number,y:Number):Boolean		
		{
			//更简单的算法  实际上 只取决于鼠标横坐标
			var p0:Point=new Point(x,y);
			p0=this.globalToLocal(p0);	
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
			if(wep.start==null) return {};
			var startPos:Point=wep.localToGlobal(new Point(wep.start.x,wep.start.y));
			var dx:Number=shootX-startPos.x;
			var dy:Number=shootY-startPos.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			var ag:Number=_heroRotation*Math.PI/180;
			//trace("_heroRotation"+_heroRotation.toString())
			return {strength:dist/30,angle:shootAngle+ag,startPos:startPos};			
		}
		public function updateMass():void
		{
			mass = health * 5;
			if (mass < 100)
			{
				mass = 100;
			}
		}
		protected function die():void
		{
			
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function set team(value:String):void
		{
			if(_team==value) return;
			_team=value;
			this.updateColor();
		}
		public function get team():String
		{
			return _team;
		}
		
		public function get healthy():int
		{
			return _healthy;
		}
		
		public function set healthy(value:int):void
		{
			_healthy = value;
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
			var radiusAngle:Number=Math.PI*value/180;
			this.x=_planet.radius*Math.cos(radiusAngle)+_planet.x;
			this.y=_planet.radius*Math.sin(radiusAngle)+_planet.y;
			this.rotation = value + 90;
			_heroRotation=0;
			_heroRotation=this.rotation+360;
			if(_heroRotation>360) _heroRotation-=360;
		}
	}
}