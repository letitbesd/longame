/*
Copyright (c) 2008 Jeroen Beckers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.dauntless.astar 
{

	/**
	 * @private
	 * @author Jeroen Beckers (info@dauntless.be)
	 */
	import be.dauntless.astar.IPositionTile;
	
	import flash.geom.Point;

	internal class DataTile implements IPositionTile
	{
		/*
		private var target : *;
		private var g:Number;
		private var h:Number;
		private var f:Number;
		
		private var open:Boolean;
		private var closed:Boolean;
		
		private var parent:DataTile;
		
		private var position:Point;
		
		private var diag:Boolean;
		
		
		//the standard cost for this tile
		private var _standardCost:Number;

		
		*/
		
		private var target : *;
		private var g:Number;
		private var h:Number;
		private var f:Number;
		
		private var open:Boolean;
		private var closed:Boolean;
		
		private var parent:DataTile;
		
		private var multiplier:Number = 1;
		
		
		//the standard cost for this tile
		public var _standardCost:Number;
		
		
		public function DataTile(p_standardCost:Number)
		{
			_standardCost = p_standardCost;
		}
		
		public function getTarget() : *
		{
			return target;
		}
		
		public function setTarget(target : *) : void
		{
			this.target = target;
		}
		
		public function getG() : Number
		{
			return g;
		}
		
		public function setG(g : Number) : void
		{
			this.g = g + cost;
			this.f = this.h + this.g;
		}
		
		public function getH() : Number
		{
			return h;
		}
		
		public function setH(end:Point) : void
		{
			this.h = Math.abs(end.x - x) * _standardCost + Math.abs(end.y - y) * _standardCost;
			this.f = this.h + this.g;
		}
		
		public function getF() : Number
		{
			return this.f;
		}
		
		public function getOpen() : Boolean
		{
			return open;
		}
		
		public function setOpen(isOpen : Boolean) : void
		{
			this.open = isOpen;
		}
		
		public function getClosed() : Boolean
		{
			return closed;
		}
		
		public function setClosed() : void
		{
			this.closed = true;
		}
		
		public function getParent() : DataTile
		{
			return parent;
		}
		
		public function setParent(parent : DataTile) : void
		{
			this.parent = parent;
		}
		protected var _x:int;
		public function get x():int
		{
			return _x;
		}
		public function set x(value:int):void
		{
			_x=value;
		}
		protected var _y:int;
		public function get y():int
		{
			return _y;
		}
		public function set y(value:int):void
		{
			_y=value;
		}
		
		public function setDiag(diag : Boolean) : void
		{
			multiplier = (diag ? Astar.DIAGONAL_FACTOR : 1);
		}

		public function get cost():Number
		{
			/**
			 * If the target tile has implemented the ICostTile, it has a getCost() that has to be used
			 */
			if(target is ICostTile)
			{
				return ICostTile(target).cost * multiplier;
			}
			else
			{
				//if not, return standard cost
				return this._standardCost * multiplier;
			}
			
		}
		
		public function calculateUpdateF(parentCost:Number):Number
		{
			return (this.cost + parentCost + getH());
		}
	
	}


}
