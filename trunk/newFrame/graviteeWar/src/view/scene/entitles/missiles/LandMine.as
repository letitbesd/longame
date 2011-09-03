package view.scene.entitles.missiles
{
	import com.collision.util.MathUtil;
	import com.longame.modules.entities.AnimatorEntity;
	
	import flash.utils.setTimeout;
	
	import view.scene.BattleScene;
	import view.scene.entitles.heros.Hero;
	import view.scene.entitles.heros.HeroBase;

	/**
	 * 地雷
	 * */
	public class LandMine extends AnimatorEntity
	{
		private var isOn:Boolean=false;
		private var playSlow:Boolean=true;
		private var count:int=0;
		private var _hero:HeroBase;
		public function LandMine(hero:HeroBase)
		{
			super();
			this.source = "wep5";
			this.x=hero.x-Math.cos((hero.rotation-90)*Math.PI/180)*4;
			this.y=hero.y-Math.sin((hero.rotation-90)*Math.PI/180)*4;
			this.rotation=hero.rotation;
			this.gotoAndStop(2);
			_hero = hero;
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
		}
		
		override protected function doRender():void
		{
			super.doRender();
			if(isOn==false)
			{
				for each (var h:Hero in BattleScene.sceneHeros)
				{
					var dist:Number=MathUtil.getDistance(this.x,this.y,h.x,h.y);
					if(dist<60){
						isOn=true;
						this.play();
					}
				}
			}
			else
			{
				if(playSlow==true)
				{
					if(this.animator.clip.currentFrame==this.animator.clip.totalFrames)
					{
						this.gotoAndStop(1);
						count++;
						if(count>=3) playSlow=false;
						setTimeout(this.play,700);
					}
				}
				else
				{
					this.play();
					setTimeout(this.destroy,1000);
				}
			}
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			this._hero.currentPlanet.addHole(this.x,this.y,1.3);
		}
	}
}