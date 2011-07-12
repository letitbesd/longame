package
{
	import AMath.AVector;
	
	import collision.CDK;
	import collision.CollisionData;
	
	import com.longame.modules.components.AbstractComp;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.globalization.CollatorMode;
	
	import heros.Hero;
	public class PathSimulator  
	{
		private static const basicSpeed:Number=15;
		private var startAngle:Number;
		private var startSpeed:Number;
		private var vx:Number;
		private var vy:Number;
		private var x:Number;
		private var y:Number;
		private var rotation:Number;
		private var _planet:Planet;
		private var _path:Vector.<PathNode>=new Vector.<PathNode>();
		private var _steps:int;
		public static var hitHero:Boolean=false;
		public static var heroIndex:int;
		public static var hitAngle:Number;
		private var _diaspatchHeroIndex:int;
		public function PathSimulator(strength:Number,angle:Number,startPos:Point,dispatchHeroIndex:int)
		{
			strength=Math.max(1,strength);
			startSpeed=basicSpeed*strength;
			startAngle=angle;
			this.x=startPos.x;
			this.y=startPos.y;
			vx=startSpeed*Math.cos(this.startAngle);
			vy=startSpeed*Math.sin(this.startAngle);
			this._diaspatchHeroIndex=dispatchHeroIndex;
		}
		public function simulate(steps:int,canvas:Graphics):Vector.<PathNode>
		{ 
			_planet=null;
			_path.length=0;
			
			_steps = steps
			while(steps--){
				if(!step()) break;
			}
			this.draw(canvas);
			return _path;
		}
		public function get planet():Planet
		{
			return _planet;
		}
		private function draw(canvas:Graphics):void
		{
			canvas.clear();
			canvas.lineStyle(1.5,0x66ccff,0.8);
//	        this.drawSolideLine(canvas);
			this.drawDotLine(canvas);
		}
		private function checkCollision():Boolean
		{
			for each(var p:Planet in Scene.planets){
				if(this.checkCollisionWithCircle(p))
				{
					_planet=p;
					return true;
				}
			}
			//与人物碰撞检测
			for each(var h:Hero in Scene.sceneHeros){
				if(this.checkCollisionWithHero(h)){
					return true;
				}
			}
			return false;
		}
		/**
		 * 判断子弹和一个圆形物体circle的碰撞情况，这种判断是假设circle的注册点在圆心,子弹和circle在一个坐标系下
		 * */
		private function checkCollisionWithCircle(planet:Planet):Boolean
		{		
			var checkPart:Shape = new Shape();
			checkPart.graphics.clear();
			checkPart.graphics.beginFill(0x66ccff,0.1);
			checkPart.graphics.drawCircle(this.x,this.y,1);
			checkPart.graphics.endFill();
			
			var cd:CollisionData=CDK.check(checkPart,planet);
			if(cd){
//				var an:Number=cd.angleInRadian;
//				var springParam:Number=0.1;
//				this.x-=cd.overlapping.length*Math.cos(an)*springParam;
//				this.y-=cd.overlapping.length*Math.sin(an)*springParam;
//				trace(cd.overlapping.length+"   cd.overlapping.length");
				return true;
			}else
			{
				return false;
			}
		} 
		private function checkCollisionWithHero(hero:Hero):Boolean
		{
			var checkPart:Shape = new Shape();
			checkPart.graphics.clear();
			checkPart.graphics.beginFill(0x66ccff,0.1);
			checkPart.graphics.drawCircle(this.x,this.y,1);
			checkPart.graphics.endFill();
			var cdk:CollisionData=CDK.check(checkPart,hero._content);
			if(cdk&&hero.index!=this._diaspatchHeroIndex)
			{
				hitHero=true;
				hitAngle=Math.atan2((hero.y-this.y),(hero.x-this.x));
				heroIndex=Scene.sceneHeros.indexOf(hero);
				//判断人物在那个星球上
				for each(var p:Planet in Scene.planets)
				{
					var dist:Number=Math.sqrt((hero.x-p.x)*(hero.x-p.x)+(hero.y-p.y)*(hero.y-p.y));
					if(dist<p.radius+10)  _planet=p;
				}
				 return true;
			}else{
				hitHero=false;
				return false;
			}
		}
		/**
		 * 用虚线画路径
		 * */
		private function drawDotLine(canvas:Graphics):void
		{
			var node:PathNode;
			var node1:PathNode;
			for(var i:int=0;i<_path.length-1;i++){
				if(i%2==0){
					node=_path[i];
					if(i+1<=_path.length-1) node1=_path[i+1];
					if(node1){
						canvas.moveTo(node.x,node.y);
						canvas.lineTo(node1.x,node1.y);
					} 
				}
			}
		}
		
		/**
		 * 用实线画路径
		 * */
		private function drawSolideLine(canvas:Graphics):void
		{
			var node:PathNode;
			node=_path[0];
			canvas.moveTo(node.x,node.y);
			for(var i:int=1;i<_path.length;i++){
				node=_path[i];
				canvas.lineTo(node.x,node.y);
			}
		}
		private function step():Boolean
		{
			var g:AVector=Scene.getAcceleration(this.x,this.y);
			vx+=g.x*0.997;
			vy+=g.y*0.997;
			this.x+=vx*0.0285;
			this.y+=vy*0.0285;
			if(this.checkCollision()){
				return false;
			}
			this.rotation=Math.atan(vy/vx)*180/Math.PI;
			if(vx<0) this.rotation=180+this.rotation;
			var node:PathNode=new PathNode();
			node.x=this.x;
			node.y=this.y;
			node.rotation=this.rotation;
			_path.push(node);
			return true;
		}
	}
}