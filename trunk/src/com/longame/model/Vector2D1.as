package com.longame.model
{
	import flash.geom.Vector3D;
	
	public class Vector2D1 extends Object
	{
		private var _x:Number;
		private var _y:Number;
		private var _magnitude:Number=0;
		private var _angle:Number=0;
		
		private var magnitudeDirty:Boolean;
		private var angleDirty:Boolean;
		
		public function Vector2D1(x:Number = 0, y:Number = 0) : void
		{
			this.setValue(x,y);
		}
		public function substract(v:Vector2D1) : void
		{
			this.setValue(this.x - v.x,this.y-v.y);
		}
		public function add(v:Vector2D) : void
		{
			this.setValue(this.x + v.x,this.y+v.y);
		}
		public function scale(scale:Number):void
		{
			this._magnitude*=scale;
		}
		public function copy(v:Vector2D1) : void
		{
			this.setValue(v.x,v.y);
		}
		public function equal(v:Vector2D1, threshHold:Number = 1e-5) : Boolean
		{
			return ((Math.abs(this.x-v.x)<=threshHold)&&(Math.abs(this.y - v.y)<=threshHold));
		}
		public function isNull():Boolean
		{
			return this.x*this.y==0;
		}
		public function setNull():void
		{
			this.setValue(0,0);
		}
		public function setValue(x:Number,y:Number):void
		{
			this.x=x;
			this.y=y;
		}
		public function toString() : String
		{
			return "x: " + String(this.x) + ";  y " + String(this.y);
		}
		public function get angle():Number
		{
			if(this.angleDirty){
				this.updateAngle();
				this.angleDirty=false;
			}
			return _angle;
		}
		public function set angle(value:Number):void
		{
			if(_angle==value) return;
			_angle=value;
			this.angleDirty=false;
			_x = _magnitude * Math.cos(angle);
			_y = _magnitude * Math.sin(angle);
		}
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(_x==value) return;
			_x=value;
			magnitudeDirty=true;
			angleDirty=true;
		}
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(_y==value) return;
			_y=value;
			magnitudeDirty=true;
			angleDirty=true;
		}
		/**
		 * 长度值
		 * */
		public function get magnitude() : Number
		{
			if(magnitudeDirty){
				this.updateManitude();
				magnitudeDirty=false;
			}
			return _magnitude;
		}
		public function set magnitude(value:Number):void
		{
			if(_magnitude==value) return;
			_magnitude=value;
			_x = _magnitude * Math.cos(this.angle);
			_y = _magnitude * Math.sin(this.angle);
			this.magnitudeDirty=false;
		}
		/**
		 * 长度归一化
		 * */
		public function normalize():void
		{
			this.magnitude=1;
		}
		private function updateManitude():void
		{
			_magnitude=Math.sqrt(_x * _x + _y * _y);
		}
		private function updateAngle():void
		{
			if (_x == 0 && _y == 0)
			{
				_angle=0;
			}
			if (_x == 0)
			{
				_angle= _y / Math.abs(_y) * (Math.PI / 2);
			}
			var an:* = _x < 0 ? (180) : (0);
			_angle=an+Math.atan(_x / _y);
		}
	}
}
