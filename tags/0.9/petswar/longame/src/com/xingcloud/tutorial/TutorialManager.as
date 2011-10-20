package com.xingcloud.tutorial
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
    /**
	 * <?xml version="1.0" encode="utf-8"?>
		<tuto packages="package1,package2">
		   <group id="group1" name="向导组1" description="这是一组向导，它们可能具有相同的UI对象">
		      <tutorials>
		         <tutorial id="tutorial1" name="向导1" description="这是向导1">
		         	<steps>
		         		<ButtonClickStep name="第一步" description="购买一个种子" target="buyButton">
		         		   <tips>
		         		   	  <Highlight target="buyButton"/>
		         		   	  <InfoBubble target="buyButton"/>
		         		   </tips>
		         		   <award exp="5" coins="10"/>
		         		</ButtonClickStep>
		         		<ButtonClickStep name="第二步" description="将买的种子播种" target="sowButton">
		         		   <tips>
		         		   	  <Highlight target="sowButton"/>
		         		   	  <InfoBubble target="sowButton"/>
		         		   </tips>
		         		   <award exp="5" coins="10"/>
		         		</ButtonClickStep>
		         		<ButtonClickStep  name="第三步" description="给它浇水5次，就会长大" target="wateringButton">
		         		   <tips>
		         		   	  <Highlight target="wateringButton"/>
		         		   	  <InfoBubble target="wateringButton"/>
		         		   </tips>
		         		   <award exp="5" coins="10"/>
		         		</ButtonClickStep>
		         	</steps>
		         	<award exp="20" coins="80"/>
		         </tutorial>
		         <tutorial id="tutorial2" name="向导2" description="这是向导2">
		         	<steps>
		         		<ButtonClickStep name="第一步" description="草莓成熟了，你可以收获了" target="reapButton">
		         		   <tips>
		         		   	  <Highlight target="reapButton"/>
		         		   	  <InfoBubble target="reapButton"/>
		         		   </tips>
		         		   <award exp="5" coins="10"/>
		         		</ButtonClickStep>
		         		<ButtonClickStep name="第二步" description="将获得的草莓卖掉，你就可以赚钱了" target="sellButton">
		         		   <tips>
		         		   	  <Highlight target="sellButton"/>
		         		   	  <InfoBubble target="sellButton"/>
		         		   </tips>
		         		   <award exp="5" coins="10"/>
		         		</ButtonClickStep>
		         	</steps>
		         	<award exp="20" coins="80"/>
		         </tutorial>
		      </tutorials>
		      <award exp="50" coins="100"  itemType="CropItem" itemCount="5"/>
		   </group>
		</tuto>
	 * 
	 * */
	public class TutorialManager
	{
		public static var testMode:Boolean=false;
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
		public static function getTutorial(id:String,target:DisplayObject):Tutorial
		{
			var tu:Tutorial;
			for each(var g:TutorialGroup in _groups){
				tu=g.getTutorial(id);
				if(tu) {
					tu.target=target;
					return tu;
				}
			}
			return null;
		}
		public static function getGroup(id:String,target:DisplayObject):TutorialGroup
		{
			var group:TutorialGroup=_groups[id];
			if(group) group.target=target;
			return group;
		}
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