package com.weapons
{
	import collision.CDK;
	import collision.CollisionData;
	
	import com.Planet;
	import com.Scene;
	import com.longame.managers.AssetsLibrary;
	import com.longame.utils.MathUtil;
	import com.signals.FightSignals;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Wep6 extends WepBase
	{
		private var _startNode:MovieClip;
		private var _endNode:MovieClip;
		private var _pathLine:Shape;
		private var _heroIndex:int;
		private var _farthestX:Number=-1;
		private var _farthestY:Number=-1;
		private var _dist:Number;
		private var _lightning:MovieClip;
		private var _angle:Number;
		private var _isMove:Boolean;
		private var _checkPart:Shape;
		public function Wep6(id:int)
		{
			super(id);
			this.isAssist=true;
			_startNode=AssetsLibrary.getMovieClip("lightningNode");
			this.addChild(_startNode)
			_startNode.visible=false;
			_endNode=AssetsLibrary.getMovieClip("lightningNode");
			_lightning=AssetsLibrary.getMovieClip("lightning");
			_endNode.visible=false;
			this.addChild(_endNode);
			Main.scene.midLayer.addChild(this);
			_checkPart=new Shape();
			_checkPart.graphics.clear();
			_checkPart.graphics.beginFill(0xffffff,0.2);
			_checkPart.graphics.drawCircle(0,0,8);
			_checkPart.graphics.endFill();
			
		}
		override public function simulatePath(param:Object, heroIndex:int):void
		{
			this._heroIndex=heroIndex;
		}
		override public function setWepPos():void
		{
			Main.scene.bg.addEventListener(MouseEvent.MOUSE_DOWN,onSceneDown);
		}
		
		private function onSceneDown(event:MouseEvent):void
		{
			_startNode.x=event.stageX;
			_startNode.y=event.stageY;
			_pathLine=new Shape();
			Main.scene.midLayer.addChild(_pathLine);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
		}
		private function onStageMove(event:MouseEvent):void
		{
			_checkPart.x=event.stageX;
			_checkPart.y=event.stageY;
			_dist=MathUtil.getDistance(_startNode.x,_startNode.y,_checkPart.x,_checkPart.y);
			if(_dist>100){
				_checkPart.x=Math.cos(_angle)*100+_startNode.x;
				_checkPart.y=Math.sin(_angle)*100+_startNode.y;
				_farthestX=_checkPart.x;
				_farthestY=_checkPart.x;
			}
			_startNode.visible=true;
			_isMove=true;
			if(this.checkCollisionWithPlanet()==false){
				_endNode.x=_checkPart.x;
				_endNode.y=_checkPart.y;
			}
			_endNode.visible=true;
			if(_dist<20) return;
			_angle=Math.atan2((_endNode.y-_startNode.y),(_endNode.x-_startNode.x));
			_pathLine.graphics.clear();
			_pathLine.graphics.moveTo(_startNode.x,_startNode.y);
			_pathLine.graphics.lineStyle(1.5,0x66ccff,0.8);
			_pathLine.graphics.lineTo(_endNode.x,_endNode.y);
		}
		private function onStageUp(event:MouseEvent):void
		{
			if(_isMove==false){
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
				return;
			} 
			_endNode.x=_checkPart.x;
			_endNode.y=_checkPart.y;
			_pathLine.graphics.endFill();
			if(_dist<100){
				_lightning.scaleY=_dist/100;
			}
			_lightning.x=_startNode.x;
			_lightning.y=_startNode.y;
			_lightning.rotation=_angle*180/Math.PI-90;
			this.addChild(_lightning);
			_pathLine.visible=false;
			Scene.lightnings.push(_pathLine);
			Main.scene.bg.removeEventListener(MouseEvent.MOUSE_DOWN,onSceneDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
			this.stage.removeEventListener(MouseEvent.CLICK,onSceneDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
			FightSignals.turnNextHero.dispatch(this._heroIndex,true);
		}
		private function checkCollisionWithPlanet():Boolean
		{
			for each (var p:Planet in Scene.planets)
			{
		   	var cd:CollisionData=CDK.check(_checkPart,p);
		  	 if(cd){
		   		return true;
			 }
		    }
			return false;
		}
	}
}