package com.longame.game.entity
{
	import com.longame.model.consts.Registration;

	/**
	 * 一个看不见的物品，但通过设置其尺寸，设置walkable，includeInBounds等属性，能让某一区域的walkable或尺寸发生变化
	 * 应用举例：加载进一张图片做场景的背景，图片中某个区域是可行走的，其他地方是不可行走的，这时候，将图片的includeInBounds设为false，
	 * 然后在图片上层加一个 DummyEntity，将其尺寸设为可行走区域的尺寸，walkable设为true,inludeInLayout设为false，那么人物将只会在DummyEntity
	 * 所限定的区域行走
	 * */
	public class DummyEntity extends DisplayEntity
	{
		public function DummyEntity(width:Number,length:Number,walkable:Boolean=true)
		{
			super();
			this.registration=Registration.TOP_LEFT;
			this.width=width;
			this.length=length;
			this.includeInLayout=false;
			this.walkable=walkable;
		}
		public function showArea():void
		{
			//TODO
//			this.container.graphics.beginFill(0xff0000,0.5);
//			this.container.graphics.drawRect(0,0,this.width,this.length);
//			this.container.graphics.endFill();
		}
		public function hideArea():void
		{
			//TODO
//			this.container.graphics.clear();
		}
	}
}