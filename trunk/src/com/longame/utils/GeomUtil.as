package com.longame.utils {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * 
	 * Copyright (c) 2008 Noel Billig (www.dncompute.com)
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 *
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 *
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 * 
	 */
	 
	/**
	 * 
	 * The line segment intersection code used here is based off of Erik Gustavsson's 
	 * tutorial found here: http://www.zikko.se/resources/lineIntersection.php
	 * That page reads: "All content on these pages may be used, copied and modifed freely."
	 * 
	 */
	public class GeomUtil {
		
		/**
		 *
		 * Returns the point of intersection between the line connecting point a1 to a2
		 * and the line connecting point b1 to b2.
		 *
		 */
		public static function getLineSegmentIntersection(
				a1:Point,a2:Point,
				b1:Point,b2:Point
				):Point {
			
			//XXX: Add an optimization here to see if the bounding boxes even overlap
			
			//Figure out where the lines intersect
			var intersection:Point = getLineIntersection(a1,a2,b1,b2);
			
			//They could be parellel, in which case there is no line intersection
			if (intersection == null) return null;
			
			//If the lines intersect, check and see if the intersection falls on the segments
			if (inRange(intersection,a1,a2) && inRange(intersection,b1,b2)) {
				return intersection;
			}
			
			return null;
			
		}
		
		
		/**
		 *
		 * Calculate the intersection between two lines. The intersection point
		 * may not necesarily occur on either line segment. To only get the line
		 * segment intersection, use <code>getLineSegmentIntersection</code> instead
		 *
		 */
		public static function getLineIntersection ( 
				a1:Point,a2:Point,
				b1:Point,b2:Point
				):Point {
		
			//calculate directional constants
			var k1:Number = (a2.y-a1.y) / (a2.x-a1.x);
			var k2:Number = (b2.y-b1.y) / (b2.x-b1.x);
			
			// if the directional constants are equal, the lines are parallel,
			// meaning there is no intersection point.
			if( k1 == k2 ) return null;
			
			var x:Number,y:Number;
			var m1:Number,m2:Number;
			
			// an infinite directional constant means the line is vertical
			if( !isFinite(k1) ) {
				
				// so the intersection must be at the x coordinate of the line
				x = a1.x;
				m2 = b1.y - k2 * b1.x;
				y = k2 * x + m2;
				
			// same as above for line 2
			} else if ( !isFinite(k2) ) {
				
				m1 = a1.y - k1 * a1.x;
				x = b1.x;
				y = k1 * x + m1;

			// if neither of the lines are vertical
			} else {
				
				m1 = a1.y - k1 * a1.x;
				m2 = b1.y - k2 * b1.x;				
				x = (m1-m2) / (k2-k1);
				y = k1 * x + m1;
				
			}
			
			return new Point(x,y);
		}
		
		
		private static function inRange(pnt:Point,a:Point,b:Point):Boolean {
			
			if (a.x != b.x) {
				return pnt.x <= a.x != pnt.x < b.x;
			} else {
				return pnt.y <= a.y != pnt.y < b.y;
			}
			
		}
        public static function createCentredRect(arg1:flash.geom.Point, arg2:flash.geom.Point):flash.geom.Rectangle
        {
            return new Rectangle(arg1.x - arg2.x / 2, arg1.y - arg2.y / 2, arg2.x, arg2.y);
        }

		//
        public static function rectForceInside(arg1:flash.geom.Rectangle, arg2:flash.geom.Rectangle):void
        {
            if (arg1.x < arg2.x)
            {
                arg1.x = arg2.x;
            }
            else 
            {
                if (arg1.right > arg2.right)
                {
                    arg1.x = arg2.right - arg1.width;
                }
            }
            if (arg1.y < arg2.y)
            {
                arg1.y = arg2.y;
            }
            else 
            {
                if (arg1.bottom > arg2.bottom)
                {
                    arg1.y = arg2.bottom - arg1.height;
                }
            }
            return;
        }

		//
        public static function rectCentreDistance(arg1:flash.geom.Rectangle, arg2:flash.geom.Rectangle):Number
        {
            return rectCentre(arg1).subtract(rectCentre(arg2)).length;
        }

		//
        public static function pointMultiply(arg1:flash.geom.Point, arg2:Number):flash.geom.Point
        {
            return new Point(arg1.x * arg2, arg1.y * arg2);
        }

		//
        public static function rectCentre(arg1:flash.geom.Rectangle):flash.geom.Point
        {
            return new Point(arg1.x + arg1.width / 2, arg1.y + arg1.height / 2);
        }			
		
//		public static function angleBetweenTwoPoints(x1:Number, y1:Number, x2:Number, y2:Number):Number{
//			var x_distance:Number = (x2 - x1);
//			var y_distance:Number = (y1 - y2);
//			
//			if (x_distance < 0){
//				return ((Math.atan((y_distance / x_distance)) + Math.PI));
//			}
//			
//			if (x_distance > 0){
//				if (y_distance < 0){
//					return (2 * Math.PI) + Math.atan(y_distance / x_distance);
//				}
//				return Math.atan(y_distance / x_distance);
//			} else {
//				if (y_distance > 0){
//					return Math.PI / 2;
//				}
//				if (y_distance < 0){
//					return Math.PI + (Math.PI / 2);
//				}
//			}
//			return 0;
//		}		
		
		/**
		 * Calculates the perimeter of a rectangle.
		 * 
		 * @param rect Rectangle to determine the perimeter of.
		 */
		public static function getRectanglePerimeter(r:Rectangle):Number
		{
			return r.width * 2 + r.height * 2;
		}
		
		
		/**
		 * Returns a new Radian object with the angle between the two specified
		 * point objects startPoint and endPoint.
		 * 
		 * @param startPoint the starting coordinate of the line which angle
		 *         is to be calculated.
		 * @param endPoint the end coordinate of the line which angle is to be
		 *         calculated.
		 * @return a new Radian instance that contains the calculated angle.
		 */
//		public static function getRadian(startPoint:Point, endPoint:Point):Radian
//		{
//			return new Radian(Math.atan2(endPoint.y - startPoint.y,
//				endPoint.x - startPoint.x));
//		}
		
		
		/**
		 * Returns a new Point object containing the polar coordinates (or the
		 * end point) of the specified startPoint, angle and distance.
		 * 
		 * @param startPoint the starting coordinate that is used to calculate
		 *         the polar coordinate.
		 * @param angle the angle in radians that is used to calculate the polar
		 *         coordinate.
		 * @param distance the distance value that is used to calculate the polar
		 *         coordinate.
		 * @return a new Point instance that contains the polar coordinates.
		 */
		public static function getPolar(startPoint:Point, angle:Number,
										distance:Number):Point
		{
			return new Point((distance * Math.cos(angle)) + startPoint.x,
				(distance * Math.sin(angle)) + startPoint.y);
		}
		
		
		/**
		 * Rotates a Point around another Point by the specified angle.
		 * 
		 * @param point The Point to rotate.
		 * @param centerPoint The center point to rotate the point around.
		 * @param angle The angle (in degrees) to rotate this point.
		 */
		public static function rotatePoint(point:Point, centerPoint:Point, angle:Number):void
		{
			var r:Number =MathUtil.degreesToRadians(angle);
			var baseX:Number = point.x - centerPoint.x;
			var baseY:Number = point.y - centerPoint.y;
			
			point.x = (Math.cos(r) * baseX) - (Math.sin(r) * baseY) + centerPoint.x;
			point.y = (Math.sin(r) * baseX) + (Math.cos(r) * baseY) + centerPoint.y;
		}		
	}
	
}