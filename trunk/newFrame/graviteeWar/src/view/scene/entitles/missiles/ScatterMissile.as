package view.scene.entitles.missiles
{
	import com.collision.CDK;
	import com.collision.CollisionData;
	import com.longame.modules.entities.AnimatorEntity;
	
	import flash.geom.Point;
	
	import view.scene.entitles.Planet;
	/**
	 * WEP2子弹爆炸后的分散子弹
	 * */
	public class ScatterMissile extends AnimatorEntity
	{
		private var _initSpeed:Point;
		private var _currentPlanet:Planet;
		private var _initPos:Point;
		public function ScatterMissile(initSpeed:Point,planet:Planet,initPos:Point)
		{
			super();
			this.source="missile2a";
			this._initSpeed=initSpeed;
			this._currentPlanet=planet;
			this._initPos=initPos;
			trace("***&&*&*");
		}
		
		override protected function doWhenActive():void
		{
		  super.doWhenActive();
		  this.x=_initPos.x;
		  this.y=_initPos.y;
		}
		
		override protected function doWhenDeactive():void
		{
		  super.doWhenDeactive();
		}
		
		override protected function doRender():void
		{
			super.doRender();
			var g:Point=this._currentPlanet.getG(this.x,this.y);
		    _initSpeed.x+=g.x*15;
			_initSpeed.y+=g.y*15;
			this.x+=_initSpeed.x*0.06;
			this.y+=_initSpeed.y*0.06;
			var cd:CollisionData=CDK.check(this.animator.clip,this._currentPlanet.container)
			if(cd){
			
				this._currentPlanet.addHole(this.x,this.y,0.5);
				this.destroy();
			}
		
		}
		
		override public function destroy():void
		{
		  super.destroy();
		}
	}
}