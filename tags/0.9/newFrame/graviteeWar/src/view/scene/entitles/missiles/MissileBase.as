package view.scene.entitles.missiles
{
	import com.longame.managers.AssetsLibrary;
	import com.longame.modules.core.IEntity;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.OnceClipEntity;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import signals.FightSignals;
	import view.scene.BattleScene;
	import view.scene.entitles.PathNode;
	import view.scene.entitles.Planet;
	import view.scene.entitles.PlayOnceObject;
	import view.scene.entitles.heros.Hero;
	
	public class MissileBase extends AnimatorEntity
	{
		private var path:Vector.<PathNode>;
		private var _content:MovieClip;
		protected var _scope:int;
		protected var _targetPlanet:Planet;
		private var node:PathNode;
		protected var fire:MissileFire;
		private var wepID:int;
		public function MissileBase(path:Vector.<PathNode>,targetPlanet:Planet,id:int,scope:int=1)
		{
			super();
			if(id==10){
				this.path=path.concat();
			}else{
				this.path=path;
			}	
			this._targetPlanet=targetPlanet;
			_content=AssetsLibrary.getMovieClip("missile"+id);
			_content.scaleX=-1;
			this.source = "missile"+id;
			this.animator.clip.scaleX = -1;
			this._scope=scope;
			wepID=id;
		}
		override protected function doRender():void
		{	
			super.doRender();
		   if(path.length==0){
			   this.destroy();
			   return;
		   }
           node=path.shift();
		   this.x=node.x;
		   this.y=node.y;
		   this.rotation=node.rotation;
		}
		override public function destroy():void
		{
			if(_targetPlanet&&wepID!=2){
				_targetPlanet.addHole(this.x,this.y,this._scope);
			}
			var explodeEffect:OnceClipEntity = new OnceClipEntity(OnceClipEntity.AUTO_REMOVE);
//			explodeEffect.source = "explodeEffect";
//			this.scene.add(explodeEffect);
//			explodeEffect.x = this.x;
//			explodeEffect.y = this.y;
			if(wepID==2) FightSignals.missileBomded.dispatch(_targetPlanet,node);
			if(wepID==9){
				for each(var h:Hero in BattleScene.sceneHeros)
				{	
					if(h.currentPlanet==_targetPlanet)  FightSignals.heroPoisoned.dispatch(h.heroIndex);
				}	
			}
				super.destroy();
		}
		
		override protected function doWhenActive():void
		{
			super.doWhenActive();
//			fire=new MissileFire(this);
		}
		
		override protected function doWhenDeactive():void
		{
		  super.doWhenDeactive();
		}
		public function getFireStartPoint():Point
		{
			return this._content.localToGlobal(new Point(_content.fireContainer.x,_content.fireContainer.y));
		}
	}
}