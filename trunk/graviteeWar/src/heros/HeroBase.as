package heros
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	import time.EnterFrame;
	
	public class HeroBase extends Sprite implements IFrameObject
	{
		public static const speed:Number=2;
		public static const teams:Array=["white","red","blue","green","yellow"]; 	
		public static const defaultAction:String="bob";
		
		/**
		 * 玩家的射击精确度，实际就是显示子弹运行路径的长短
		 * */
		public var accurate:int=50;
		protected var _team:String;
		protected var _content:MovieClip;
		protected var shootAngle:Number;
		/**
		 * 
		 * */
		protected var _planet:Planet;
		protected var atRight:Boolean=false;
		protected var _angle:Number;
		protected var heroRotation:Number=0;
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
//			_content.scaleX=_content.scaleY=1.5;
			var i:int=Math.floor(Math.random()*Scene.planets.length);
			_planet=Scene.planets[i];
			var angle:Number=Math.random()*360;
			this.angle=270;//angle;
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
		/**
		 * 攻击角度，1-180度
		 * */
		public function aimAt(angle:uint):void
		{
			this.doAction("aiming7");
			//todo
//			angle-=this.angle;
//			trace(angle-this.angle,360+angle-this.angle);
			if(angle==0) angle=1;
			if(angle>180&&angle<300) angle=180;
			if(angle>300) angle=0;
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
		/**
		 * 人物基于球中心的角度，也就决定了人物的位置
		 * 和flash坐标系中的角度一致
		 * */
		public function get angle():Number
		{
			return _angle;
		}
		public function set angle(value:Number):void
		{
			if(_angle==value) return;
			_angle=value;
			var radiusAngle:Number=Math.PI*value/180;
			this.x=_planet.radius*Math.cos(radiusAngle)+_planet.x;
			this.y=_planet.radius*Math.sin(radiusAngle)+_planet.y;
			this.rotation=value+90;
		}
		public function moveLeft():void
		{
			this.turnLeft();
			this.doAction("walk");
			this.angle-=speed;
//			heroRotation=0
			if(this._angle<-360) this._angle+=360;
			heroRotation=this._angle-270;
			if(heroRotation<-360) heroRotation+=360;
			
			
		}
		public function moveRight():void
		{
			this.turnRight();
			this.doAction("walk");
			this.angle+=speed;
			if(this._angle>360) this._angle-=360;
//			heroRotation=0
			heroRotation=this._angle-270;
			if(heroRotation>360) heroRotation-=360;
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
		/**
		 * 
		 * 判断全局坐标系下的点x,y是否在人物和圆心连线的左边
		 * */
		private function pointIsLeft(x:Number,y:Number):Boolean
		{
			var p:Point=new Point(_planet.x,_planet.y);
			p=_planet.parent.localToGlobal(p);
			p=this.globalToLocal(p);	
			if(p.x<0) p.x=0;
			var p1:Point=new Point(x,y);
			p1=this.globalToLocal(p1);
			var numberX:Number=p1.x;
			if(atRight==true) p1.x=-numberX;
			return (p.y/p.x)*p1.x-p1.y<=0;
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
			return {strength:dist/30,angle:shootAngle+ag,startPos:startPos};
		}
	}
}