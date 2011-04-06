package com.longame.modules.components
{
	import flash.geom.Vector3D;
	
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.utils.MathUtil;
	
	/**
	 * 速度组件，只有IDisplayEntity才可以添加
	 * */
	public class VelocityComp extends TickedComp
	{
		/**
		 * 最低速度，0-无穷
		 * */
//		public var min:Number=Number.MIN_VALUE;
		/**
		 * 最高速度，0-无穷
		 * */
//		public var max:Number=Number.MAX_VALUE;
		
		private var _velocity:Vector3D=new Vector3D();
		private var _acceleration:Vector3D=new Vector3D();
		
		public function VelocityComp(id:String=null)
		{
			super(id);
		}
		
		override protected function doWhenActive():void
		{
			//只能被添加显示个体中
			if(!(owner is IDisplayEntity)) throw new Error("VelocityComp only can be added to an IDisplayEntity!");
			super.doWhenActive();
		}
		override public function onTick(deltaTime:Number):void
		{
			_velocity.x+=_acceleration.x;
			_velocity.y+=_acceleration.y;
			_velocity.z+=_acceleration.z;
			if((_velocity.x==0)&&(_velocity.y==0)&&(_velocity.z==0))return;
			(owner as IDisplayEntity).x+=_velocity.x;
			(owner as IDisplayEntity).y+=_velocity.y;
			(owner as IDisplayEntity).z+=_velocity.z;
		}
		/**
		 * 设定速度
		 * @param length: 速度矢量的长度
		 * @param angleXY:速度矢量的xy平面的投影角度,degree单位
		 * @param angleZ: 速度矢量在与xy平面的夹角，degree单位,0-90度有效
		 * todo,这个是个好公式，做成util，不过正确性待检验
		 * */
		public function setV(length:Number,angleXY:Number=0,angleZ:Number=0):void
		{
			var angleXY1:Number=MathUtil.degreesToRadians(angleXY);
		    var angleZ1:Number=MathUtil.degreesToRadians(angleZ);
			var lengthXY:Number=length*Math.cos(angleZ1);
			_velocity.x= lengthXY * Math.cos( angleXY1 );
			_velocity.y= lengthXY * Math.sin( angleXY1 );
			_velocity.z= length * Math.sin(angleZ1);
		}
		/**
		 * 设定加速度
		 * @param length: 速度矢量的长度
		 * @param angleXY:速度矢量的xy平面的投影角度
		 * @param angleZ: 速度矢量在与xy平面的夹角
		 * */
		public function setA(length:Number,angleXY:Number,angleZ:Number=0):void
		{
			var angleXY1:Number=MathUtil.degreesToRadians(angleXY);
			var angleZ1:Number=MathUtil.degreesToRadians(angleZ);
			var lengthXY:Number=length*Math.cos(angleZ1);
			_acceleration.x= lengthXY * Math.cos( angleXY1 );
			_acceleration.y= lengthXY * Math.sin( angleXY1 );
			_acceleration.z= length * Math.sin(angleZ1);
		}
		/**
		 * 将速度设定到某个值,通过x,y,z的方法
		 * */
		public function setV1(x:Number=0,y:Number=0,z:Number=0):void
		{
			_velocity.x=x;
			_velocity.y=y;
			_velocity.z=z;
		}
		/**
		 * 将加速度设定到某个值，通过x,y,z的方法
		 * */
		public function setA1(x:Number=0,y:Number=0,z:Number=0):void
		{
			_acceleration.x=x;
			_acceleration.y=y;
			_acceleration.z=z;
		}
		/**
		 * 获取速度
		 * */
		public function get velocity():Vector3D
		{
			return _velocity.clone();
		}
		/**
		 * 获取加速度
		 * */
		public function get acceleration():Vector3D
		{
			return _acceleration.clone();
		}
	}
}