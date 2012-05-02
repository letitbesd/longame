package com.longame.display.screen{	import com.gskinner.motion.GTween;	import com.longame.core.long_internal;	import com.longame.utils.debug.Logger;		import flash.events.Event;	import flash.events.EventDispatcher;	import flash.utils.setTimeout;		import org.osflash.signals.Signal;		import starling.display.DisplayObject;	import starling.display.DisplayObjectContainer;
		use namespace long_internal;	/**	 * Manages opening and closing as well as updating of screens.	 * 	 * @author Sascha Balkau	 * @version 1.0.0	 */	public class ScreenManager	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				protected static const TWEEN_DURATION:Number = 0.2;		protected static const TWEEN_IN_PROPERTIES:Object = {alpha: 1.0}		protected static const TWEEN_OUT_PROPERTIES:Object = {alpha: 0.6}						public var onScreenOpen:Signal=new Signal(IScreen);		public var onScreenClose:Signal=new Signal(IScreen);		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////		/** @parameter to create screen*/		protected var _para:*;		/** @private */		protected var _screenParent:DisplayObjectContainer;		/** @private */		protected var _screen:IScreen;		/** @private */		protected var _nextScreen:IScreen;		/** @private */		protected var _openScreenClass:Class;		/** @private */		protected var _screenOpenDelay:Number;		/** @private */		protected var _screenCloseDelay:Number;		/** @private */		protected var _tweenDuration:Number;		/** @private */		protected var _tweenInValues:Object = {alpha: 1.0}		/** @private */		protected var _tweenOutValues:Object = {alpha: 0.0}		/** @private */		protected var _isLoading:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////		/**		 * Creates a new ScreenManager instance.		 * 		 * @param screenParent the parent container for all screens.		 * @param tweenDuration Duration (in seconds) used for screen in/out tweens.		 *         Setting this to 0 will make the ScreenManager use no tweening at all.		 * @param screenOpenDelay A delay (in seconds) that the screen manager waits		 *         before opening a screen.		 * @param screenCloseDelay A delay (in seconds) that the screen manager waits		 *         before closing an opened screen.		 */		public function ScreenManager(screenParent:DisplayObjectContainer=null,									  tweenDuration:Number = 0.2,									  screenOpenDelay:Number = 0.2,									  screenCloseDelay:Number = 0.2)		{			super();						_screenParent = screenParent;			this.tweenDuration = tweenDuration;			this.screenOpenDelay = screenOpenDelay;			this.screenCloseDelay = screenCloseDelay;		}				/**		 * Opens the screen of the specified class. Any currently opened screen is closed		 * before the new screen is opened. The class needs to implement IGameScreen.		 * 		 * @param screenClass The screen class.		 * @para 创建screen需要的参数，如果参数和上一个screen不一样，会重新创建一个screen，否则update之		 */		public function openScreen(screenClass:Class,para:*=null):void		{			/* If the specified screen is already open, only update it! */			if ((_openScreenClass == screenClass)&&(_para==para))			{				updateScreen();				return;			}			_para=para;			var screen:IScreen;			screen =_para? new screenClass(_para): new screenClass();			if (screen is IScreen)			{				_isLoading = true;				_openScreenClass = screenClass;				_nextScreen = screen;								/* Only change screen alpha if we're actually using tweens! */				if (_tweenDuration > 0)				{					_nextScreen["alpha"] = 0;				}				if(_screenParent) _screenParent.addChild(_nextScreen as DisplayObject);				else Engine.addScreen(_nextScreen as IScreen);				closeLastScreen();			}			else			{				Logger.error(this,"openScreen"," Tried to open a screen that is not of type IGameScreen ("+ screenClass + ")!");			}		}		/**		 * Updates the currently opened screen.		 */		public function updateScreen():void		{			if (_screen && !_isLoading) _screen.update();		}						/**		 * Closes the currently opened screen. This is normally not necessary unless		 * you need a situation where no screens should be on the stage.		 */		public function closeScreen():void		{			if (!_screen) return;			_nextScreen = null;			closeLastScreen();		}		////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the currently opened screen.		 */		public function get currentScreen():IScreen		{			return _screen;		}						/**		 * The duration (in seconds) that the ScreenManager will use to tween in/out		 * screens. If set to 0 the ScreenManager will completely ignore tweening.		 */		public function get tweenDuration():Number		{			return _tweenDuration;		}		public function set tweenDuration(v:Number):void		{			if (v < 0) v = 0;			_tweenDuration = v;		}						/**		 * A delay (in seconds) that the screen manager waits before opening a screen.		 * This can be used to make transitions less abrupt.		 */		public function get screenOpenDelay():Number		{			return _screenOpenDelay;		}		public function set screenOpenDelay(v:Number):void		{			if (v < 0) v = 0;			_screenOpenDelay = v;		}						/**		 * A delay (in seconds) that the screen manager waits before closing an opened screen.		 * This can be used to make transitions less abrupt.		 */		public function get screenCloseDelay():Number		{			return _screenCloseDelay;		}		public function set screenCloseDelay(v:Number):void		{			if (v < 0) v = 0;			_screenCloseDelay = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		protected function onScreenCreated(s:IScreen):void		{			_screen.onCreate.remove(onScreenCreated);			/* Screen is loaded and child objects are created, time to lay out			* children and update the screen text */			_screen.update();						_isLoading = false;						if (_tweenDuration > 0)			{				var gt:GTween=new GTween(_screen, _tweenDuration, _tweenInValues);				gt.onComplete=onTweenInComplete;			}			else			{				onTweenInComplete(null);			}		}						/**		 * @private		 */		protected function onTweenInComplete(g:GTween):void		{			this.onScreenOpen.dispatch(_screen);		}						/**		 * @private		 */		protected function onTweenOutComplete(e:Object):void		{			var oldScreen:IScreen = _screen;			_screen.dispose();			_screen = null;			loadNextScreen();			this.onScreenClose.dispatch(oldScreen);		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * closeLastScreen		 * @private		 */		protected function closeLastScreen():void		{			if (_screen)			{				if (_tweenDuration > 0)				{					var gt:GTween=new GTween(_screen, _tweenDuration, _tweenOutValues);					gt.delay= _screenCloseDelay;					gt.onComplete=onTweenOutComplete;				}				else				{					setTimeout(onTweenOutComplete, _screenCloseDelay * 1000, null);				}			}			else			{				loadNextScreen();			}		}						/**		 * loadNextScreen		 * @private		 */		protected function loadNextScreen():void		{			if (_nextScreen)			{				setTimeout(function():void				{					_screen = IScreen(_nextScreen);					_screen.onCreate.add(onScreenCreated);					_screen.load();				}, _screenOpenDelay * 1000);			}		}	}}