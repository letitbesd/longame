package com.longame.modules.scenes.utils
{
	import com.longame.model.EntityItemSpec;
	import com.longame.modules.components.DepthDebugger;
	import com.longame.modules.entities.AnimatorEntity;
	import com.longame.modules.entities.Character;
	import com.longame.modules.entities.DisplayEntity;
	import com.longame.modules.entities.SpriteEntity;
	import com.longame.modules.groups.DisplayGroup;
	import com.longame.modules.scenes.GameScene;
	import com.longame.modules.scenes.SceneManager;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.items.spec.ItemSpec;
	import com.longame.utils.StringParser;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	public class SceneParser
	{
		public function SceneParser()
		{
		}
		public static function parseScene(xml:XML):GameScene
		{
			if(xml.children().length()==0) throw new Error("What is this? baby");
			var type:String=SceneManager.D2;
			if(xml.hasOwnProperty("@type"))  type=xml.@type;
			var tile:uint=40;
			if(xml.hasOwnProperty("@tileSize"))  tile=parseInt(xml.@tileSize);
			var layout:Boolean=false;
			if(xml.hasOwnProperty("@autoLayout")) layout=StringParser.toBoolean(xml.@autoLayout);
			
			var scene:GameScene=new GameScene(type,tile,layout);
			parseDisplayGroup(xml,scene);
			return scene;
		}
		public static function parseDisplayGroup(xml:XML,group:DisplayGroup=null):DisplayGroup
		{
			if(group==null){
				var id:String;
				var autoLayout:Boolean=false;
				if(xml.hasOwnProperty("@id")) id=xml.@id;
				if(xml.hasOwnProperty("@autoLayout")) autoLayout=StringParser.toBoolean(xml.@autoLayout);
				group=new DisplayGroup(id,autoLayout);
			}
			//如果Group有一个libId属性，那么直接去SceneLibrary里取出生成
			if(xml.hasOwnProperty("@libId")){
				return SceneLibrary.createDisplayGroup(xml.@libId,group)
			}
			parseDisplayEntity(xml,group);
			var entitiesXml:XMLList=xml.children();
			var len:uint=entitiesXml.length();
			var childXml:XML;
			var childType:String;
			var child:DisplayEntity;
			var childItemSpec:EntityItemSpec;
			for(var i:int=0;i<len;i++){
				childXml=entitiesXml[i];
				//通过itemId的type属性来确定对象类型
				if(childXml.hasOwnProperty("@itemId")) childItemSpec=ItemDatabase.getItem(childXml.@itemId) as EntityItemSpec;
				if(childItemSpec) childType=childItemSpec.type;
				//如果节点是Group那么类型就是DisplayGroup
				else              childType=(String(childXml.localName())=="Group")?"DisplayGroup":"DisplayEntity";
				switch(childType){
					case "DisplayEntity":
						child=parseDisplayEntity(childXml);
						break;
					case "SpriteEntity":
						child=parseSpriteEntity(childXml,null,childItemSpec);
						break;
					case "AnimatorEntity":
						child=parseAnimatorEntity(childXml,null,childItemSpec);
						break;
					case "Character":
						child=parseAnimatorEntity(childXml,new Character(),childItemSpec);
						break;
					case "DisplayGroup":
						child=parseDisplayGroup(childXml);
						break;
				}
				group.add(child,childXml.@state||"");
				//debug
//				if(group.id=="upground"){
//					child.add(new DepthDebugger());
//				}
				//可能的bug点
				if(childXml.hasOwnProperty("@depth")) group.setChildIndex(child,parseInt(childXml.@depth));
				childItemSpec=null;
			}
			return group;
		}
		public static function parseAnimatorEntity(xml:XML,entity:AnimatorEntity=null,itemSpec:EntityItemSpec=null):AnimatorEntity
		{
			if(entity==null){
				var id:String;
				if(xml.hasOwnProperty("@id")) id=xml.@id;
				entity=new AnimatorEntity(id);
			}
			parseSpriteEntity(xml,entity,itemSpec);
			return entity;
		}
		public static function parseSpriteEntity(xml:XML,entity:SpriteEntity=null,itemSpec:EntityItemSpec=null):SpriteEntity
		{
			if(entity==null){
				var id:String;
				if(xml.hasOwnProperty("@id")) id=xml.@id;
				entity=new SpriteEntity(id);
			}
			if(itemSpec) entity.itemSpec=itemSpec;
			else if(xml.hasOwnProperty("@itemId")) entity.itemSpec=ItemDatabase.getItem(xml.@itemId) as EntityItemSpec;
			else if(xml.hasOwnProperty("@source")) entity.source=String(xml.@source);
			if(xml.hasOwnProperty("@direction"))  entity.direction=parseInt(xml.@direction);
			parseDisplayEntity(xml,entity);
			return entity;
		}
		public static function parseDisplayEntity(xml:XML,entity:DisplayEntity=null):DisplayEntity
		{
			if(entity==null){
				var id:String;
				if(xml.hasOwnProperty("@id")) id=xml.@id;
				entity=new DisplayEntity(id);
			}
			var tempArr:Array;
			var tempStr:String;
			//postion
//			if(xml.hasOwnProperty("@tile")) {
//				tempStr=xml.@tile;
//				tempArr=StringParser.toArray(tempStr,true);
//				entity.snapToTile(tempArr[0],tempArr[1]);
//			}
			if(xml.hasOwnProperty("@position")) {
				tempStr=xml.@position;
				tempArr=StringParser.toArray(tempStr,true);
				entity.x=tempArr[0];
				entity.y=tempArr[1];
				entity.z=tempArr[2];
			}
			//size
			if(xml.hasOwnProperty("@size")){
				tempStr=xml.@size;
				tempArr=StringParser.toArray(tempStr,true);
				entity.width=tempArr[0];
				entity.length=tempArr[1];
				entity.height=tempArr[2];
			}
			//rotation
			if(xml.hasOwnProperty("@rotation")) {
				entity.rotation=Number(xml.@rotation);
			}
			//scale
			if(xml.hasOwnProperty("@scale")){
				tempStr=xml.@scale;
				tempArr=StringParser.toArray(tempStr,true);
				entity.scaleX=tempArr[0];
				entity.scaleY=tempArr[1];
			}
			//walkable
			if(xml.hasOwnProperty("@walkable")){
				entity.walkable=StringParser.toBoolean(xml.@walkable);
			}
			//registration
			if(xml.hasOwnProperty("@registration")){
				entity.registration=xml.@registration;
			}
			if(xml.hasOwnProperty("@inLayout")){
				entity.includeInLayout=StringParser.toBoolean(xml.@inLayout);
			}
			if(xml.hasOwnProperty("@inBounds")){
				entity.includeInBounds=StringParser.toBoolean(xml.@inBounds);
			}
			return entity;
		}
	}
}