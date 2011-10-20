package view.scene.entitles.heros.weapons
{
	
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.longame.managers.InputManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.scene.entitles.Planet;
	import view.scene.entitles.heros.HeroBase;

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
		public function Wep8(hero:HeroBase)
		{
			super(hero);
			this.isAssist=true;
			currentHero=hero;
			checkPart=new Shape();
			checkPart.graphics.beginFill(0xffffff,0.3);
			checkPart.graphics.drawCircle(0,0,20);
			checkPart.graphics.endFill();
		}
		override public function setWepPos():void
		{
			//点击
//			BattleScene.addEventListener(MouseEvent.CLICK,onStageClick)
			InputManager.onMouseDown.add(onStageClick);
		}
		private function onStageClick(event:MouseEvent):void
		{
			//检测圆球位置调整到鼠标点击点的位置
//			checkPart.visible=false;
			checkPart.x=event.stageX;
			checkPart.y=event.stageY;
			currentHero.scene.container.addChild(checkPart);
//			checkPart.visible=false;
			//与场景内星球做碰撞检测
			for each (var p:Planet in BattleScene.planets)
			{
				var cd:CollisionData=CDK.check(checkPart,p.container);
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
					FightSignals.turnNextHero.dispatch(currentHero.heroIndex,true);
//					EnterFrame.addObject(this);
					InputManager.onMouseDown.remove(onStageClick);
					currentHero.currentPlanet=p;
					currentHero.teleport(checkPart);
			    }
		    }
		}
	}
}