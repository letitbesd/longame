package com.longame.game.entity.display.primitive
{
	import com.longame.display.graphics.SolidColorFill;
	import com.longame.game.scene.SceneManager;

	/**
	 * 方格高亮显示
	 * */
	public class TileHilighter extends LRectangle
	{
		public static const ALPHA:Number=0.8;
		/**
		 * 绿色显示正常高亮
		 * */
		public static const VALIDATED_COLOR:uint=0x00ff00;
		/**
		 * 红色显示非正常高亮，比如这个格子被占据
		 * */
		public static const INVALIDATED_COLOR:uint=0xff0000;
		/**
		 * 定义三种种状态
		 * */
//		public static const VALIDATED_STATE:String="validated";
//		public static const INVALIDATED_STATE:String="invalidated";
//		public static const HIDE_STATE:String="hide";

		public function TileHilighter(id:String=null)
		{
			super(id);
			this._includeInLayout=false;
			this._includeInBounds=false;
			this.width=this.length=SceneManager.tileSize;
			this.color=VALIDATED_COLOR;
		}
		private var _color:uint;
		public function set color(value:uint):void
		{
			if(value==_color) return;
			_color=value;
			this.fill=new SolidColorFill(value,ALPHA);
		}
		public function get color():uint
		{
			return _color;
		}
//		override protected function doWhenStateChange(oldState:String, newState:String):void
//		{
//			super.doWhenStateChange(oldState,newState);
//			switch(newState){
//				case VALIDATED_STATE:
//					this.fill=new SolidColorFill(VALIDATED_COLOR,ALPHA);
//					break;
//				case INVALIDATED_STATE:
//					this.fill=new SolidColorFill(INVALIDATED_COLOR,ALPHA);
//					break;
//				case HIDE_STATE:
//					this.destroy();
//					return;
//				default:
//					//no state....
//					break;
//			}
//		}
	}
}