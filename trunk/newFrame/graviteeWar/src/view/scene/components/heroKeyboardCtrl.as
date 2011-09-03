package view.scene.components
{
	import com.longame.managers.InputManager;
	import com.longame.modules.components.AbstractComp;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import view.scene.entitles.heros.Hero;
	
	public class heroKeyboardCtrl extends AbstractComp
	{
		public var leftArrow:Boolean = false;
		public var rightArrow:Boolean = false;
		public var hero:view.scene.entitles.heros.Hero;
		
		public function heroKeyboardCtrl(id:String=null)
		{
			super(id);
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			InputManager.onKeyDown.add(onKeydown);
			InputManager.onKeyUp.add(onKeyUp);
			
			this.hero = _owner as Hero;
		}
		
		private function onKeyUp(key:uint):void
		{
			leftArrow = false;
			rightArrow = false;
			if(!hero.isAiming){
				hero.doAction(hero.unfireAction);
			}
		}
		
		protected function onKeydown(key:uint):void
		{
			if(hero.onTopHalf){
				if(key==Keyboard.LEFT || key == Keyboard.UP){
					this.rightArrow = true;
				}else if(key==Keyboard.RIGHT || key == Keyboard.DOWN){
					this.leftArrow = true;
				}
			}else{
				if(key==Keyboard.LEFT || key == Keyboard.UP){
					this.leftArrow = true;
				}else if(key==Keyboard.RIGHT || key == Keyboard.DOWN){
					this.rightArrow = true;
				}
			}
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			InputManager.onKeyDown.remove(onKeydown);
			InputManager.onKeyUp.remove(onKeyUp);
		}
	}
}