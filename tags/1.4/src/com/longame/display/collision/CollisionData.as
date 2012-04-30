package com.longame.display.collision
{
	
	import com.longame.model.geom.Ellipse;
	import com.longame.model.geom.Line;
	import com.longame.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.EOFError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class CollisionData
	{
		public var item1Left:Number;
		public var item1Top:Number;
		//大物体的在小物体矩形框范围内的像素集合
		public var pixels2:ByteArray;
		//大物体被截取时的matrix
		public var transMatrix2:Matrix;//
		
		public var colorExclusionArray:Array;//
		public var alphaThreshold:Number;
		public var overlapping:Array;
		
		protected var item1:DisplayObject;
		protected var item2:DisplayObject;		
        //幅度为单位的角度
		protected  var _angle:Number=NaN;
		protected var _distance:Number;
		
		protected var _distances:Dictionary;
		
		

		
		public function CollisionData(item1:DisplayObject,item2:DisplayObject)
		{
			this.item1=item1;
			this.item2=item2;
			_distances=new Dictionary(true);
		}
		public function get smallTarget():DisplayObject
		{
			return this.item1;
		}
		public function get bigTarget():DisplayObject
		{
			return this.item2;
		}
		/**
		 * 获取碰撞角度值，角度是以接触面为切线，指向大物体的方向
		 * */
		public function get angleInDegree():Number
		{
			if(isNaN(_angle)) _angle=this.findAngle(item1,item2)[0];
			return MathUtil.radiansToDegrees(_angle);
		}
		/**
		 * 获取碰撞角度弧度值，角度是以接触面为切线，指向大物体的方向
		 * */
		public function get angleInRadian():Number
		{
			if(isNaN(_angle)) _angle=this.findAngle(item1,item2)[0];
			return this._angle;
		}
		/**
		 * 计算沿着angle方向叠合区域的厚度，用于碰撞产生后调整item1的位置，使得两物体刚好接触
		 * angle以degree为单位
		 * */
		public function getOverlapInAngle(angleInRadian:Number=NaN):int
		{
			if(_distances[angleInRadian]) return _distances[angleInRadian];
			if(!isNaN(angleInRadian)){
				angleInRadian=this.angleInRadian;
			}
			var dis:int=this.findDistance(angleInRadian);
			_distances[angleInRadian]=dis;
			return dis;
		}
		protected function findDistance(angle:Number):int
		{
//			var maxRadius:int=Math.max(item1.width,item1.height);
//			maxRadius*=2;
//			var w:int=item1.width;
//			var h:int=item1.height;
//			var pixel:uint;
            var r0:int;
			var r1:int;
			var line:Line=new Line(new Point(0,0),Math.tan(-angle));
			for each(var p:Point in this.overlapping){
				trace(p,p.x,line.getY(p.x));
				if(line.onLine(p)){
					trace(r1++);
				}
			}

//			var solidStart:Boolean=false;
//            for(var r:int=0;r<=maxRadius;r++){
//				var circle:Ellipse=new Ellipse(0,0,r,r);
//				var p:Point=circle.getPointOfDegree(angle);
//				var x0:int=p.x-this.item1Left;
//				var y0:int=p.y-this.item1Top;
//				pixels2.position=((y0*w)+x0)<<2;		
//				trace("pixel位置: "+pixels2.position,p.x,p.y);
//				try
//				{
//					pixel = pixels2.readUnsignedInt();
//				}
//				catch(e:EOFError)
//				{
//					r1=r;
//					trace("piexl错了");
//					break;
//				}
//				if(!solidStart){
//					if(CDK.checkEdgePoint(pixel,this.colorExclusionArray,true,this.alphaThreshold)){
//						r0=r;
//						solidStart=true;						
//					}
//				}else{
//					if(CDK.checkEdgePoint(pixel,this.colorExclusionArray,false,this.alphaThreshold)){
//						r1=r;
//					}
//				}			
//			}
			trace("ro,r1",r0,r1);
			return r1-r0;
		}
		protected var testBmd0:BitmapData;
		protected var testBm0:Bitmap;
		
//		protected var testBmd:BitmapData;
//		protected var testBm:Bitmap;		

        //显示下叠合部分，仅做测试
        protected function showBmForTest(angle:Number):void
		{
			if(this.testBm0==null){
				testBmd0 = new BitmapData(item1.width, item1.height,false, 0xff000000);
				testBm0=new Bitmap(testBmd0);
				item1.stage.addChild(testBm0);
				testBm0.x=150;
				testBm0.y=150;				
			}else{
				testBmd0.dispose();
				testBmd0 = new BitmapData(item1.width, item1.height,false, 0xff000000);
			}
			
			testBm0.bitmapData=testBmd0;
			testBmd0.lock();
			var line:Line=new Line(new Point(-this.item1Left,-this.item1Top),Math.tan(angle));
			
			for each(var pos:Point in overlapping){
				var an:Number=Math.atan2(pos.y,pos.x);
				
				if(Math.abs(an-angle)<Math.PI*0.1/180){
					trace("i coming!");
				}
				
				var px:Number=pos.x-this.item1Left;
				var py:Number=pos.y-this.item1Top;
				testBmd0.setPixel32(px,py,0xffff0000);
				trace("在线吗： ",line.onLine(new Point(px,py)),py-line.getY(px),Math.abs(an-angle)*180/Math.PI);
				//testBmd0.setPixel32(pos.x,pos.y,0xffff0000);
			}
			var maxRadius:int=Math.max(item1.width,item1.height);
			maxRadius*=2;		
			var degree:Number=angle*180/Math.PI;
			trace("当前角度: ",degree);
			
            for(var r:int=0;r<=maxRadius;r++){
				//var circle:Ellipse=new Ellipse(-this.item1Left,-this.item1Top,r,r);
				var circle:Ellipse=new Ellipse(-r/2-this.item1Left,-r/2-this.item1Top,r,r);
				var p:Point=circle.getPointOfDegree(degree+90);
				trace("和园一致吗： ",line.onLine(p));
//				for each(pos in overlapping){
//					px=pos.x-this.item1Left;
//					py=pos.y-this.item1Top;
//					GeomUtil.getDistanceByPoint(new Point(px,py),p);
//					testBmd0.setPixel32(px,py,0xffff0000);
//					trace("在线园吗： ",GeomUtil.getDistanceByPoint(new Point(px,py),p));
//				}				
				try{
					//stestBmd0.setPixel32(p.x%item1.width,p.y/item1.width,0xff00ff00);
					testBmd0.setPixel32(p.x,p.y,0xff00ff00);
				}catch(e:Error){
					
				}
			}		
			testBmd0.unlock();			
		}
		
		protected function findAngle(item1:DisplayObject, item2:DisplayObject):Array
		{
			var center:Point = new Point((item1.width >> 1), (item1.height >> 1));
			var pixels:ByteArray;// = pixels2;
			transMatrix2.tx += center.x;
			transMatrix2.ty += center.y;
			var bmdResample:BitmapData = new BitmapData(item1.width << 1, item1.height << 1, true, 0x00FFFFFF);
			bmdResample.draw(item2, transMatrix2, item2.transform.colorTransform, null, null, true);
			pixels = bmdResample.getPixels(new Rectangle(0, 0, bmdResample.width, bmdResample.height));
			
			center.x = bmdResample.width >> 1;
			center.y = bmdResample.height >> 1;
			
			var columnHeight:uint = Math.round(bmdResample.height);
			var rowWidth:uint = Math.round(bmdResample.width);
			
			var pixel:uint, thisAlpha:uint, lastAlpha:int, edgeArray:Array = [], hasColors:int = colorExclusionArray.length;
			
			for(var j:uint = 0; j < columnHeight; j++)
			{
				var k:uint = (j * rowWidth) << 2;
				pixels.position = k;
				lastAlpha = -1;
				var upperLimit:int = ((j + 1) * rowWidth) << 2;
				while(k < upperLimit)
				{
					k = pixels.position;
					
					try
					{
						pixel = pixels.readUnsignedInt();
					}
					catch(e:EOFError)
					{
						break;
					}
					
					
					thisAlpha = pixel >> 24 & 0xFF;
					
					if(lastAlpha == -1)
					{
						lastAlpha = thisAlpha;
					}
					else
					{
						if(thisAlpha > alphaThreshold)
						{
							var colorFlag:Boolean = false;
							if(hasColors)
							{
								colorFlag=CDK.checkPixelColor(pixel,colorExclusionArray,thisAlpha);
							}
							
							if(!colorFlag) edgeArray.push(k >> 2);
						}
					}
				}
			}
			
			var edgePoint:int, numEdges:int = edgeArray.length;
//				
//			if(this.testBm==null){
//				testBmd = new BitmapData(item1.width << 1, item1.height << 1,false, 0xff000000);
//				testBm=new Bitmap(testBmd);
//				item1.stage.addChild(testBm);
//				testBm.x=200;
//				testBm.y=200;				
//			}else{
//				testBmd.dispose();
//			}
//			testBmd = new BitmapData(item1.width << 1, item1.height << 1,false, 0xff000000);
//			testBm.bitmapData=testBmd;
//			testBmd.lock();
			//面积较大那个物体在小物体矩形框内的叠合图形
			//矩形框的中心点是小物体的矩形中心
			//矩形框放大了2背
			//overlapCenterX，overlapCenterY是叠合图形的几何重心，用于计算叠合时的角度
			var overlapCenterX:Number=0;
			var overlapCenterY:Number=0;
			for(j = 0; j < numEdges; j++)
			{
				edgePoint = int(edgeArray[j]);
				var edgeX:Number=edgePoint % rowWidth;
				var edgeY:Number=edgePoint / rowWidth;
//                testBmd.setPixel32(edgeX,edgeY,0xffff0000);
				overlapCenterX+=edgeX;
				overlapCenterY+=edgeY;
				
			}
			overlapCenterX/=numEdges;
			overlapCenterY/=numEdges;
//			testBmd.setPixel32(center.x,center.y,0xffff0000);
//			testBmd.setPixel32(overlapCenterX,overlapCenterY,0xff00ff00);
//			testBmd.unlock();

			var average:Number =Math.atan2(overlapCenterY-center.y, overlapCenterX-center.x);
			var line:Line=new Line(new Point(overlapCenterX,overlapCenterY),center);
			
			
			var startY:int=Math.min(center.y,overlapCenterY);
			var endY:int=Math.max(center.y,overlapCenterY);
			
			var startX:int=Math.min(center.x,overlapCenterX);
			var endX:int=Math.max(center.x,overlapCenterX);
			
			var checkSolid:Boolean;
			var x0:int;
			var y0:int;
			var x1:int;
			var y1:int;
//			testBmd.lock();
			
			if((endX-startX)>=(endY-startY)){
				checkSolid=(center.x<=overlapCenterX);
				//trace("X>Y",(checkSolid?"checkSolid":"toCenter"));
				for (x0=startX;x0<endX;x0++){
					y0=line.getY(x0);
//					testBmd.setPixel32(x0,y0,0xff00ff00);
					pixels.position=((y0*rowWidth)+x0)<<2;			
					try
					{
						pixel = pixels.readUnsignedInt();
					}
					catch(e:EOFError)
					{
						break;
					}
					if(CDK.checkEdgePoint(pixel,colorExclusionArray,checkSolid,this.alphaThreshold)){
						x1=x0;
						y1=y0;
						break;
					}					
				}
			}else{
				checkSolid=(center.y<=overlapCenterY);
				//trace("X<Y",(checkSolid?"checkSolid":"toCenter"));
				for (y0=startY;y0<endY;y0++){
					x0=line.getX(y0);
//				    testBmd.setPixel32(x0,y0,0xff00ff00);
					pixels.position=((y0*rowWidth)+x0)<<2;			
					try
					{
						pixel = pixels.readUnsignedInt();
					}
					catch(e:EOFError)
					{
						break;
					}
					if(CDK.checkEdgePoint(pixel,colorExclusionArray,checkSolid,this.alphaThreshold)){
						x1=x0;
						y1=y0;
						break;
					}					
				}
			}
			var dis:int=MathUtil.getDistanceByPoint(center,new Point(x1,y1));
//			testBmd.unlock();
			//trace("距离哦: "+dis/2);
//			this.showBmForTest(average);
			return [average,dis];
		}		
		
	}
}