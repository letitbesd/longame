package com.longame.modules.entities
{
	import com.longame.core.IAnimatedObject;
	import com.longame.core.long_internal;
	import com.longame.display.GameAnimator;
	import com.longame.display.core.RenderManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.RenderData;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MovieClipUtil;
	import com.longame.utils.ObjectUtil;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	use namespace long_internal;

	/**
	 * 目前采用的方式是clip继续play，然后渲染每帧的位图，那叫卡啊，而且方向变化后明显不对，位图渲染todo
	 * */
	public class AnimatorEntity extends SpriteEntity
	{
		/**
		 * 当一个动画播放完毕时发出,通常是通过gotoAndPlay来播放动画的时候，如果loops为-1，就不会发出这个事件
		 * @param String是动画的帧名
		 * */
		public var onAnimationPlayed:Signal=new Signal(String);
		
		protected var _defaultAnimation:String;
		/**
		 * 所有的帧标签map，存储着 帧标签和帧数的相互索引
		 * 基于以下设定：所有方向的mc具有相同的动画序列
		 * */
		protected var _labelsMap:Dictionary;
		
		public function AnimatorEntity(id:String=null)
		{
			super(id);
		}
		override protected function doWhenDestroy():void
		{
			super.doWhenDestroy();
			_labelsMap=null;
			labelToLoop=null;
			lastClipState=null;
		}
		override protected function removeSignals():void
		{
			super.removeSignals();
			onAnimationPlayed.removeAll();
			onAnimationPlayed=null;
		}
		override protected function  doWhenBuild():void
		{
			if(clip){
				_labelsMap=new Dictionary();
				var labels:Array=clip.currentLabels;
				for(var i:int=0;i<labels.length;i++){
					var label:FrameLabel=labels[i];
					_labelsMap[label.frame]=label.name;
					_labelsMap[label.name]=label.frame
				}
				if(_labelsMap[_currentFrame]) this._currentLabel=_labelsMap[_currentFrame];
			}
			if(!this.setLastClipState()){
				if(this._defaultAnimation) this.gotoAndPlay(this._defaultAnimation,-1);
				else this.play();
			}
			super.doWhenBuild();
		}
		/**
		 * 记录动画的上一帧，用于判断动画是否在播放
		 * */
		protected var _oldFrame:int=1;
		override protected function renderBitmap():void
		{
			if(_bitmapInvalidated||(_oldFrame!=this.currentFrame)){
				RenderManager.loadRender(this._currentSource,effects,this.currentFrame,onBitmapLoaded);
				_oldFrame=this.currentFrame;
				_bitmapInvalidated=false;
			}
		}
		override protected function onBitmapLoaded(data:RenderData):void
		{
			super.onBitmapLoaded(data);
			
		}
		/**
		 * animator要显示的影片剪辑，注意：只有非位图渲染情况下，影片剪辑会被加进舞台显示
		 * */
		final public function get clip():MovieClip
		{
			return this._sprite as MovieClip;
		}
		protected var labelToLoop:LoopedLabelFrame=new LoopedLabelFrame();
		protected var lastClipState:ClipState=new ClipState();
		/**
		 * 播放某帧
		 * @param frame: 索引或标签
		 * @param loops: 如果是标签，则重播放这个标签到下个标签或这个标签到帧尾这个区间段几次，-1为无穷
		 */
		public function gotoAndPlay(frame:Object,loops:int=0):void
		{
			lastClipState.init("gotoAndPlay",[frame,loops]);
			if(this.clip==null){
				return;
			}
			if (this.totalFrames>1)
			{
				try{
					if(!this._renderAsBitmap) this.clip.gotoAndPlay(frame);
					else  this.setFrame(frame);
					if((frame is String)&&(loops!=0)){
						labelToLoop.init(frame as String,_labelsMap[frame],loops);
					}else{
						labelToLoop.reset();
					}
				}catch(e:Error){
					if(!this._renderAsBitmap) this.play();
					labelToLoop.reset();
				}
			}
		}
		public function gotoAndStop(frame:Object):void
		{
			lastClipState.init("gotoAndStop",[frame]);
			if(this.clip==null){
				return;
			}
			labelToLoop.reset();
			if(!this._renderAsBitmap) this.clip.gotoAndStop(frame);
			else this.setFrame(frame);
		}
		public function play():void
		{
			lastClipState.init("play",null);
			if(this.clip==null){
				return;
			}
			labelToLoop.reset();
			if(!this._renderAsBitmap) this.clip.play();
		}
		public function stop():void
		{
			lastClipState.init("stop",null);
			if(this.clip==null){
				return;
			}
			labelToLoop.reset();
			if(!this._renderAsBitmap) this.clip.stop();
		}
		public function get totalFrames():int
		{
			if(clip) return this.clip.totalFrames;
			return 0;
		}
		protected var _currentFrame:int=1;
		public function get currentFrame():int
		{
			if(!_renderAsBitmap && clip) return this.clip.currentFrame;
			return _currentFrame;
		}
		protected var _currentLabel:String;
		public function get currentLabel():String
		{
			if(!_renderAsBitmap && clip) return this.clip.currentLabel;
			return _currentLabel;
		}
		public function get currentFrameLabel():String
		{
			return _labelsMap[currentFrame];
		}
		private var _hasLoop:Boolean;
		override protected function doRender():void
		{
			super.doRender();
			if(this.clip==null) return;
			
			if(this._renderAsBitmap){
				if(this.lastClipState.has){
					switch(this.lastClipState.state){
						case "gotoAndPlay":
						case "play":
							this.setFrame(++_currentFrame);
							break;
						case "gotoAndStop":
						case "stop":
							//do nothing
							break;
					}	
				}
				if(this._currentFrame>this.totalFrames) this.setFrame(1);
			}
			if(this.labelToLoop.has()){
				var needLoop:Boolean=((this.currentLabel!=null)&&(this.currentLabel!=this.labelToLoop.label));
				var needLoop1:Boolean=(this.currentFrame==this.totalFrames);
				if(needLoop||needLoop1){
					this.labelToLoop.loopOnce();
					this.gotoAndPlay(this.labelToLoop.label,this.labelToLoop.loopLeft());
					return;
				}
			}else if(_hasLoop){
				if(this.defaultAnimation) this.gotoAndPlay(this.defaultAnimation,-1);
				else this.play();
				this.onAnimationPlayed.dispatch(labelToLoop.label);
			}
			_hasLoop=this.labelToLoop.has();
		}
		private function setFrame(frame:*):void
		{
			if(frame is String) this._currentFrame=_labelsMap[frame] as int;
			else this._currentFrame=frame as int;
			if(_labelsMap[_currentFrame]) this._currentLabel=_labelsMap[_currentFrame];
		}
		/**
		 * 在clip没有创建好的情况下，调用了动画控制，这时候不起任何作用，当build后就会调用这个完成设定意图
		 * */
		protected function setLastClipState():Boolean
		{
			if(this.clip==null) return false;
			if(this.lastClipState.has){
				switch(this.lastClipState.state){
					case "gotoAndPlay":
						var loops:int=this.lastClipState.params[1];
						if(labelToLoop.has()) loops=labelToLoop.loops;
						this.gotoAndPlay(this.lastClipState.params[0],loops);
						break;
					case "gotoAndStop":
						this.gotoAndStop(this.lastClipState.params[0]);
						break;
					case "play":
						this.play();
						break;
					case "stop":
						this.stop();
						break;
				}
				return true;
			}
			return false;
		}
		public function set defaultAnimation(value:String):void
		{
			if(_defaultAnimation==value) return;
			_defaultAnimation=value;
		}
		public function get defaultAnimation():String
		{
			return _defaultAnimation;
		}
	}
}
internal class LoopedLabelFrame
{
	public var label:String;
	public var frame:uint=0;
	public var loops:int=0;
	protected var _loopLeft:int=0;
	
	protected var _has:Boolean;
	
	public function LoopedLabelFrame()
	{
	}
	public function init(label:String,frame:uint,loop:int):void
	{
		this.label=label;
		this.frame=frame;
		this.loops=loop;
		_loopLeft=loop;
		_has=true;
	}
	public function loopOnce():Boolean
	{
		if(loops<0) return true;
		if(_loopLeft<=0){
			_has=false;
			return false;
		}
		_loopLeft--;
		return true;
	}
	public function has():Boolean
	{
		return _has;
	}
	public function loopLeft():int
	{
		return _loopLeft;
	}
	public function reset():void
	{
		label=null;
		frame=0;
		loops=0;
		_loopLeft=0;
		_has=false;
	}
}
internal class ClipState{
	public var state:String;
	public var params:Array;
	public function ClipState()
	{
	}
	public function init(state:String,params:Array):void
	{
		this.state=state;
		this.params=params;
	}
	public function destroy():void
	{
		this.state=null;
		this.params=null;
	}
	public function get has():Boolean
	{
		return this.state!=null;
	}
}