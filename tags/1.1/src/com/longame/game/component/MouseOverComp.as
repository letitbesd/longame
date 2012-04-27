package com.longame.game.component
{
	import com.longame.game.core.IMouseObject;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.SpriteEntity;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

	public class MouseOverComp extends AbstractComp
	{
		public var onOver:Signal=new Signal();
		public var onOut:Signal=new Signal();
		
		private var overFilter:BitmapFilter;
		private var oldFilters:Array;
		private var bringToTop:Boolean;
		private var oldScale:Point;
		private var overScale:Number;
		
		/**
		 * @param bringToTop:拖动时是否保持对象在最上层
		 * */
		public function MouseOverComp(filter:BitmapFilter,scale:Number=1,bringToTop:Boolean=false)
		{
			super();
			this.overFilter=filter;
			this.overScale=scale;
			this.bringToTop=bringToTop;
			if(filter==null) throw new Error("filter can not be null!");
		}
		override protected function whenActive():void
		{
			if(!(_owner is SpriteEntity)) throw new Error("SpriteEntity needed!");
			theOwner.onMouse.over.add(onMouseOver);
			theOwner.onMouse.out.add(onMouseOut);
			theOwner.container.buttonMode=true;
		}
		override protected function whenDeactive():void
		{
			theOwner.onMouse.over.remove(onMouseOver);
			theOwner.onMouse.out.remove(onMouseOut);
			theOwner.container.buttonMode=false;
			if(this.oldFilters) theOwner.container.filters=this.oldFilters;
			if(this.oldScale){
				theOwner.scaleX=this.oldScale.x;
				theOwner.scaleY=this.oldScale.y;
			}
			this.theOwner.alwaysInTop=false;
		}
		override protected  function whenDestroy():void
		{
			overFilter=null;
			this.onOver.removeAll();
			this.onOut.removeAll();
		}
		private function onMouseOver(evt:MouseEvent):void
		{
			this.oldScale=new Point(theOwner.scaleX,theOwner.scaleY);
			theOwner.scaleX=theOwner.scaleY=this.overScale;
			this.oldFilters=theOwner.container.filters;
			var newFilters:Array=this.oldFilters.concat();
			newFilters.push(this.overFilter);
			theOwner.container.filters=newFilters;
			this.onOver.dispatch();
			this.theOwner.alwaysInTop=this.bringToTop;
		}
		private function onMouseOut(evt:MouseEvent):void
		{
			//todo，本来想不影响对象可能具有的其它滤镜，但是indexOf不能检索出来
//			var filters:Array=theOwner.container.filters;
//			var i:int=filters.indexOf(this.overFilter);
//			if(i==-1) return;
//			filters.splice(i,1);
			theOwner.container.filters=this.oldFilters;
			theOwner.scaleX=this.oldScale.x;
			theOwner.scaleY=this.oldScale.y;
			this.onOut.dispatch();
			this.theOwner.alwaysInTop=false;
		}
		private function get theOwner():SpriteEntity
		{
			return _owner as SpriteEntity;
		}
	}
}