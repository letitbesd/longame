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
	import be.dauntless.astar.IPositionTile;
	
	import flash.geom.Point;
	
	/**
	 * Provides basic implementation for the IPositionTile, IWalkable and ICostTile interfaces
	 * @author Jeroen
	 */
	public class BasicTile implements IPositionTile, IWalkableTile, ICostTile
	{
		protected var _cost:Number;
		protected var _walkable:Boolean;

		public function BasicTile(cost:Number, x:int,y:int, walkable:Boolean)
		{
			this._cost = cost;
			this._x=x;
			this._y=y;
			this._walkable = walkable;
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
		
		public function get walkable() : Boolean
		{
			return _walkable;
		}
		
		public function set walkable(walkable : Boolean) : void
		{
			this._walkable = walkable;
		}
		
		public function get cost() : Number
		{
			return _cost;
		}
		
		public function set cost(cost : Number) : void
		{
			this._cost = cost;
		}
	}
}
