package signals
{
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.SingleSignal;

	public class FightSignals
	{
		public static var fightStart:Signal = new Signal();
        public static var onHeroHitted:Signal=new Signal(int,Number,Boolean,Boolean);
//		public static var turnNextHero:Signal=new Signal(int);
		public static var attackComplete:Signal = new Signal(uint);
		public static var gameOver:Signal = new Signal(); 
	}
}