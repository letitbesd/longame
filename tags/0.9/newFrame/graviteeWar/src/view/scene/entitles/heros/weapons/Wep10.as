package view.scene.entitles.heros.weapons
{
	import com.collision.util.MathUtil;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.InputManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import signals.FightSignals;
	
	import view.scene.entitles.PathNode;
	import view.scene.entitles.heros.HeroBase;

	public class Wep10 extends WepBase 
	{
		private var param:Object={};
		private var startPos:Point=new Point();
		private var _heroIndex:int;
		private var shootCount:int=0;
		private var maxCount:int=5;
		private var intervalID:uint;
		private var _path:Vector.<PathNode>;
		public function Wep10(hero:HeroBase)
		{
			super(hero);
			this.isAssist=true;
			this.wepID=10;
		}
		override public function simulatePath(param:Object):void
		{
			super.simulatePath( param);
		}
		override public function shoot():void
		{
//			this.currentPath=_path;
			super.shoot();
			shootCount++;
			if(shootCount>=maxCount) clearInterval(intervalID);
		}
		override public function setWepPos():void
		{
			InputManager.onMouseDown.add(onSceneDown);
		}
		private function onSceneDown(event:MouseEvent):void
		{
		  startPos.x=event.stageX;
		  startPos.y=event.stageY;
		  param.startPos=startPos;
		  InputManager.onMouseMove.add(onSceneMove);
		  InputManager.onMouseUp.add(onSceneUp);
		}
		private function onSceneMove(event:MouseEvent):void
		{
		  var dist:Number=MathUtil.getDistance(startPos.x,startPos.y,event.stageX,event.stageY);
		  param.strength=dist/30;
		  param.angle=Math.atan2(event.stageY-startPos.y,event.stageX-startPos.x);
		  this.simulatePath(param)
		  InputManager.onMouseDown.remove(onSceneDown);
		}
		private function onSceneUp(event:MouseEvent):void
		{
			var blackHole:MovieClip=AssetsLibrary.getMovieClip("blackhole");
			blackHole.x=startPos.x;
			blackHole.y=startPos.y;
			blackHole.rotation=param.angle*180/Math.PI;
			this._hero.scene.container.addChild(blackHole);
			this.shoot();
			intervalID=setInterval(this.shoot,500);
			InputManager.onMouseMove.remove(onSceneMove);
			InputManager.onMouseUp.remove(onSceneUp);
			FightSignals.turnNextHero.dispatch(this._heroIndex,true);
		}
		
	}
}