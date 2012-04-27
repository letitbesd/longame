package com.xingcloud.tutorial
{
	import com.longame.commands.base.SerialCommand;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.AwardItemSpec;
	import com.xingcloud.net.connector.AMFConnector;
	import com.xingcloud.net.connector.Connector;
	import com.xingcloud.net.connector.MessageResult;
	import com.xingcloud.tasks.TaskEvent;
	import com.xingcloud.tutorial.actions.TutorialAction;
	import com.xingcloud.tutorial.steps.TutorialStep;
	
	import flash.display.DisplayObject;
	
	use namespace xingcloud_internal;
	/**
	 * <Tutorial   id="" name="" description="" award="">
	 * 				<Step>
	 *              </Step>
	 * </Tutorial>
	 * */
	[DefaultProperty("steps")]
	final public class Tutorial extends SerialCommand
	{
		protected var _id:String;	
		protected var _name:String;
		protected var _description:String="";
		protected  var _target:*;
		protected var _awardId:String;
		
		protected var _steps:Array=[];
		/**
		 * 属于哪个TutorialGroup，初始化时通过setOwner()自动赋值
		 * */
		xingcloud_internal var _owner:TutorialGroup;
		xingcloud_internal var currentStep:int=0;
		
		public function Tutorial()
		{
			super();
		}
		public static function parseFromXML(xml:XML):Tutorial
		{
			var tu:Tutorial=new Tutorial();
			tu._id=xml.@id;
			tu._name=xml.@name;
			tu._description=xml.@description;
			var stepList:XMLList=xml.children();
			var len:uint=stepList.length();
			var stepXml:XML;
			var step:TutorialStep;
			var stepCls:Class;
			for(var i:int=0;i<len;i++){
				stepXml=stepList[i];
				stepCls=TutorialManager.getClass(stepXml.localName().toString());
				if(stepCls==null) throw new Error("The class : "+stepXml.localName().toString()+" does not exist!");
				step=new stepCls() as TutorialStep;
				step.parseFromXML(stepXml);
				step._index=i+1;
				step._owner=tu;
				tu._steps.push(step);
			}
			if(xml.hasOwnProperty("@award")){
				tu._awardId=xml.@award;
			}
			return tu;
		}
		override protected function enqueueCommands():void
		{
			if(this.isCompleted) return;
			//从currentStep开始，可能会有问题,所以不太可能从某一步开始执行向导
			for(var i:int=0;i<steps.length;i++){
				var step:TutorialStep=steps[i];
				this.enqueue(step,step.name);
			}
		}
		override protected function doExecute():void
		{
			Engine.inTutorial=true;
			super.doExecute();
		}
		override protected function complete():void
		{
			steps.splice(0,steps.length);
			Engine.inTutorial=false;
			super.complete();
			_target=null;
		}
		override public function abort():void
		{
			super.abort();
			_target=null;
		}
		/**
		 * name是唯一的标志，之所以不用id，是因为和mxml的id标签发生冲突
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
		public function set target(value:*):void
		{
			_target=value;
		}
		/**
		 *跟向导系统相联系的界面或场景，必须
		 */
		public function get target():*
		{
			if(_target) return _target;
			if(_owner&&_owner.target) return _owner.target;
			return null;
		}
		public function get steps():Array
		{
			return _steps;
		}
		public function get award():AwardItemSpec
		{
			if(_awardId==null) return null;
			return ItemDatabase.getItem(_awardId) as AwardItemSpec;
		}
		public function get owner():TutorialGroup
		{
			return _owner;
		}
//		xingcloud_internal function setOwner(owner:TutorialGroup):void
//		{
//			_owner=owner;
//		}
//		private function onGotTutorialFailed(event:TaskEvent):void
//		{
//			currentStep=0;
//			this.doExecute();
//		}
//		private function onGotTutorialSuccess(event:TaskEvent):void
//		{
//			var result:Object=(event.task as Connector).data.data;
//			//从某一步开始执行时不可行的
//			if(result==null){
//				currentStep=0;
//			}else{
//				//读取存储了的开始步骤
//                currentStep=result.index;
//			}
//			this.doExecute();
//		}
		override public function get isCompleted():Boolean
		{
			return _isCompleted||(currentStep>_steps.length-1);
		}
//		public function get hasCompleted():Boolean
//		{
//			return currentStep>_steps.length-1;
//		}
	}
}