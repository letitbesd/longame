package com.xingcloud.quests
{
	import flash.utils.Dictionary;

	/**
	 * QuestGroup定义类似于ItemGroup，包含一组Quest
	 * 它是动态不可继承类，在xml里定义时，可以使用Quest的任何可定义属性，如果子Quest没有定义该属性，则将被覆盖。
	 * 典型的XML定义，grop允许嵌套
	 * <Group id="2003"/>
	 *     <Quest id="1345">
	 *         <Steps>
	 *            <Step action="BuyAction" count="5" itemId="1005"/>
	 *            <Step action="SellAction" count="2" itemId="1003"/>
	 *            <Step action="DestroyAction" count="1" itemId="1006"/>
	 *         </Steps>
	 *       <Award exp="50" coins="200" itemType="CropItem" itemCount="5"/>
	 *     </Quest>
	 * </Group>
	 * */
	dynamic final public class QuestGroup
	{
		protected var _id:String;
		protected var _name:String;
		protected var _description:String;
		protected var _type:String;
		
		protected var _quests:Dictionary;
		protected var _groups:Dictionary;
		
		public function QuestGroup()
		{
		}
		public static function parseFromXML(xml:XML):QuestGroup
		{
			var g:QuestGroup=new QuestGroup();
			g._id=xml.@id;
			g._name=xml.@name;
			g._description=xml.@description;
			g._type=xml.@type;
			g._quests=new Dictionary();
			g._groups=new Dictionary();
			
			var children:XMLList=xml.children();
			var len:uint=children.length();
			var xmlChild:XML;
			var quest:Quest;
			var group:QuestGroup;
			for(var i:int=0;i<len;i++){
				xmlChild=children[i];
				var xmlName:String=xmlChild.localName().toString().toLocaleLowerCase();
				if(xmlName=="quest"){
					quest=Quest.parseFromXML(xmlChild);
					g._quests[quest.id]=quest;
				}else if(xmlName=="group"){
					group=QuestGroup.parseFromXML(xmlChild);
					g._groups[group.id]=group;
				}
			}
			return g;
		}
		public function getQuest(id:String,deepSearch:Boolean=false):Quest
		{
			var quest:Quest=_quests[id];
			if(quest&&(quest.id==id)) return quest;
			if(deepSearch){
				for each(var g:QuestGroup in _groups){
					quest=g.getQuest(id,true);
					if(quest) return quest;
				}
			}
			return quest;
		}
		public function getGroup(id:String,deepSearch:Boolean=false):QuestGroup
		{
			var group:QuestGroup=_groups[id];
			if(group&&(group.id==id)) return group;
			if(deepSearch){
				for each(var g:QuestGroup in _groups){
					group=g.getGroup(id,true);
					if(group) return group;
				}
			}
			return group;
		}
		public function get id():String
		{
			return _id;
		}
		public function get name():String
		{
			return _name;
		}
		public function get description():String
		{
			return _description;
		}
		public function get type():String
		{
			return _type;
		}
		public function get quests():Dictionary
		{
			return _quests;
		}
		public function get groups():Dictionary
		{
			return _groups;
		}
	}
}