package com.xingcloud.tutorial
{
	import com.longame.commands.base.SerialCommand;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.AwardItemSpec;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

    use namespace xingcloud_internal;
	/**
	 * Tutorial集合，可以包含很多的Tutorial
	 * <Group  id="" name="" description="" award="">
	 *       <Tutorial>
	 *      </Tutorial>
	 * 	    <Tutorial>
	 *      </Tutorial>
	 * </Group>
	 * */
	[DefaultProperty("tutorials")]
	public class TutorialGroup extends SerialCommand
	{
		protected var _id:String;	
		protected var _name:String;
		protected var _description:String="";
		protected var _tutorialsMap:Dictionary=new Dictionary();
		
		protected var _awardId:String;
		
		/**
		 *跟向导系统相联系的界面或场景
		 */
		public  var target:*;

		public function TutorialGroup()
		{
			super();
		}
		public static function parseFromXML(xml:XML):TutorialGroup
		{
			var tg:TutorialGroup=new TutorialGroup();
			tg._id=xml.@id;
			tg._name=xml.@name;
			tg._description=xml.@description;
			//todo how to do
//			tg._target=xml.@target;
//			if(!xml.hasOwnProperty("Tutorials")) throw new Error("TutorialGroup shoud has 'Tutorials' node!");
//			var tuList:XMLList=xml.Tutorials[0].children();
			var tuList:XMLList=xml.Tutorial;
			var len:uint=tuList.length();
			var tu:Tutorial;
			for(var i:int=0;i<len;i++){
				tu=Tutorial.parseFromXML(tuList[i]);
				tu._owner=tg;
				tg.enqueue(tu,tu.name);
				tg._tutorialsMap[tu.id]=tu;
			}
			
			if(xml.hasOwnProperty("@award")){
				tg._awardId=xml.@award;
			}
			return tg;
		}
		public function getTutorial(id:String):Tutorial
		{
			return _tutorialsMap[id];
		}
		/**
		 * 唯一的标志
		 * */
		public function get id():String
		{
			return _id;
		}
		override public function get name():String
		{
			return _name;
		}
		/**
		 * 描述，可能跟多语言有关系，redmine上的管理员可以看到这个描述，知道这步是干什么的
		 * */
		public function get description():String
		{
			return _description;
		}
		public function get award():AwardItemSpec
		{
			if(_awardId==null) return null;
			return ItemDatabase.getItem(_awardId) as AwardItemSpec;
		}
		override protected function complete():void
		{
			super.complete();
			target=null;
		}
	}
}