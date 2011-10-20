/////////////////////////////////////
// 
// Created by : giantJadder
// contact with me : giantJadder@gmail.com
//
/////////////////////////////////////
package view.scene.entitles 
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Point;

	/**
	 * After an "AntLine" instance is added to display list, use method "start" to start ant-line animation.
	 */
	public class AntLine extends Sprite
	{
		/* ****************** Constructor  ***************** */
		/* ************************************************* */
		public function AntLine()
		{
			super();
			g = this.graphics;
		}
		/* ******************   Fields  ******************** */
		/* ************************************************* */

		private var gap:Number = 0;

		private var g:Graphics;

		private var size:Size;

		private var tail:Number = 0;

		private var xCoe:Number = 1;                     
		private var yCoe:Number = 1;

		private var antLength:Number = 10;
		private var antGap:Number = 5;

		/*------------- Change  parameters  below -------------------*/
		public var lineThickness:Number = 1;
		public var lineColor:Number = 0x000000;//0xc63030;// 0x75b924; 
		public var lineAlpha:Number = 1.0;

		public var caps:String = CapsStyle.NONE;

		public var joint:String = JointStyle.ROUND;
		/*--------------  Change  parameters  above --------------*/

		/* **************** EventHandler  ****************** */
		/* ************************************************* */

		private function draw():void
		{
			g.clear();
			g.lineStyle(lineThickness,lineColor,lineAlpha,false,"normal",caps,joint);
			xCoe = size.width < 0 ? -1:1;
			if (antLength + antGap > Math.abs(size.width))
			{
				g.moveTo(0,0);
				g.lineTo(size.width,0);
				return;
			}

			var i:int = 0;
			while (true)
			{
				var offset:Number =  ( gap+ i*(antLength+antGap) );
				with (Math)
				{
					if (offset + antLength + antGap > abs(size.width))
					{

						if (offset + antLength > abs(size.width))
						{
							g.moveTo(offset*xCoe,0);
							g.lineTo(size.width,0);
							g.moveTo(size.width,0);
							g.lineTo(size.width, (offset+antLength- abs(size.width))*yCoe);
						}
						else
						{
							g.moveTo(offset*xCoe,0);
							g.lineTo((offset+antLength)*xCoe,0);
						}
						tail = offset + antLength + antGap - abs(size.width);
						return;
					}
					g.moveTo( offset*xCoe,0);
					g.lineTo( (offset+antLength)*xCoe,0);
					i++;
				}
			}
		}
		/* *******************  Communication ******************** */
		/* ******************************************************* */
		/**
		* 调用这个方法更改矩形的宽高
		*/
		public function setSize(w:Number):void
		{
			size = new Size(w);
			draw();
		}
	}
}
class Size{;
public function Size(_w:Number=0)
{
	width = _w;
}
public var width:Number;
}