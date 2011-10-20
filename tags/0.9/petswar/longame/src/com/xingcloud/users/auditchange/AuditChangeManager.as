package com.xingcloud.users.auditchange
{
	import com.longame.commands.base.Command;
	import com.longame.commands.net.Remoting;
	import com.longame.core.ITickedObject;
	import com.longame.managers.ProcessManager;
	import com.xingcloud.core.Config;
	import com.xingcloud.core.ModelBase;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.items.owned.OwnedItem;
	import com.xingcloud.users.AbstractUserProfile;
	import com.xingcloud.users.actions.ActionResult;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 *变更记录管理器
	 * @author Admin
	 * 
	 */	
	public class AuditChangeManager extends Command implements ITickedObject
	{
		private static var _instance:AuditChangeManager;
		/**
		 * audit队列达到这个长度后就会向服务器发送
		 * */
		public static const minLength:uint=8;
		/**
		 * audit发送的最短时间周期,毫秒
		 * */
		public static const minPeriod:uint=3000;
		/**
		 * 发送一批audits编一个号，好对结果进行处理
		 * */
		private static var batchId:uint=0;
		/**
		 * 已发送的变更缓存，用于后续查找操作
		 * */
		private static var auditCache:Dictionary=new Dictionary(true);
		/**
		 * 在队列中待发的audit
		 * */
		private var _audits:Array;
		
		/**
		 * AuditManager的服务路径如，AuditManager.execute，是amfphp/services/AuditManager.php的execute方法
		 * 如果是amfphp/someGame/services/AuditManager.php，则应为someGame.AuditManager.execute
		 * */
		private var _mainService:String;
		/**
		 * 上次发送时间
		 * */
		private var _latestSendTime:int=0;
		/**
		 *当前活动的auditchange 
		 */		
		protected static var _currentAudit:AuditChange;
		/**
		 * 无需直接实例化
		 * AuditChangeManager.init()
		 * AuditChangeManager.instance
		 * */
		public function AuditChangeManager(singleLock:singleLock)
		{
			super();
			_audits=[];
		}
		/**
		 * 初始化ActionManager的后台服务，并创建一个ActionManager实例
		 * @param service: ActionManager在后台的服务，详见ELEX.ACTION_SERVICE
		 * */
		public static function init(service:String):void
		{
			_instance=new AuditChangeManager(new singleLock);
			if(service==null) throw new Error("Please give me a backend ActionManager service!");
			_instance._mainService=service;
		}
		public static function get instance():AuditChangeManager
		{
			return _instance;
		}
		
		override protected function doExecute():void
		{
			super.doExecute();
			//每批audit发送到后台的结构为
			//  =>id
			//  =>info {userId:用户id,target:publish/test,...},用于后台log或其它用途
			//  =>data: 一组{name:audit.action.name,params:audit.params,changes:audit.changes}
			var auditArgs:Object=new Object();
			auditArgs.id=batchId++;
			auditArgs.info=Config.appInfo;
			auditArgs.data=new Array();
			
			//每执行一批次就将其放入字典
			var batch:Array=[];
			auditCache[auditArgs.id]=batch;

			for(var i:int=0;i<_audits.length;i++)
			{
				var audit:AuditChange=_audits[i];
				if(audit.sended) return;
				auditArgs.data.push({name:audit.name,changes:audit.changes,params:audit.params});
				audit.sended=true;
				batch.push(audit);
			}	
			var amf:Remoting=new Remoting(_mainService,auditArgs,XingCloud.defaultRemoteMethod,null,XingCloud.needAuth);
			amf.onSuccess=onBatchSuccess;
			amf.onFail=onBatchFail;
			amf.execute();
			//发完清空
			_audits.splice(0,_audits.length);
		}
		override protected function notifyError(errorMsg:String):void
		{
			super.notifyError(errorMsg);
			if(this._hasError) {
			}
		}
		override protected function complete():void
		{
			super.complete();
		}
		private var _started:Boolean=false;

		/**
		 * 退出进程，停止向后台发送audit
		 * */
		public function stop():void
		{
			if(_started==false) return;
			_started=false;
			ProcessManager.removeTickedObject(this);
		}
		public function onTick(delta:Number):void
		{
			if(!this._paused) return;
			if(_audits.length==0) return;
			if((_audits.length>=AuditChangeManager.minLength)||(_latestSendTime&&(getTimer()-_latestSendTime>=minPeriod))){
				_latestSendTime=getTimer();
				this.execute();
			}
		}
		/**
		 *清空记录
		 * */
		public function clear():void
		{
			auditCache=new Dictionary();
		}
		/**
		 *增加一个变更记录 
		 * @param audits
		 * 
		 */		
		public function addAudit(...audits):void
		{
			if(!_started)
			{
				_latestSendTime=getTimer();
				ProcessManager.addTickedObject(this);
				_started=true;
			}
			for(var i:int=0;i<audits.length;i++)
			{
				var audit:AuditChange=audits[i];
				if(this._audits.indexOf(audit)>-1) continue;
				this._audits.push(audit);
			}
		}
		/**
		 *移除一个变更记录 
		 * @param audits
		 * 
		 */		
		public function removeAudit(...audits):void
		{
			for(var i:int=0;i<audits.length;i++){
				var audit:AuditChange=audits[i];
				var index:int=this._audits.indexOf(audit);
				if(index>-1) this._audits.splice(i,1);
			}			
		}
		/**
		 * 获取已经发送过的某个id的audit
		 * */
		public static function getAudit(id:String):AuditChange
		{
			for(var i:* in auditCache)
			{
				var batch:Array=auditCache[i];
				for each(var audit:AuditChange in batch)
				{
					if(audit.id==id) return audit;
				}
			}
			return null;
		}
		
		protected function onBatchSuccess(data:Object):void
		{
            this.handleBatchResult(data);
			this.complete();	
			clearChangeCache();
		}
		protected function onBatchFail(error:String):void
		{
//            this.handleBatchResult(new ActionResult(ActionResult.SERVER_ERROR_CODE,error));
			this.notifyError(error);
			clearChangeCache();
		}
		protected function clearChangeCache():void
		{
			if(batchId>100)
			{
				batchId=0;
				auditCache=new Dictionary();
			}
		}
		/**
		 * 处理一组action成功返回的结果
		 * data
		 *     --id:int                 这组action的编号，和发送时对应
		 *     --results                一组结果，每个元素对应一个action的结果,Array
		 *            --actionResult    对应一个action的结果,Object
		 *                  --result    整个action返回的结果，开发者自定义，元素类型ActionResult
		 *                  --detail    action每个changes对应的结果,元素类型ActionResult
		 *            --actionResult
		 *            --...
		 * */
		protected function handleBatchResult(data:Object):void
		{
			var auditBatch:Array=auditCache[data.id];
			var results:Array=data.results as Array;
			if(results&&auditBatch&&auditBatch.length<=results.length)
			{
				for(var i:int=0;i<auditBatch.length;i++)
				{
					var audit:AuditChange=auditBatch[i];
					audit.handleDataBack(results[i].detail);
				}
			}
			else
			{
				this.notifyError("invaliate data formate "+data.toString());
			}
		}
		/**
		 * 开始一个auditchange记录,想往后台发送audit，此后数据变更会被自动记录
		 * @param successCallback:   成功回调函数,模板:  function onSuccess(result:ActionResult,detail:Array):void;
		 * @param failCallback:      失败回调函数，模板：function onSuccess(result:ActionResult,detail:Array):void;
		 * 回调模板函数说明：result是action的整体结果,需要开发者在后台对应action中自定义
		 *                  detail是action对userProfile的每项属性修改对应的ActionResult
		 * */
		public  function start(audit:AuditChange,successCallback:Function=null,failCallback:Function=null):AuditChange
		{
			_currentAudit=audit;
			_currentAudit.onSuccess=successCallback
			_currentAudit.onFail=failCallback;
			addAudit(_currentAudit);
			return _currentAudit;
		}
		
		/**
		 * 希望后面的操作不记录audit,在某些场合我们不希望改变profile的时候向后退发数据，比如我们从后台更新数据时
		 * */
		public  function stopTrack():void
		{
			_currentAudit=null;
		}
		/**
		 *获取当前 变更记录
		 * @return 
		 * 
		 */		
		public  function get currentAudit():AuditChange
		{
			return _currentAudit;	
		}
		/**
		 * 当前是否有指定的audit可用
		 * */
		public  function get canUse():Boolean
		{
			return _currentAudit&&(!_currentAudit.sended);
		}
		/**
		 * 添加一个属性改变，后台会直接改变数据库
		 * @param item:      要改变属性的实例对象，UserInfoBase的子类，如UserProfile,OwnedItem等
		 * @param property:  要改变的属性名
		 * @param oldValue:  改变前的值
		 * @param newValue:  改变后的值
		 * */
		public  function appendUpdateChange(item:ModelBase,property:String,oldValue:Object,newValue:Object):Boolean
		{
			if(!canUse) return false;
			var change:Object={target:item.className,method:"update",uid:item.uid,property:property,oldValue:oldValue,newValue:newValue};
			var duplicate:Object=checkSamePropChange(change);
			if(duplicate) //有重复，更新新值
			{
				duplicate.newValue=change.newValue;
			}
			else
			{
				_currentAudit.changeField[item.className]=item;
				_currentAudit.changes.push(change);
			}
			return true;
		}
		/**
		 * 检查和chg具有相同对象，相同改变方法及改变属性的change，如果玩家拖着一个物品不停的动，那是不是要非常频繁的发数据到后台呢，遇到这种情况，只
		 * 发最近的那次改变，ok
		 * */
		private  function checkSamePropChange(chg:Object):Object
		{
			for (var i:int=0;i<_currentAudit.changes.length;i++)
			{
				var change:Object=_currentAudit.changes[i];
				if((chg.target==change.target)&&(chg.method==change.method)&&(chg.uid==change.uid)&&(chg.property==change.property))
				{
					return change;
				}
			}
			return null;
		}		
		/**
		 * 要添加一条记录，后台会直接改变数据库
		 * @param item:      新物品
		 * */
		public  function appendItemAddChange(item:OwnedItem):Boolean
		{
			if(!canUse) return false;
			_currentAudit.changes.push({target:item.className,method:"add",item:item});
			_currentAudit.changeField[item.className]=item;
			return true;
		}
		/**
		 * 要删除一条记录，后台会直接改变数据库
		 * @param item:   要删除的物品
		 * */
		public  function appendItemRemoveChange(item:OwnedItem):Boolean
		{
			if(!canUse) return false;
			_currentAudit.changes.push({target:item.className,method:"remove",uid:item.uid});
			_currentAudit.changeField[item.className]=item;
			return true;
		}
	}
}
internal class singleLock{
	
}