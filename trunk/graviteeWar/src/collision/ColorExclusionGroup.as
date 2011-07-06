package collision
{
	public class ColorExclusionGroup
	{
		protected var _colors:Array;
		
		public function ColorExclusionGroup()
		{
			_colors=[];
		}
		public function get colors():Array
		{
			return _colors;
		}
		public function addColor(theColor:uint, alphaRange:uint = 255, redRange:uint = 20, greenRange:uint = 20, blueRange:uint = 20):void
		{
			var numColors:int = _colors.length;
			for(var i:uint = 0; i < numColors; i++)
			{
				if(_colors[i].color == theColor)
				{
					throw new Error("Color could not be added - color already in the exclusion list [" + theColor + "]");
					break;
				}
			}
			var colorExclusion:ColorExclusion=new ColorExclusion();
			colorExclusion.aPlus = (theColor >> 24 & 0xFF) + alphaRange;
			colorExclusion.aMinus = colorExclusion.aPlus  - (alphaRange << 1);
			colorExclusion.rPlus = (theColor >> 16 & 0xFF) + redRange;
			colorExclusion.rMinus = colorExclusion.rPlus - (redRange << 1);
			colorExclusion.gPlus = (theColor >> 8 & 0xFF) + greenRange;
			colorExclusion.gMinus = colorExclusion.gPlus - (greenRange << 1);
			colorExclusion.bPlus = (theColor & 0xFF) + blueRange;
			colorExclusion.bMinus = colorExclusion.bPlus - (blueRange << 1);
			
			_colors.push(colorExclusion);
		}
		
		public function removeColor(theColor:uint):void
		{
			var found:Boolean = false, numColors:int = _colors.length;
			for(var i:uint = 0; i < numColors; i++)
			{
				if(_colors[i].color == theColor)
				{
					_colors.splice(i, 1);
					found = true;
					break;
				}
			}
			
			if(!found)
			{
				throw new Error("Color could not be removed - color not found in exclusion list [" + theColor + "]");
			}
		}		
	}
}