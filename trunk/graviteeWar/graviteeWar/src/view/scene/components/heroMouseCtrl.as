package view.scene.components
{	
	import com.longame.managers.InputManager;
	import com.longame.modules.components.AbstractComp;
	import com.longame.modules.scenes.GameScene;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import view.scene.entitles.heros.Hero;
	
	public class heroMouseCtrl extends AbstractComp
	{
		private var _animation:String;
		public var hero:Hero;
		public var scene:GameScene;
		public function heroMouseCtrl(animation:String = "notaiming7")
		{
			super();
			_animation = animation;
		}
		
		override protected function doWhenActive():void
		{
			this.hero = _owner as Hero;
//			this.scene = this._owner.
			this.hero.doAction(_animation);
			if(!hero) throw new Error("The mouseController component is only for Hero!");
			(_owner as Hero).gotoAndStop(this._animation);
			(_owner as Hero).mouseEnabled=true;
			(_owner as Hero).container.buttonMode = true;
			(_owner as Hero).onMouse.down.add(onMouseDown);
			
		}
		
		override protected function doWhenDeactive():void
		{
			(_owner as Hero).onMouse.down.remove(onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			(_owner as Hero).isAiming = true;
			InputManager.onMouseUp.add(onMouseUp);
			InputManager.onMouseMove.add(onMouseMove);
		}
		
		
		protected function onMouseUp(event:MouseEvent):void
		{
//			(_owner as Hero).state = "";
			hero.shoot();
			hero.isAiming = false;
			hero.doAction("notaiming7");
			InputManager.onMouseUp.remove(onMouseUp);
			InputManager.onMouseMove.remove(onMouseMove);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			var mouseX:Number=event.stageX;
			var mouseY:Number=event.stageY;
			var p:Point=new Point(mouseX,mouseY);
			(_owner as Hero).simulatePath(p.x,p.y);
		}
	}
}