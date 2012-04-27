package com.xingcloud.tutorial.steps
{
	import com.longame.commands.base.Command;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.AwardItemSpec;
	import com.xingcloud.net.connector.AMFConnector;
	import com.xingcloud.tutorial.Tutorial;
	import com.xingcloud.tutorial.TutorialManager;
	import com.xingcloud.tutorial.tips.AbstractTip;
	import com.xingcloud.tutorial.tips.ITutorialTip;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	use namespace xingcloud_internal;
	/**
	 * 一个教程步骤，步骤里面可以显示很多的ITutorialTip来提示玩家操作，步骤的要实现的一个很重要的功能是，
	 * 在完成时调用complete()，告诉其父Tutorial这步完成可以进行下步，如ButtonClickStep里面，当某个按钮被玩家点下时，任务就完成了
	 * 同时向后台提交action，获取相应的奖励。
	 * */
	[DefaultProperty("tips")]
	public class TutorialStep extends Command
	{
		protected var _name:String;
		protected var _owner:Tutorial;
		protected var _target:String;
		protected var _awardId:String;
		protected var _description:String="";
		protected var _tips:Array=[];
		protected var _index:uint=1;
		
		protected var _clickable:Boolean;
		
		/**
		 * 指定一个全局坐标系下的矩形范围，用于显示tip，
		 * 这个参数用于当target实在不好指定时，让开发者自己定义位置
		 * */
		protected var _rect:Rectangle;
		
		public function TutorialStep(delay:uint=0)
		{
			super(delay);
		}
		public function parseFromXML(xml:XML):void
		{
			this._name=xml.@name;
			this._description=xml.@description;
			this._target=xml.@target;
			if(!xml.hasOwnProperty("Tips")) throw new Error("TutorialStep shoud has 'Tips' node!");
			var tipList:XMLList=xml.Tips[0].children();
			var len:uint=tipList.length();
			var tipXml:XML;
			var tip:AbstractTip;
			var tipCls:Class;
			for(var i:int=0;i<len;i++){
				tipXml=tipList[i];
				tipCls=TutorialManager.getClass(tipXml.localName().toString());
				if(tipCls==null) throw new Error("The class : "+tipXml.localName().toString()+" does not exist!");
				tip=new tipCls() as AbstractTip;
				tip.parseFromXML(tipXml);
				this._tips.push(tip);
			}
			if(xml.hasOwnProperty("@delay")) this._delay=parseInt(xml.@delay)*1000;
			if(xml.hasOwnProperty("@award")){
				this._awardId=xml.@award;
			}
			if(xml.hasOwnProperty("@rect")){
				var arr:Array=(xml.@rect).toString().split(",",4);
				_rect=new Rectangle();
				_rect.x=Number(arr[0]);
				_rect.y=Number(arr[1]);
				_rect.width=Number(arr[2]);
				_rect.height=Number(arr[3]);
			}
		}
		/**
		 * 记录这是第几步，Tutorial会调用setIndex初始化
		 * */
		public function get index():int
		{
			return _index;
		}
		xingcloud_internal function setIndex(i:uint):void
		{
			_index=i;
		}
		/**
		 * 这个步骤属于哪个Tutorial，初始化时通过setOwner()自动赋值
		 * */
		public function get owner():Tutorial
		{
			return _owner;
		}
		xingcloud_internal function setOwner(owner:Tutorial):void
		{
			_owner=owner;
		}
		override protected function doExecute():void
		{
			if(!validate()) return;
			super.doExecute();
			for each(var tip:ITutorialTip in tips){
				tip.owner=this;
				tip.show();
			}
		}
		override protected function complete():void
		{
			if(this._isCompleted) return;
			for each(var tip:ITutorialTip in tips){
				tip.hide();
				tip.owner=null;
			}
			tips.splice(0,tips.length);
			if(XingCloud.userprofile&&(!TutorialManager.testMode)){
				//向后台提交
//				var amf:Remoting=new Remoting(Config.TUTORIAL_STEP_SERVICE,{user_uid:XingCloud.userprofile.uid,tutorial:this.owner.name,name:this.name,index:this.index});
//				amf.execute();
				var amf:AMFConnector=new AMFConnector(Config.TUTORIAL_STEP_SERVICE,{user_uid:XingCloud.userprofile.uid,tutorial:this.owner.name,name:this.name,index:this.index});
				amf.execute();
			}
			super.complete();
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
		/**
		 * 是否可点击，如果true，则这一步点击就进入下一步
		 * */
		public function get clickable():Boolean
		{
			return _clickable;
		}
		/**
		 * 可能有关的界面元素
		 * */
		public function get target():DisplayObject
		{
			if(_target && _target.length){
				if(_owner && _owner.target) {
					var t:DisplayObject=_owner.target;
					var ts:Array=_target.split(".");
					for(var i:int=0;i<ts.length;i++){
						t=t[ts[i]];
					}
					return t;
//					return _owner.target[_target] as DisplayObject;
				}
				return null;
				
			}
			return _owner.target;
		}
		/**
		 * 这一步给玩家的视觉提示，比如高亮某个按钮，一步可以有多个tip
		 * 常见的InfoBubble,Highlight
		 * */
		public function get tips():Array
		{
			return _tips;
		}
		public function get rect():Rectangle
		{
			return _rect;
		}
		/**
		 * 奖励
		 * */
		public function get award():AwardItemSpec
		{
			if(_awardId==null) return null;
			return ItemDatabase.getItem(_awardId) as AwardItemSpec;
		}
		public function validate():Boolean
		{
			return true;
			//todo
		}
	}
}