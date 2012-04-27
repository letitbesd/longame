package com.xingcloud.tutorial.steps
{
	import com.longame.commands.base.Command;
	import com.longame.managers.InputManager;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.StringParser;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.model.item.ItemDatabase;
	import com.xingcloud.model.item.spec.AwardItemSpec;
	import com.xingcloud.model.users.AbstractUserProfile;
	import com.xingcloud.net.connector.AMFConnector;
	import com.xingcloud.tutorial.Tutorial;
	import com.xingcloud.tutorial.TutorialManager;
	import com.xingcloud.tutorial.tips.TutorialTip;
	import com.xingcloud.tutorial.tips.ITutorialTip;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	use namespace xingcloud_internal;
	/**
	 * 一个教程步骤，步骤里面可以显示很多的ITutorialTip来提示玩家操作，步骤的要实现的一个很重要的功能是，
	 * 在完成时调用complete()，告诉其父Tutorial这步完成可以进行下步，如ButtonClickStep里面，当某个按钮被玩家点下时，任务就完成了
	 * 同时向后台提交action，获取相应的奖励。
	 * <Step name="" description="" target="" award="" delay="" rect="" enabledKeys="null/LEFT,RIGHT">
	 * 		<Tip/>
	 *     <Tip/>
	 * </Step>
	 * 说明：enabledKeys="null"会屏蔽所有按键
	 *          enabledKeys="LEFT,RIGHT"会屏蔽左右按键之外的键
	 * */
	[DefaultProperty("tips")]
	public class TutorialStep extends Command
	{
		protected var _name:String;
		protected var _target:String;
		protected var _awardId:String;
		protected var _description:String="";
		protected var _enabledKeys:Array=[];
		xingcloud_internal var _owner:Tutorial;
		xingcloud_internal var _index:uint=1;
		protected var _tips:Array=[];
		/**
		 * 指定一个全局坐标系下的矩形范围，用于显示tip，
		 * 这个参数用于当target实在不好指定时，让开发者自己定义位置
		 * */
		protected var _rect:Rectangle;
		
		public function TutorialStep()
		{
			super();
		}
		public function parseFromXML(xml:XML):void
		{
			this._name=xml.@name;
			this._description=xml.@description;
			this._target=xml.@target;
			var tipList:XMLList=xml.children();
			var len:uint=tipList.length();
			var tipXml:XML;
			var tip:TutorialTip;
			var tipCls:Class;
			for(var i:int=0;i<len;i++){
				tipXml=tipList[i];
				tipCls=TutorialManager.getClass(tipXml.localName().toString());
				if(tipCls==null) throw new Error("The class : "+tipXml.localName().toString()+" does not exist!");
				tip=new tipCls() as TutorialTip;
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
			//按键屏蔽
			if(xml.hasOwnProperty("@enabledKeys")){
				var k:String=xml.@enabledKeys;
				if(k.toLocaleLowerCase()=="null"){
					this._enabledKeys=null;
				}else{
					var ks:Array=StringParser.toArray(k);
					for each(var kid:String in ks){
						this._enabledKeys.push(Keyboard[kid]);
					}
				}
			}
		}
		/**
		 * 记录这是第几步，Tutorial会调用setIndex初始化
		 * */
		public function get index():int
		{
			return _index;
		}
		/**
		 * 这个步骤属于哪个Tutorial，初始化时通过setOwner()自动赋值
		 * */
		public function get owner():Tutorial
		{
			return _owner;
		}
		private var oldEnabledKeys:Array;
		override protected function doExecute():void
		{
			if(!validate()) return;
			super.doExecute();
			for each(var tip:ITutorialTip in tips){
				tip.owner=this;
				tip.show();
			}
			if(InputManager.enabledKeys)
				oldEnabledKeys=InputManager.enabledKeys.concat();
			else
				oldEnabledKeys=null;
			//按键屏蔽
			InputManager.enabledKeys=this._enabledKeys;
		}
		override protected function complete():void
		{
			if(this._isCompleted) return;
			this._isCompleted=true;
			if(AbstractUserProfile.ownerUser){
				AbstractUserProfile.ownerUser.updateTutorial(owner.id,this.index);
			}
			for each(var tip:ITutorialTip in _tips){
				tip.hide();
			}
			_tips.splice(0,_tips.length);
			_tips=null;
			_owner=null;
			//取消按键屏蔽
			InputManager.enabledKeys=oldEnabledKeys;
			//延时调用，防止两步之间有重叠
			//但是导致homeIntro向导里看不到调整人物属性的向导啦，todo，明天
			ProcessManager.callLater(super.complete);
//			super.complete();
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
		 * 可能有关的界面元素
		 * */
		public function get target():DisplayObject
		{
			if(_target && _target.length){
				if(_owner && _owner.target) {
					var t:*=_owner.target;
					var ts:Array=_target.split(".");
					for(var i:int=0;i<ts.length;i++){
						t=t[ts[i]];
					}
					return t as DisplayObject;
				}
				return null;
				
			}
			return _owner.target as DisplayObject;
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