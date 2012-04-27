package com.longame.modules.scenes.utils
{
	import com.longame.modules.entities.display.primitive.TileHilighter;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.DictionaryUtil;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class TileHilightUtil
	{
		public static var tileColor:uint=TileHilighter.VALIDATED_COLOR;
		
		protected static var _hilightsMap:Dictionary=new Dictionary();
		/**
		 * 把以centerX和centerY中心点，长宽分别为width和length范围内的方格加亮显示,单位均为SceneTile，不是像素
		 * @param centerX:       中心点tile的x索引
		 * @param centerY:       中心点tile的y索引
		 * @param width:         x方向上的tile数量
		 * @param length:        y方向上的tile数量
		 * @param z:             点亮这个tile的在场景中的高度
		 * @param dehilightOld:  是否消除当前的高亮
		 * */
		public static function hilight(target:IDisplayGroup,centerX:int,centerY:int,width:uint=1,length:uint=1,z:Number=0,dehilightOld:Boolean=true):void
		{
			var tiles:Vector.<Point>=SceneManager.getTiles(centerX,centerY,width,length);
			var tile:TileHilighter;
			var newTiles:Dictionary=new Dictionary();
			for each(var t:Point in tiles){
//				if(!target.map.isValidTile(t.x,t.y)) continue;
				var key:String=t.x+"_"+t.y;
				tile=null;
				if(_hilightsMap[target]) tile=_hilightsMap[target][key];
				if(tile) {
					delete _hilightsMap[target][key];
					tile.color=tileColor;
				}
				else     {
					tile=doHilight(target,t.x,t.y,dehilightOld);
				}
				newTiles[key]=tile;
			}
			if(dehilightOld) dehilight(target);
			for(key in newTiles)
			{
				if(_hilightsMap[target]==null)  _hilightsMap[target]=new Dictionary(true);
				_hilightsMap[target][key]=newTiles[key];
			}
		}
		/**
		 * 取消所有单元格点亮
		 * */
		public static function dehilight(target:IDisplayGroup):void
		{
			for(var key:String in _hilightsMap[target]){
				var t:TileHilighter=_hilightsMap[target][key];
				t.destroy();
				delete _hilightsMap[target][key];
			}
		}
		/**
		 * 将x,y索引处的单元格点亮，并将其置于z高度
		 * @param target:        下面的坐标一定要是基于target的
		 * @param x:             目标tile的x索引或全局坐标
		 * @param y:             目标tile的y索引或全局坐标
		 * @param dehilightOld:  是否消除当前的高亮
		 * @param globalAxis:    是否全局坐标，否则x,y代表的是方格索引
		 * */
		public static function hilightTile(target:IDisplayGroup,x:Number,y:Number,z:Number=0,dehilightOld:Boolean=true,globalAxis:Boolean=false):void
		{
			var p:Point=new Point(x,y);
			if(globalAxis) {
				var pt:Vector3D=target.globalToLocal(p);
				p=SceneManager.getTileIndex(pt.x,pt.y);
			}
			var key:String=p.x+"_"+p.y;
			var tile:TileHilighter;
			if(_hilightsMap[target]) tile=_hilightsMap[target][key];
			if(tile) return;
			tile=doHilight(target,p.x,p.y,dehilightOld);
			if(dehilightOld) dehilight(target);
			if(_hilightsMap[target]==null) _hilightsMap[target]=new Dictionary(true);
			_hilightsMap[target][key]=tile;
//			_hilightsMap[key]=tile;
		}
		private static function doHilight(target:IDisplayGroup,x:int,y:int,dehilghtOld:Boolean=true):TileHilighter
		{
			var t:TileHilighter;
			if(dehilghtOld){
				var ts:Array=DictionaryUtil.getKeys(_hilightsMap[target]);
				if(ts.length) {
					var oldKey:String=ts[0] as String;
					t=_hilightsMap[target][oldKey];
					delete _hilightsMap[target][oldKey];
				}				
			}
			if(t==null)
			{
				t=new TileHilighter();
				target.add(t);
			}
			t.snapToTile(x,y);
			t.color=tileColor;
			return t;
		}
	}
}