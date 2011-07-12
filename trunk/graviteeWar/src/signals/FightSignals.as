package signals
{
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

	public class FightSignals
	{
        public static var onHeroHitted:Signal=new Signal(int,Number,Boolean);
	}
}