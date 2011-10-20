package view.scene
{
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.scenes.GameScene;
	
	public class SceneBase extends GameScene
	{
		protected var _sceneBack:SpriteEntity;
		protected var _sceneMiddle:DisplayGroup;
		protected var _heroLayer:DisplayGroup;
		protected var _sceneFront:SpriteEntity;
		
		protected var _middleStarBg:SpriteEntity;
		protected var _closeStarBg:SpriteEntity;
		
		protected var _middleBackground:SpriteEntity;
		public function SceneBase(back:String=null,front:String=null,middle:String=null,tileSize:int=60)
		{
			super("2d",tileSize);
			this.addLayers(back,front,middle);
		}
		
		protected function addLayers(back:String,front:String,middle:String):void
		{
			if(back) {
				_sceneBack=this.addSimpleLayer(back);
				_sceneBack.includeInBounds=false;
			}
			_sceneMiddle=this.addLayer();
			if(middle){
				_middleBackground=_sceneMiddle.addSimpleLayer(middle);
				_middleBackground.includeInBounds=false;
			}
			_heroLayer=this.addLayer();
			if(front) {
				_sceneFront=this.addSimpleLayer(front);
				_sceneFront.includeInBounds=false;
			}
		}
		public function get heroLayer():DisplayGroup
		{
			return this._heroLayer;
		}
		public function get backLayer():SpriteEntity
		{
			return this._sceneBack;
		}
		public function get monsterMiddle():DisplayGroup
		{
			return this._sceneMiddle;
		}
	}
}