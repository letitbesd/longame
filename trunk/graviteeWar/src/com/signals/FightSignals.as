package com.signals
{
	import com.PathNode;
	import com.Planet;
	
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

	public class FightSignals
	{
        public static var onHeroHitted:Signal=new Signal(int,Number,Boolean,Boolean);
		public static var turnNextHero:Signal=new Signal(int,Boolean);
		public static var heroDead:Signal=new Signal(int);
		public static var changWep:Signal=new Signal(int);
		public static var heroPoisoned:Signal=new Signal(int);
		public static var roundEnd:Signal=new Signal();
		public static var missileBomded:Signal=new Signal(Planet,PathNode);
	}
}