package com.longame.modules.core.signals
{
	import com.longame.modules.core.IMouseObject;
	import com.longame.modules.entities.IDisplayEntity;
	
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

    /**
	 * 定义一个所有与鼠标响应相关的信号集
	 * */
	public class MouseSignals
	{
		private var _target:IDisplayEntity;
		
		private var _click:NativeSignal;
		private var _down:NativeSignal;
		private var _up:NativeSignal;
		private var _move:NativeSignal;
		private var _wheel:NativeSignal;
		private var _over:NativeSignal;
		private var _out:NativeSignal;
		
		public function MouseSignals(target:IDisplayEntity):void
		{
			this._target=target;
		}
		public function removeAll():void
		{
			if(_down) _down.removeAll();
			if(_up)  _up.removeAll();
			if(_move) _move.removeAll();
			if(_wheel) _wheel.removeAll();
			if(_over) _over.removeAll();
			if(_out) _out.removeAll();
			if(_click) _click.removeAll();
		}
		/**
		 * 鼠标按下响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get click():NativeSignal
		{
			if(_click==null) _click=new NativeSignal(_target.container,MouseEvent.CLICK,MouseEvent);
			return _click;
		}
		/**
		 * 鼠标按下响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get down():NativeSignal
		{
			if(_down==null) _down=new NativeSignal(_target.container,MouseEvent.MOUSE_DOWN,MouseEvent);
			return _down;
		}
		/**
		 * 鼠标弹起响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get up():NativeSignal
		{
			if(_up==null) _up=new NativeSignal(_target.container,MouseEvent.MOUSE_UP,MouseEvent);
			return _up;
		}
		/**
		 * 鼠标移动响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get move():NativeSignal
		{
			if(_move==null) _move=new NativeSignal(_target.container,MouseEvent.MOUSE_MOVE,MouseEvent);
			return _move;
		}
		/**
		 * 鼠标滚动响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get wheel():NativeSignal
		{
			if(_wheel==null) _wheel=new NativeSignal(_target.container,MouseEvent.MOUSE_WHEEL,MouseEvent);
			return _wheel;
		}
		/**
		 * 鼠标over响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get over():NativeSignal
		{
			if(_over==null) _over=new NativeSignal(_target.container,MouseEvent.ROLL_OVER,MouseEvent);
			return _over;
		}
		/**
		 * 鼠标out响应
		 * 回调模板：callBackFunction(evt:MouseEvent):void;
		 * */
		public function get out():NativeSignal
		{
			if(_out==null) _out=new NativeSignal(_target.container,MouseEvent.ROLL_OUT,MouseEvent);
			return _out;
		}
	}
}