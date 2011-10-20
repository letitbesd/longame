package view.scene.entitles.missiles
{
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.collision.util.MathUtil;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.InputManager;
	import com.longame.modules.entities.AnimatorEntity;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import signals.FightSignals;
	
	import view.scene.BattleScene;
	import view.scene.entitles.Planet;
	
	public class Lightning extends AnimatorEntity
	{
		private var _startNode:MovieClip; //起始节点
		private var _endNode:MovieClip;   //结束节点
		private var _pathLine:Shape;    //节点之间的连线
		private var _farthestX:Number=-1;  //
		private var _farthestY:Number=-1;
		private var _dist:Number;
		private var _checkPart:Shape;
		private var _angle:Number;
		private var _isMove:Boolean;
		private var _heroIndex:int;
		public function Lightning(heroIndex:int)
		{
			super();
			this.source = "lightning";
		    this._heroIndex=heroIndex;	
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			this.animator.clip.visible=false;
			InputManager.onMouseDown.add(onMouseDown);
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			trace("add");
		   _startNode = AssetsLibrary.getMovieClip("lightningNode");
		   _startNode.x=event.stageX;
		   _startNode.y=event.stageY;
		   _pathLine=new Shape();
		   _checkPart=new Shape();
		   _checkPart.graphics.clear();
		   _checkPart.graphics.beginFill(0xffffff,0.2);
		   _checkPart.graphics.drawCircle(0,0,8);
		   _checkPart.graphics.endFill();
		   this.scene.container.addChild(_startNode);
		   InputManager.onMouseMove.add(onMouseMove);
		   InputManager.onMouseUp.add(onMouseUp);
		   _endNode = AssetsLibrary.getMovieClip("lightningNode");
		   this.scene.container.addChild(_endNode);
		   InputManager.onMouseDown.remove(onMouseDown);
		   
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			_checkPart.x=event.stageX;
			_checkPart.y=event.stageY;
			_angle=Math.atan2((_checkPart.y-_startNode.y),(_checkPart.x-_startNode.x));
			if(_angle<0) _angle +=Math.PI*2;
			_dist=MathUtil.getDistance(_startNode.x,_startNode.y,_checkPart.x,_checkPart.y);
			if(_dist>100){
				_checkPart.x=Math.cos(_angle)*100+_startNode.x;
				_checkPart.y=Math.sin(_angle)*100+_startNode.y;
				_farthestX=_checkPart.x;
				_farthestY=_checkPart.y;
			}
			_startNode.visible=true;
			_isMove=true;
			if(this.checkCollisionWithPlanet()==false){
				_endNode.x=_checkPart.x;
				_endNode.y=_checkPart.y;
			}
			_endNode.visible=true;
			if(_dist<20) return;
			_pathLine.graphics.clear();
			_pathLine.graphics.moveTo(_startNode.x,_startNode.y);
			_pathLine.graphics.lineStyle(1.5,0x66ccff,0.8);
			_pathLine.graphics.lineTo(_endNode.x,_endNode.y);
			this.scene.container.addChild(_pathLine);
		}
		
		
		private function onMouseUp(event:MouseEvent):void
		{
			this.animator.clip.visible=true;
			this.play();
			if(_isMove==false){
				InputManager.onMouseMove.remove(onMouseMove);
				return;
			} 
			_endNode.x=_checkPart.x;
			_endNode.y=_checkPart.y;
			_pathLine.graphics.endFill();
			if(_dist<100){
				this.scaleY=_dist/100;
			}
			this.x=_startNode.x;
			this.y=_startNode.y;
			this.rotation=_angle*180/Math.PI-90;
			_pathLine.visible=false;
			BattleScene.lightnings.push(_pathLine);
			InputManager.onMouseMove.remove(onMouseMove);
			InputManager.onMouseUp.remove(onMouseUp);
			FightSignals.turnNextHero.dispatch(this._heroIndex,true);
		}
		private function checkCollisionWithPlanet():Boolean
		{
			for each (var p:Planet in BattleScene.planets)
			{
				var cd:CollisionData=CDK.check(_checkPart,p.container);
				if(cd)
				{
					return true;
				}
			}
			return false;
		}
  }
}