package  com.longame.display.graphics
{
	import flash.display.Graphics;

	public class SolidColorFill implements IFill
	{
		////////////////////////////////////////////////////////////////////////
		//	ID
		////////////////////////////////////////////////////////////////////////
		
		static private var _IDCount:uint = 0;
		
		/**
		 * @private
		 */
		public const UID:uint = _IDCount++;
		
		/**
		 * @private
		 */
		protected var setID:String;
		
		/**
		 * @private
		 */
		public function get id ():String
		{
			return (setID == null || setID == "")?
				"SolidColorFill" + UID.toString():
				setID;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set id (value:String):void
		{
			setID = value;
		}
		
		/**
		 * Constructor
		 */
		public function SolidColorFill (color:uint, alpha:Number)
		{
			this.color = color;
			this.alpha = alpha;			
		}
		
		/**
		 * The fill color.
		 */
		public var color:uint;
		
		/**
		 * The transparency of the fill.
		 */
		public var alpha:Number;
		
		///////////////////////////////////////////////////////////
		//	IFILL
		///////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function begin (target:Graphics):void
		{			
			target.beginFill(color, alpha);
		}
		
		/**
		 * @inheritDoc
		 */
		public function end (target:Graphics):void
		{
			target.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone ():IFill
		{
			return new SolidColorFill(color, alpha);
		}
	}
}