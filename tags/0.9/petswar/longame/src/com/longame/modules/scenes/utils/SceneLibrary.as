package com.longame.modules.scenes.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import com.longame.modules.groups.DisplayGroup;
	
	import com.longame.commands.net.AbstractLoader;
	import com.longame.resource.ResourceManager;
	import com.longame.resource.Resource;

	internal class SceneLibrary
	{
		private static var onSuccessCall:Function;
		
//		private static var entities:Dictionary=new Dictionary(true);
		private static var _groups:Dictionary=new Dictionary(true);
		
		public function SceneLibrary()
		{
			
		}
		/**
		 * @param libXml: <Libs>
		 *                   <Lib src=/>
		 *                </Libs>
		 * @param type: xml /binary /cbinary,see Resource
		 * */
		
//		public static function preload(libXml:XML,onSuccess:Function=null,onFail:Function=null,type:String="xml"):void
//		{
//			onSuccessCall=onSuccess;
//			var i:int=0;
//			var max:uint=sources.length;
//			for(i=0;i<max;i++){
//				ResourceManager.instance.load(sources[i],onItemLoaded,onFail,type);
//			}
//			ResourceManager.instance.addEventListener(ActionEvent.ACTION_COMPLETE,onLoaded);
//		}
		public static function getGroupXml(id:String):XML
		{
			return _groups[id];
		}
		public static function createDisplayGroup(id:String,group:DisplayGroup=null):DisplayGroup
		{
			var xml:XML=getGroupXml(id);
			if(xml==null) {
				throw new Error("No DisplayGroup with id: "+id+"in SceneLibrary!");
				return null;
			}
			return SceneParser.parseDisplayGroup(xml,group);
		}
//		protected static function onLoaded(event:ActionEvent):void
//		{
//			if(onSuccessCall!=null) onSuccessCall(event);
//		}
//		protected static function onItemLoaded(resource:Resource):void
//		{
//			var xml:XML;
//			if(resource.type=="xml"){
//				xml=resource.content as XML;
//			}else{
//				xml=new XML(resource.content);
//			}
//		    parseXml(xml);	
//		}
		/**
		 * <sceneLib>
		 *    <Group libId="1001">
		 *       <!--如同场景中group的定义-->
		 *    </Group>
		 *     <Group libId="1002">
		 *       <!--如同场景中group的定义-->
		 *    </Group>
		 * </sceneLib>
		 * 
		 * */
		public static function addXml(xml:XML):void
		{
			var list:XMLList=xml.Group;
			for each(var gxml:XML in list){
				_groups[gxml.@libId]=gxml;
			}
		}
		
		
	}
}