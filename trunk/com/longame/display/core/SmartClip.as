package com.longame.display.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import com.longame.core.IAnimatedObject;
	import com.longame.core.IDestroyable;
	import com.longame.display.effects.BitmapEffect;
	import com.longame.managers.AssetsLibrary;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.MovieClipUtil;
	
	import org.osflash.signals.Signal;
	
	/**
	 * SmartClip意为聪明的剪辑，用SmartClip可以人工生成一个在flash里面神通广大的MovieClip，更重要的是它可以实现位图渲染
	 * SmartClip的可能的使用场合：
	 * 1. 将一堆图片或显示对象组合成一个MovieClip
	 * 2. 将一个传统的MovieClip转换成一个SmartClip,并可以选择位图渲染，提高效率；
	 * 3. 可以做一个非常方便的导航器或ViewStack,比如作为ScreenManager，将Screen作为SmartClip的帧，这样是不是很方便？
	 * 4. 是不是可以用来做Preloader,SimpleButton,等等
	 * 思考：使用buildFromMovieClip，renderAsBitmap开启反而会消耗更多的的CPU和内存，位图渲染的优势在哪里？
	 */
	
	public class SmartClip extends Sprite implements IDestroyable, IAnimatedObject, IBitmapRenderer
	{
		private const PLAY:String = "play";
		private const REVERSE_PLAY:String = "reversePlay";
		/**
		 * 位图效果，在renderAsBitmap=true的时候有效
		 * 如果是很多个动画对象添加特效，资源消耗很厉害
		 * */
		public var effects:Vector.<BitmapEffect>=new Vector.<BitmapEffect>();
		
		/**signals**/
		protected var _onPlay:Signal;
		protected var _onStop:Signal;
		protected var _onFrameChange:Signal;
		/**完成一次循环播放*/
		protected var _onLooped:Signal;
		
		/** @private */
		protected var _frames:Array;
		/** @private */
		protected var _labels:Array;
		/** @private */
		protected var _frameObject:*;
		
		private var _playDirectionFlag:String;
		//private var _startUpFlag:Boolean;
		
		/** @private */
		protected var _i:int = 0;	
		/** @private */
		protected var _len:int = 0;
		/** @private */
		protected var _fn:uint = 0;	
		
		private var _currentFrame:int;
		private var _frameRate:int;
		private var _frameInterval:int;
		private var _autoLoop:Boolean=true;
		/**
		 * 是不是来源于一个传统MovieClip
		 * */
		private var _movieClipSource:MovieClip;
		
		private var _destroyed:Boolean;
		
		protected var _lastUpdateTime:Number;
		
		protected var _renderAsBitmap:Boolean;
		protected var _bitmap:Bitmap;
		/**
		 * @param renderAsBitmap:是否用位图渲染
		 * @param frameRate:帧频，默认30
		 */
		public function SmartClip(frameRate:int = 30) 
		{
			this.frameRate=frameRate;
			reset();
		}
		/**
		 * 从一个MovieClip类或MovieClip实例来创建
		 * @param source: MovieClip类名或类
		 * @param renderAsBitmap: 是否采用位图渲染，否则SmartClip只是控制这个MovieClip而已,
		 *                        好处是控制比普通的MovieClip更加灵活,如gotoAndPlay("Roll",3),能将Roll动作播放3次
		 * */
		public function buildFromMovieClip(source:*,renderAsBitmap:Boolean=true):void
		{
			this.reset();
			if(_movieClipSource&&this.contains(_movieClipSource)){
				this.removeChild(_movieClipSource);
			}
			if(source is String){
				source=AssetsLibrary.getClass(source as String);
			}
			if(source is Class){
				_movieClipSource=new source() as MovieClip;
			}
			if(_movieClipSource==null){
				throw new Error("source can only be MovieClip Class or Class name!");
			}
			this.renderAsBitmap=renderAsBitmap;
			var fn:uint=_movieClipSource.totalFrames;
			var label:String;
			for(_i=1;_i<=fn;_i++){
				label=MovieClipUtil.getLabel(_movieClipSource,_i);
				this.addFrame(source,_i,label);
			}
		}
		
		//////////////////////////////////////////////////
		////////// Public
		//////////////////////////////////////////////////
		
		/**
		 * 添加一帧
		 * 
		 * @param	displaySource 此帧对应的显示对象源，见RenderManager.getRender中src的定义
		 * @param	frameIndex 从1开始的帧索引
		 * @param	labelName   此帧的标签名
		 * @param	displayNow  是否立即显示此帧
		 */
		public function addFrame(displaySource:*, frameIndex:uint = 0 , labelName:String = null, displayNow:Boolean = false):void
		{
			frameIndex = (frameIndex == 0) ? _frames.length + 1 : frameIndex;
			
			if (frameCheck(frameIndex, true))
			{
				_frames.splice(frameIndex - 1, 0, displaySource);
				addLabelAt(frameIndex, labelName);
				
				if (displayNow || _frames.length == 1) 
				{
					gotoAndStopBase(frameIndex, true, false);
				}
			}
		}
		
		/**
		 * 批量添加帧
		 * 
		 * @param	displaySources :一组显示对象源，见addFram
		 * @param   startFrame:     开始帧，第一个显示对象添加到开始帧，后面的依次加1
		 * @param   displayNow:   是否立即显示
		 * 
		 */
		public function addFrames(displaySources:Array, startFrame:uint = 0, displayNow:Boolean = false):void
		{
			startFrame = (startFrame == 0) ? _frames.length + 1 : startFrame;
			
			if (displaySources != null)
			{
				var len:int = displaySources.length;
				for (var i:int = 0; i < len; i++) 
				{
					if (i > 0) displayNow = false;
					this.addFrame(displaySources[i], startFrame++, null, displayNow);
				}
			}
		}
		
		/**
		 * 移除某帧
		 * 
		 * @param	frame  帧索引
		 * @param	onlyDisplayObjectDelete 是否保留帧，只移除显示对象，也就是变为空帧
		 */
		public function removeFrameAt(frame:uint, onlyDisplayObjectDelete:Boolean = false):void
		{
			if (frameCheck(frame))
			{
				if (onlyDisplayObjectDelete)
				{
					_frames[frame - 1] = null;
				}
				else
				{
					_frames.splice(frame - 1, 1);
					_labels.splice(frame - 1, 1);
				}
				
				
				if (_frames.length > 0)
				{
					if (_currentFrame == frame && !onlyDisplayObjectDelete)
					{
						gotoAndStop((frame > _frames.length) ? _frames.length : frame);
					}
					else if (onlyDisplayObjectDelete)
					{
						gotoAndStopBase(_currentFrame, true, false);
					}
				}
				else
				{
					reset();
					return;
				}

			}
		}
		
		/**
		 * 移除所有帧
		 */
		public function removeAllFrames():void
		{
			reset();
		}
		
		/**
		 * 获取frame处的显示对象
		 */
		public function getFrameAt(frame:Object):DisplayObject 
		{
			convertToFrameIndex(frame);	
			return _frames[_fn - 1];
		}
		
		/**
		 * 设定某一帧处的显示对象
		 */
		public function setDisplayObjectAt(displayObject:DisplayObject, frame:Object, displayNow:Boolean = false ):void 
		{
			convertToFrameIndex(frame);
			_frames[_fn - 1] = displayObject;
			
			if (displayNow || _fn == _currentFrame) 
			{
				gotoAndStopBase(_fn, true, false);
			}
		}
		
		////ラベル制御 -------------------------------------------------------------------------------------------
		
		/**
		 * 添加一个帧标签
		 * 
		 * @param	frameNumber 在第几帧添加
		 * @param	labelName   帧标签的名字
		 */
		public function addLabelAt(frameIndex:uint, labelName:String):void 
		{
			if(labelName==null) return;
			if (frameCheck(frameIndex) && labelDuplicationChecker(labelName))
			{
				_labels[frameIndex - 1] = labelName;
			}
		}
		
		/**
		 * 删除帧标签
		 */
		public function removeLabelAt(frameIndex:uint):void 
		{
			if (frameCheck(frameIndex))
			{
				_labels[frameIndex - 1] = null;
			}
		}
		
		protected var labelToLoop:LoopedLabelFrame=new LoopedLabelFrame();
		/**
		 * 播放某帧
		 * @param frame: 索引或标签
		 * @param loops: 如果是标签，则重播放这个标签到下个标签或这个标签到帧尾这个区间段几次，-1为无穷
		 * @param frameRate:播放帧频
		 */
		public function gotoAndPlay(frame:Object,loops:int=0,frameRate:uint=30):void
		{
			if (_frames.length > 1)
			{
				this.frameRate=frameRate;
				convertToFrameIndex(frame);
				_playDirectionFlag = PLAY;
				gotoAndStopBase(_fn);
				playBaseFunction(_fn,_autoLoop);
				if((frame is String)&&(loops!=0)){
					labelToLoop.init(String(frame),_currentFrame,loops);
				}else{
					labelToLoop.reset();
				}
			}
		}
		
		/**
		 *从frame开始往回播放
		 * @param frame: 索引或标签
		 * @param frameRate:播放帧频
		 */
		public function gotoAndReversePlay(frame:Object,frameRate:uint=30):void
		{
			if (_frames.length > 1)
			{
				this.frameRate=frameRate;
				convertToFrameIndex(frame);
				_playDirectionFlag = REVERSE_PLAY;
				gotoAndStopBase(_fn);
				playBaseFunction(_fn, _autoLoop);
			}
		}
		
		
		/**
		 * 停在某一帧
		 */
		public function gotoAndStop(frame:Object):void
		{
			gotoAndStopBase(frame, false, true);
		}
		
		/**
		 * 从当前帧播放
		 * 
		 */
		public function play(autoLoop:Boolean = true, frameRate:uint =30):void
		{
			if (_frames.length > 1)
			{
				this.frameRate=frameRate;
				_playDirectionFlag = PLAY;
				//gotoAndStop(_currentFrame);
				playBaseFunction(_currentFrame, autoLoop);
			}
		}
		
		/**
		 * 停止
		 */
		public function stop():void 
		{
			this.stopRender();
		}
		
		/**
		 *下一帧
		 */
		public function nextFrame():void
		{
			if (_frames.length > 1)
			{
				if (_currentFrame == _frames.length)
				{
					if (_autoLoop)
					{
						gotoAndStopBase(1);
						loopCompleteEventDispatcher();
					}
					else
					{
						this.stopRender();
						return;
					}
				}
				else if (_currentFrame < _frames.length)
				{
					_currentFrame++;
					gotoAndStopBase(_currentFrame);
				}
			}
		}
		
		/**
		 * 上一帧
		 */
		public function prevFrame():void
		{
			if (_frames.length > 1)
			{
				if (_currentFrame == 1)
				{
					if (_autoLoop)
					{
						gotoAndStopBase(_frames.length);
						loopCompleteEventDispatcher();
					}
					else
					{
						this.stopRender();
						return;
					}
				}
				else if (_currentFrame > 1)
				{
					_currentFrame--;
					gotoAndStopBase(_currentFrame);
				}
			}
		}
		
		
		
		
		/**
	     * 输出帧信息
		 */
		public function getFramesInformation():String
		{
			_len = _frames.length;
			
			var mes:String = "Frame\t:Label\t\t:DisplayObject\t\t:Name\n========================================\n";
			for (_i = 0; _i < _len; _i++) 
			{
				mes += (_i+1) + "\t:" + ((_labels[_i] == null) ? "(no label)" : _labels[_i]) + "\t\t:" + ((_frames[_i] == null) ? "null" : _frames[_i].toString()) + "\t\t:" + ((_frames[_i] == null) ? "(no exist)" : _frames[_i].name) + "\n";
			}
			mes += "========================================\ntotalFrames : " + _len + "\nenterFrameDelayTime : " + _frameInterval + "\nisLoop : " + _autoLoop + "\nisPlaying : " + isPlaying;
			return mes;
		}
		
		
		
		
		//////////////////////////////////////////////////
		////////// Private 
		//////////////////////////////////////////////////
		
		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		public function destroy():void
		{
			if(_destroyed) return;
			_destroyed=true;
			//todo,销毁，unload？
			//			for each(var frameObject:* in _frames){
			//			}
			this.stopRender();
			this.reset();
		}
		public function onFrame(deltaTime:Number):void
		{
			if(ProcessManager.virtualTime - _lastUpdateTime > this._frameInterval)
			{
				this.handleFrame();
				_lastUpdateTime = ProcessManager.virtualTime;
			}
			
		}
		protected function startRender():void
		{
			if(_isPlaying) return;
			_isPlaying=true;
			_lastUpdateTime=0;
			ProcessManager.addAnimatedObject(this);
			if(this._onPlay) this._onPlay.dispatch(this);
		}
		protected function stopRender():void
		{
			if(!_isPlaying) return;
			_isPlaying=false;
			ProcessManager.removeAnimatedObject(this);
			if(this._onStop) this._onStop.dispatch();
		}
		/**
		 * gotoAndStopBase
		 * @param	frame
		 * @param	internalFlag     停在这不动了
		 * @param	eventDipatchFlag 是否分发事件
		 */
		private function gotoAndStopBase(frame:Object, internalFlag:Boolean = true, eventDipatchFlag:Boolean = true):void
		{
			convertToFrameIndex(frame);
			if (frameCheck(_fn))
			{
				if (!internalFlag) this.stopRender();
				
				if (_frames[_fn - 1] != null)
				{
					var oldFrameObject:*=_frameObject;
					_frameObject = _frames[_fn - 1];
					//指定位图渲染
					if(this._renderAsBitmap){
						RenderManager.render(this,_frameObject,effects,(_movieClipSource?_fn:null));
					//如果非位图渲染，而_movieClipSource存在，则只需控制这个MovieClip即可
					}else if(_movieClipSource){
						_movieClipSource.gotoAndStop(_fn);
					}else{
						//删掉上一帧的对象
						if(oldFrameObject&&(oldFrameObject is DisplayObject)&&this.contains(oldFrameObject)) this.removeChild(oldFrameObject as DisplayObject);
						//添加新对象
						if(_frameObject&&(_frameObject is DisplayObject)) this.addChildAt(_frameObject as DisplayObject,0);
					}
				}
				_currentFrame = _fn;
				if (eventDipatchFlag) {
					if(this._onFrameChange) this._onFrameChange.dispatch(this);
				}
			}
		}
		
		private function playBaseFunction(frameIndex:uint, isLoop:Boolean):void
		{
			var isLoop_temp:Boolean = _autoLoop;	
			_autoLoop = isLoop;
			
			if (frameCheck(frameIndex))
			{
				if (canMoveOn())
				{
					_autoLoop = isLoop;
					this.startRender();
				}
				else
				{
					_autoLoop = isLoop_temp;
					return;
				}

			}
		}
		private var _hasLoop:Boolean;
		/**
		 * 每帧控制
		 * */
		private function handleFrame():void 
		{
			if(this.labelToLoop.has()){
				var currentLabel:String=_labels[_currentFrame];
				var needLoop:Boolean=((currentLabel!=null)&&(currentLabel!=this.labelToLoop.label));
				var needLoop1:Boolean=(_playDirectionFlag==PLAY)&&(_currentFrame==_frames.length);
				var needLoop2:Boolean=(_playDirectionFlag==REVERSE_PLAY)&&(_currentFrame==1);
				if(needLoop||needLoop1||needLoop2){
					this.labelToLoop.loopOnce();
					this.gotoAndPlay(this.labelToLoop.label,this.labelToLoop.loopLeft());
				    return;
				}
			}else if(_hasLoop){
				if(this._onLooped) this._onLooped.dispatch(this);
			}
			_hasLoop=this.labelToLoop.has();
			if (canMoveOn())
			{
				switch (_playDirectionFlag)
				{
					case PLAY:
						if (_autoLoop && _currentFrame == _frames.length)
						{
							gotoAndStopBase(1);
							loopCompleteEventDispatcher();
						}
						else
						{
							nextFrame();
						}
						break;
						
					case REVERSE_PLAY:
						if (_autoLoop && _currentFrame == 1)
						{
							gotoAndStopBase(_frames.length);
							loopCompleteEventDispatcher();
						}
						else
						{
							prevFrame();
						}
						break;
					
					default:
						this.stopRender();
						throw new Error("playDirectionFlag can only be 'play' or 'reverse_play'!");
						break;
				}
			}
			else
			{
				this.stopRender();
			}
		}
		/** @private */
		protected function convertToFrameIndex(frame:Object):uint
		{
			if (frame is uint)
			{
				_fn = uint(frame);
				return _fn;
			}
			else if (frame is String)
			{
				_i=_labels.indexOf(String(frame));
				if(_i==-1){
					throw new Error("There is no label named :[ " + frame + " ]");
				}
				_fn=_i+1;
				return _fn;
			}
			else
			{
				throw new Error("frame can only be String or uint!");
			}
			
			return undefined;
		}
		private function loopCompleteEventDispatcher():void
		{
//			if(this._onLoop) this._onLoop.dispatch();
		}
		
		/** @private */
		/**
		 * 根据当前播放头位置，确定是否需要继续往前播放
		 * **/
		private function canMoveOn():Boolean
		{
				if ((_currentFrame == _frames.length && _playDirectionFlag == PLAY && !_autoLoop) || 
						(_currentFrame == 1 && _playDirectionFlag == REVERSE_PLAY && !_autoLoop))
				{
					return false;
				}
				else
				{
					return true;
				}
		}
		
		/** @private 
		 * 		 * 
		 * */
		protected function frameCheck(frameNumber:uint, addToArray:Boolean = false):Boolean
		{
			if (framesEmptyCheck(frameNumber, addToArray))
			{
				if (frameNumberLengthCheck(frameNumber,addToArray))
				{
					return true;
				}
			}
			return false;
		}
		
		/** @private 
		 * 
		 * */
		protected function framesEmptyCheck(frameNumber:uint, addToArray:Boolean):Boolean
		{
			if (_frames.length > 0 || (addToArray && _frames.length + 1  >= frameNumber))
			{
				return true;
			}
			else
			{
				throw new Error("frameNumber: "+frameNumber+" is invalide!");
			}
		}
		
		/** @private */
		/**
		 * 
		 * */
		protected function frameNumberLengthCheck(frameNumber:uint, addToArray:Boolean):Boolean
		{
			frameNumber--;
			
			if (_frames.length  > frameNumber || (addToArray && _frames.length  >= frameNumber))
			{
				if (frameNumber + 1 > 0)
				{
					return true;
				}
				else
				{
					throw new Error("frameNumber canot <0 : " + frameNumber + ")");
				}
				
			}
			else
			{
				throw new Error("frameNumber: "+(frameNumber+1)+" cant >  frame total length: " + _frames.length);
			}
		}
		
		/** @private */
		/**
		 * 检查labelName是否被占用
		 * */
		protected function labelDuplicationChecker(labelName:String):Boolean
		{
			if(labelName==null) return true;
			var ii:int= _labels.indexOf(labelName);
			if(ii>-1){
				throw new Error("Label: [ " + labelName + " ] has exist!");
				return false;
			}
			return true;
		}
		
		private function reset():void
		{
			if (_frameObject&&(_frameObject is DisplayObject)&&this.contains(_frameObject)) this.removeChild(_frameObject);
			_frames = [];
			_labels = [];
			_currentFrame = 0;
		}
		
		/**
		 *  如果是顺序播放，到了最后一帧是否从第一帧重新开始
		 * 如果是倒序播放，到了第一帧是否从最后一帧重新开始
		 * @default false
		 */
		public function get autoLoop():Boolean { return _autoLoop; }
		
		public function set autoLoop(value:Boolean):void 
		{
			_autoLoop = value;
		}
		
		/**
		 *帧播放的时间间隔，毫秒，默认33毫秒，也就是FPS=30
		 * 
		 * @default 33
		 */
		public function get frameRate():int { return _frameRate; }
		
		public function set frameRate(value:int):void 
		{
			_frameRate=value;
			_frameInterval =1000/value;
		}
		
		// getter only
		/**
		 * 当前帧
		 */
		public function get currentFrame():int { return _currentFrame; }
		
		/**
		 *总帧数
		 */
		public function get totalFrames():uint { return _frames.length; }
		
		protected var _isPlaying:Boolean;
		/**
		 * 是否在播放
		 */
		public function get isPlaying():Boolean { return _isPlaying; }
		
		/**
		 * 是否每帧都采用二进制渲染,对于简单图形是没必要的
		 * */
		public function get renderAsBitmap():Boolean 
		{
			return _renderAsBitmap
		}
		public function set renderAsBitmap(value:Boolean):void{
			if(_renderAsBitmap==value) return;
			_renderAsBitmap=value;
			if(value){
				if(_bitmap==null){
					_bitmap=new Bitmap(new BitmapData(1,1));
					this.addChildAt(_bitmap,0);
				}
				if(_movieClipSource&&this.contains(_movieClipSource)) this.removeChild(_movieClipSource);			
			}else{
				if(_bitmap&&this.contains(_bitmap)) this.removeChild(_bitmap);
				_bitmap=null;
				if(_movieClipSource){
					this.addChildAt(_movieClipSource,0);
					_movieClipSource.stop();
				}
			}
		}
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		/**
		 * 开始播放事件
		 * */
		public function get onPlay():Signal
		{
			if(this._onPlay==null) _onPlay=new Signal(SmartClip);
			return _onPlay;
		}
		/**
		 * 停止播放事件
		 * */
		public function get onStop():Signal
		{
			if(this._onStop==null) _onStop=new Signal(SmartClip);
			return _onStop;
		}
		/**
		 * 每帧变化事件
		 * */
		public function get onFrameChange():Signal
		{
			if(this._onFrameChange==null) _onFrameChange=new Signal(SmartClip);
			return _onFrameChange;
		}
		/**
		 * 循环完成
		 * */
		public function get onLooped():Signal
		{
			if(this._onLooped==null) _onLooped=new Signal(SmartClip);
			return _onLooped;
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