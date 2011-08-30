package view.scene.entitles
{
	import com.longame.display.core.OnceClip;
	import com.longame.managers.AssetsLibrary;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.OnceClipEntity;
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.resource.ResourceManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import signals.FightSignals;
	
	import view.scene.components.ExplodeComp;
	import view.ui.components.time.CountdownEvent;
	
	public class Missile extends AnimatorEntity
	{
		private var path:Vector.<PathNode>;
		private var _content:MovieClip;
		private var _targetPlanet:Planet;
		private var fire:MissileFire;
		public function Missile(path:Vector.<PathNode>,targetPlanet:Planet,heroIndex:int)
		{
			super();
			this.path=path;
			this._targetPlanet=targetPlanet;
			this.source = "missile";
			this._content = AssetsLibrary.getMovieClip("missile");
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
			fire=new MissileFire(this);
			this.scene.add(fire);
		}
		
		override protected function doWhenDeactive():void
		{
			super.doWhenDeactive();
			
		}
		
		override protected function doRender():void
		{
			super.doRender();
			if(path.length==0){
				this.destroy();
				return;
			}
			var node:PathNode=path.shift();
			this.x=node.x;
			this.y=node.y;
			this.rotation=node.rotation;
		}

		override public function destroy():void
		{
			
			if(_targetPlanet)
			{
				_targetPlanet.addHole(this.x,this.y);
			}
			var explodeEffect:OnceClipEntity = new OnceClipEntity(OnceClipEntity.AUTO_REMOVE);
			explodeEffect.source = "explodeEffect";
			this.scene.add(explodeEffect);
			explodeEffect.x = this.x;
			explodeEffect.y = this.y;
			this.fire.destroy();
			
			super.destroy();
		}		

		public function getFireStartPoint():Point
		{
			return this._content.localToGlobal(new Point(_content.fireContainer.x,_content.fireContainer.y));
		}
	}
}