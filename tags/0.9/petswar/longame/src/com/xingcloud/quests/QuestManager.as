package  com.xingcloud.quests
{
	import com.longame.commands.base.Command;
	import com.longame.core.long_internal;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.users.actions.Action;
	import com.xingcloud.users.actions.ActionResult;
	
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	use namespace xingcloud_internal;

	public class QuestManager
	{
		/**
		 * 当某个任务完成后分发
		 * String:任务id
		 * */
		public static var onQuestCompleted:Signal=new Signal(String);
		
		protected static var _groups:Dictionary;
		
		public function QuestManager()
		{
		}
		/***
		 * 添加一个XML定义的任务列表，允许多个xml文件，但要保持各个节点的id唯一，典型的XML定义如下
		 * <Quests>
			 * <Group id="2001"/>
			 *    <Quest id="1342" icon="" level="" prev="" next="">
			 *       <Steps>
			 *          <Step action="BuyAction" count="5" itemId="1005"/>
			 *          <Step action="SellAction" count="2" itemId="1003"/>
			 *          <Step action="DestroyAction" count="1" itemId="1006"/>
			 *       </Steps>
			 *       <Award exp="50" coins="200" itemType="CropItem" itemCount="5"/>
			 *    </Quest>
			 *    <Quest id="1343">
			 *       <Steps>
			 *          <Step action="BuyAction" count="5" itemId="1005"/>
			 *          <Step action="SellAction" count="2" itemId="1003"/>
			 *          <Step action="DestroyAction" count="1" itemId="1006"/>
			 *       </Steps>
			 *       <Award exp="50" coins="200" itemType="CropItem" itemId="12345" itemCount="5"/>
			 *    </Quest>
			 * 	  <Group id="2002"/>
			 *       <Quest id="1344">
			 *        <Steps>
			 *          <Step action="BuyAction" count="5" itemId="1005"/>
			 *          <Step action="SellAction" count="2" itemId="1003"/>
			 *          <Step action="DestroyAction" count="1" itemId="1006"/>
			 *        </Steps>
			 *       <Award exp="50" coins="200" itemType="CropItem" itemCount="5"/>
			 *       </Quest>
			 *     </Group>
			 * </Group>
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
		 *  </Quests>
		 * */
		public static function addXmlDefinition(xml:XML):void
		{
			if(_groups==null) _groups=new Dictionary();
			var children:XMLList=xml.children();
			var group:QuestGroup;
			for each(var childXml:XML in children){
				group=QuestGroup.parseFromXML(childXml);
				_groups[group.id]=group;
			}
		}
		private static var inited:Boolean;
		private static function init():void
		{
			if(inited) return;
			if(XingCloud.userprofile&&XingCloud.userprofile.quests){
				inited=true;
				QuestManager.handleDataFromServer(XingCloud.userprofile.quests);
				Action.onQuestStep.add(onQuestStep);
			}
		}
		/**
		 * 从服务器端返回的任务完成数据
		 * @questData:
		 * 	 =>id:任务id
		 *   =>step:当前完成的步骤编号
		 *   =>isCompleted:整个任务是否完成
		 * @award:
		 *   =>award:任务奖励
		 *     =>exp:23
		 *     =>coins:100
		 *     =>任何userProfile具有的某个属性值......
		 *     =>newItem: 奖励某一个ownedItem的完整数据
		 * */
		private static function onQuestStep(questData:Object):void
		{
			var quest:Quest=getQuest(questData.id);
			if(quest){
				var step:QuestStep=quest.steps[questData.step];
				step.completedCount+=1;
				if(questData.isCompleted){
					quest.setAsCompleted();
//					var award:Object=questData.award;
//					if(award){
//						//如果奖励有新物品，则添加之
//						if(award.newItem){
//							//添加新物品
//							XingCloud.userprofile.addItemFromObject(award.newItem);
//							//可能需要显示一下，事件??
//							delete award.newItem;
//						}
//						//改变属性值
//						for(var prop:String in award){
//							XingCloud.userprofile[prop]+=Number(award[prop]);
//						}
//					}
					onQuestCompleted.dispatch(quest.id);
				}
			}
		}
		/**
		 * 获取某个id的quest
		 * */
		public static function getQuest(id:String):Quest
		{
			init();	
			var quest:Quest;
			for each(var g:QuestGroup in _groups){
				quest=g.getQuest(id,true);
				if(quest){
					return quest;
				}
			}
			return quest;
		}
		public static function ifQuestCompleted(id:String):Boolean
		{
			init();
			var quest:Quest;
			for each(var g:QuestGroup in _groups){
				quest=g.getQuest(id,true);
				if(quest){
					return quest.isCompleted;
				}
			}
			return true;
		}
		public static function getGroup(id:String,deepSearch:Boolean=false):QuestGroup
		{
			init();	
			var group:QuestGroup=_groups[id];
			if(group) return group;
			for each(var g:QuestGroup in _groups){
				group=g.getGroup(id,true);
				if(group) return group;
			}
			return group;
		}
		public  static function get groups():Dictionary
		{
			return _groups;
		}
		private static function handleDataFromServer(data:Object):void
		{
			for(var qid:String in data){
				var quest:Quest=QuestManager.getQuest(qid);
				if(quest==null) continue;
				var questData:Object=data[qid];
				var steps:Array=questData.steps;
				var stepCount:int=steps.length;
				if(stepCount==0) continue;
				quest.stepsToComplete=[];
				var step:QuestStep;
				for (var i:int=0;i<stepCount;i++){
					step=quest.steps[i];
					step.completedCount=steps[i];
					if(!step.isCompleted) quest.stepsToComplete.push(step);
				}
			}
		}
	}
}