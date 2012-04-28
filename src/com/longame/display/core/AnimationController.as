package com.longame.display.core
{
	import com.longame.core.long_internal;
	import com.longame.utils.debug.Logger;
	
	import org.osflash.signals.Signal;

	use namespace long_internal;
	public class AnimationController
	{
		private var labelToLoop:LoopedLabelFrame=new LoopedLabelFrame();
		private var lastAnimationState:AnimationState=new AnimationState();
		private var forceAnimation:Boolean;
		private var target:IFrameAnimator;
		protected var _defaultAnimation:String;
		/**
		 * 是stop还是play默认动画
		 * */
		protected var _playDefaultAnimation:Boolean=true;
		protected var _onAnimationPlayed:Signal=new Signal(String);
		protected var _onLastFrame:Signal=new Signal();
		
		public function AnimationController(target:IFrameAnimator)
		{
			this.target=target;
		}
		public function initialize():void
		{
			this.setFrame(1);
			forceAnimation=true;
			if(!this.setLastClipState()){
				this.showDefaultAnimation();
			}
			forceAnimation=false;
		}
		public function update():void
		{
			if(!this.noAnimation()){
				if(this.lastAnimationState.has){
					switch(this.lastAnimationState.state){
						case "gotoAndPlay":
						case "play":
							this.setFrame(_currentFrame+1);
							break;
						case "gotoAndStop":
						case "stop":
							//do nothing
							break;
					}	
				}
				if(this._currentFrame>frames.totalFrames) this.setFrame(1);
				if(this.labelToLoop.has()){
					if((this.currentFrame==this.labelToLoop.endFrame)||(this.currentFrame==frames.totalFrames)){
						if(this.labelToLoop.loopOnce()){
							this.setFrame(labelToLoop.frame);
						}else{
							this.showDefaultAnimation();
							this.onAnimationPlayed.dispatch(labelToLoop.label);
						}
						return ;
					}
				}
			}
		}
		/**
		 * 播放某帧
		 * @param frame: 索引或标签
		 * @param loops: 如果是标签，则重播放这个标签到下个标签或这个标签到帧尾这个区间段几次，-1为无穷,0则只播一次，1则播两次，依次类推
		 * bug: 要播放gotoAndPlay的帧最好不是1帧，否则莫名其妙的问题，如果1帧为何不用gotoAndStop呢
		 */
		public function gotoAndPlay(frame:Object,loops:int=0):Boolean
		{
			var old:Boolean=lastAnimationState.init("gotoAndPlay",[frame,loops]);
			if(old&&!forceAnimation) return false;
			if(noAnimation()) {
				return false;
			}
			var has:Boolean=frames.totalFrames>1;
			if(frame is String) has&&=frames.hasLabel(frame as String);
			else if(frame is uint)   has&&=(frame as uint)<=frames.totalFrames;
			if (has)
			{
				this.setFrame(frame);
				if(frame is String){
					labelToLoop.init(frame as String,frames.getFrame(frame as String),loops,frames.getLabelEnd(frame as String));
				}else{
					labelToLoop.reset();
				}
			}else{
				Logger.warn(this,"gotoAndPlay","The animator has no label with name: "+frame);
				labelToLoop.reset();
			}
			return true;
		}
		public function gotoAndStop(frame:Object):Boolean
		{
			var old:Boolean=lastAnimationState.init("gotoAndStop",[frame]);
			if(old&&!forceAnimation) return false;
			if(noAnimation()){
				return false;
			}
			labelToLoop.reset();
			this.setFrame(frame);
			return true;
		}
		public function play():Boolean
		{
			var old:Boolean=lastAnimationState.init("play",null);
			if(old&&!forceAnimation) return false;
			if(noAnimation()){
				return false;
			}
			labelToLoop.reset();
			return true;
		}
		public function stop():Boolean
		{
			var old:Boolean=lastAnimationState.init("stop",null);
			if(old&&!forceAnimation) return false;
			if(noAnimation()){
				return false;
			}
			labelToLoop.reset();
			return true;
		}
		/**
		 * 播放默认的动画
		 * */
		protected function showDefaultAnimation():void
		{
			if(_playDefaultAnimation){
				if(this._defaultAnimation) this.gotoAndPlay(this._defaultAnimation,-1);
				else this.play();
			}else{
				if(this._defaultAnimation) this.gotoAndStop(this._defaultAnimation);
				else this.stop();
			}
		}
		/**
		 * 设定默认的动画
		 * @param animation:动画名称
		 * @param play:是play还是stop在那里
		 * */
		public function setDefaultAnimation(animation:String,play:Boolean=true):void
		{
			_defaultAnimation=animation;
			_playDefaultAnimation=play;
		}
		public function get defaultAnimation():String
		{
			return _defaultAnimation;
		}
		/**
		 * 在clip没有创建好的情况下，调用了动画控制，这时候不起任何作用，当build后就会调用这个完成设定意图
		 * */
		private function setLastClipState():Boolean
		{
			if(noAnimation()) return false;
			if(this.lastAnimationState.has){
				switch(this.lastAnimationState.state){
					case "gotoAndPlay":
						var loops:int=this.lastAnimationState.params[1];
						if(labelToLoop.has()) loops=labelToLoop.loops;
						this.gotoAndPlay(this.lastAnimationState.params[0],loops);
						break;
					case "gotoAndStop":
						this.gotoAndStop(this.lastAnimationState.params[0]);
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
		private function setFrame(frame:*):void
		{
			var newFrame:int;
			if(frame is String) newFrame=frames.getFrame(frame as String);
			else newFrame=frame as int;
			if(newFrame!=_currentFrame){
				_currentFrame=newFrame;
				var cf:String=frames.getLabel(_currentFrame)
				if(cf) this._currentLabel=cf;
				target.currentFrame=_currentFrame;
				if(_currentFrame>=frames.totalFrames){
					this.onLastFrame.dispatch();
				}
			}
		}
		private var _currentFrame:int;
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		private var _currentLabel:String;
		public function get currentLabel():String
		{
			return _currentLabel;
		}
		public function get currentFrameLabel():String
		{
			if(frames) return frames.getLabel(currentFrame);
			return null;
		}
		/**
		 * 当一个动画播放完毕时发出,通常是通过gotoAndPlay来播放动画的时候，如果loops为-1，就不会发出这个事件
		 * @param String是动画的帧名
		 * */
		public function get onAnimationPlayed():Signal
		{
			return _onAnimationPlayed;
		}
		public function get onLastFrame():Signal
		{
			return _onLastFrame;
		}
		private function get frames():AnimationFrames
		{
			if(target==null) return null;
			return target.frames;
		}
		private function noAnimation():Boolean
		{
			return ((frames==null)||(frames.totalFrames<2));
		}
		public function destroy():void
		{
			target=null;
			labelToLoop=null;
			lastAnimationState=null;
			_onAnimationPlayed.removeAll();
			_onAnimationPlayed=null;
			_onLastFrame.removeAll();
			_onLastFrame=null;
		}
	}
}
internal class LoopedLabelFrame
{
	public var label:String;
	public var frame:uint=0;
	public var loops:int=0;
	public var endFrame:int;
	private var _loopLeft:int=0;
	
	private var _has:Boolean;
	
	public function LoopedLabelFrame()
	{
	}
	public function init(label:String,frame:uint,loop:int,endFrame:int):void
	{
		this.label=label;
		this.frame=frame;
		this.loops=loop;
		this.endFrame=endFrame;
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
		endFrame=0;
		_loopLeft=0;
		_has=false;
	}
}
internal class AnimationState{
	public var state:String;
	public var params:Array;
	public function AnimationState()
	{
	}
	public function init(state:String,params:Array):Boolean
	{
		var isSame:Boolean=(this.state==state);
		if(isSame){
			if(params!=null && params.length){
				for(var i:int=0;i<params.length;i++){
					if(this.params[i]!=params[i]){
						isSame=false;
						break;
					}
				}				
			}else{
				isSame=(this.params==params);
			}
		}
		if(!isSame){
			this.state=state;
			this.params=params;			
		}
		return isSame;
	}
	public function reset():void
	{
		this.state=null;
		this.params=null;
	}
	public function get has():Boolean
	{
		return this.state!=null;
	}
}