package com.longame.game.scene
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.plugins.BlurPlugin;
	import com.gskinner.motion.plugins.ColorAdjustPlugin;
	import com.gskinner.motion.plugins.MatrixPlugin;
	import com.longame.commands.effect.ShockEffect;
	import com.longame.game.component.AbstractComp;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.model.Range;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MatrixTransformer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

    /**
	 * 虚拟镜头
	 * */
	public class Camera extends AbstractComp
	{
		private var _onStop:Signal;
		/**
		 * 渐变效果所用的渐变函数，见com.gskinner.motion.easing.*;
		 * */
		public var ease:Function=Linear.easeNone;
		/**
		 * 镜头所有变换的时间消耗，秒,0.5还不行？，为0则立即变换，没有缓动
		 * 位置移动可通过setFocus,startFollow的_moveSpeed来自动计算，更为科学
		 * */
		public var duration:int=0;
		/**
		 * 指定镜头移动的速度
		 * */
		public var moveSpeed:int=-1;
		private var lensRect:Rectangle;
		private var explicitTargetWidth:Number;
		private var explicitTargetHeight:Number;
		/**
		 * 镜头中心点在舞台上的坐标
		 * */
		private var lensCenter:Point;
		
		private var _followingTarget:IDisplayEntity;
		
		private var _zoom:Number=1;
		private var _rotation:Number=0;
		private var _x:Number=0;
		private var _y:Number=0;
		private var oldPosition:Point;
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
		
		public function Camera(id:String=null)
		{
			super(id);
		}
		/**
		 * 初始化
		* @param lensRect:镜头的边框，以全局坐标系为准，目标将被限制到lensRect的范围内显示，lensRect不指定则为整个舞台，
		*                 scene左上角不能移入 lensRect的左上角，scene右下角不能移入lensRect的右下角
		* @param width:   手动指定场景的宽度，不指定则自动计算scene的宽度
		* @param height:  手动指定场景的高度，不指定则自动计算scene的高度
		* */
		public function initialize(lensRect:Rectangle=null,width:Number=-1,height:Number=-1):void
		{
			if(this.actived) return;
			MatrixPlugin.install();
			BlurPlugin.install();
			ColorAdjustPlugin.install();
			this.lensRect=lensRect;
			this.explicitTargetWidth=width;
			this.explicitTargetHeight=height;
		}
		override protected function whenActive():void
		{
			super.whenActive();
			if(lensRect==null){
				var stage:Stage=sceneContainer.stage;
				lensRect=stage.getBounds(stage);
			}
			var cx:Number=(lensRect.left+lensRect.right)/2;
			var cy:Number=(lensRect.top+lensRect.bottom)/2;	
			lensCenter=new Point(cx,cy);
//			this.updateCameraXY();
			//初始化下_x,_y
			var lensCenterInScene:Point=sceneContainer.globalToLocal(lensCenter);
			_x=lensCenterInScene.x;
			_y=lensCenterInScene.y;
			this.oldPosition=new Point(sceneContainer.x,sceneContainer.y);
		}
		override protected function whenDeactive():void
		{
			super.whenDeactive();
			this.stopFollow();
			if(_transformTween) _transformTween.paused=true;
		}
		override protected function whenDestroy():void
		{
			super.whenDestroy();
			this._onStop=null;
			_transformTween=null;
		}
		private function onCameraStopped(param:*=null):void
		{
			if(this._onStop){
				this._onStop.dispatch();
			}
		}
		/**
		 * 要实现镜头效果，需要外部轮番调用render()
		 * */
		public function render():void
		{
			if(sceneContainer.stage==null) return;
			if(_transformInvalidated){
				validateTransform();
				_transformInvalidated=false;
			}
			if(_colorInvalidated){
				validateColor();
				_colorInvalidated=false;
			}
			if(_blurInvalidated){
				validateBlur();
				_blurInvalidated=false;
			}
			var newPos:Point=new Point(sceneContainer.x,sceneContainer.y);
			var moved:Point=newPos.subtract(this.oldPosition);
			if(moved.length>0){
//				this.updateCameraXY();
				this.handleParallaxChildren(moved);
				this.oldPosition=newPos;
			}
		}
		/**
		 * 当镜头停止移动时分发
		 * */
		public function get onStop():Signal
		{
			if((_onStop==null)&& !destroyed) _onStop=new Signal();
			return _onStop;
		}
		/**
		 * 指示镜头目前是否空闲，如果在做移动，旋转等动作就是false
		 * 或者有变化还没实施
		 * */
		public function get idle():Boolean
		{
			if(_transformTween&&_transformTween.paused) return true;
			return !_transformInvalidated&&!_blurInvalidated&&!_colorInvalidated;
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
		 * 将摄像头对准x点，在sceneContainer的坐标系下
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
		 * 将摄像头对准y点，在sceneContainer的坐标系下
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
		private var _transformTween:GTween;
		private function validateTransform():void
		{
			var newPos:Point=this.calPosition();
			matrix.identity();
			
			var lensCenterInScene:Point=sceneContainer.globalToLocal(lensCenter);			
			MatrixTransformer.scaleToAroundInternalPoint(matrix,lensCenterInScene.x,lensCenterInScene.y,_zoom,_zoom);
			//todo，有点问题滴
			MatrixTransformer.rotateToAroundInternalPoint(matrix,lensCenterInScene.x,lensCenterInScene.y,Math.PI*_rotation/180);
			
			matrix.tx=newPos.x;
			matrix.ty=newPos.y;
			
			var time:Number=this.calMoveDuration(new Point(sceneContainer.x,sceneContainer.y),newPos);
			if(time>0){
				if(_transformTween==null) {
					_transformTween=new GTween(sceneContainer);
					_transformTween.ease=ease;
					_transformTween.onComplete=onCameraStopped;
				}
				time=Math.max(0.1,time);
				_transformTween.duration=time;
				_transformTween.setValues({a:matrix.a,b:matrix.b,c:matrix.c,d:matrix.d,tx:matrix.tx,ty:matrix.ty});
				_transformTween.paused=false;
			}else{
				sceneContainer.transform.matrix=matrix;
			}
		}
		/**
		 * 当场景移动时，处理有视差的子对象
		 * @param movedDist 场景向x,y方向分别移动了多少距离
		 * */
		private function handleParallaxChildren(movedDist:Point):void
		{
			for each(var child:IDisplayEntity in scene.parallaxChildren){
				//所有parallax属性不为1的对象
				//如果parallax<1,表示移动慢点，那么需要向sceneContainer的反方向移动一点
				//如果parallax>1，表示移动快点，那么需要向sceneContainer的正方向多移动一点
				//还应考虑场景的缩放
				var deltaX:Number=-movedDist.x*(1-child.parallax)/_zoom;
				var deltaY:Number=-movedDist.y*(1-child.parallax)/_zoom;
				//转换成场景坐标
				var delta:Vector3D=SceneManager.screenToScene(new Vector3D(deltaX,deltaY));
				child.container.x+=delta.x;
				child.container.y+=delta.y;
			}
		}
		private function validateColor():void
		{
			var g:GTween=GTweener.to(sceneContainer,duration,{brightness:_brightness,saturation:_saturation,hue:_hue,contrast:_contrast},{ease:ease});
		}
		private function validateBlur():void
		{
			var g:GTween=GTweener.to(sceneContainer,duration,{blurX:_blurX,blurY:_blurY},{ease:ease});
		}
		/**
		 * 显示场景中心点
		 * */
		public function showCenter():void
		{
			var targetRect:Rectangle=sceneContainer.getRect(sceneContainer);
			this.x=(targetRect.left+targetRect.right)/2;
			this.y=(targetRect.top+targetRect.bottom)/2;
		}
		/**
		 * 通过缩放显示全部场景
		 * */
		public function showAll():void
		{
			var targetRect:Rectangle=sceneContainer.getRect(sceneContainer);
			var wz:Number=lensRect.width/targetRect.width;
			var hz:Number=lensRect.height/targetRect.height;
			this.zoom=Math.min(wz,hz);
			//缩放同时显示中心点
			this.x=(targetRect.left+targetRect.right)/2;
			this.y=(targetRect.top+targetRect.bottom)/2;
		}
		/**
		 * 将视角中心放到对象target上
		 * @param target 目标对象
		 * @param speed 镜头每秒移动多少像素
		 *              speed<0，镜头移动时间按照 this.duration来确定
		 *              speed==0,镜头立即到达
		 *              speed>0， 镜头根据移动距离的多少缓动到达
		 * */
		public function setFocus(target:IDisplayEntity,speed:int=-1):void
		{
			if(_transformTween) {
				_transformTween.paused=true;
			}
			if(this._followingTarget) this.stopFollow();
			this.moveSpeed=speed;
			var pos:Point=new Point(target.container.x,target.container.y);
			pos=target.parent.container.localToGlobal(pos);
			pos=sceneContainer.globalToLocal(pos);
			this.x=pos.x;
			this.y=pos.y;
		}
		/**
		 * 开始跟随目标
		 * @param target 目标
		 * @param speed 镜头每秒移动多少像素
		 *              speed<0，镜头移动时间按照 this.duration来确定
		 *              speed==0,镜头立即到达
		 *              speed>0， 镜头根据移动距离的多少缓动到达
		 * */
		public function startFollow(target:IDisplayEntity,speed:int=-1):void
		{
			if(target==this._followingTarget) return;
			if(_transformTween) {
				_transformTween.paused=true;
			}
			this.moveSpeed=speed;
			if(this._followingTarget) this.stopFollow();
			if(target){
				this._followingTarget=target;
				this._followingTarget.onMove.add(onFollowingTargetMove);
				this._followingTarget.onDeactive.add(onFollowingTargetDeactived);
				if(duration>=0) this.duration=duration;
			}
		}
		/**
		 * 停止跟随目标
		 * */
		public function stopFollow():void
		{
			if(this._followingTarget&&(!this._followingTarget.destroyed)){
				this._followingTarget.onMove.remove(onFollowingTargetMove);
				this._followingTarget.onDeactive.remove(onFollowingTargetDeactived);
			}
			
			this._followingTarget=null;
		}
		/**
		 * 镜头震动
		 * @param magnitude 震动幅度大小，比如22像素，会在这个基础上做随机
		 * */
		public function shock(magnitude:int=22):void
		{
			if(_transformTween) _transformTween.paused=true;
			this.moveSpeed=0;
			var shock:ShockEffect=new ShockEffect();
			shock.addTarget(this,magnitude);
			shock.onComplete.addOnce(this.onCameraStopped);
			shock.execute();
		}
		/**
		 * 当跟随对象移动时，移动镜头
		 * */
		private function onFollowingTargetMove(target:IDisplayEntity):void
		{
			if(this._followingTarget&&this._followingTarget.actived){
				var p:Point=new Point(this._followingTarget.container.x,this._followingTarget.container.y);
				p=this._followingTarget.container.parent.localToGlobal(p);
				p=this.sceneContainer.globalToLocal(p);
				this.x=p.x;
				this.y=p.y;
			}
		}
		/**
		 * 当对象被删除时，停止跟随
		 * */
		private function onFollowingTargetDeactived(target:IDisplayEntity):void
		{
			this.stopFollow();
		}
		/**
		 * 根据镜头当前位置计算场景的位置
		 * */
		private function calPosition():Point
		{			
			//场景的0,0点移动到镜头中心时场景的位置
			var zero:Point=sceneContainer.parent.globalToLocal(lensCenter);
			var targetPos:Point=new Point(_x+_offsetX,	_y+_offsetY);
			targetPos=sceneContainer.localToGlobal(targetPos);
			targetPos=sceneContainer.parent.globalToLocal(targetPos);
			var xx:Number=zero.x-targetPos.x;
			var yy:Number=zero.y-targetPos.y;
			//考虑target的注册点，计算target实际应该移动到的位置
//			var xx:Number=zero.x-(_x+offsetX)*_zoom;
//			var yy:Number=zero.y-(_y+offsetY)*_zoom;
			//计算视窗内target可移动的范围
			var ranges:Array=this.calRange();
			
			xx=ranges[0].valideValue(xx);
			yy=ranges[1].valideValue(yy);	
			//还原_x,_y，让摄像头的_x,_y跟当前真实位置同步
//			_x=(lensCenterInTargetParent.x-_offsetX-xx)/_zoom;
//			_y=(lensCenterInTargetParent.y-_offsetY-yy)/_zoom;
			this.updateCameraXY();
			return new Point(xx,yy);
		}	
		/**
		 * 还原_x,_y，让摄像头的_x,_y跟当前真实位置同步
		 * */
		private function updateCameraXY():void
		{
			var lensCenterInScene:Point=sceneContainer.parent.globalToLocal(lensCenter);
			_x=(lensCenterInScene.x-_offsetX-sceneContainer.x)/_zoom;
			_y=(lensCenterInScene.y-_offsetY-sceneContainer.y)/_zoom;
		}
		/**
		 * 综合视窗大小位置和target的大小及注册点，计算target可移动的范围，不超出视窗边界为准
		 * */
		private function calRange():Array
		{
			var targetRect:Rectangle=sceneContainer.getRect(sceneContainer);
			var targetWidth:Number=(this.explicitTargetWidth<=0)?targetRect.width:explicitTargetWidth;
			var targetHeight:Number=(this.explicitTargetHeight<=0)?targetRect.height:explicitTargetHeight;
			
			var vp:Point=new Point(lensRect.x,lensRect.y);
			vp=sceneContainer.parent.globalToLocal(vp);			
			
			var xMin:Number=vp.x+lensRect.width-(targetWidth+targetRect.left)*_zoom;
			var xMax:Number=vp.x-targetRect.left*_zoom;
			var yMin:Number=vp.y+lensRect.height-(targetHeight+targetRect.top)*_zoom;
			var yMax:Number=vp.y-targetRect.top*_zoom;
			
			var xRange:Range=new Range(xMin,xMax);
			var yRange:Range=new Range(yMin,yMax);	
			return [xRange,yRange];		
		}
		/**
		 * 根据指定当前的移动速度，来计算缓动时间
		 * 原则:_moveSpeed<0，则取 duration
		 *      _moveSpeed==0，取0
		 *      _moveSpeed>0,根据距离计算
		 * */
		private function calMoveDuration(oldPos:Point,newPos:Point):Number
		{
			if(moveSpeed<0) return duration;
			else if(moveSpeed==0) return 0;
			var dis:Number=newPos.subtract(oldPos).length;
//			trace(dis,dis/_moveSpeed);
			return dis/moveSpeed;
		}
		private function get scene():BaseScene
		{
			return _owner as BaseScene;
		}
		private function get sceneContainer():Sprite
		{
			return scene.container;
		}
	}
}