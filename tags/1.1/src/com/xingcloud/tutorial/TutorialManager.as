package com.xingcloud.tutorial
{
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.users.AbstractUserProfile;
	import com.xingcloud.tutorial.steps.AutoPlayStep;
	import com.xingcloud.tutorial.steps.ClickTargetStep;
	import com.xingcloud.tutorial.steps.DragTargetStep;
	import com.xingcloud.tutorial.steps.KeyPressStep;
	import com.xingcloud.tutorial.steps.SignalStep;
	import com.xingcloud.tutorial.tips.Highlight;
	import com.xingcloud.tutorial.tips.InfoTip;
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	use namespace xingcloud_internal;
    /**
	 * <?xml version="1.0" encode="utf-8"?>
		<TutorialDefine packages="package1,package2">
		   <Group id="group1" name="向导组1" description="这是一组向导，它们可能具有相同的UI对象" award="awardId">
			 <Tutorial id="tutorial1" name="向导1" description="这是向导1" award="awardId">
				<ButtonClickStep name="第一步" description="购买一个种子" target="buyButton"  award="awardId">
				  <Highlight target="buyButton"/>
				  <InfoTip direction="1" emphasize="true"/>
				</ButtonClickStep>
				<ButtonClickStep name="第二步" description="将买的种子播种" target="sowButton"  award="awardId">
				  <Highlight target="sowButton"/>
				  <InfoTip direction="1" emphasize="true"/>
				</ButtonClickStep>
				<ButtonClickStep  name="第三步" description="给它浇水5次，就会长大" target="wateringButton"  award="awardId">
				  <Highlight target="wateringButton"/>
				  <InfoTip direction="1" emphasize="true"/>
				</ButtonClickStep>
			 </Tutorial>
			 <Tutorial id="tutorial2" name="向导2" description="这是向导2"  award="awardId">
				<AutoPlayStep stayTime="3" name="第一步" description="草莓成熟了，你可以收获了" target="reapButton"/>
				  <Highlight/>
				  <InfoTip direction="1" emphasize="true"/>
				</AutoPlayStep>
				<ButtonClickStep name="第二步" description="将获得的草莓卖掉，你就可以赚钱了" target="sellButton">
				  <Highlight target="sellButton"/>
				  <InfoTip direction="1" emphasize="true"/>
				</ButtonClickStep>
			 </Tutorial>
		   </Group>
		</TutorialDefine>
	 * 
	 * */
	public class TutorialManager
	{
		AutoPlayStep
		ClickTargetStep
		DragTargetStep
		KeyPressStep
		SignalStep
		InfoTip
		Highlight
		/**
		 * 是否向服务器发送数据，否则存本地
		 * */
//		public static var localMode:Boolean=false;
		
		protected static var _groups:Dictionary;
		protected static var _packages:Array=["com.xingcloud.tutorial.steps","com.xingcloud.tutorial.tips"];
		
		public function TutorialManager()
		{
			
		}
		/**
		 * 从一个XML定义来添加一组tutorial，目前不支持group的多级嵌套，没有必要
		 * */
		public static function addXmlDefinition(xml:XML):void
		{
			if(_groups==null) _groups=new Dictionary();
			if(xml.hasOwnProperty("@packages")) parsePackages((xml.@packages).toString());
			var children:XMLList=xml.children();
			var group:TutorialGroup;
			for each(var childXml:XML in children){
				group=TutorialGroup.parseFromXML(childXml);
				_groups[group.id]=group;
			}
		}
		/**
		 * 从AbstractUserProfile.tutorials数据来初始化，看哪些向导已经完成了
		 * =>data
				  =>id
				     =>index=2            //完成了第几步
				  =>id1
		 * */
		xingcloud_internal static function init(data:*):void
		{
			if(data==null) return;
			var tu:Tutorial;
			for(var id:String in data){
				tu=getTutorial(id);
				if(tu){
					tu.currentStep=parseInt(data[id].index);
				}
			}
		}
//		public static function abortAll():void
//		{
//			for each(var tu:Tutorial in tutorialsInRunning){
//				tu.onComplete.remove(onTutorialCompleted);
//				tu.abort();
//			}
//			tutorialsInRunning.length=0;
//		}
//		private static var tutorialsInRunning:Vector.<Tutorial>=new Vector.<Tutorial>();
		public static function startTutorial(id:String,target:*):Tutorial
		{
			var tu:Tutorial=getTutorial(id);
			if(tu&&!tu.isCompleted&& tu.paused) {
//				tutorialsInRunning.push(tu);
//				tu.onComplete.add(onTutorialCompleted);
				tu.target=target;
				tu.execute();
			}
			return tu;
		}
//		private static function onTutorialCompleted(tu:Tutorial):void
//		{
//			var i:int=tutorialsInRunning.indexOf(tu);
//			if(i>-1){
//				tutorialsInRunning.splice(i,1);
//			}
//			tu.onComplete.remove(onTutorialCompleted);
//		}
//		public static function endTutorial(id:String):Tutorial
//		{
//			var tu:Tutorial=getTutorial(id,null);
//			if(tu) tu.abort();
//			return tu;
//		}
		private static function getTutorial(id:String):Tutorial
		{
			var tu:Tutorial;
			for each(var g:TutorialGroup in _groups){
				tu=g.getTutorial(id);
				if(tu) {
//					tu.target=target;
					return tu;
				}
			}
			return null;
		}
//		public static function getGroup(id:String,target:DisplayObject):TutorialGroup
//		{
//			var group:TutorialGroup=_groups[id];
//			if(group) group.target=target;
//			return group;
//		}
		public static function get packages():Array
		{
			return _packages;
		}
		public static function getClass(shorClassName:String):Class
		{
			var fullClassName:String;
			for each(var pak:String in _packages){
				fullClassName=pak+"."+shorClassName;
				if(ApplicationDomain.currentDomain.hasDefinition(fullClassName)){
					return ApplicationDomain.currentDomain.getDefinition(fullClassName) as Class;
				}
			}
			return null;
		}
		public  static function get groups():Dictionary
		{
			return _groups;
		}
		private static function parsePackages(value:String):void
		{
			var paks:Array=value.split(",");
			_packages.concat(paks);
		}
	}
}