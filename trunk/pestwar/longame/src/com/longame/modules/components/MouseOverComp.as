package com.longame.modules.components
{
	import com.longame.display.bitmapEffect.BitmapEffect;
	import com.longame.modules.core.IMouseObject;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.entities.SpriteEntity;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MouseOverComp extends AbstractComp
	{
		private var overEffect:BitmapEffect;
		public function MouseOverComp(effect:BitmapEffect)
		{
			super();
			this.overEffect=effect;
			if(effect==null) throw new Error("effect can not be null!");
		}
		override protected function doWhenActive():void
		{
			if(!(_owner is SpriteEntity)) throw new Error("SpriteEntity needed!");
			theOwner.onMouse.over.add(onOver);
			theOwner.onMouse.out.add(onOut);
//			theOwner.onMouse.onMouseDown.add(onOut);
		}
		override protected function doWhenDeactive():void
		{
			theOwner.onMouse.over.remove(onOver);
			theOwner.onMouse.out.remove(onOut);
		}
		private function onOver(evt:MouseEvent):void
		{
			theOwner.effects.push(this.overEffect);
		}
		private function onOut(evt:MouseEvent):void
		{
			var i:int=theOwner.effects.indexOf(overEffect);
			if(i==-1) return;
			theOwner.effects.splice(i,1);
		}
		private function get theOwner():SpriteEntity
		{
			return _owner as SpriteEntity;
		}
	}
}