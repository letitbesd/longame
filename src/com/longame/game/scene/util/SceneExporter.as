package com.longame.game.scene.util
{
	import com.longame.core.long_internal;
	import com.longame.game.core.IComponent;
	import com.longame.game.entity.AnimatorEntity;
	import com.longame.game.entity.DisplayEntity;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.SpriteEntity;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.scene.IScene;
	import com.longame.game.scene.BaseScene;
	import com.longame.game.scene.SceneManager;
	import com.longame.model.consts.Registration;
	import com.longame.utils.DictionaryUtil;
	
	import flash.utils.Dictionary;

	use namespace long_internal;
	
	public class SceneExporter
	{
		public function SceneExporter()
		{
			
		}
		public static function fromScene(scene:BaseScene):XML
		{
			var xml:XML=<Scene type={SceneManager.sceneType} tileSize={SceneManager.tileSize}></Scene>;
			fromDisplayGroup(scene,xml);
		    delete xml.@position;
			return xml;
		}
		public static function fromDisplayGroup(g:DisplayGroup,xml:XML=null):XML
		{
			if(xml==null) {
				xml=<Group></Group>;
			}
			if(g.useCustomId) xml.@id=g.id;
			if(g.autoLayout) xml.@autoLayout=true;
			xml.@position=g.x+","+g.y+","+g.z;
			var child:DisplayEntity;
			var childXml:XML;
			for each(child in g.allChildren){
				switch(child.className){
					case "DisplayGroup":
						childXml=fromDisplayGroup(child as DisplayGroup);
						childXml.@depth=child.depth;
						break;
					case "DisplayEntity":
						childXml=fromDisplayEntity(child);
						break;
					case "SpriteEntity":
						childXml=fromSpriteEntity(child as SpriteEntity);
						break;
					case "AnimatorEntity":
						childXml=fromAnimatorEntity(child as AnimatorEntity);
						break;
					default:
						childXml=null;
						break;
				}
				if(childXml){
					//todo
//					if(state!="") childXml.@state=state;
					xml.appendChild(childXml);
				}
			}
			return xml;
		}
		public static function fromDisplayEntity(d:DisplayEntity,xml:XML=null):XML
		{
			if(xml==null) xml=<Entity/>;
			if(d.useCustomId) xml.@id=d.id;
			xml.@position=d.x+","+d.y+","+d.z;
			xml.@size=d.width+","+d.length+","+d.height;
			if(d.rotation!=0) xml.@rotation=d.rotation;
			if((d.scaleX!=1)||(d.scaleY!=1))   xml.@scale=d.scaleX+","+d.scaleY;
			if(!d.walkable)   xml.@walkable="false";
			if(d.registration!=Registration.TOP_LEFT) xml.@registration="center";
			if(d.includeInLayout==false) xml.@inLayout="false";
			if(d.includeInBounds==false) xml.@inBounds="false";
			return xml;
		}
		public static function fromSpriteEntity(s:SpriteEntity,xml:XML=null):XML
		{
			if(xml==null){
				xml=<Entity/>;
			}
			if(s.itemSpec)　xml.@itemId=s.itemSpec.id;
			else if(s.source) xml.@source=s.source;
			if(s.direction!=0) xml.@direction=s.direction;
			fromDisplayEntity(s,xml);
			//SpriteEntity的尺寸由itemSpec定义
			delete xml.@size;
			return xml;
		}
		public static function fromAnimatorEntity(a:AnimatorEntity,xml:XML=null):XML
		{
			if(xml==null) xml=<Entity/>;
			fromSpriteEntity(a,xml);
			return xml;
		}
	}
}