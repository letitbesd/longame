package com.longame.model
{
	import com.longame.utils.MathUtil;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Vector2D extends Object
	{
		public var x:Number;
		public var y:Number;
		
		public function Vector2D(x:Number = 0, y:Number = 0) : void
		{
			this.x = x;
			this.y = y;
		}
		public function normarize():void
		{
			this.setMagnitude(1);
		}
		public function setMagnitude(value:Number):void
		{
			this.x = value * Math.cos(getAngle(true));
			this.y = value * Math.sin(getAngle(true));
		}
		public function substract(v:Vector2D) : void
		{
			this.x = this.x - v.x;
			this.y = this.y - v.y;
		}
		public function add(v:Vector2D) : void
		{
			this.x = this.x + v.x;
			this.y = this.y + v.y;
		}
		
		public function toString() : String
		{
			return "x: " + String(this.x) + ";  y " + String(this.y);
		}
		/**
		 * 长度不变，设定角度，degree值
		 * */
		public function setAngle(angle:Number,radian:Boolean=false) : void
		{
			if(!radian) angle = angle * (Math.PI/180);
			var d:Number = this.magnitude();
			this.x = d * Math.cos(angle);
			this.y = d * Math.sin(angle);
		}
		public function getAngle(radian:Boolean = false) : Number
		{
			return MathUtil.getAngle(new Point(),new Point(this.x,this.y),radian);
			if (this.x == 0 && this.y == 0)
			{
				return 0;
			}
			if (this.x == 0)
			{
				return this.y / Math.abs(this.y) * (!radian ? (90) : (Math.PI / 2));
			}
			var an:* = this.x < 0 ? (180) : (0);
			return an + (!radian ? (Math.atan(this.y / this.x) * 180 / Math.PI) : (Math.atan(this.x / this.y)));
		}
		public function equal(v:Vector2D, threshHold:Number = 1e-005) : Boolean
		{
			if (Math.abs(this.x - v.x) <= threshHold)
			{
				return true;
			}
			return Math.abs(this.y - v.y) ? (true) : (false);
		}
		public function copy(v:Vector2D) : void
		{
			this.x = v.x;
			this.y = v.y;
		}
		
		public function multiplyScale(scale:Number) : void
		{
			this.x = this.x * scale;
			this.y = this.y * scale;
		}
		/**
		 * 长度值
		 * */
		public function magnitude() : Number
		{
			return Math.sqrt(this.x * this.x + this.y * this.y);
		}
		
	}
}
