package com.longame.modules.components
{
	import com.longame.managers.InputManager;
	import com.longame.model.Direction;
	import com.longame.modules.core.EntityTile;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.scenes.SceneManager;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	/**
	 * 四个按键来决定对象的8个行走方向，目前两个问题待解决：
	 * 1. 走的时候是随玩家控制，不走方格中心，在某些时候可能会有问题，至少要让它停止的时候在网格中心
	 * 2. 没有碰撞检测，目前哪里都可以走
	 * */
	public class KeyboardController extends TickedComp
	{
		public var speed:Number=3;
		[Link]
		public var mover:PathComp;
		//方向键控制方案
		public static const ARROW_KEYS:Array=[Keyboard.UP,Keyboard.DOWN,Keyboard.LEFT,Keyboard.RIGHT];
		//WSAD字母键控制方案
		public static const WASD_KEYS:Array=[Keyboard.W,Keyboard.S,Keyboard.A,Keyboard.D];
		//2.5D场景中，方向控制和2D不一样，如按UP按钮，实际是要往左上方走才符合视觉效果
		private static const directionsInD25:Array=[Direction.LEFT_UP,Direction.RIGHT_DOWN,Direction.LEFT_DOWN,Direction.RIGHT_UP,Direction.LEFT,Direction.RIGHT,Direction.UP,Direction.DOWN];
		
		//默认WSAD字母控制方案
		private var _controlKeys:Array=WASD_KEYS;
		
		public function KeyboardController()
		{
			super();
		}
		/**
		 * 设定四个方向上的控制按键，斜角方向自动对应，比如设置了LEFT/UP,那么LEFT和UP同时按下，则斜向上运动
		 * keys示例：[Keyboard.W,Keyboard.S,Keyboard.A,Keyboard.D]，用字母WSAD来控制方向
		 * */
		public function setKeys(keys:Array):void
		{
			if(keys==null) return;
			if(keys.length!=4) throw new Error("keys should be a four elments Array!");
			_controlKeys=keys;
		}
		override protected function doWhenActive():void
		{
			if(!(_owner is Character)) throw new Error("KeyboardController can only be used by Character!");
			super.doWhenActive();
		}
		private var pressedDirections:Array;
		private var releasedDirections:Array;
		private var currentDirect:int=-1;
		private var stopPosition:Point;

		override public function onTick(deltaTime:Number):void
		{
		   pressedDirections=[];
		   for(var i:int=0;i<4;i++){
			   if(InputManager.isKeyDown(_controlKeys[i])) {
				   pressedDirections.push(i)
			   }
		   }
		   var direct:int=-1;
		   if(pressedDirections.length){
			   if(pressedDirections.length==1){
				   direct=pressedDirections[0];
			   }else if(pressedDirections.length==2){
				   direct=Direction.getDiagonalDirection(pressedDirections[0],pressedDirections[1]);
			   }  
			   //如果是2.5D场景，那么控制会有所不一样
			   if((direct>-1)&&(SceneManager.sceneType==SceneManager.D25)) direct=directionsInD25[direct];
		   }
		   if(currentDirect!=direct){
			   currentDirect=direct;
			   if(direct>-1){
				   mover.moveOnDirection(currentDirect);
//				   (_owner as Character).mover.setV1(speed,Direction.getDegree(currentDirect));
//				   (owner as Character).direction=currentDirect;
			   }else{
				   mover.stop();			   
//				   var nextX:int=(_owner as Character).tileBounds.x+Direction.dx[direct];
//				   var nextY:int=(_owner as Character).tileBounds.y+Direction.dy[direct];
//				   var nextTile:EntityTile=(_owner as Character).parent.map.getTile(nextX,nextY) as EntityTile;
//				   if(nextTile){
//					   if(nextTile.walkable)
//					   {
//						   stopPosition=(_owner as Character).getSnappedPositionInTile(nextX,nextY);
//					   }else{
//						   return;
//					   }
//				   }else{
//					   return;
//				   }
			   }
		   }
//		   if(stopPosition){
//			   var dist:Number=Point.distance(stopPosition,new Point((_owner as Character).x,(_owner as Character).y));
//			   trace(dist);
//			   if(dist<speed){
//				   (_owner as Character).x=stopPosition.x;
//				   (_owner as Character).y=stopPosition.y;
//				   (_owner as Character).velocity.setV1(0,0.0);
//				   stopPosition=null;
//			   }else{
//				   (_owner as Character).velocity.setV(speed,Direction.getDegree(currentDirect));
//				   (owner as Character).direction=currentDirect;
//			   }
//			   return;
//		   }
		}
		
		/**
		 * 当前物体可以无障碍向此方向d移动
		 * */			
		public function isWalkableDirection(d:int):Boolean
		{
			//面前那个单元格
			var tileX:int=(_owner as Character).tileBounds.x;
			var tileY:int=(_owner as Character).tileBounds.y;
			var p:Point=(_owner as Character).parent.localToGlobal(new Vector3D(tileX,tileY,0),true);
			var nextX:int=p.x+Direction.dx[d];
			var nextY:int=p.y+Direction.dy[d];
			var nextTile:EntityTile=(_owner as Character).scene.map.getTile(nextX,nextY) as EntityTile;
			//如果面前那个单元格到了地图范围之外
			if(nextTile==null){
				//以当前单元格中心点为基准，超过了就不让走了
				var center:Point=SceneManager.getTilePosition(tileX,tileY);
				//如果当前单元格的中心点在d的正前方，表示还可以走一截，否则到此为止
				return Direction.isInTheDirection(new Point((_owner as Character).x,(_owner as Character).y),center,d);
			}
			//如果不能walkable，并和this是否有碰撞，有则不可行走
			for each(var ch:IDisplayEntity in nextTile.children){
				if(ch==_owner) continue;
				if(ch.walkable) continue;
				if(ch.bounds.intersects((_owner as Character).bounds)){
					return false;
				}
			}			
			return true;
		}	
	}
}