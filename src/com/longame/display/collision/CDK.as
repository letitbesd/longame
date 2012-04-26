/*

Licensed under the MIT License

Copyright (c) 2008 Corey O'Neil
www.coreyoneil.com

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

package  com.longame.display.collision
{	
	import com.longame.utils.DisplayObjectUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.EOFError;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class CDK
	{
		private var colorExclusionArray		:Array;
		
		private var bmd1					:BitmapData;
		private var bmd2					:BitmapData;
		
		private var pixels1					:ByteArray;
		private var pixels2					:ByteArray;
		private var transMatrix1			:Matrix;
		private var transMatrix2			:Matrix;
		
		private var _alphaThreshold			:Number;
		
		private static var _instance:CDK;
		
		public function CDK():void 
		{	
			init();
			_instance=this;
		}
		public static function get instance():CDK
		{
			if(_instance==null) new CDK();
			return _instance;
		}
		public static function check(item1:DisplayObject,item2:DisplayObject,alphaThresh:Number=0,theColors:ColorExclusionGroup=null):CollisionData
		{
			var cdk:CDK=CDK.instance;
			cdk.alphaThreshold=alphaThresh;
			if(theColors) cdk.colorExclusionArray=theColors.colors;
			var c:CollisionData; 
			if(item1.hitTestObject(item2)){
				if((item1.width*item1.height)>(item2.width*item2.height)){
					c=cdk.findCollisions(item2,item1);
				}else{
					c=cdk.findCollisions(item1,item2);
				}
			}
			return c;
		}
		private function init():void
		{			
			colorExclusionArray = [];
			_alphaThreshold = 0;
		}		
		protected function findCollisions(item1:DisplayObject, item2:DisplayObject):CollisionData
		{
			var item1_isText:Boolean = false, item2_isText:Boolean = false;
			
			if(item1 is TextField)
			{
				item1_isText = (TextField(item1).antiAliasType == "advanced") ? true : false;
				TextField(item1).antiAliasType = item1_isText? "normal" : TextField(item1).antiAliasType;
			}
			
			if(item2 is TextField)
			{
				item2_isText = (TextField(item2).antiAliasType == "advanced") ? true : false;
				TextField(item2).antiAliasType =item2_isText? "normal" : TextField(item2).antiAliasType;
			}
			//item1相对于舞台的二进制图像
			var bmdObj1:Object=DisplayObjectUtil.getBitmapData(item1,item1.stage);	
			bmd1=bmdObj1.bmd as BitmapData;
			transMatrix1=bmdObj1.mat as Matrix;
			var item1xDiff:Number=transMatrix1.tx;
			var item1yDiff:Number=transMatrix1.ty;	
			//以item1在舞台上的矩形范围来截取item2的图
			var rect1:Rectangle=item1.getBounds(item1.stage);
			var rect2:Rectangle=item2.getBounds(item2.stage);
			transMatrix2=DisplayObjectUtil.getMartrix(item2,item2.stage);
			transMatrix2.tx-=(rect1.left-rect2.left);
			transMatrix2.ty-=(rect1.top-rect2.top);
			var bmdObj2:Object=DisplayObjectUtil.getBitmapData(item2,item2.stage,1.0,1.0,-1,item1.width,item1.height,transMatrix2);
			bmd2=bmdObj2.bmd as BitmapData;

			pixels1 = bmd1.getPixels(new Rectangle(0, 0, bmd1.width, bmd1.height));
			pixels2 = bmd2.getPixels(new Rectangle(0, 0, bmd1.width, bmd1.height));	
			
			var k:uint = 0, value1:uint = 0, value2:uint = 0, collisionPoint:Number = -1, overlap:Boolean = false, overlapping:Array = [];
			var locY:Number, locX:Number, hasColors:int = colorExclusionArray.length;
			
			pixels1.position = 0;
			pixels2.position = 0;
			var pixelLength:int = pixels1.length;
			while(k < pixelLength)
			{
				k = pixels1.position;
				try
				{
					value1 = pixels1.readUnsignedInt();
					value2 = pixels2.readUnsignedInt();
				}
				catch(e:EOFError)
				{
					break;
				}
				
				var alpha1:uint = value1 >> 24 & 0xFF, alpha2:uint = value2 >> 24 & 0xFF;
				
				if(alpha1 > _alphaThreshold && alpha2 > _alphaThreshold)
				{	
					var colorFlag:Boolean = false;
					if(hasColors)
					{
						var colorFlag1:Boolean= checkPixelColor(value1,colorExclusionArray,alpha1);						
						var colorFlag2:Boolean=checkPixelColor(value2,colorExclusionArray,alpha2);
						colorFlag=colorFlag1||colorFlag2;
					}
					
					if(!colorFlag)
					{
						overlap = true;
						//uint占4位？所以除以4.。。
						collisionPoint = k >> 2;
						
						locY = collisionPoint / bmd1.width, locX = collisionPoint % bmd1.width;
						var locStage:Point =new Point(locX, locY);
						//以item1的注册点为坐标原点
						locStage.x -= item1yDiff;
						locStage.y -= item1yDiff;						
						//转换到舞台上去,叠合点在舞台上的坐标
						//暂用item1的本地坐标
						//locStage=item1.localToGlobal(locStage);						
						overlapping.push(locStage);
					}
				}
			}
			var c:CollisionData;
			if(overlap)
			{
				c =new CollisionData(item1,item2);
				c.overlapping=overlapping;
				c.alphaThreshold=this._alphaThreshold;
				c.pixels2=pixels2;
				c.transMatrix2=transMatrix2;
				c.colorExclusionArray=this.colorExclusionArray;
				c.item1Left=-item1yDiff;
				c.item1Top=-item1yDiff;
			}
			
			if(item1_isText) TextField(item1).antiAliasType = "advanced";
			
			if(item2_isText) TextField(item2).antiAliasType = "advanced";
			
			item1_isText = item2_isText = false;
			return c;
		}
		public static function checkEdgePoint(pixel:uint,colorExclusions:Array,checkSolid:Boolean,_alphaThreshold:Number):Boolean
		{			
			var thisAlpha:uint = pixel >> 24 & 0xFF;
			//colorFlag为true表示颜色为空
			var colorFlag:Boolean = true;
			var hasColors:int=colorExclusions.length;
			if(thisAlpha > _alphaThreshold)
			{
				colorFlag=false;
				if(hasColors)
				{
					colorFlag=checkPixelColor(pixel,colorExclusions,thisAlpha);
				}						
			}
			if(checkSolid){
				if(!colorFlag){
					return true;
				}
			}else{
				if(colorFlag){
					return true;
				}
			}			
			return false;
		}
		/**
		 * 颜色碰撞检测
		 * */
		public static function checkPixelColor(pixel:uint,colorExclusions:Array,theAlpha:Number):Boolean
		{
			var colorFlag:Boolean=false;
			var red1:uint = pixel >> 16 & 0xFF, green1:uint = pixel >> 8 & 0xFF, blue1:uint = pixel & 0xFF;
			
			var colorObj:ColorExclusion, a:uint, r:uint, g:uint, b:uint, item1Flags:uint;
			var colors:int=colorExclusions.length;
			for(var n:uint = 0; n < colors; n++)
			{
				colorObj = ColorExclusion(colorExclusions[n]);
				
				item1Flags = 0;
				if((blue1 >= colorObj.bMinus) && (blue1 <= colorObj.bPlus))
				{
					item1Flags++;
				}
				if((green1 >= colorObj.gMinus) && (green1 <= colorObj.gPlus))
				{
					item1Flags++;
				}
				if((red1 >= colorObj.rMinus) && (red1 <= colorObj.rPlus))
				{
					item1Flags++;
				}
				if((theAlpha >= colorObj.aMinus) && (theAlpha <= colorObj.aPlus))
				{
					item1Flags++;
				}									
				if(item1Flags == 4)
				{
					colorFlag = true;
				}
			}
			return colorFlag;
		}
		public function set alphaThreshold(theAlpha:Number):void
		{
			if((theAlpha <= 1) && (theAlpha >= 0))
			{
				_alphaThreshold = theAlpha * 255;
			}
			else
			{
				throw new Error("alphaThreshold expects a value from 0 to 1");
			}
		}
		
		public function get alphaThreshold():Number
		{
			return _alphaThreshold;
		}
		
	}
}