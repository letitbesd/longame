package signals
{
	import org.osflash.signals.Signal;

	public class CountDownSignals
	{
		public static var updateSignal:Signal = new Signal();
		public static var completeSignal:Signal = new Signal();
	}
}