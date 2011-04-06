package com.longame.modules.components
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.longame.core.long_internal;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.DisplayGroup;
	

    use namespace long_internal;
	/**
	 * 测试阶段，显示IDisplayEntity的层级信息，使用方法
	 * someDisplayEntity:
	 * 开启：
	 * someDisplayEntity.add(new DepthDebugger(),"debug");
	 * someDisplayEntity.state="debug";
	 * 关闭：
	 * someDisplayEntity.state="";
	 * */
	public class DepthDebugger extends AbstractComp
	{
		long_internal var label:TextField;
		
		public function DepthDebugger()
		{
			super("depthDebugger");
		}
		override protected function doWhenActive():void
		{
			if(label==null){
				label=new TextField();
				label.defaultTextFormat=new TextFormat(null,16,0xff0000,true);
				label.text="0";
				//显示到注册点
				label.x-=(this.owner as IDisplayEntity).offsetX;
				label.y-=(this.owner as IDisplayEntity).offsetY;
				(this.owner as IDisplayEntity).container.addChild(label);
			}
			(this.owner as IDisplayEntity).onDepthChanged.add(this.onOwnerDepthChanged);
		}
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			if(label){
				(this.owner as IDisplayEntity).container.removeChild(label);
				label=null;
			}
			(this.owner as IDisplayEntity).onDepthChanged.remove(this.onOwnerDepthChanged);
		}
		private function onOwnerDepthChanged(target:IDisplayEntity,oldIndex:int,newIndex:int):void
		{
			var g:DisplayGroup=(this.owner as DisplayEntity).owner as DisplayGroup;
			if(g){
				var children:Vector.<IDisplayEntity>=g.getDisplays();
				for each(var child:IDisplayEntity in children){
					var dd:DepthDebugger=child.getChild("depthDebugger") as DepthDebugger;
					if(dd){
						dd.label.text=""+child.depth;
					}
				}
			}
			label.text=""+newIndex;
		}
	}
}