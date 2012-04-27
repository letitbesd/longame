/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.longame.managers
{
    import com.longame.core.ITickedObject;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import org.osflash.signals.Signal;

    /**
     * The input manager wraps the default input events produced by Flash to make
     * them more game friendly. For instance, by default, Flash will dispatch a
     * key down event when a key is pressed, and at a consistent interval while it
     * is still held down. For games, this is not very useful.
     *
     * <p>The InputMap class contains several constants that represent the keyboard
     * and mouse. It can also be used to facilitate responding to specific key events
     * (OnSpacePressed) rather than generic key events (OnKeyDown).</p>
     *
     * @see InputMap
     */
    public class InputManager implements ITickedObject
    {
		private static var _enabledKeys:Array=[];
		/**
		 * 设置按键过滤
		 * =null 所有按键被屏蔽
		 * =[] 所有按键均被监听
		 * =[37,...] 左键被监听(左键37)
		 * */
		public static function get enabledKeys():Array
		{
			return _enabledKeys;
		}
		public static function set enabledKeys(value:Array):void
		{
			if(_enabledKeys==value) return;
			for (var k:* in _keyState){
				if((_keyState[k]==false)||(value&&(value.length==0))) continue;
				//将目前正按下，但是马上不被支持的按键释放
				if((value==null)||(value.indexOf(k)==-1)){
					simulateKeyUp(k);
				}
			}
			_enabledKeys=value;
		}
		public static var onKeyDown:Signal=new Signal(uint);
		public static var onKeyUp:Signal=new Signal(uint);
		public static var onMouseDown:Signal=new Signal(MouseEvent);
		public static var onMouseUp:Signal=new Signal(MouseEvent);
		public static var onMouseMove:Signal=new Signal(MouseEvent);
		public static var onMouseWheel:Signal=new Signal(MouseEvent);
		public static var onMouseOver:Signal=new Signal(MouseEvent);
		public static var onMouseOut:Signal=new Signal(MouseEvent);		
		
		
		private static var _instance:InputManager;
		private static var mainApp:DisplayObject;
		public static function init(_mainApp:Sprite):void
		{
			mainApp=_mainApp;
			mainApp.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			mainApp.stage.addEventListener(KeyboardEvent.KEY_UP,   keyUpListener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_DOWN,  mouseDownListener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_UP,    mouseUpListener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_MOVE,  mouseMoveListener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelLitener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_OVER,  mouseOverListener);
			mainApp.parent.addEventListener(MouseEvent.MOUSE_OUT,   mouseOutListener);
			// Add ourselves with the highest priority, so that our update happens at the beginning of the next tick.
			// This will keep objects processing afterwards as up-to-date as possible when using keyJustPressed() or keyJustReleased()
			_instance=new InputManager();
			ProcessManager.addTickedObject(_instance,Number.MAX_VALUE );			
		}
        /**
         * @inheritDoc
         */
        public function onTick(deltaTime:Number):void
        {
            // This function tracks which keys were just pressed (or released) within the last tick.
            // It should be called at the beginning of the tick to give the most accurate responses possible.
            
            var cnt:int;
            
            for (cnt = 0; cnt < _keyState.length; cnt++)
            {
                if (_keyState[cnt] && !_keyStateOld[cnt])
                    _justPressed[cnt] = true;
                else
                    _justPressed[cnt] = false;
                
                if (!_keyState[cnt] && _keyStateOld[cnt])
                    _justReleased[cnt] = true;
                else
                    _justReleased[cnt] = false;
                
                _keyStateOld[cnt] = _keyState[cnt];
            }
        }
		private static var keyDownListeners:Dictionary=new Dictionary();
		private static var keyUpListeners:Dictionary=new Dictionary();
		/**
		 * 将按键按下和某个函数绑定
		 * func无参数
		 * */
		public static function bindKeyDown(func:Function,...keys):void
		{
			if(keyDownListeners[func]==keys) return;
			keyDownListeners[func]=keys;
		}
		public static function bindKeyUp(func:Function,key:uint):void
		{
			if(keyUpListeners[func]==key) return;
			keyUpListeners[func]=key;
		}
		/**
		 * 将按键按下或弹起的侦听函数解开绑定
		 * */
		public static function unbindKey(func:Function):void
		{
			delete keyDownListeners[func];
			delete keyUpListeners[func];
		}
        /**
         * Returns whether or not a key was pressed since the last tick.
         */
        public static function keyJustPressed(keyCode:int):Boolean
        {
            return _justPressed[keyCode];
        }
        
        /**
         * Returns whether or not a key was released since the last tick.
         */
        public static function keyJustReleased(keyCode:int):Boolean
        {
            return _justReleased[keyCode];
        }

        /**
         * Returns whether or not a specific key is down.
         */
        public static function isKeyDown(keyCode:int):Boolean
        {
            return _keyState[keyCode];
        }
        
        /**
         * Returns true if any key is down.
         */
        public static function isAnyKeyDown():Boolean
        {
            for each(var b:Boolean in _keyState)
                if(b)
                    return true;
            return false;
        }

        /**
         * Simulates a key press. The key will remain 'down' until SimulateKeyUp is called
         * with the same keyCode.
         *
         * @param keyCode The key to simulate. This should be one of the constants defined in
         * InputMap
         *
         * @see InputMap
         */
        public static function simulateKeyDown(keyCode:int):void
        {
            _keyState[keyCode] = true;
			onKeyDown.dispatch(keyCode);
        }

        /**
         * Simulates a key release.
         *
         * @param keyCode The key to simulate. This should be one of the constants defined in
         * InputMap
         *
         * @see InputMap
         */
        public static function simulateKeyUp(keyCode:int):void
        {
			_keyState[keyCode] = false;
			onKeyUp.dispatch(keyCode);
        }

        /**
         * Simulates clicking the mouse button.
         */
        public static function simulateMouseDown():void
        {
			onMouseDown.dispatch(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }

        /**
         * Simulates releasing the mouse button.
         */
        public static function simulateMouseUp():void
        {
			onMouseDown.dispatch(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }

        /**
         * Simulates moving the mouse button. All this does is dispatch a mouse
         * move event since there is no way to change the current cursor position
         * of the mouse.
         */
        public static function simulateMouseMove():void
        {
			onMouseMove.dispatch(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, Math.random() * 100, Math.random () * 100));
        }

        public static function simulateMouseOver():void
        {
			onMouseOver.dispatch(new MouseEvent(MouseEvent.MOUSE_OVER));
        }

        public static function simulateMouseOut():void
        {
			onMouseOut.dispatch(new MouseEvent(MouseEvent.MOUSE_OUT));
        }

        public static function simulateMouseWheel():void
        {
			onMouseWheel.dispatch(new MouseEvent(MouseEvent.MOUSE_WHEEL));
        }

        private static function keyDownListener(event:KeyboardEvent):void
        {
			//屏蔽所有按键
			if(enabledKeys==null) return;
			//keyFilter包含了这个按键，屏蔽之
			if((enabledKeys.length>0)&&(enabledKeys.indexOf(event.keyCode)==-1)) return;
			
            if (_keyState[event.keyCode])
                return;
            _keyState[event.keyCode] = true;
			//检查是否触发某个按键按下绑定函数
			var triggered:Boolean;
			var keys:Array;
			for (var func:* in keyDownListeners){
				triggered=true;
				keys=keyDownListeners[func];
				for each(var key:uint in keys){
					if(_keyState[key]!==true){
						triggered=false;
						break;
					}
				}
				if(triggered) (func as Function).apply();
			}
            onKeyDown.dispatch(event.keyCode);
        }
        private static function keyUpListener(event:KeyboardEvent):void
        {
//			//屏蔽所有按键
			if(enabledKeys==null) return;
			//keyFilter包含了这个按键，屏蔽之
			if((enabledKeys.length>0)&&(enabledKeys.indexOf(event.keyCode)==-1)) return;
            _keyState[event.keyCode] = false;
			//检查是否触发某个按键弹起绑定
			for(var func:* in keyUpListeners){
				if(keyUpListeners[func]==event.keyCode){
					(func as Function).apply();
				}
			}
            onKeyUp.dispatch(event.keyCode);
        }
		private static function mouseDownListener(event:MouseEvent):void
		{
			onMouseDown.dispatch(event);
		}
		private static function mouseUpListener(event:MouseEvent):void
		{
			onMouseUp.dispatch(event);
		}
		
		private static  function mouseMoveListener(event:MouseEvent):void
		{
			onMouseMove.dispatch(event);
		}
		
		private static function mouseOverListener(event:MouseEvent):void
		{
			onMouseOver.dispatch(event);
		}
		
		private static function mouseOutListener(event:MouseEvent):void
		{
			onMouseOut.dispatch(event);
		}
		
		private static function mouseWheelLitener(event:MouseEvent):void
		{
			onMouseWheel.dispatch(event);
		}	
        private static var _keyState:Array = new Array();     // The most recent information on key states
        private static var _keyStateOld:Array = new Array();  // The state of the keys on the previous tick
        private static var _justPressed:Array = new Array();  // An array of keys that were just pressed within the last tick.
        private static var _justReleased:Array = new Array(); // An array of keys that were just released within the last tick.
    }
}

