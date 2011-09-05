package view.scene.entitles.item
{
	import com.longame.modules.entities.AnimatorEntity;
	
	import view.scene.entitles.Planet;
	
	public class Item extends AnimatorEntity
	{
		public var timeSince:int = 0;
		public var positionPlanet:Planet;
		
		public function Item(id:String=null)
		{
			super(id);
		}
	}
}