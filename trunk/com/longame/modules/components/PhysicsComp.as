package com.longame.modules.components
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2XForm;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import com.longame.core.Settings;
	import com.longame.model.MathVector;
	import longame.physics.Box2DShape;
	import com.longame.physics.Box2DWorld;

	/**
	 * 物理引擎组件，一个IDisplayEntity可以有很多的组件
	 * to delete
	 * */
	public class PhysicsComp extends TickedComp
	{
		private var _bodyDef:b2BodyDef= new b2BodyDef();
		private var _body:b2Body;
		private var _shapes:Vector.<Box2DShape>;
		private var _velocity:MathVector = new MathVector();
		private var _angularVelocity:Number = 0;
		private var _movable:Boolean = true;
		private var _rotatable:Boolean = false;
		private var _sleepable:Boolean = true;
		private var _massValue:Number = -1;
		private var _massObject:b2MassData = new b2MassData();
		
		public function PhysicsComp(id:String=null)
		{
			super(id);
		}
		override public function onTick(deltaTime:Number):void
		{
			
		}
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			//create the body
			_body = world.addBody(_bodyDef);
			_body.SetUserData(this);
			velocity = _velocity.scale(Settings.WORLD_SCALE);
			angularVelocity = _angularVelocity;
			sleepable = _sleepable;
			
			//create the shapes
			generateShapes();
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			destroyAllShapes();
			
			world.removeBody(_body);
			_body.SetUserData(null);
			_body = null;
		}
		override public function destroy():void
		{
			_shapes.length=0;
			super.destroy();
		}
		public function get world():Box2DWorld
		{
			return Engine.physics;
		}
		
		public function get body():b2Body
		{
			return _body;
		}
		
		public function get shapes():Vector.<Box2DShape>
		{
			return _shapes;
		}
		
		public function get mass():Number
		{
			if (_body)
				return _massObject.mass;
			else
				return _massValue;
		}
		
		public function set mass(value:Number):void
		{
			_massValue = value;
			
			if (_body)
				updateMass();
		}
		
		public function get velocity():MathVector
		{	
			if (_body) 
				return new MathVector(_body.GetLinearVelocity().x, _body.GetLinearVelocity().y).scale(Settings.WORLD_SCALE);
			else
				return _velocity;
		}
		
		public function set velocity(value:MathVector):void
		{
			value.scaleEquals(Settings.INVERSE_WORLD_SCALE);
			
			if (_body)
			{
				_body.SetLinearVelocity(new b2Vec2(value.x, value.y));
			} else
			{
				_velocity = value;
			}
		}
		
		public function get angularVelocity():Number
		{
			if (_body)
				return _body.GetAngularVelocity();
			else
				return _angularVelocity;
		}
		
		public function set angularVelocity(value:Number):void
		{
			if (_body)
				_body.SetAngularVelocity(value);
			else
				_angularVelocity = value;
		}
		
		public function get movable():Boolean
		{
			return _movable;
		}
		
		public function set movable(value:Boolean):void
		{
			_movable = value;
			
			if (_body)
				updateMass();
		}
		
		public function get rotatable():Boolean
		{
			return _rotatable;
		}
		
		public function set rotatable(value:Boolean):void
		{
			_rotatable = value;
			
			if (_body)
				updateMass();
		}
		
		public function get sleepable():Boolean
		{
			return _sleepable;
		}
		
		public function set sleepable(value:Boolean):void
		{
			_sleepable = value;
			
			if (_body)
				_body.AllowSleeping(_sleepable);
		}
		
		public function get angle():Number
		{
			if (_body)
				return _body.GetAngle() * 180 / Math.PI;
			else
				return _bodyDef.angle * 180 / Math.PI;
		}
		
		public function set angle(value:Number):void
		{
			value = value * Math.PI / 180;
			
			_bodyDef.angle = value;
			
			if (_body)
				_body.SetXForm(new b2XForm(_body.GetPosition(), new b2Mat22(value)));
			//_body.SetXForm(_body.GetPosition(), value);
		}
		public function get position():MathVector
		{
			if (_body)
				return new MathVector(_body.GetPosition().x, _body.GetPosition().y).scale(Settings.WORLD_SCALE);
			else
				return new MathVector(_bodyDef.position.x, _bodyDef.position.y).scale(Settings.WORLD_SCALE);
		}
		
		public function set position(value:MathVector):void
		{
			value.scaleEquals(Settings.INVERSE_WORLD_SCALE);
			
			_bodyDef.position.Set(value.x, value.y);
			
			if (_body)
				_body.SetXForm(new b2XForm(_bodyDef.position, new b2Mat22(_body.GetAngle())));
			//_body.SetXForm(_bodyDef.position, _body.GetAngle());
		}
		
		public function get x():Number
		{
			if (_body)
				return _body.GetPosition().x * Settings.WORLD_SCALE;
			else
				return _bodyDef.position.x * Settings.WORLD_SCALE;
		}
		
		public function set x(value:Number):void
		{
			value *= Settings.INVERSE_WORLD_SCALE;
			
			_bodyDef.position.Set(value, _bodyDef.position.y);
			
			if (_body)
				_body.SetXForm(new b2XForm(_bodyDef.position, new b2Mat22(_body.GetAngle())));
			//_body.SetXForm(_bodyDef.position, _body.GetAngle());
		}
		
		public function get y():Number
		{
			if (_body)
				return _body.GetPosition().y * Settings.WORLD_SCALE;
			else
				return _bodyDef.position.y * Settings.WORLD_SCALE;
		}
		
		public function set y(value:Number):void
		{
			value *= Settings.INVERSE_WORLD_SCALE;
			
			_bodyDef.position.Set(_bodyDef.position.x, value);
			
			if (_body)
				_body.SetXForm(new b2XForm(_bodyDef.position, new b2Mat22(_body.GetAngle())));
			//_body.SetXForm(_bodyDef.position, _body.GetAngle());
		}
		public function addShape(box2DShape:Box2DShape):void
		{
			//check to see if the shape already has an owner
			if (box2DShape.body)
			{
				throw new Error("You can not add one shape to two different bodies, or to the same body more than once.");
				return;
			}
			
			//add the shape
			_shapes.push(box2DShape);
			
			if (_body)
				generateShapes();
		}
		
		public function removeShape(box2DShape:Box2DShape):void
		{
			//make sure the shape exists on the body
			if (!hasShape(box2DShape))
			{
				throw new Error("You can not call removeShape() on a Box2DBodyComponent that does not have that shape.");
				return;
			}
			
			//remove the shape
			_shapes.splice(_shapes.indexOf(box2DShape), 1);
			
			if (_body)
				generateShapes();
		}
		
		public function hasShape(box2DShape:Box2DShape):Boolean
		{
			if (!_shapes)
				return false;
			
			return _shapes.indexOf(box2DShape) != -1;
		}
		
		public function resetShape(box2DShape:Box2DShape):void
		{
			if (!hasShape(box2DShape))
			{
				throw new Error("You can only call resetShape() on a body that owns that shape.");
				return;
			}
			
			box2DShape.destroyShape();
			box2DShape.createShape(this);
		}
		private function generateShapes():void
		{
			if (!_body)
			{
				throw new Error("You cannot generate shapes until you have registered the Box2DBodyComponent.");
				return;
			}
			
			destroyAllShapes();
			
			if (_shapes)
			{
				for each (var shape:Box2DShape in _shapes)
				shape.createShape(this);
			}
			
			updateMass();
		}
		
		private function destroyAllShapes():void
		{
			var shape:b2Shape = _body.GetShapeList();
			while (shape)
			{
				var nextShape:b2Shape = shape.GetNext();
				Box2DShape(shape.GetUserData()).destroyShape();
				shape = nextShape;
			}
		}
		private function updateMass():void
		{
			if (!_body)
			{
				throw new Error("You cannot update mass until the Box2DBodyComponent has been registered.");
				return;
			}
			
			_body.SetMassFromShapes();
			if (!_movable || !_rotatable || _massValue != -1)
			{
				_massObject = new  b2MassData();
				
				//set movability
				if (!_movable)
					_massObject.mass = 0;
				else
					_massObject.mass = _body.GetMass();
				
				
				//set rotatability
				if (!_rotatable)
					_massObject.I = 0;
				else
					_massObject.I = _body.GetInertia();
				
				if (_massValue != -1)
				{
					_massObject.mass = _massValue;
				}
				
				//update mass
				_body.SetMass(_massObject);
			} else
			{
				_massValue = _body.GetMass();
				_massObject.mass = _massValue;
			}
		}
	}
}