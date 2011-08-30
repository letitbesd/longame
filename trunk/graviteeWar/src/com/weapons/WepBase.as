package com.weapons
{
	import com.IFrameObject;
	import com.PathNode;
	import com.PathSimulator;
	import com.Scene;
	import com.missiles.MissileBase;
	
	import flash.display.Sprite;
	
	public class WepBase extends Sprite implements IFrameObject
	{
		protected var simulator:PathSimulator;
		protected var currentPath:Vector.<PathNode>;
		protected var wepID:int;   
		protected var maxDamage:int=25;
		protected var damageScopeStrength:Number=1;//爆炸范围系数
		public var changeAction:Boolean=false;
		public var heroInfo:Object;
		/**
		 * 是否为辅助型武器
		 * */
		public var isAssist:Boolean=false;
		public function WepBase(id:int)
		{
			super();
			wepID=id;
		}
		public function simulatePath(param:Object,heroIndex:int):void
		{
			simulator=new PathSimulator(param.strength,param.angle,param.startPos,heroIndex);
			currentPath=simulator.curveSimulate(100,Scene.pathCanvas.graphics);
			
		}
		public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:MissileBase=new MissileBase(this.currentPath,simulator.planet,wepID,damageScopeStrength);
			Scene.pathCanvas.graphics.clear();
			Main.scene.addChild(missile);
		}
		public function setWepPos():void
		{
		
		}
		public function onFrame():void
		{
		
		}
	}
}