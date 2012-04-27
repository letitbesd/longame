package com.longame.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/*
	把字体解析成点坐标点的类,使用时只需要调用这个类的静态方法就可以了
	例子:这个粒子的效果就是用外部的小球来代替字体
	实现一:
	var ball:Ball
	var arr:Array = FontPoint.encode("hello", new TextFormat("黑体", 20, 0xff00ff));
	for (var i:int = 0; i < arr.length-1; i++)
	{
	ball = new Ball(5, 0xff0000, arr[i].x, arr[i].y);//坏处就是不知道arr[i].x
	addChild(ball);
	}
	实现二:
	var arr:Array = FontPoint.encode("hold", new TextFormat("sans", 20, 0xFF0000), 1, 8,-20,-40,this,new Ball());
	直接把一个类的实例传进去,这样做的好处是不用自己去迭代对象,坏处也是显而易见的,因为程序使用的是类反射,基于这个
	原因,我们得自定义一个类(包括了对象和属性).我们也不能传入构造函数,如果有需要,请考虑改写这个类,加入一些额外的参数
	去支持构造参数的传入
	@author 陈伟群
	*/
	public class FontPoint
	{
		public function FontPoint()
		{	
		}
		/**
		 * 
		 * @param	text 解析的文本
		 * @param	format 格式化文本
		 * @param	rate 解析出来的点频率,不建议修改,值越大越稀疏
		 * @param	density 解析出来的点密度,不建议修改
		 * @param	offsetX 点的X坐标偏移
		 * @param	offsetY 点的Y坐标偏移
		 * @param	stg 显示对象,例如是舞台
		 * @param	obj=null 一个类实例,如果加入这个参数则会自动迭代并加入舞台
		 * @return
		 */
		public static function encode(text:String, format:TextFormat, rate:uint = 1, density:uint = 10, offsetX:Number = 0,offsetY:Number=0,stg:DisplayObjectContainer=null,obj:*=null):Array
		{
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.text = text;
			if (format.color==0) format.color = 0xFFFFFF;
			tf.setTextFormat(format);
			var bmd:BitmapData = new BitmapData(tf.width,tf.height, false, 0xfff);
			bmd.draw(tf);
			var bm:Bitmap = new Bitmap(bmd);
			var arr:Array = new Array();
			for (var i:int = 0; i < bm.height ;i++)
			{
				for (var j:int = 0; j < bm.width; j += rate) 
				{
					if ((bmd.getPixel(j, i)>>16)&0xff)
					{
						var point:* = { x:null, y:null};
						point.x = j* density + offsetX;
						point.y = i * density + offsetY;
						arr.push(point);
					}
				}
			}
			
			if (obj!=null) 
			{
				for (var k:int = 0; k < arr.length; k++) 
				{
					//反射实例化对象.达到复制的目的
					var c:Class = getDefinitionByName(getQualifiedClassName(obj)) as Class;
					var obj:* = new c();
					obj.x = arr[k].x;
					obj.y = arr[k].y;
					stg.addChild(obj);
				}
			}
			return arr;
		}
		
	}
}