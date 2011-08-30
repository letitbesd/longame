package view.scene.entitles
{
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.OnceClipEntity;
	import com.longame.modules.entities.SpriteEntity;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;

	/**
	 * 尾巴拖太长，todo
	 * */
	public class MissileFire extends AnimatorEntity
	{
		private static const range:Number=90;
		private var missile:Missile;
		public function MissileFire(missile:Missile)
		{
			super();
			this.missile=missile;
//			this.container.filters=[new GlowFilter(0xff0000,0.8,10,10,5)];
		}
		private var currentCount:int=0;
		private var fullTime:int=-1;
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			this.generateFireCell(5);
		}
		
		override public  function destroy():void
		{
			super.destroy();
			if(this.parent) this.parent.remove(this);
			this.missile=null;
		}
		/**
		 * 产生count个火焰粒子
		 * */
		private function generateFireCell(count:uint):void
		{
			var startPoint:Point=missile.getFireStartPoint();
			for (var i:int=0;i<count;i++){
				var cell:OnceClipEntity= new OnceClipEntity();
				cell.source = "fireCell";
//					PlayOnceObject.play(,startPoint.x,startPoint.y,this);
				cell.x = startPoint.x;
				cell.y = startPoint.y;
//				cell.rotation=range/2-range*Math.random();
				cell.rotation=360*Math.random();
			}
		}
	}
}