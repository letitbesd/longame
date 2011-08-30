package com.weapons
{
	import com.IFrameObject;
	import com.PathNode;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class Wep10 extends WepBase 
	{
		private var param:Object={};
		private var startPos:Point=new Point();
		private var _heroIndex:int;
		private var shootCount:int=0;
		private var maxCount:int=5;
		private var intervalID:uint;
		private var _path:Vector.<PathNode>;
		public function Wep10(id:int,heroIndex:int)
		{
			super(id);
			this.isAssist=true;
			this._heroIndex=heroIndex;		
			Main.scene.addChild(this);
		}
		override public function simulatePath(param:Object, heroIndex:int):void
		{
			super.simulatePath( param, heroIndex);
//			_path=this.currentPath.concat();
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
			Main.scene.bg.addEventListener(MouseEvent.MOUSE_DOWN,onSceneDown);
		}
		private function onSceneDown(event:MouseEvent):void
		{
		  startPos.x=event.stageX;
		  startPos.y=event.stageY;
		  param.startPos=startPos;
		  this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onSceneMove);
		  this.stage.addEventListener(MouseEvent.MOUSE_UP,onSceneUp);
		}
		private function onSceneMove(event:MouseEvent):void
		{
		  var dist:Number=MathUtil.getDistance(startPos.x,startPos.y,event.stageX,event.stageY);
		  param.strength=dist/30;
		  param.angle=Math.atan2(event.stageY-startPos.y,event.stageX-startPos.x);
		  this.simulatePath(param,this._heroIndex)
		  Main.scene.bg.removeEventListener(MouseEvent.MOUSE_DOWN,onSceneDown);
		}
		private function onSceneUp(event:MouseEvent):void
		{
			var blackHole:MovieClip=AssetsLibrary.getMovieClip("blackhole");
			blackHole.x=startPos.x;
			blackHole.y=startPos.y;
			blackHole.rotation=param.angle*180/Math.PI;
			Main.scene.midLayer.addChild(blackHole);
			this.shoot();
			intervalID=setInterval(this.shoot,500);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSceneMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onSceneUp);
			FightSignals.turnNextHero.dispatch(this._heroIndex,true);
		}
		
	}
}