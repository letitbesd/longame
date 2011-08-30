package com.longame.modules.core.bounds
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.display.screen.IScreen;
	import com.longame.modules.core.IComponent;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.entities.display.primitive.LGGrid;
	import com.longame.modules.entities.display.primitive.LGRectangle;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.IScene;
	
	import flash.geom.Vector3D;

	use namespace long_internal;

	public class Bounds implements IBounds
	{
		public function get volume ():Number
		{
			return width * length * height;
		}
		
		////////////////////////////////////////////////////////////////
		//	W / L / H
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get width ():Number
		{
			return _right - _left;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length ():Number
		{
			return _front - _back;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height ():Number
		{
			return _top - _bottom;
		}
		
		////////////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		////////////////////////////////////////////////////////////////
		
		long_internal var _left:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get left ():Number
		{
			return _left;
		}
		
		long_internal var _right:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get right ():Number
		{
			return _right;
		}
		
		////////////////////////////////////////////////////////////////
		//	BACK / FRONT
		////////////////////////////////////////////////////////////////
		
		long_internal var _back:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get back ():Number
		{
			return _back;
		}
		
		long_internal var _front:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get front ():Number
		{
			return _front;
		}
		
		////////////////////////////////////////////////////////////////
		//	TOP / BOTTOM
		////////////////////////////////////////////////////////////////
		
		long_internal var _bottom:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get bottom ():Number
		{
			return _bottom;
		}
		
		long_internal var _top:Number=0;
		
		/**
		 * @inheritDoc
		 */
		public function get top ():Number
		{
			return _top
		}
		
		////////////////////////////////////////////////////////////////
		//	CENTER PT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get center():Vector3D
		{
			var pt:Vector3D = new Vector3D();
			pt.x = (right - left) / 2;
			pt.y = (front - back) / 2;
			pt.z = (top - bottom) / 2;
			
			return pt;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get points ():Array
		{
			var a:Array = [];
			
			a.push(new Vector3D(left, back, bottom));
			a.push(new Vector3D(right, back, bottom));
			a.push(new Vector3D(right, front, bottom));
			a.push(new Vector3D(left, front, bottom));
			
			a.push(new Vector3D(left, back, top));
			a.push(new Vector3D(right, back, top));
			a.push(new Vector3D(right, front, top));
			a.push(new Vector3D(left, front, top));
			
			return a;
		}
		
		////////////////////////////////////////////////////////////////
		//	COLLISION
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function intersects (bounds:IBounds):Boolean
		{
			return (checkOverlaps(bounds)!=null);
		}
		public function checkOverlaps(bounds:IBounds):Vector3D
		{
			var ox:Number=width / 2 + bounds.width / 2-Math.abs(center.x - bounds.center.x);
			var oy:Number=length / 2 + bounds.length / 2-Math.abs(center.y - bounds.center.y);
			var oz:Number= height / 2 + bounds.height / 2-Math.abs(center.z - bounds.center.z);
			if((ox>=0)&&(oy>=0)&&(oz>=0)) return new Vector3D(ox,oy,oz);
			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function containsPoint(x:Number,y:Number,z:Number=0):Boolean
		{
			if ((left <= x && x <= right) &&
				(back <= y && y <= front) &&
				(bottom <= z &&z <=top))
			{
				return true;
			}
			
			else
				return false;
		}
		public function containsBounds(bounds:IBounds):Boolean
		{
			return left<=bounds.left && back<=bounds.back && right>=bounds.right && front>=bounds.front && bottom<=bounds.bottom && top>=bounds.top;
		}
		/**
		 * Constructor
		 */
		public function Bounds ()
		{
		}
	}
}