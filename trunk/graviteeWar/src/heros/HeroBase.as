package heros
{
	import AMath.AVector;
	import AMath.Vector2D;
	
	import collision.CDK;
	import collision.CollisionData;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	import time.EnterFrame;
	
	public class HeroBase extends Sprite implements IFrameObject
	{
		public static const speed:Number=2;
		public static const teams:Array=["white","red","blue","green","yellow"]; 	
		public static const defaultAction:String="bob";
		private static const collideRadius:Number = 5;
		
		public var accurate:int=50;				//玩家的射击精确度，实际就是显示子弹运行路径的长短
		protected var _team:String;
		public var _content:MovieClip;
		protected var shootAngle:Number;
		protected var _planet:Planet;
		protected var atRight:Boolean=false;
		protected var isAiming:Boolean = false;
		protected var heroRotation:Number=0;
		protected var cdCheck:Boolean = false;
		protected var _index:int;
		/**
		 * 人物旋转之后，炮筒的角度计算不对。。。。
		 * */
		public function HeroBase(team:String)
		{
			super();
			_content=Main.getMovieClip("hero");
			this.addChild(_content);
			this.team=team;
			this.doAction(defaultAction);
			var i:int=Math.floor(Math.random()*Scene.planets.length);
			_planet=Scene.planets[i];
			var angle:Number=Math.random()*360;
			
			var radiusAngle:Number=Math.PI*270/180;
			this.x=_planet.radius*Math.cos(radiusAngle)+_planet.x;
			this.y=_planet.radius*Math.sin(radiusAngle)+_planet.y;
			this.rotation=360;	
			
			this.addEventListener(MouseEvent.MOUSE_OVER,showName);
			this.addEventListener(MouseEvent.MOUSE_OUT,hideName);
		}
		
		protected function showName(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		}
		
		protected function hideName(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		}
		
		public function active():void
		{
			EnterFrame.addObject(this);
		}
		public function deactive():void
		{
			EnterFrame.removeObject(this);
		}
		public function doAction(name:String):void
		{
			_content.gotoAndStop(name);
			this.updateColor();
		}
		
		public function aimAt(angle:uint):void  //攻击角度，1-180度
		{
			this.isAiming = true;
			this.doAction("aiming7");
			trace("aim at"+angle);
			if(angle==0) angle=1;
			//if(angle>180&&angle<300) angle=180;
			//if(angle>=300) angle=0;
			if(angle < 0) angle = 1;
			if(angle > 180) angle = 180;
			if(angle == 180) angle = 1;			
			this._content.graphic.gotoAndStop(angle);
		}
		public function onFrame():void
		{			
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
		
		public function moveLeft():void  
		{
			this.turnLeft();
			this.doAction("walk");
			var an:Number;
			if(this.rotation > 180)
				an = this.rotation - 180;
			else
				an = this.rotation + 180;
			var moveDirection:Number = an*Math.PI/180;  //移动方向垂直于rotation 实际方向会相差90度 原因不明
			var moveOnce:Point = new Point();   //移动一步位移量
			moveOnce.x = Math.cos(moveDirection)*speed;
			moveOnce.y = Math.sin(moveDirection)*speed;
			
			collideCheck(new Point(this.x + moveOnce.x,this.y + moveOnce.y));
			
			heroRotation=0;
			//if(this.rotation<-360) this.rotation+=360;
			heroRotation=this.rotation+360;
			if(heroRotation>360) heroRotation-=360;
			trace("heroRotation" + heroRotation.toString());
		}
		
		public function moveRight():void
		{
			this.turnRight();
			this.doAction("walk");
			var moveDirection:Number = this.rotation*Math.PI/180;  //移动方向垂直于rotation 实际方向会相差90度 原因不明
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
			
			heroRotation=0;
			//if(this.rotation<-360) this.rotation+=360;
			heroRotation=this.rotation+360;
			if(heroRotation>360) heroRotation-=360;
			trace("heroRotation" + heroRotation.toString());
		}
		
		private function collideCheck(point:Point):void  
			//参数是碰撞测试点  检查该点是否和星球碰撞 若不碰撞 向下调 若碰撞太多 向上调 调整后再执行检查
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
			atRight=false;
		}
		
		protected function turnRight():void
		{
			if(this.scaleX==-1) return;
			this.scaleX=-1;
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
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:Missile=new Missile(this.currentPath,simulator.planet);
			Scene.pathCanvas.graphics.clear();
			Main.scene.addChild(missile);
			this.doAction("notaiming7");
		}
		
		private var simulator:PathSimulator;
		
		protected function simulatePath(shootX:Number,shootY:Number):void
		{
			var inLeft:Boolean=pointIsLeft(shootX,shootY);
			//todo,以炮管注册点为中心
			//以炮管注册点为中心，炮管的发射方向
			var p:Point=new Point(shootX,shootY);
			p=this.globalToLocal(p);
			this.shootAngle=Math.atan2(p.y,p.x);
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
			if(param==null) return;
			simulator=new PathSimulator(param.strength,param.angle,param.startPos);
			currentPath=simulator.simulate(accurate,Scene.pathCanvas.graphics);
		}
		
		private function pointIsLeft(x:Number,y:Number):Boolean		
			//鼠标点击并移动后 判断小人是否向左  方法是找到分割小人左右的那条直线的方程 把鼠标X Y值代入看是否>=0
		{
			/*调试代码 误删
			//判断全局坐标系下的点x,y是否在人物和圆心连线的左边  此算法只有在星球完整的时候正确   
			//注意trace斜率K之后 发现 不管小人走到哪  K一直是无穷大  且atan(K)一直是90度  
			//这说明小人的rotation变化之后 以他为准的坐标系也随之旋转
			var p:Point=new Point(_planet.x,_planet.y);
			p=_planet.parent.localToGlobal(p);
			p=this.globalToLocal(p);	
			if(p.x<0) p.x=0;
			
			var p1:Point=new Point(x,y);
			p1=this.globalToLocal(p1);
			
			var numberX:Number=p1.x;
			if(atRight==true) p1.x=-numberX;
			//trace("斜率"+Math.atan2(p.y,p.x)*180/Math.PI);
			trace("斜率"+p.y/p.x);
			return (p.y/p.x)*p1.x-p1.y<=0;
			*/						
			
			/*基于直线方程的算法  此算法正确
			var p0:Point=new Point(x,y);
			p0=this.globalToLocal(p0);		
			var numberX:Number=p0.x;
			if(atRight==true) p0.x=-numberX;		
			
			var k:Number = Number.MAX_VALUE;		
			//小人的rotation变化之后 以他为准的坐标系也随之旋转  所以以小人为准建立坐标系的话(此例中就是把p0转为小人的坐标系下)
			//判断小人向左还是向右的这直线的斜率K总是无穷大的(角度总是90度)
			return p0.y - k*p0.x >= 0;*/
			
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
			var startPos:Point=wep.localToGlobal(new Point(wep.start.x,wep.start.y));
			var dx:Number=shootX-startPos.x;
			var dy:Number=shootY-startPos.y;
			var dist:Number=Math.sqrt(dx*dx+dy*dy);
			var ag:Number=heroRotation*Math.PI/180;
			trace("heroRotation"+heroRotation.toString());
			trace("shootAngle"+shootAngle*180/Math.PI);
			//trace("heroRotation"+heroRotation.toString())
			return {strength:dist/30,angle:shootAngle+ag,startPos:startPos};			
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
	}
}