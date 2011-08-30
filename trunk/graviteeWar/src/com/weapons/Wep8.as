package com.weapons
{
	import collision.CDK;
	import collision.CollisionData;
	
	import com.IFrameObject;
	import com.Planet;
	import com.Scene;
	import com.heros.Hero;
	import com.heros.HeroBase;
	import com.signals.FightSignals;
	import com.time.EnterFrame;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class Wep8 extends WepBase 
	{
		/**
		 *  检测用圆球，使鼠标点击PLANET周围一定范围人物也能瞬移过去
		 * */
		private var checkPart:Shape;
		private var currentHero:HeroBase;
		private var angle:Number;
		private var isCheck:Boolean;
		/**
		 * 检测用圆球，位置在HERO注册点，用于调整HERO瞬移过去后能正确ROTATION
		 * */
		private var circle:Shape;
		private var currentPlanet:Planet;   //HERO所在的星球
		public function Wep8(id:int,hero:HeroBase)
		{
			super(id);
			this.isAssist=true;
			currentHero=hero;
			checkPart=new Shape();
			checkPart.graphics.beginFill(0xffffff,0.3);
			checkPart.graphics.drawCircle(0,0,20);
			checkPart.graphics.endFill();
			Main.scene.addChild(checkPart)
			circle=new Shape();
			circle.graphics.beginFill(0xFFFFFF,0.3);
			circle.graphics.drawCircle(0,0,7);
			circle.graphics.endFill();
			Main.scene.addChild(circle)
		}
		override public function setWepPos():void
		{
			//点击
			Main.scene.addEventListener(MouseEvent.CLICK,onStageClick)
		}
		private function onStageClick(event:MouseEvent):void
		{
			//检测圆球位置调整到鼠标点击点的位置
			checkPart.visible=false;
			checkPart.x=event.stageX;
			checkPart.y=event.stageY;
			//与场景内星球做碰撞检测
			for each (var p:Planet in Scene.planets)
			{
				var cd:CollisionData=CDK.check(checkPart,p);
				if(cd)
				{
					if(cd.overlapping.length>1320) return; //如果重叠区域像素大于1320 说明检测圆球已经被星球完全覆盖 RETURN
					//如果重叠区域像素大于664 说明检测圆球进入星球一半多 ，往外调整 否则向球心方向调整
					if(cd.overlapping.length>664){
					 checkPart.x-=cd.overlapping.length*Math.cos(cd.angleInRadian)*0.01;
					 checkPart.y-=cd.overlapping.length*Math.sin(cd.angleInRadian)*0.01;
					}else{
						checkPart.x+=(664-cd.overlapping.length)*Math.cos(cd.angleInRadian)*0.03;
						checkPart.y+=(664-cd.overlapping.length)*Math.sin(cd.angleInRadian)*0.03;
					}
					currentHero.doAction("teleportout");  //做动作
					FightSignals.turnNextHero.dispatch(currentHero.index,true);
					EnterFrame.addObject(this);
					Main.scene.removeEventListener(MouseEvent.CLICK,onStageClick)
					currentPlanet=p;  //更新HERO所在星球
					currentHero._planet=p;
			    }
		    }
		}
		override public function onFrame():void
		{
			if(currentHero._content.graphic.currentFrame>=40&&isCheck==false) //如果第一个动作做完了
			{
				trace("&&&*&*&*");
				//调整HERO位置
				currentHero.x=checkPart.x;
				currentHero.y=checkPart.y;
				if(checkPart.parent) checkPart.parent.removeChild(checkPart);  //移除检测圆球
				circle.x=currentHero.x;	
				circle.y=currentHero.y;
				//获得CIRCLE与星球碰撞角度
				var cd1:CollisionData=CDK.check(circle,currentPlanet);
				if(cd1){
					angle=cd1.angleInDegree-90;
					if(circle.parent) circle.parent.removeChild(circle);
				}
				currentHero.rotation=angle;
				currentHero.doAction("teleportin");
				isCheck=true;
			}
			if(currentHero._content.graphic.currentFrame>=40&&isCheck==true)  //如果第二个动作做完了
			{
				currentHero.doAction("bob");
				EnterFrame.removeObject(this);
			}
		}
	}
}