package com.longame.model.signals
{
	import flash.events.MouseEvent;
	
	import com.longame.core.IMouseObject;
	
	import org.osflash.signals.Signal;

	public class MouseSignals
	{
		private var _onMouseDown:Signal;
		private var _onMouseUp:Signal;
		private var _onMouseMove:Signal;
		private var _onMouseWheel:Signal;
		private var _onMouseOver:Signal;
		private var _onMouseOut:Signal;
		
		public function MouseSignal():void
		{
			
		}
		public function removeAll():void
		{
			if(_onMouseDown) _onMouseDown.removeAll();
			if(_onMouseUp)  _onMouseUp.removeAll();
			if(_onMouseMove) _onMouseMove.removeAll();
			if(_onMouseWheel) _onMouseWheel.removeAll();
			if(_onMouseOver) _onMouseOver.removeAll();
			if(_onMouseOut) _onMouseOut.removeAll();
		}
		public function get onMouseDown():Signal
		{
			if(_onMouseDown==null) _onMouseDown=new Signal(MouseEvent,IMouseObject);
			return _onMouseDown;
		}
		public function get onMouseUp():Signal
		{
			if(_onMouseUp==null) _onMouseUp=new Signal(MouseEvent,IMouseObject);
			return _onMouseUp;
		}
		public function get onMouseMove():Signal
		{
			if(_onMouseMove==null) _onMouseMove=new Signal(MouseEvent,IMouseObject);
			return _onMouseMove;
		}
		public function get onMouseWheel():Signal
		{
			if(_onMouseWheel==null) _onMouseWheel=new Signal(MouseEvent,IMouseObject);
			return _onMouseWheel;
		}
		public function get onMouseOver():Signal
		{
			if(_onMouseOver==null) _onMouseOver=new Signal(MouseEvent,IMouseObject);
			return _onMouseOver;
		}
		public function get onMouseOut():Signal
		{
			if(_onMouseOut==null) _onMouseOut=new Signal(MouseEvent,IMouseObject);
			return _onMouseOut;
		}
	}
}