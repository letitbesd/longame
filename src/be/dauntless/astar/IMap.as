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
	 * @author Jeroen Beckers (info@dauntless.be)
	 */
	public interface IMap 
	{
		function getTile(x:int,y:int) : IPositionTile;
		function setTile(tile:IPositionTile):void;
		function get width():int;
		function get height():int;
		function getNeighbours(x:int,y:int):Array;
		function isDiagonal(from:Point, to:Point):Boolean;
		function isValidTile(x:int,y:int):Boolean;
	}
}
