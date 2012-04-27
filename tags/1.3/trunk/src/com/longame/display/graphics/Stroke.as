package com.longame.display.graphics
{
	import flash.display.Graphics;
	
	/**
	 * The Stroke class defines the properties for a line.
	 */
	public class Stroke implements IStroke
	{
		/**
		 * The line weight, in pixels.
		 */
		public var weight:Number;
		
		/**
		 * The line color.
		 */
		public var color:uint;
		
		/**
		 * The transparency of the line.
		 */
		public var alpha:Number;
		
		/**
		 * Specifies whether to hint strokes to full pixels.
		 */
		public var usePixelHinting:Boolean;
		
		/**
		 * Specifies how to scale a stroke.
		 */
		public var scaleMode:String;
		
		/**
		 * Specifies the type of caps at the end of lines.
		 */
		public var caps:String;
		
		/**
		 * Specifies the type of joint appearance used at angles.
		 */
		public var joints:String;
		
		/**
		 * Indicates the limit at which a miter is cut off.
		 */
		public var miterLimit:Number;
		
		/**
		 * Constructor
		 */
		public function Stroke (weight:Number,
								color:uint,
								alpha:Number = 1,
								usePixelHinting:Boolean = false,
								scaleMode:String = "normal",
								caps:String = null,
								joints:String = null,
								miterLimit:Number = 0)
		{
			this.weight = weight;
			this.color = color;
			this.alpha = alpha;
			
			this.usePixelHinting = usePixelHinting;
			
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		/**
		 * @inheritDoc
		 */
		public function apply (target:Graphics):void
		{
			target.lineStyle(weight, color, alpha, usePixelHinting, scaleMode, caps, joints, miterLimit);
		}
	}
}