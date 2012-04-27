package com.longame.game.entity
{
	import com.longame.core.IAnimatedObject;
	import com.longame.core.long_internal;
	import com.longame.display.core.RenderManager;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.TextureData;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.MovieClipUtil;
	import com.longame.utils.ObjectUtil;
	import com.longame.utils.debug.Logger;
	
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
		protected var _onAnimationPlayed:Signal;
		
		protected var _defaultAnimation:String;
		protected var _playDefaultAnimation:Boolean=true;
		/**
		 * 所有的帧标签map，存储着 帧标签和帧数的相互索引
		 * 基于以下设定：所有方向的mc具有相同的动画序列,缓存呢，todo
		 * */
		protected var _labels:McLabels=new McLabels();
		
		public function AnimatorEntity(id:String=null)
		{
			super(id);
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			_labels.destroy();
			_labels=null;
			labelToLoop=null;
			lastClipState=null;
			_onAnimationPlayed=null;
			_onLastFrame=null;
		}
		override protected function whenDeactive():void
		{
//			if(!this._renderAsBitmap && this.clip) this.clip.stop();
			super.whenDeactive();
		}
		private var forceAnimation:Boolean;
		override protected function  whenSourceLoaded():void
		{
			if(_sourceDisplay){
				_labels.parse(_sourceDisplay as MovieClip);
				var cf:String=_labels.getLabel(_currentFrame)
				if(cf) this._currentLabel=cf;
			}
			forceAnimation=true;
			if(!this.setLastClipState()){
				this.showDefaultAnimation();
			}
			forceAnimation=false;
			super.whenSourceLoaded();
		}
		/**
		 * 记录动画的上一帧，用于判断动画是否在播放
		 * */
		protected var _oldFrame:int=1;
		override protected function renderBitmap():void
		{
			if((_bitmapInvalidated||(_oldFrame!=this.currentFrame))&&_sourceDisplay){
				RenderManager.loadTexture(this._currentSource,this.currentFrame,_scaleX,_scaleY,onTextureLoaded);
				_bitmapInvalidated=false;
			}
		}
		protected var labelToLoop:LoopedLabelFrame=new LoopedLabelFrame();
		protected var lastClipState:ClipState=new ClipState();
		/**
		 * 播放某帧
		 * @param frame: 索引或标签
		 * @param loops: 如果是标签，则重播放这个标签到下个标签或这个标签到帧尾这个区间段几次，-1为无穷,0则只播一次，1则播两次，依次类推
		 * bug: 要播放gotoAndPlay的帧最好不是1帧，否则莫名其妙的问题，如果1帧为何不用gotoAndStop呢
		 */
		public function gotoAndPlay(frame:Object,loops:int=0):Boolean
		{
			var old:Boolean=lastClipState.init("gotoAndPlay",[frame,loops]);
			if(old&&!forceAnimation) return false;
			if(this._sourceDisplay==null) {
				return false;
			}
			var has:Boolean=this.totalFrames>1;
			if(frame is String) has&&=_labels.hasLabel(frame as String);
			else if(frame is uint)   has&&=(frame as uint)<=this.totalFrames;
			if (has)
			{
			    this.setFrame(frame);
				if(frame is String){
					labelToLoop.init(frame as String,_labels.getFrame(frame as String),loops,_labels.getLabelEnd(frame as String));
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
			var old:Boolean=lastClipState.init("gotoAndStop",[frame]);
			if(old&&!forceAnimation) return false;
			if(this._sourceDisplay==null){
				return false;
			}
			labelToLoop.reset();
			this.setFrame(frame);
			return true;
		}
		public function play():Boolean
		{
			var old:Boolean=lastClipState.init("play",null);
			if(old&&!forceAnimation) return false;
			if(this._sourceDisplay==null){
				return false;
			}
			labelToLoop.reset();
			return true;
		}
		public function stop():Boolean
		{
			var old:Boolean=lastClipState.init("stop",null);
			if(old&&!forceAnimation) return false;
			if(this._sourceDisplay==null){
				return false;
			}
			labelToLoop.reset();
			return true;
		}
		public function get totalFrames():int
		{
			if(_sourceDisplay) return (this._sourceDisplay as MovieClip).totalFrames;
			return int.MAX_VALUE;
		}
		protected var _currentFrame:int=1;
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		protected var _currentLabel:String;
		public function get currentLabel():String
		{
			return _currentLabel;
		}
		public function get currentFrameLabel():String
		{
			return _labels.getLabel(currentFrame);
		}
		override public function set visible(value:Boolean):void
		{
			if(value==_visible) return;
			super.visible=value;
		}
		override protected function doRender():void
		{
			if(this._sourceDisplay){
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
				if(this.labelToLoop.has()){
					if((this.currentFrame==this.labelToLoop.endFrame)||(this.currentFrame==this.totalFrames)){
						if(this.labelToLoop.loopOnce()){
							this.setFrame(labelToLoop.frame);
						}else{
							this.whenAnimationPlayed(labelToLoop.label);
						}
						return;
					}
				}
			}
			super.doRender();
			if((this.currentFrame>=this.totalFrames)&&(this._oldFrame!=this.currentFrame)){
				this.whenLastFrame();
			}
			this._oldFrame=this.currentFrame;
		}
		/**
		 * 当某个动画播放完毕时
		 * */
		protected function whenAnimationPlayed(label:String):void
		{
			this.showDefaultAnimation();
			this.onAnimationPlayed.dispatch(label);
		}
		/**
		 * 每当到最后一帧调用，做需要做的处理，比如有些动画播放完就消失
		 * 但是如果一直停在最后一帧，只会掉最开始那次
		 * */
		protected function whenLastFrame():void
		{
			if(this._onLastFrame) this._onLastFrame.dispatch(this);
		}
		private function setFrame(frame:*):void
		{
			if(frame is String) this._currentFrame=_labels.getFrame(frame as String);
			else this._currentFrame=frame as int;
			var cf:String=_labels.getLabel(_currentFrame)
			if(cf) this._currentLabel=cf;
		}
		/**
		 * 在clip没有创建好的情况下，调用了动画控制，这时候不起任何作用，当build后就会调用这个完成设定意图
		 * */
		protected function setLastClipState():Boolean
		{
			if(this._sourceDisplay==null) return false;
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
		/**
		 * 当一个动画播放完毕时发出,通常是通过gotoAndPlay来播放动画的时候，如果loops为-1，就不会发出这个事件
		 * @param String是动画的帧名
		 * */
		public function get onAnimationPlayed():Signal
		{
			if(this.disposed) return null;
			if(this._onAnimationPlayed==null) this._onAnimationPlayed=new Signal(String);
			return this._onAnimationPlayed;
		}
		protected var _onLastFrame:Signal;
		public function get onLastFrame():Signal
		{
			if(this.disposed) return null;
			if(_onLastFrame==null) _onLastFrame=new Signal(AnimatorEntity);
			return _onLastFrame;
		}
		public function get defaultAnimation():String
		{
			return _defaultAnimation;
		}
	}
}
import flash.display.FrameLabel;
import flash.display.MovieClip;

internal class McLabels
{
	/**
	 * mc里所有label标签序列
	 * */
	private var _labels:Vector.<String>=new Vector.<String>();
	/**
	 * mc里所有标签对应的帧序列
	 * */
	private var _labelFrames:Vector.<uint>=new Vector.<uint>();
	
	private var totalFrames:int;
	
	public function McLabels()
	{
	}
	public function parse(clip:MovieClip):void
	{
		_labelFrames.length=0;
		_labels.length=0;
		var allLabels:Array=clip.currentLabels;
		for(var i:int=0;i<allLabels.length;i++){
			var label:FrameLabel=allLabels[i];
			_labelFrames[i]=label.frame;
			_labels[i]=label.name;
		}
		totalFrames=clip.totalFrames;
	}
	public function hasLabel(label:String):Boolean
	{
		return _labels.indexOf(label)>-1;
	}
	public function getLabel(frame:uint):String
	{
		var i:int=_labelFrames.indexOf(frame);
		if(i==-1) return null;
		return _labels[i];
	}
	public function getFrame(label:String):uint
	{
		var i:int=_labels.indexOf(label);
		if(i==-1) return 0;
		return _labelFrames[i];
	}
	public function getLabelEnd(label:String):int
	{
		var i:int=_labels.indexOf(label);
		if(i==-1) return 0;
		if(i>=_labels.length-1){
			return totalFrames;
		}
		return Math.max(1,_labelFrames[i+1]-1);			
		
	}
	public function destroy():void
	{
		_labels=null;
		_labelFrames=null;
	}
}
internal class LoopedLabelFrame
{
	public var label:String;
	public var frame:uint=0;
	public var loops:int=0;
	public var endFrame:int;
	protected var _loopLeft:int=0;
	
	protected var _has:Boolean;
	
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
internal class ClipState{
	public var state:String;
	public var params:Array;
	public function ClipState()
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