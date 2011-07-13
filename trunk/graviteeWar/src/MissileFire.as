package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	import com.time.EnterFrame;
	/**
	 * 尾巴拖太长，todo
	 * */
	public class MissileFire extends Sprite implements IFrameObject
	{
		private static const range:Number=90;
		private var missile:Missile;
		public function MissileFire(missile:Missile)
		{
			super();
			this.missile=missile;
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.filters=[new GlowFilter(0xff0000,0.8,10,10,5)];
		}
		private var currentCount:int=0;
		private var fullTime:int=-1;
		public function onFrame():void
		{
			this.generateFireCell(5);
		}
		public function destroy():void
		{
			if(this.parent) this.parent.removeChild(this);
			EnterFrame.removeObject(this);
			this.missile=null;
		}
		private function onAdded(e:Event):void
		{
			EnterFrame.addObject(this);
		}
		/**
		 * 产生count个火焰粒子
		 * */
		private function generateFireCell(count:uint):void
		{
			var startPoint:Point=missile.getFireStartPoint();
			for (var i:int=0;i<count;i++){
				var cell:PlayOnceObject=PlayOnceObject.play("fireCell",startPoint.x,startPoint.y,this);
//				cell.rotation=range/2-range*Math.random();
				cell.rotation=360*Math.random();
			}
		}
	}
}