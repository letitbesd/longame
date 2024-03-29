﻿/*
CASA Lib for ActionScript 3.0
Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

- Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

- Neither the name of the CASA Lib nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/
package{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 Provides utility functions for DisplayObjects/DisplayObjectContainers.
	 
	 @author Aaron Clinger
	 @version 05/25/09
	 */
	public class DisplayObjectUtil {
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//  ADOBE SYSTEMS INCORPORATED
		//  Copyright 2006 Adobe Systems Incorporated
		//  All Rights Reserved.
		//
		//  NOTICE: Adobe permits you to use, modify, and distribute this file
		//  in accordance with the terms of the license agreement accompanying it.
		//
		////////////////////////////////////////////////////////////////////////////////
		public static var RESTORE:int = 0;
		public static var MIRROR_HORIZONTAL:int = 1;
		public static var MIRROR_VERTICAL:int = 2;
		/**
		 * 以对象的图形中心（不是注册点）水平翻转
		 * */
		public static function flipHorizontal(target:DisplayObject):void
		{
			var center:Point=getCenter(target);
			var sx:Number=-1;//(target.scaleX>0)?-1:1;
			scaleAround(target,center.x,0,target.scaleX*sx,target.scaleY);
			
		}
		/**
		 * 以对象的图形中心（不是注册点）垂直翻转
		 * */		
		public static function flipVertical(target:DisplayObject):void
		{
			var center:Point=getCenter(target);
			var sy:Number=-1;//(target.scaleY>0)?-1:1;
			scaleAround(target,0,center.y,target.scaleX,target.scaleY*sy);			 
		}	
		/**
		 * 获取target在coordinateSpace坐标系下的几何中心点，coordinateSpace的意义同getBounds方法的说明
		 * 要获取target在coordinateSpace坐标系下的左边缘/右边缘/上边缘/下边缘采用类似的方法
		 * */
		public static function getCenter(target:DisplayObject,coordinateSpace:DisplayObject=null):Point
		{
			if(coordinateSpace==null) coordinateSpace=target;
			var rect:Rectangle=target.getBounds(coordinateSpace);
			return new Point((rect.left+rect.right)/2,(rect.top+rect.bottom)/2);			
		}
		/**
		 * 计算target在theParent坐标系下的左上角位置
		 * */
		public static function getLeftTop(target:DisplayObject,coordinateSpace:DisplayObject=null):Point
		{
			if(coordinateSpace==null) coordinateSpace=target;
			var rec:Rectangle=target.getBounds(coordinateSpace);
			return new Point(rec.left,rec.top);
		}		
		/**
		 * 将对象中心点放到_x,_y位置
		 * */
		
		public static function centerOnPoint(target:DisplayObject,_x:Number,_y:Number):void
		{
			var d:Point=getCenter(target)
			target.x=_x-target.scaleX*d.x;
			target.y=_y-target.scaleY*d.y;
		}
		/**
		 * 将对象左上角放到_x,_y位置
		 * */
		
		public static function lefttopOnPoint(target:DisplayObject,_x:Number,_y:Number):void
		{
			var d:Point=getLeftTop(target)
			target.x=_x-target.scaleX*d.x;
			target.y=_y-target.scaleY*d.y;
		}		
		/**
		 * 将目标大小限制在container以内，并将其居中
		 * 对于target尺寸比container要大的情况，需要调用此函数后再addChild
		 * todo 遇到scale不为1的情况，还需要测试
		 * noScaleUp:如果target的尺寸比container小，不放大
		 * */
		public static function restrainAndCenterInContainer(target:DisplayObject,container:DisplayObjectContainer,noScaleUp:Boolean=true):void
		{
			var rect:Rectangle=container.getBounds(container);
			restrainAndCenterInRect(target,rect,noScaleUp);
		}
		/**
		 * 将目标大小限制在rect大小以内，并将其居中
		 * noScaleUp:如果target的尺寸比rect小，不放大
		 * */
		public static function restrainAndCenterInRect(target:DisplayObject,rect:Rectangle,noScaleUp:Boolean=true):void
		{
			if(!(noScaleUp&&(target.width<=rect.width)&&(target.height<=rect.height)))	resizeAndMaintainAspectRatio(target,rect.width,rect.height);
			var centerX:Number=(rect.left+rect.right)/2;
			var centerY:Number=(rect.top+rect.bottom)/2;
			centerOnPoint(target,centerX,centerY);
		}
		/**
		 * Resizes a DisplayObject to fit into specified bounds such that the
		 * aspect ratio of the target's width and height does not change.
		 * 
		 * @param target		The DisplayObject to resize.
		 * @param width			The desired width for the target.
		 * @param height		The desired height for the target.
		 * @param aspectRatio	The desired aspect ratio. If NaN, the aspect
		 * 						ratio is calculated from the target's current
		 * 						width and height.
		 */
		public static function resizeAndMaintainAspectRatio(target:DisplayObject, width:Number, height:Number, aspectRatio:Number = NaN):void
		{
			var currentAspectRatio:Number = !isNaN(aspectRatio) ? aspectRatio : target.width / target.height;
			var boundsAspectRatio:Number = width / height;
			
			if(currentAspectRatio < boundsAspectRatio)
			{
				target.width = Math.floor(height * currentAspectRatio);
				target.height = height;
			}
			else
			{
				target.width = width;
				target.height = Math.floor(width / currentAspectRatio);
			}
		}		
		/**
		 * Scale around an arbitrary centre point
		 * @param Number local horizontal offset from 'real' registration point
		 * @param Number local vertical offset from 'real' registration point
		 * @param Number relative scaleX increase; e.g. 2 to double, 0.5 to half
		 * @param Number relative scaleY increase
		 */ 
		public static function scaleAround(target:DisplayObject, offsetX:Number, offsetY:Number, absScaleX:Number, absScaleY:Number ):void { 
			// scaling will be done relatively 
			var relScaleX:Number = absScaleX/target.scaleX; 
			var relScaleY:Number = absScaleY /target.scaleY; 
			// map vector to centre point within parent scope 
			var AC:Point = new Point( offsetX, offsetY ); 
			AC = target.localToGlobal( AC ); 
			AC = target.parent.globalToLocal( AC ); 
			// current registered postion AB 
			var AB:Point = new Point( target.x, target.y ); 
			// CB = AB - AC, this vector that will scale as it runs from the centre 
			var CB:Point = AB.subtract( AC ); 
			CB.x *= relScaleX; 
			CB.y *= relScaleY; 
			// recaulate AB, this will be the adjusted position for the clip 
			AB = AC.add( CB ); 
			// set actual properties 
			target.scaleX *= relScaleX; 
			target.scaleY *= relScaleY; 
			target.x = AB.x; 
			target.y = AB.y; 
		}		
		/**
		 * Rotate around an arbitrary centre point
		 * @param Number local horizontal offset from 'real' registration point
		 * @param Number local vertical offset from 'real' registration point
		 * @param Number absolute rotation in degrees 
		 */ 
		public static function rotateAround(target:DisplayObject, offsetX:Number, offsetY:Number, toDegrees:Number ):void { 
			var relDegrees:Number = toDegrees - ( target.rotation % 360 ); 
			var relRadians:Number = Math.PI * relDegrees / 180; 
			var M:Matrix = new Matrix( 1, 0, 0, 1, 0, 0 ); 
			M.rotate( relRadians ); 
			// map vector to centre point within parent scope 
			var AC:Point = new Point( offsetX, offsetY ); 
			AC = target.localToGlobal( AC ); 
			AC = target.parent.globalToLocal( AC ); 
			// current registered postion AB 
			var AB:Point = new Point( target.x, target.y ); 
			// point to rotate, offset position from virtual centre 
			var CB:Point = AB.subtract( AC ); 
			// rotate CB around imaginary centre  
			// then get new AB = AC + CB 
			CB = M.transformPoint( CB ); 
			AB = AC.add( CB ); 
			// set real values on clip 
			target.rotation = toDegrees; 
			target.x = AB.x; 
			target.y = AB.y; 
		} 
		public static function reshape(target:DisplayObject,type:int):void{
			switch(type){
				case RESTORE:
					var m:Matrix = target.transform.matrix;
					m.a = m.d = 1;
					target.transform.matrix = m;
					break;
				case MIRROR_HORIZONTAL:
					if (target.scaleX > 0) target.scaleX *= -1;
					break;
				case MIRROR_VERTICAL:
					if (target.scaleY > 0) target.scaleY *= -1;
					break;
			}
		}
		/**
		 * duplicateDisplayObject
		 * creates a duplicate of the DisplayObject passed.
		 * similar to duplicateMovieClip in AVM1
		 * @param target the display object to duplicate
		 * @param autoAdd if true, adds the duplicate to the display list
		 * in which target was located
		 * @return a duplicate instance of target
		 * 
		 * //******注意********
		 * 对于flash库中的MovieClip等对象，要加个外链接类才可以实现
		 */
		public function duplicate(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			cloneDisplayProperty(duplicate,target);
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
		// duplicate properties
		protected static function cloneDisplayProperty(display:DisplayObject,target:DisplayObject):void
		{
			// duplicate properties
			display.transform = target.transform;
			display.filters = target.filters;
			display.cacheAsBitmap = target.cacheAsBitmap;
			display.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				//rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				display.scale9Grid = rect;
			}			
		}
		/**
		 * 将对象的图像画出来，也就是说只复制外形
		 *复制后的对象保留在theParent坐标系下的视觉效果
		 *主要是旋转和缩放等属性，然后将此图形放到一个Sprite中，使此Sprite的中心点位置和原对象一致
		 * opagueColor 0xff00ff，不要带透明度通道
		 * */
		public static function drawAsSprite(target:DisplayObject,theParent:DisplayObjectContainer=null,autoAdd:Boolean=false,opagueColor:int=-1):Sprite
		{
			var spr:Sprite=new Sprite();
			var bmp:Bitmap=drawAsBitmap(target,theParent,false,opagueColor);
			spr.addChild(bmp);
			//计算注册点
			var leftTop:Point=getLeftTop(target,theParent);				
			bmp.x=leftTop.x;
			bmp.y=leftTop.y;
			if(theParent&&autoAdd){
				theParent.addChild(spr);
			}			
			return spr;
		}	        
		/**
		 * target.visible=false,并不影响哦。。。。
		 * 将对象的图像画出来，也就是说只复制外形
		 *复制后的对象保留在theParent坐标系下的视觉效果
		 *主要是旋转和缩放等属性
		 *  opagueColor 0xff00ff，不要带透明度通道
		 * */
		public static function drawAsBitmap(target:DisplayObject,theParent:DisplayObjectContainer=null,autoAdd:Boolean=false,opagueColor:int=-1):Bitmap
		{
			var bmd:BitmapData=getBitmapData(target,theParent,opagueColor,-1,-1).bmd as BitmapData;
			var bmp:Bitmap=new Bitmap(bmd,"auto",true);
			if(theParent&&autoAdd){
				theParent.addChild(bmp);
			}			
			return bmp;
		}	
		/**
		 * 将对象的图像画出来，也就是说只复制外形
		 *复制后的对象保留在theParent坐标系下的视觉效果
		 *主要是旋转和缩放等属性
		 * 此方法只获取其BitmapData
		 * @param target 要获取的可视对象
		 * @param theParent 对象的父级，在其坐标系下呈现
		 * @param width 指定的宽度,无指定则自动计算
		 * @param height 指定的高度，无指定则自动计算
		 * @param opagueColor 不透明色，不指定则透明  opagueColor 0xff00ff，不要带透明度通道
		 * @param matrix  draw时的matrix，非特殊情况不用指定
		 * */		
		public static function getBitmapData(target:DisplayObject,theParent:DisplayObjectContainer=null,opagueColor:int=-1,width:int=-1,height:int=-1,matrix:Matrix=null):Object
		{
			var bmd:BitmapData;
			var mat:Matrix;
            //如果是 bitmap直接搞回去
			if(target is Bitmap){
				bmd=(target as Bitmap).bitmapData;
			}else
			{
				var _theParent:DisplayObject=theParent;
				if(_theParent==null) _theParent=target;
				mat=matrix;
				if(mat==null) mat=getMartrix(target,_theParent);
				var rect:Rectangle = target.getBounds(_theParent);
				if(width<0) width=Math.round(rect.width);
				if(height<0) height=Math.round(rect.height);
				var transparent:Boolean=(opagueColor<0);
				var theColor:uint=transparent?0x00ffffff:opagueColor;
				bmd=new BitmapData(width,height,transparent,theColor);
				bmd.draw(target,mat,target.transform.colorTransform,target.blendMode,null,true);
			}	
			return {bmd:bmd,mat:mat}			
		}	
		/**
		 * 获取mc frame帧的位图数据,frame可以是index，也可以是label
		 * */
		public static function getFrameBitmapData(mc:MovieClip, frame:*):BitmapData
		{
			var frameIndex:uint=1;
			if(frame is int) frameIndex=frame as int;
			else if(frame is String) frameIndex=MovieClipUtil.getFrame(mc,frame as String);
			else frame=1;
			frameIndex=Math.min(mc.totalFrames,Math.max(1,frameIndex));
			mc.gotoAndStop(frameIndex);
			//todo
//			MovieClipUtil.advanceChildClips(mc,frameIndex);
			return DisplayObjectUtil.getBitmapData(mc).bmd as BitmapData;
		}
		/**
		 *计算target在theParent坐标系下的Martrix，使得复制后的对象保留在theParent坐标系下的视觉效果
		 *主要是旋转和缩放等属性
		 * 
		 */
		public static function getMartrix(target:DisplayObject,theParent:DisplayObject=null):Matrix
		{
			if(theParent==null) theParent=target;
			if(theParent!=target){
				if(!DisplayObjectContainer(theParent).contains(target)){
					throw new Error("theParent must contain the target!"); 	
				}
			}
			var mat:Matrix =new Matrix();	
			if(theParent!=target){
				var currentParent:DisplayObject = target;
				while(currentParent !=theParent)
				{
					mat.concat(currentParent.transform.matrix);
					currentParent = currentParent.parent;
				}					
			}	
			var leftTop:Point=getLeftTop(target,theParent);
			var rigister:Point=new Point();
			if(theParent!=target){
				rigister=target.localToGlobal(rigister);
				rigister=theParent.globalToLocal(rigister);
			}
			mat.tx=rigister.x-leftTop.x;
			mat.ty=rigister.y-leftTop.y;
			return mat;
		}
	}
}