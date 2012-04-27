package com.longame.game.core.bounds
{
	import com.longame.model.consts.Registration;
	import com.longame.game.entity.IDisplayEntity;
	
	import flash.geom.Vector3D;

	/**
	 * The IBounds implementation for Primitive-type classes
	 */
	public class EntityBounds extends Bounds implements IBounds
	{
		/**
		 * @inheritDoc
		 */
		override public function get width ():Number
		{
			return _target.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get length ():Number
		{
			return _target.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height ():Number
		{
			return _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function get left ():Number
		{
			if(_target.registration==Registration.CENTER) return _target.x-_target.width/2;
			return _target.x;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get right ():Number
		{
			if(_target.registration==Registration.CENTER) return _target.x+_target.width/2;
			return _target.x + _target.width;
		}
		
		////////////////////////////////////////////////////////////////
		//	BACK / FRONT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function get back ():Number
		{
			if(_target.registration==Registration.CENTER) return _target.y-_target.length/2;
			return _target.y;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get front ():Number
		{
			if(_target.registration==Registration.CENTER) return _target.y+_target.length/2;
			return _target.y + _target.length;
		}
		
		////////////////////////////////////////////////////////////////
		//	BOTTOM / TOP
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function get bottom ():Number
		{
			return _target.z;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get top ():Number
		{
			return _target.z + _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	CENTER PT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function get center ():Vector3D
		{
			if(_target.registration==Registration.CENTER){
				return new Vector3D(_target.x,_target.y,_target.z+ _target.height / 2);
			}			
			var pt:Vector3D = new Vector3D();
			pt.x = _target.x + _target.width / 2;
			pt.y = _target.y + _target.length / 2;
			pt.z = _target.z + _target.height / 2;
			
			return pt;
		}
		private var _target:IDisplayEntity;
		
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function EntityBounds (target:IDisplayEntity)
		{
			this._target = target;
		}
	}
}