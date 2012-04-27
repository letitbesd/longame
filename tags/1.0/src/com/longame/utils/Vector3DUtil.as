package com.longame.utils
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Vector3DUtil
	{
		/**
		 * 将x,y,z表示的三维矢量转换为length,angleXY,angleZ方式的极坐标矢量，极坐标矢量的解释见fromPolar
		 * 返回一个Vector3D，x表示length，y表示angleXY,，z表示angleZ
		 * todo,角度算得有问题
		 * */
        public static function toPolar(oldV:Vector3D):Vector3D
		{
			var v:Vector3D=new Vector3D();
			v.x=oldV.length;
			v.y=MathUtil.getAngle(new Point(),new Point(oldV.x,oldV.y));
			v.z=MathUtil.getAngle(new Point(),new Point(oldV.x,oldV.z));
			//这个角度应该是-90到90度之间
			if(v.z>90) v.z=180-v.z;
			else if(v.z<-90) v.z=180+v.z;
			return v;
		}
		/**
		 * 将length,angleXY,angleZ表示的极坐标矢量转换为x,y,z表示的三维矢量
		 * @param length: 矢量长度
		 * @param angleXY:俯视xy平面，x坐标轴正方向和矢量线之间的夹角，顺时针为正,degree
		 * @param angleZ: 矢量和xy平面的夹角，向上为正，-90到90度，degree
		 * @param oldV:   如果指定了，就直接改之，oldV应该是个普通的用x，y，z来表示的三维矢量
		 * */
		public static function fromPolar(length:Number,angleXY:Number=0,angleZ:Number=0,oldV:Vector3D=null):Vector3D
		{
			if(oldV==null) oldV=new Vector3D();
			if(length==0){
				oldV.x=0;
				oldV.y=0;
				oldV.z=0;
			}else{
				var angleXY1:Number=MathUtil.degreesToRadians(angleXY);
				var angleZ1:Number=MathUtil.degreesToRadians(angleZ);
				var lengthXY:Number=length*Math.cos(angleZ1);
				oldV.x= lengthXY * Math.cos( angleXY1 );
				oldV.y= lengthXY * Math.sin( angleXY1 );
				oldV.z= length * Math.sin(angleZ1);
			}
			return oldV;
		}
	}
}