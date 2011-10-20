package com.xingcloud.tutorial
{
	import com.longame.commands.base.SerialCommand;
	import com.longame.commands.net.Remoting;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.ItemDatabase;
	import com.xingcloud.items.spec.AwardItemSpec;
	import com.xingcloud.tutorial.actions.TutorialAction;
	import com.xingcloud.tutorial.steps.TutorialStep;
	
	import flash.display.DisplayObject;
	
	use namespace xingcloud_internal;
	
	[DefaultProperty("steps")]
	final public class Tutorial extends SerialCommand
	{
		protected var _id:String;	
		protected var _name:String;
		protected var _description:String="";
		protected  var _target:DisplayObject;
		protected var _awardId:String;
		
		protected var _steps:Array=[];
		/**
		 * 属于哪个TutorialGroup，初始化时通过setOwner()自动赋值
		 * */
		protected var _owner:TutorialGroup;
		private var currentStep:int=-1;
		
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
//			tu._target=xml.@target;
			if(!xml.hasOwnProperty("Steps")) throw new Error("Tutorial shoud has 'Steps' node!");
			var stepList:XMLList=xml.Steps[0].children();
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
				step.setIndex(i+1);
				step.setOwner(tu);
				tu._steps.push(step);
			}
			if(xml.hasOwnProperty("@award")){
				tu._awardId=xml.@award;
			}
			return tu;
		}
		override protected function enqueueCommands():void
		{
			if(this.hasCompleted) return;
			for(var i:int=0;i<steps.length;i++){
				var step:TutorialStep=steps[i];
//				step.setIndex(i+1);
//				step.setOwner(this);
				this.enqueue(step,step.name);
			}
		}
		override protected function doExecute():void
		{
			if(TutorialManager.testMode){
				currentStep=0;
				super.doExecute();
				return;
			}
			//先从服务器拿向导数据
			if(currentStep<0){
				var amf:Remoting=new Remoting(Config.TUTORIAL_GET_SERVICE,{user_uid:XingCloud.userprofile.uid,tutorial:this.name});
				amf.onFail=this.onGotTutorialFailed;
				amf.onSuccess=this.onGotTutorialSuccess;
				amf.execute();		
			}else{
				super.doExecute();
			}
		}
		override protected function complete():void
		{
			steps.splice(0,steps.length);
			//向后台提交
			if((!hasCompleted)&&(!TutorialManager.testMode)){
				var amf:Remoting=new Remoting(Config.TUTORIAL_COMPLETE_SERVICE,{user_uid:XingCloud.userprofile.uid,name:this.name});
				amf.execute();	
			}
			super.complete();
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
		public function set target(value:DisplayObject):void
		{
			_target=value;
		}
		/**
		 *跟向导系统相联系的界面或场景，必须
		 */
		public function get target():DisplayObject
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
		xingcloud_internal function setOwner(owner:TutorialGroup):void
		{
			_owner=owner;
		}
		private function onGotTutorialFailed(e:String):void
		{
			currentStep=0;
			this.doExecute();
		}
		private function onGotTutorialSuccess(data:Object):void
		{
			var result:Object=data.data;
			//从某一步开始执行时不可行的
			if(result==null){
				currentStep=0;
			}else{
				//读取存储了的开始步骤
                currentStep=result.index;
			}
			this.doExecute();
		}
		public function get hasCompleted():Boolean
		{
			return currentStep>_steps.length-1;
		}
	}
}