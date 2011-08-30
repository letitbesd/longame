package com.longame.display
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.plugins.BlurPlugin;
	import com.gskinner.motion.plugins.ColorAdjustPlugin;
	import com.gskinner.motion.plugins.MatrixPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.longame.model.Range;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MathUtil;
	import com.longame.utils.MatrixTransformer;

    /**
	 * 虚拟镜头
	 * */
	public class Camera 
	{
		/**
		 * 渐变效果所用的渐变函数，见com.gskinner.motion.easing.*;
		 * */
		public var ease:Function=Linear.easeNone;
		/**
		 * 镜头变换时间消耗，秒,0.5还不行？
		 * */
		public var duration:int=0;
		
		private var target:DisplayObject;
		private var lensRect:Rectangle;
		private var explicitTargetWidth:Number;
		private var explicitTargetHeight:Number;
		/**
		 * 镜头中心点
		 * */
		private var lensCenter:Point;
		
		private var currentTarget:DisplayObject;
		private var currentSpeed:Number;
		private var autoStop:Boolean=false;
		
		private var _zoom:Number=1;
		private var _rotation:Number=0;
		private var _x:Number=0;
		private var _y:Number=0;
		private var _offsetX:Number=0;
		private var _offsetY:Number=0;
		
		private var _blurX:int=0;
		private var _blurY:int=0;
		
		private var _brightness:Number=0;
		private var _contrast:Number=0;
		private var _saturation:Number=0;
		private var _hue:Number=0;
		
		private var _transformInvalidated:Boolean;
		private var _blurInvalidated:Boolean;
		private var _colorInvalidated:Boolean;
		
		private var matrix:Matrix=new Matrix();
		
		/**
		 * 虚拟镜头
		 * @param target: 目标对象，通常是大面积的场景或背景
		 * @param lensRect:镜头的边框，以全局坐标系为准，目标将被限制到lensRect的范围内显示，lensRect不指定则为整个舞台，
		 *                 target左上角不能移入 lensRect的左上角，target右下角不能移入lensRect的右下角
		 * @param width:   手动指定场景的宽度，不指定则自动计算target的宽度
		 * @param height:  手动指定场景的高度，不指定则自动计算target的高度
		 * */
		public function Camera(target:DisplayObject,lensRect:Rectangle=null,width:Number=0,height:Number=0)
		{
			MatrixPlugin.install();
			BlurPlugin.install();
			ColorAdjustPlugin.install();
			this.target=target;
			this.lensRect=lensRect;
			this.explicitTargetWidth=width;
			this.explicitTargetHeight=height;
			if(target.stage==null) target.addEventListener(Event.ADDED_TO_STAGE,init);
			else init();
		}
		private function init(e:Event=null):void
		{
			if(lensRect==null){
				var stage:Stage=target.stage;
				lensRect=stage.getBounds(stage);
			}
			var cx:Number=(lensRect.left+lensRect.right)/2;
			var cy:Number=(lensRect.top+lensRect.bottom)/2;	
			lensCenter=new Point(cx,cy);
			//初始化下_x,_y
			var lensCenterInTarget:Point=target.globalToLocal(lensCenter);
			_x=lensCenterInTarget.x;
			_y=lensCenterInTarget.y;
			
			if(e) target.removeEventListener(Event.ADDED_TO_STAGE,init);
		}
		/**
		 * 要实现镜头效果，需要外部轮番调用render()
		 * */
		public function render():void
		{
			if(target.stage==null) return;
			
			if(this.currentTarget&&this.currentTarget.stage){
				//目标不为空且在舞台上，持续跟随
				var p:Point=new Point(this.currentTarget.x,this.currentTarget.y);
				p=this.currentTarget.parent.localToGlobal(p);
				p=this.target.globalToLocal(p);
				this.x=p.x;
				this.y=p.y;
			}
			if(_transformInvalidated){
				validateTransform();
				_transformInvalidated=false;
			}else if(this.autoStop){
				this.stopFollow();
			}
			if(_colorInvalidated){
				validateColor();
				_colorInvalidated=false;
			}
			if(_blurInvalidated){
				validateBlur();
				_blurInvalidated=false;
			}
		}
		public function get bounds():Rectangle
		{
			return lensRect;
		}
		/**
		 * 缩放
		 * */
		public function get zoom():Number
		{
			return _zoom;
		}
		public function set zoom(value:Number):void
		{
			if(_zoom==value) return;
			_zoom=value;
			_transformInvalidated=true;
		}
		/**
		 * 旋转
		 * */
		public function get rotation():Number
		{
			return _rotation;
		}
		public function set rotation(value:Number):void
		{
			if(_rotation==value) return;
			_rotation=value;
			_transformInvalidated=true;
		}
		/**
		 * 将摄像头对准x点，在target的坐标系下
		 * */
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			if(value==_x) return;
			_x=value;
			_transformInvalidated=true;
		}
		/**
		 * 将摄像头对准y点，在target的坐标系下
		 * */
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			if(value==_y) return;
			_y=value;
			_transformInvalidated=true;
		}
		public function get offsetX():Number
		{
			return _offsetX;
		}
		public function set offsetX(value:Number):void
		{
			if(value==_offsetX) return;
			_offsetX=value;
			_transformInvalidated=true;
		}
		public function get offsetY():Number
		{
			return _offsetY;
		}
		public function set offsetY(value:Number):void
		{
			if(value==_offsetY) return;
			_offsetY=value;
			_transformInvalidated=true;
		}
		public function get blurX():int
		{
			return _blurX;
		}
		public function set blurX(value:int):void
		{
			if(_blurX==value) return;
			_blurX=value;
			_blurInvalidated=true;	
		}
		public function get blurY():int
		{
			return _blurY;
		}
		public function set blurY(value:int):void
		{
			if(_blurY==value) return;
			_blurY=value;
			_blurInvalidated=true;	
		}
		public function get brightness():Number
		{
			return _brightness;
		}
		public function set brightness(value:Number):void
		{
			if(_brightness==value) return;
			_brightness=value;
			_colorInvalidated=true;
		}
		public function get contrast():Number
		{
			return _contrast;
		}
		public function set contrast(value:Number):void
		{
			if(_contrast==value) return;
			_contrast=value;
			_colorInvalidated=true;
		}
		public function get saturation():Number
		{
			return _saturation;
		}
		public function set saturation(value:Number):void
		{
			if(_saturation==value) return;
			_saturation=value;
			_colorInvalidated=true;
		}
		public function get hue():Number
		{
			return _hue;
		}
		public function set hue(value:Number):void
		{
			if(_hue==value) return;
			_hue=value;
			_colorInvalidated=true;
		}
		private function validateTransform():void
		{
			var p:Point=this.calPosition();
			matrix.identity();
			
			var lensCenterInTarget:Point=target.globalToLocal(lensCenter);			
			MatrixTransformer.scaleToAroundInternalPoint(matrix,lensCenterInTarget.x,lensCenterInTarget.y,_zoom,_zoom);
			//todo，有点问题滴
			MatrixTransformer.rotateToAroundInternalPoint(matrix,lensCenterInTarget.x,lensCenterInTarget.y,Math.PI*_rotation/180);
			
			matrix.tx=p.x;
			matrix.ty=p.y;
			if(this.duration>0)
				var g:GTween=GTweener.to(target,this.duration,{a:matrix.a,b:matrix.b,c:matrix.c,d:matrix.d,tx:matrix.tx,ty:matrix.ty},{ease:ease});
			else 
				target.transform.matrix=matrix;
		}
		private function validateColor():void
		{
			var g:GTween=GTweener.to(target,this.duration,{brightness:_brightness,saturation:_saturation,hue:_hue,contrast:_contrast},{ease:ease});
		}
		private function validateBlur():void
		{
			var g:GTween=GTweener.to(target,this.duration,{blurX:_blurX,blurY:_blurY},{ease:ease});
		}
		/**
		 * 显示场景中心点
		 * */
		public function showCenter():void
		{
			var targetRect:Rectangle=target.getRect(target);
			this.x=(targetRect.left+targetRect.right)/2;
			this.y=(targetRect.top+targetRect.bottom)/2;
		}
		/**
		 * 通过缩放显示全部场景
		 * */
		public function showAll():void
		{
			var targetRect:Rectangle=target.getRect(target);
			var wz:Number=lensRect.width/targetRect.width;
			var hz:Number=lensRect.height/targetRect.height;
			this.zoom=Math.min(wz,hz);
			//缩放同时显示中心点
			this.x=(targetRect.left+targetRect.right)/2;
			this.y=(targetRect.top+targetRect.bottom)/2;
		}
		/**
		 * 开始跟随目标
		 * @param target 目标
		 * @param speed 跟进目标当前位置的速度，单位： 像素/毫秒，如果speed=0表示即时跟进目标位置
		 * @param autoStop true则跟随一次就停止，对于持续运动目标，如果想持续追随，就要用false
		 * */
		public function startFollow(target:DisplayObject,speed:Number=0,autoStop:Boolean=false):void
		{
			if(target==this.currentTarget) return;
            this.currentTarget=target;
            this.currentSpeed=speed;
            this.autoStop=autoStop;
		}
		/**
		 * 停止跟随目标
		 * */
		public function stopFollow():void
		{
			this.currentTarget=null;
			this.currentSpeed=0;
		}
		/**
		 * 计算镜头当前位置
		 * */
		private function calPosition():Point
		{			
			var lensCenterInTargetParent:Point=target.parent.globalToLocal(lensCenter);
			//考虑target的注册点，计算target实际应该移动到的位置
			var xx:Number=lensCenterInTargetParent.x-_x*_zoom-_offsetX;
			var yy:Number=lensCenterInTargetParent.y-_y*_zoom-_offsetY;
			//计算视窗内target可移动的范围
			//todo,2.5D场景有问题
//			var ranges:Array=this.calRange();
//			
//			xx=ranges[0].valideValue(xx);
//			yy=ranges[1].valideValue(yy);	
			//还原_x,_y，让摄像头的_x,_y跟当前真实位置同步
			_x=(lensCenterInTargetParent.x-_offsetX-xx)/_zoom;
			_y=(lensCenterInTargetParent.y-_offsetY-yy)/_zoom;
			
			return new Point(xx,yy);
		}	
		/**
		 * 综合视窗大小位置和target的大小及注册点，计算target可移动的范围，不超出视窗边界为准
		 * */
		private function calRange():Array
		{
			var targetRect:Rectangle=target.getRect(target);
			var targetWidth:Number=(this.explicitTargetWidth<=0)?targetRect.width:explicitTargetWidth;
			var targetHeight:Number=(this.explicitTargetHeight<=0)?targetRect.height:explicitTargetHeight;
			
			var vp:Point=new Point(lensRect.x,lensRect.y);
			vp=target.parent.globalToLocal(vp);			
			
			var xMin:Number=vp.x-targetRect.left*_zoom;
			var xMax:Number=vp.x+lensRect.width-(targetWidth+targetRect.left)*_zoom;
			var yMin:Number=vp.y-targetRect.top*_zoom;
			var yMax:Number=vp.y+lensRect.height-(targetHeight+targetRect.top)*_zoom;
			
			var xRange:Range=new Range(xMin,xMax);
			var yRange:Range=new Range(yMin,yMax);	
			return [xRange,yRange];		
		}	
	}
}