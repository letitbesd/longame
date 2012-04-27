package com.longame.model
{
	import com.longame.managers.AssetsLibrary;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.modules.scenes.SceneManager;
	import com.longame.utils.DisplayObjectUtil;
	import com.longame.utils.Reflection;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.ItemSpec;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;

	/**
	 * 场景里每个DisplayEntity的属性定义
	 * */
	public class EntityItemSpec extends ItemSpec
	{
		//type定义对象类型
		public static const DEFAULT_ENTITY_TYPE:Class=SpriteEntity;
		
		public var size:Vector3D=new Vector3D(-1,-1,-1);
		public var scale:Point=new Point(1,1);
		public var stackable:Boolean=false;
		public var walkable:Boolean=false;
		public var registration:String="center";
		/**
		 * 默认动画
		 * */
		public var defaultAnimation:String;
		
		public var renderAsBitmap:Boolean=false;
		/**
		 * 是否自动计算偏移，请在素材不按照要求来做，而又不想手动设定偏移时设为true
		 * */
		public var autoOffset:Boolean=false;
		
		private var _offset:Point;
		
//		public var parallax:Number;
		private var _entityClass:Class;
		
		public function EntityItemSpec()
		{
			super();
			//默认类型
			type="SpriteEntity";
		}
		override public function get icon():String
		{
			if(this._icon) return this._icon;
			var arr:Array= this.source.split(",");
			var ic:String=arr[0];
			var i:int=1;
			while(ic==""||ic=="null"){
				ic=arr[i++];
				if(i>=arr.length) break;
			}
			return ic;
		}
		public function get entityClass():Class
		{
			if(_entityClass) return _entityClass;
			if(type!=null){
				for each(var pack:String in ItemDatabase.packages){
					var clsString:String=pack+"."+type;
					var cls:Class=Reflection.getClassByName(clsString);
					if(cls) {
						_entityClass=cls;
						break;
					}
				}	
			}
			if(_entityClass==null) _entityClass=DEFAULT_ENTITY_TYPE;
			return _entityClass;
		}
		public function createEntity():SpriteEntity
		{
			var cls:Class=this.entityClass;
			if(cls==null) return null;
			var entity:SpriteEntity=new cls() as SpriteEntity;
			entity.itemSpec=this;
			return entity;
		}
		public function get offset():Point
		{
			if((_offset==null)&&this.autoOffset){
				//在解析的时候会读取这个offset来确定数据类型，但这个时候会出错，就返回一个point给它
				//之后要用到offset，又发现offset没有被设定时，就自动计算一下
				if(autoOffset){
					try{
						_offset=calOffsetBySpec(this);
					}catch(e:Error){
						return new Point();
					}	
				}
			}
			if(_offset==null) return new Point();
			return _offset;
		}
		public function set offset(value:Point):void
		{
			_offset=value;
		}
		/**
		 * 根据spec自动计算位置偏移
		 * */
		private function calOffsetBySpec(spec:EntityItemSpec):Point
		{
			var offset:Point=new Point();
			var count:uint=0;
			var clsNames:Array=spec.source.split(",");
			for each(var clsName:String in clsNames){
				var disp:DisplayObject=AssetsLibrary.getInstance(clsName) as DisplayObject;
				if(disp==null) continue;
				var off:Point=calOffset(disp);
				offset.x+=off.x;
				offset.y+=off.y;
				count++;
			}
			offset.x/=count;
			offset.y/=count;
			return offset;
		}
		/**
		 * 自动计算偏移，物体水平中心和最底往上cellSize/2的交叉点
		 * **/
		private  function calOffset(obj:DisplayObject):Point
		{
			var center:Point=DisplayObjectUtil.getCenter(obj);
			//底部向上缩进半个格子
			var b:Number=center.y+obj.height/2;
			return new Point(-center.x,-b+SceneManager.tileSize/2);
		}
	}
}