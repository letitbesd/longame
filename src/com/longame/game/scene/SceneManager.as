package com.longame.game.scene
{
	import com.longame.commands.net.AssetsLoader;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.managers.AssetsLibrary;
	import com.longame.model.EntityItemSpec;
	import com.longame.model.consts.Registration;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.scene.transformation.DefaultIsometricTransformation;
	import com.longame.game.scene.transformation.ISpaceTransformation;
	import com.longame.game.scene.transformation.OrthogonalTransformation;
	import com.longame.utils.ArrayUtil;
	import com.longame.utils.DisplayObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 场景管理器，包括坐标转换，tile定位等
	 */
	public class SceneManager
	{
		public static const D2:String="2d";
		public static const D25:String="2.5d";
		/////////////////////////////////////////////////////////////////////
		//	TRANSFORMATION OBJECT
		/////////////////////////////////////////////////////////////////////
		protected static var _tileSize:int=40;
		protected static var _type:String;
		protected static var _useTileMap:Boolean;
		
		static public function init(tile_size:int,scene_type:String,useTileMap:Boolean):void
		{
			_tileSize=tile_size;
			_type=scene_type;
			switch(_type){
				case SceneManager.D25:
					_transformation=new DefaultIsometricTransformation();
					break;
				case  SceneManager.D2:
					_transformation=new OrthogonalTransformation();
					break;
				default:
					throw new Error("There is no Scene type: "+_type+"!");
			}
			_useTileMap=useTileMap;
		}
		public static function get sceneType():String
		{
			return _type;
		}
		public static function get tileSize():int
		{
			return _tileSize;
		}
		public static function get useTileMap():Boolean
		{
			return _useTileMap;
		}
		static private var _transformation:ISpaceTransformation = new DefaultIsometricTransformation();
		
		static public function get transformation ():ISpaceTransformation
		{
			return _transformation;
		}
		
		/**
		 * @private
		 */
		static public function set transformation (value:ISpaceTransformation):void
		{
			if (value)
				_transformation = value;
			
			else
				_transformation = new DefaultIsometricTransformation();
		}
		
		/////////////////////////////////////////////////////////////////////
		//	TRANSFORMATION METHODS
		/////////////////////////////////////////////////////////////////////
		
		/**
		 * Converts a given pt in cartesian coordinates to 3D isometric space.
		 * 
		 * @param screenPt The pt in cartesian coordinates.
		 * @param createNew Flag indicating whether to affect the provided pt or to return a converted copy.
		 * @return pt A pt in 3D isometric space.
		 */
		static public function screenToScene (screenPt:Vector3D, createNew:Boolean = false):Vector3D
		{
			var isoPt:Vector3D = _transformation.screenToSpace(screenPt);
			
			if (createNew)
				return isoPt;
			
			else
			{
				screenPt.x = isoPt.x;
				screenPt.y = isoPt.y;
				screenPt.z = isoPt.z;
				
				return screenPt;
			}
		}
		
		/**
		 * Converts a given pt in 3D isometric space to cartesian coordinates.
		 * 
		 * @param isoPt The pt in 3D isometric space.
		 * @param createNew Flag indicating whether to affect the provided pt or to return a converted copy.
		 * @return pt A pt in cartesian coordinates.
		 */
		static public function sceneToScreen (isoPt:Vector3D, createNew:Boolean = false):Vector3D
		{
			var screenPt:Vector3D = _transformation.spaceToScreen(isoPt);
			
			if (createNew)
				return screenPt;
			
			else
			{
				isoPt.x = screenPt.x;
				isoPt.y = screenPt.y;
				isoPt.z = screenPt.z;
				
				return isoPt;
			}
		}
		/**
		 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++计算跟方格有关的各种参数+++++++++++++++++++++++++++++++++++++++++++++++
		 * */
		/**
		 * 获取 iso坐标系下的_x,_y坐标对应的方格索引
		 * tileX表示沿X方向上是第几个方格
		 * tileY表示沿Y方向上是第几个方格
		 * 均从0开始
		 * */
		public static function getTileIndex(_x:Number,_y:Number):Point
		{
			var tileX:int=Math.floor(_x / _tileSize)
			var tileY:int=Math.floor(_y / _tileSize)
			return new Point(tileX,tileY)				
		}
		/**
		 * tileX，tileY对应的方格在ISO中的坐标
		 * @param centerX=false 获取方格本来X坐标（平行四边形的上定点)，否则获取其中心点X
		 * @param centerY=false 获取方格本来Y坐标（平行四边形的上定点)，否则获取其中心点y
		 * */
		public static  function getTilePosition(tileX:int,tileY:int,centerX:Boolean=true,centerY:Boolean=true):Point
		{
			var offsetX:Number=centerX?tileSize*0.5:0
			var offsetY:Number=centerY?tileSize*0.5:0
			return new Point(tileX*tileSize+offsetX, tileY*tileSize+offsetY)
		}
		/**
		 * iso坐标p对应的方格坐标
		 * @param p:iso坐标系下的点p，获取与其最为接近的方格中心点
		 * @param centerX: true,获取tile的中心点X，否则为其原点（平心四边形的上定点）
		 * @param centerY: true,获取tile的中心点Y，否则为其原点（平心四边形的上定点）
		 * */
		public static  function getTiledPosition(p:Point,centerX:Boolean=true,centerY:Boolean=true):Point
		{
			var p1:Point=getTileIndex(p.x,p.y)
			return getTilePosition(p1.x,p1.y,centerX,centerY)
		}
		/**
		 * 方格索引tileX,tileY对应的方格是否在可视的方格范围之内
		 * todo，这个不要鸟
		 * */
//		public static  function isInnerTile(tileX:int,tileY:int):Boolean
//		{
//			return !((tileX<0)||(tileY<0)||(tileX>=sizeX)||(tileY>=sizeY));
//		}	
		/**
		 * p0和p1是否在同一个格子里
		 * */
		public static function isInSameTile(p0:Point,p1:Point):Boolean
		{
			return getTileIndex(p0.x,p0.y)==getTileIndex(p1.x,p1.y);
		}
		/**
		 * 计算obj的bounds实际所占方格
		 * */
		public static function getTargetTiles(obj:IDisplayEntity):Vector.<Point>
		{
			return (obj is IDisplayGroup)?getGroupTiles(obj as IDisplayGroup):getEntityTiles(obj);
		}
		private static function getGroupTiles(obj:IDisplayGroup):Vector.<Point>
		{
			tempGroup=obj;
			obj.foreachDisplay(calChildTiles,true,true);
//			resultTiles=null;
			tempTiles=null;
			tempGroup=null;
			return resultTiles;
		}
		private static var tempTiles:Vector.<Point>=new Vector.<Point>();
		private static var resultTiles:Vector.<Point>=new Vector.<Point>();
		private static var tempGroup:IDisplayGroup;
		private static function calChildTiles(child:IDisplayEntity):void
		{
//			if(!child.includeInLayout) return;
			if(!child.includeInBounds) return;
			tempTiles=getEntityTiles(child);
			var t0:Vector3D;
			for each(var t:Point in tempTiles){
				if(child.owner) t=(child.owner as IDisplayEntity).parent.localToGlobal(new Vector3D(t.x,t.y),true);
				if(tempGroup.owner) {
					t0=(tempGroup.owner as IDisplayEntity).globalToLocal(new Point(t.x,t.y),true);
					t.x=t0.x;
					t.y=t0.y;
				}
				resultTiles.push(t);
			}
		}
		private static function getEntityTiles(obj:IDisplayEntity):Vector.<Point>
		{
			var p:Point=SceneManager.getTileIndex(obj.x,obj.y);
			var w:uint=SceneManager.getTiledLength(obj.width);
			var h:uint=SceneManager.getTiledLength(obj.length);
			if(obj.registration==Registration.CENTER) return getTiles(p.x,p.y,w,h);//
			var tiles:Vector.<Point>=new Vector.<Point>();
			for (var i:int=0;i<w;i++){
				for (var j:int=0;j<h;j++){
					tiles.push(new Point(p.x+i,p.y+j));
				}
			}
			return tiles;
		}
		/**
		 * 计算像素单位size对应的单元格数量，最少算1个
		 * @param size:像素长度
		 * @param min:最小单元格数
		 * */
		public static function getTiledLength(size:Number,min:int=1):int
		{
			return Math.max(Math.round(size/tileSize),min);
		}
		/**
		 * 以tileX,tileY方格为中心，xy方向上方格数分别为width,length的方格列表
		 * @param tileX:x方向方格索引
		 * @param tileY:y方向方格索引
		 * @param width:x方向上方格数量
		 * @param length:y方向方格数量
		 * */
		public static function getTiles(tileX:int,tileY:int,width:int,length:int):Vector.<Point>
		{
			var tile:Point=new Point();
			var tiles:Vector.<Point>=new Vector.<Point>();
			var centerTile:Point=new Point(tileX,tileY)
			tiles[0]=centerTile
			var d:int=-1
			var ind:int=1;
			var t:Point;
			var xt:int=width;
			while(xt>1){
				t=new Point(centerTile.x+ind*d,centerTile.y);
				tiles.push(t);
				d=-d
				if(d<0) ind++
					xt--;
			}
			var newxt:Vector.<Point>=ArrayUtil.clonePointArray(tiles) as Vector.<Point>;
			for each(var tp:Point in newxt){
				d=-1;
				ind=1;
				var yt:int=length;
				while(yt>1){
					t=new Point(tp.x,tp.y+ind*d)
					tiles.push(t);
					d=-d
					if(d<0) ind++
						yt--;				
				}					
			}	
			return tiles;
		}
		/**
		 * 在parent包含child的情况下，计算child的注册点tile在parent的坐标系下的偏移，通常parent不是child的直接父容器，而且child往上的容器有一些位置不在0,0点
		 * */
		public static function getTileOffsetBetween(child:IDisplayEntity,parent:IDisplayGroup):Point
		{
			var p0:Point=new Point();
			var pa:IDisplayGroup=child.parent;
			while(pa){
				if(pa==parent) break;
				if(pa is IScene){
					throw new Error(child +" is not the child of "+parent);
					break;
				}
				p0.x+=pa.tileBounds.x;
				p0.y+=pa.tileBounds.y;
				pa=pa.parent;
			}
			return p0;
		}
		/**
		 * 在parent包含child的情况下，计算child的注册点在parent的坐标系下的偏移，通常parent不是child的直接父容器，而且child往上的容器有一些位置不在0,0点
		 * */
		public static function getOffsetBetween(child:IDisplayEntity,parent:IDisplayGroup):Vector3D
		{
			var p0:Vector3D=new Vector3D();
			var pa:IDisplayGroup=child.parent;
			while(pa){
				if(pa==parent) break;
				if(pa is IScene){
					throw new Error(child +" is not the child of "+parent);
					break;
				}
				p0.x+=pa.x;
				p0.y+=pa.y;
				p0.z+=pa.z;
				pa=pa.parent;
			}
			return p0;
		}
	}
}