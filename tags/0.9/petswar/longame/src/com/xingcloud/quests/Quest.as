package com.xingcloud.quests
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.Remoting;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.XingCloudEvent;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.items.spec.AwardItemSpec;
	import com.xingcloud.users.actions.Action;
	import com.xingcloud.users.actions.IAction;
	import com.xingcloud.users.actions.QuestAcceptAction;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.charts.chartClasses.DataDescription;

    use namespace xingcloud_internal;
	/**
	 * var quest:Quest;
	 * if(quest.executable) quest.execute();
	 * 典型的XML定义
	 * <Quest id="1342" award="awardId" name="" description="" type="" icon="">
	 *   <Steps>
	 *      <Step action="BuyAction" count="5" itemId="1005"/>
	 *      <Step action="SellAction" count="2" itemId="1003"/>
	 *      <Step action="DestroyAction" count="1" itemId="1006"/>
	 *   </Steps>
	 * </Quest>
	 * todo,Quest和后台的交流结果，尤其是失败的时候，是否应该统一交给QuestManager来管理？
	 * QuestManager要成为所有Quest操作的唯一入口。。。
	 * */
	public class Quest extends Command implements IQuest
	{
		public function Quest()
		{
			super();
		}
		override protected function doExecute():void
		{
			if(!this.executable) throw new Error("This quest is not executable!");
			super.doExecute();
			//本地模式会在本地自动判断任务完成进度，否则根据服务器返回自动判断
			if(Config.localMode){
				this.onAcceptSuccess(null);
			}else{
				var act:QuestAcceptAction=new QuestAcceptAction(this.id,this.onAcceptSuccess,this.onAcceptFail);
				act.execute();
			}
		}
		override protected function notifyError(errorMsg:String):void
		{
			super.notifyError(errorMsg);
			Action.onComplete.remove(checkAction);
		}
		override protected function complete():void
		{
			super.complete();
			Action.onComplete.remove(checkAction);
		}
		/**
		 * 没有完成的steps
		 * */
		xingcloud_internal var stepsToComplete:Array=[];
		public static function parseFromXML(xml:XML):Quest
		{
			var q:Quest=new Quest();
			q._id=xml.@id;
			q._name=xml.@name;
			q._description=xml.@description;
			q._type=xml.@type;
			q._startTime=parseInt(xml.@startTime);
			q._endTime=parseInt(xml.@endTime);
			q._repeatCount=parseInt(xml.@repeatCount);
			q._repeatInterval=parseInt(xml.@repeatInterval);
			q._level=parseInt(xml.@level);
			q._icon=xml.@icon;
			q._prev=xml.@prev;
			q._next=xml.@next;
			q._steps=[];
			
			var act:QuestStep;
			var actionList:XMLList=xml.Steps.children();
			var len:uint=actionList.length();
			for(var i:int=0;i<len;i++){
				act=QuestStep.parseFromXML(actionList[i]);
				q._steps.push(act);
			}
			if(xml.hasOwnProperty("@award")){
				q._awardId=xml.@award;
			}
			q.stepsToComplete=q._steps.concat();
			return q;
		}
		xingcloud_internal function setAsCompleted():void
		{
			this.stepsToComplete.length=0;
			var step:QuestStep;
			for (var i:int=0;i<_steps.length;i++){
				step=_steps[i];
				step.completedCount=step.count;
			}
		}
		protected var _id:String;
		public function get id():String
		{
			return _id;
		}
		protected var _name:String;
		override public function get name():String
		{
			return _name;
		}
		protected var _description:String;
		public function get description():String
		{
			return _description;
		}
		protected var _type:String;
		public function get type():String
		{
			return _type;
		}
		protected var _startTime:uint;
		public function get startTime():uint
		{
			return _startTime;
		}
		protected var _endTime:uint;
		public function get endTime():uint
		{
			return _endTime;
		}
		protected var _repeatCount:int;
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		protected var _repeatInterval:uint;
		public function get repeatInterval():uint
		{
			return _repeatInterval;
		}
		protected var _prev:String;
		public function get prev():String
		{
			return _prev;
		}
		protected var _next:String;
		public function get next():String
		{
			return _next;
		}
		protected var _level:uint=0;
		public function get level():uint
		{
			return _level;
		}
		protected var _icon:String;
		public function get icon():String
		{
			return _icon;
		}
		protected var _iconDisplay:DisplayObject;
		public function get iconDisplay():DisplayObject
		{
			//todo....
			return _iconDisplay;
		}
		protected var _steps:Array=[];
		public function get steps():Array
		{
			return _steps;
		}
		protected var _awardId:String;
		public function get award():AwardItemSpec
		{
			if(_awardId==null) return null;
			return ItemDatabase.getItem(_awardId) as AwardItemSpec;
		}

		public function get executable():Boolean
		{
			//todo
			//起止时间，重复情况，level情况，prev是否完成？
			var canExecute:Boolean=!this.isCompleted;
			return canExecute;
		}
		override public function get isCompleted():Boolean
		{
			return stepsToComplete.length==0;
		}	
		/**
		 * 如果用户产生了一个action，那么更新下此任务的完成度
		 * todo，这里有问题
		 * */
		protected function checkAction(act:IAction,data:Object):void
		{
			var completed:Boolean=true;
			var actOk:Boolean;
			var acts:Array=stepsToComplete.concat();
			for each(var qact:QuestStep in acts){
				actOk=qact.checkAction(act,data);
				if(actOk) {
					trace("******行为完成一个："+act.name);
					var i:int=stepsToComplete.indexOf(qact);
					if(i>-1) stepsToComplete.splice(i,1);
				}
				
				if(!actOk) completed=false;
			}
			if(completed){
				trace("******任务完成一个："+this.name);
//				var amf:Remoting=new Remoting(Config.QUEST_SUBMMIT_SERVICE,{user_uid:XingCloud.userprofile.uid,quest_uid:this.id});
//				amf.onSuccess=this.onSubmmitSuccess;
//				amf.onFail=this.onSubmmitFail;
//				amf.execute();	
				//奖励
				if(_awardId){
//					_award.submmit(new QuestChangeAction(this.id,"complete"),true);
				}
				//自动激活？
//				if(this.next){
//					var quest:Quest=QuestManager.getQuest(next);
//					if(quest&&quest.executable) quest.execute();
//				}
			}
		}
		private var accepted:Boolean=false;
		private function onAcceptSuccess(data:Object):void
		{
			accepted=true;
			if(Config.localMode) Action.onComplete.add(checkAction);
			trace("任务接受成功: "+this.name);
		}
		private function onAcceptFail(error:Object):void
		{
			this.accepted=false;
			trace("任务接受失败: "+error.message);
		}
		private function onSubmmitSuccess(data:Object):void
		{
			trace("任务完成提交成功！");
			this.complete();
		}
		private function onSubmmitFail(error:String):void
		{
			trace("任务完成提交失败: "+error);
		}
		
	}
}