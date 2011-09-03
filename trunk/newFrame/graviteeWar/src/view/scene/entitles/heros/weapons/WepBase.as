package view.scene.entitles.heros.weapons
{
	
	import com.longame.modules.entities.AnimatorEntity;
	
	import flash.display.Sprite;
	
	import view.scene.BattleScene;
	import view.scene.entitles.IFrameObject;
	import view.scene.entitles.Missile;
	import view.scene.entitles.PathNode;
	import view.scene.entitles.PathSimulator;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;
	import view.scene.entitles.missiles.MissileBase;
	
	public class WepBase  implements IFrameObject
	{
		protected var simulator:PathSimulator;
		protected var currentPath:Vector.<PathNode>;
		protected var wepID:int=1;   
		protected var maxDamage:int=25;
		protected var damageScope:Number=1;//爆炸范围系数
		protected var heroIndex:int;
		public var changeAction:Boolean=false;
		public var heroInfo:Object;
		/**
		 * 是否为辅助型武器
		 * */
		public var isAssist:Boolean=false;
		protected var _hero:HeroBase;
		public function WepBase(hero:HeroBase)
		{
			super();
			this._hero = hero;
		}
		public function simulatePath(param:Object):void
		{
			simulator=new PathSimulator(param.strength,param.angle,param.startPos,this._hero.heroIndex);
			currentPath=simulator.curveSimulate(100,BattleScene.pathCanvas.graphics);
			
		}
		public function shoot():void
		{
			if((currentPath==null)||(currentPath.length==0)) return;
			var missile:MissileBase=new MissileBase(this.currentPath,simulator.planet,wepID,damageScope);
			BattleScene.pathCanvas.graphics.clear();
			this._hero.scene.add(missile);
		}
		
		public function setWepPos():void
		{
		
		}
		public function onFrame():void
		{
		
		}
	}
}