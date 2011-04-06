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
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import com.longame.core.IMouseObject;
    import com.longame.core.ITickedObject;
    
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
		private static var mouseObjects:Vector.<IMouseObject>=new Vector.<IMouseObject>();
		private static var mouseDisplays:Vector.<DisplayObject>=new Vector.<DisplayObject>();
		/**
		 * 将mouseObj和display关联到一起，当后者发生鼠标点击事件时，会帮助前者自动发出相应的鼠标signal，
		 * 统一管理，提高效率，这样相应的display可以禁掉鼠标响应?
		 * @param mouseObj:一个IMouseObje对象
		 * @param display:一个显示对象
		 * */
		public static function registerMouseObject(mouseObj:IMouseObject,display:DisplayObject):Boolean
		{
			if(mouseObjects.indexOf(mouseObj)!=-1) return false;
			mouseObjects[mouseObjects.length]=mouseObj;
			mouseDisplays[mouseDisplays.length]=display;
			return true;
		}
		/**
		 * 注销一个IMmouseObject，之后这个target不会分发鼠标响应signal
		 * */
		public static function unregisterMouseObject(target:IMouseObject):Boolean
		{
			var i:int=mouseObjects.indexOf(target);
			if(i>-1) {
				mouseObjects.splice(i,1);
				mouseDisplays.splice(i,1);
			}
			return i>-1;
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
			onKeyDown.dispatch(keyCode);
            _keyState[keyCode] = true;
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
           onKeyUp.dispatch(keyCode);
			_keyState[keyCode] = false;
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
            if (_keyState[event.keyCode])
                return;

            _keyState[event.keyCode] = true;
            onKeyDown.dispatch(event.keyCode);
        }

        private static function keyUpListener(event:KeyboardEvent):void
        {
            _keyState[event.keyCode] = false;
            onKeyUp.dispatch(event.keyCode);
        }
		private static function mouseDownListener(event:MouseEvent):void
		{
			onMouseDown.dispatch(event);
			mouseObjectsDispatch(event,"onMouseDown");
		}
		private static function mouseUpListener(event:MouseEvent):void
		{
			onMouseDown.dispatch(event);
			mouseObjectsDispatch(event,"onMouseUp");
		}
		
		private static  function mouseMoveListener(event:MouseEvent):void
		{
			onMouseMove.dispatch(event);
			mouseObjectsDispatch(event,"onMouseMove");
		}
		
		private static function mouseOverListener(event:MouseEvent):void
		{
			onMouseOver.dispatch(event);
			mouseObjectsDispatch(event,"onMouseOver");
		}
		
		private static function mouseOutListener(event:MouseEvent):void
		{
			onMouseOut.dispatch(event);
			mouseObjectsDispatch(event,"onMouseOut");
		}
		
		private static function mouseWheelLitener(event:MouseEvent):void
		{
			onMouseWheel.dispatch(event);
			mouseObjectsDispatch(event,"onMouseWheel");
		}	
		/**
		 * 从点击点顺着显示列表向上搜索，发现是注册了的IMouseObject就帮助其分发相应的signal
		 * 注意，对象还是要mouseEnabled=true才能被搜寻到的
		 * */
		private static function mouseObjectsDispatch(event:MouseEvent,signal:String):void
		{
			if (mouseObjects.length==0) return;
			var targetDisplay:DisplayObject=event.target as  DisplayObject;
			var globalPos:Point=new Point(event.stageX,event.stageY);
			var localPos:Point;
			var i:int;
			while(targetDisplay){
				if(targetDisplay==mainApp.parent) break;
				i=mouseDisplays.indexOf(targetDisplay);
				if(i>-1) {
					//由于监听对象是mainApp.parent，所以localX,localY是不对的，转换到真实对象坐标系下
					localPos=targetDisplay.globalToLocal(globalPos);
					event.localX=localPos.x;
					event.localY=localPos.y;
					mouseObjects[i].onMouse[signal].dispatch(event,mouseObjects[i]);
				}
				targetDisplay=targetDisplay.parent;
			}		
		}
		private static function calLocalMousePosition():void
		{
			
		}
        private static var _keyState:Array = new Array();     // The most recent information on key states
        private static var _keyStateOld:Array = new Array();  // The state of the keys on the previous tick
        private static var _justPressed:Array = new Array();  // An array of keys that were just pressed within the last tick.
        private static var _justReleased:Array = new Array(); // An array of keys that were just released within the last tick.
    }
}

