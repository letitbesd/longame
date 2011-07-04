package com.longame.display.tip
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class ToolTip extends InfoBubble
	{
		//true:信息框跟随鼠标移动
		//false：信息框跟随对象移动
		public var followMouse:Boolean=false;
			
		protected var tips:Array=[]
		
		public function ToolTip(_followMouse:Boolean=true)
		{
			super();
			this.followMouse=_followMouse
		}
		public  function register(t:DisplayObject,title:String,icon:DisplayObject=null,content:String=null):void
		{
			var has:Boolean=this.addTip(new TipDescription(t.name,t,title,icon,content))
			if(!has){
               this.enableTip(t)		
			}
		}
		public function unRegister(t:DisplayObject):void
		{
			for  (var i:int=0;i<this.tips.length;i++){
				var tt:TipDescription=this.tips[i]
				if(tt.name==t.name){
					this.tips.splice(i,1)
					this.disableTip(tt.target)
				}				
			}			
		}
		protected function getBasePosition():Point
		{
			var pn:Point 
			if(this.followMouse) {
				pn=new Point(this._container.mouseX,this._container.mouseY)
			}else{
				//目标的上部中央作为显示基点
				var rect:Rectangle=_target.getBounds(_container);
				pn=new Point((rect.left+rect.right)/2,rect.top);
			}
			return pn;
		}
		override protected function tick( event:Event ):void {
			this.setPosition();
			super.tick(event);
		}
		override public function moveTo(x:Number,y:Number):void
		{
			var speed:Number = 3;
			var xp:Number = x + this._offSet+this.offsetX;
			var yp:Number = y - this.height +this.offsetY;
			
			var overhangRight:Number = this._defaultWidth + xp;
			if( overhangRight > stage.stageWidth ){
				xp =  stage.stageWidth -  this._defaultWidth;
			}
			if( xp < 0 ) {
				xp = 0;
			}
			if( yp < 0 ){
				yp = 0;
			}
			this.x += ( xp - this.x ) / speed;
			this.y += ( yp - this.y ) / speed;
		}
		protected function setPosition():void {
			var pn:Point=getBasePosition();
			moveTo(pn.x,pn.y);
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
				var success:Boolean=this.show(tt.target,tt.title,tt.content,tt.icon);
				//initialize coordinates
//				var sp:Point=this.getBasePosition();
//				
//				this.x = sp.x + this._offSet+this.offsetX;
//				this.y = sp.y - this.height+this.offsetY;
//				
//				this.alpha = 0;
//				this._container.addChild( this );
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