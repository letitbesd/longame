package com.longame.game.entity
{
	import com.longame.core.long_internal;
	import com.longame.model.Direction;
	import com.longame.model.EntityItemSpec;
	import com.longame.game.component.fight.AttackComp;
	import com.longame.game.component.KeyboardController;
	import com.longame.game.component.MouseController;
	
	import flash.utils.Dictionary;

    use namespace long_internal;
	public class Hero extends Character
	{
		/**
		 * 最多拥有多少宠物
		 * */
		public var maxPets:int=1;
		
		public function Hero(id:String=null)
		{
			super(id);
			//鼠标控制组件
			var _mouser:MouseController=new MouseController();
			this.add(_mouser);
			//按键控制组件
			var _keyer:KeyboardController=new KeyboardController();
			this.add(_keyer);
			this._offensive=false;
			this._faction=CharacterFaction.ALLY;
			
		}
		public function attack(target:Character=null,animation:String="attack"):void
		{
//			if(target)
			{
//				this.direction=Direction.getDirectionBetweenTiles(this.tileBounds.x,this.tileBounds.y,target.tileBounds.x,target.tileBounds.y);
				this.gotoAndPlay(animation);
//				target.onTileMove.add(onTargetMove);
			}
		}
		public function stopAttack():void
		{
			this.gotoAndPlay(this.defaultAnimation);
		}
		protected var _pets:Dictionary=new Dictionary();
		protected var _petNum:int=0;
		/**
		 * 添加一只宠物
		 * */
		public function addPet(petSpec:EntityItemSpec,petName:String="pet"):Pet
		{
			if(_petNum>=maxPets) return null;
            if(_pets[petName]) return null;			
			var pet:Pet=new petSpec.entityClass() as Pet;
			pet.itemSpec=petSpec;
			_pets[petName]=pet;
			pet.host=this;
			if(this.actived) {
				this.parent.add(pet);
			}
			return pet;
		}
		/**
		 * 移除一只宠物
		 * */
		public function removePet(petName:String):Pet
		{
			var pet:Pet=_pets[petName];
			if(pet){
				delete _pets[petName];
				pet.host=null;
				this.parent.remove(pet);
			}
			return pet;
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			for each(var pet:Pet in _pets){
				pet.dispose();
			}
			_pets=null;
		}
		override protected function  whenActive():void
		{
			super.whenActive();
			for each(var pet:Pet in _pets){
//				(this.parent as DisplayEntity).activeChild(pet);
				this.parent.add(pet);
			}
		}
		override protected function  whenDeactive():void
		{
			for each(var pet:Pet in _pets){
//				(this.parent as DisplayEntity).deactiveChild(pet);
				this.parent.remove(pet);
			}
			super.whenDeactive();
		}
	}
}