package com.longame.display.tip
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class ToolTip extends InfoBubble
	{
		protected var tips:Array=[]
		
		public function ToolTip(_followMouse:Boolean=true)
		{
			super();
			this.followMouse=_followMouse
		}
		public  function regist(t:DisplayObject,title:String,icon:DisplayObject=null,content:String=null):void
		{
			var has:Boolean=this.addTip(new TipDescription(t.name,t,title,icon,content))
			if(!has){
               this.enableTip(t)		
			}
		}
		public function unRegist(t:DisplayObject):void
		{
			for  (var i:int=0;i<this.tips.length;i++){
				var tt:TipDescription=this.tips[i]
				if(tt.name==t.name){
					this.tips.splice(i,1)
					this.disableTip(tt.target)
				}				
			}			
		}
		protected function findTarget(t:DisplayObject):TipDescription
		{
			for  (var i:int=0;i<this.tips.length;i++){
				var tt:TipDescription=this.tips[i]
				if(tt.name==t.name){
                    return tt
				}				
			}		
			return null	
		}
		protected function enableTip(t:DisplayObject):void
		{
			t.addEventListener(MouseEvent.MOUSE_OVER,onOverTarget)						
		}
		protected function disableTip(t:DisplayObject):void
		{
			t.removeEventListener(MouseEvent.MOUSE_OVER,onOverTarget)
			t.removeEventListener(MouseEvent.MOUSE_OUT,onOutTarget)						
		}		
		protected function addTip(t:TipDescription):Boolean
		{
			var has:Boolean=false
			for  (var i:int=0;i<this.tips.length;i++){
				var tt:TipDescription=this.tips[i]
				if(tt.name==t.name){
					has=true
					this.tips.splice(i,1)
				}
			}
			this.tips.push(t)
			return has
		}
		protected function onOverTarget(e:MouseEvent):void
		{
			var dt:DisplayObject=DisplayObject(e.currentTarget)
			var tt:TipDescription=this.findTarget(dt)
			if(tt){
				var success:Boolean=this.show(tt.target,tt.title,tt.icon,tt.content)
				if(success) tt.target.addEventListener(MouseEvent.MOUSE_OUT,onOutTarget)				
			}
		}
		protected function onOutTarget(e:MouseEvent):void
		{
			this.hide()	
			this._target.removeEventListener(MouseEvent.MOUSE_OUT,onOutTarget)		
		}		
	}
}
    import flash.display.DisplayObject;

	internal class TipDescription
	{
		public var name:String
		public var target:DisplayObject
		public var title:String
		public var icon:DisplayObject
		public var content:String
		
		public function TipDescription(_name:String,_target:DisplayObject,_title:String,_icon:DisplayObject,_content:String)
		{
			this.name=_name
			this.target=_target
			this.title=_title
			this.icon=_icon
			this.content=_content
		}
	}