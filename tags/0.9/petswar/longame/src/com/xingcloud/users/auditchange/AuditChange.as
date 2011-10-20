package com.xingcloud.users.auditchange
{
	import com.longame.utils.Reflection;
	import com.xingcloud.core.ModelBase;
	import com.xingcloud.core.XingCloud;
	import com.xingcloud.core.xingcloud_internal;
	import com.xingcloud.items.owned.OwnedItem;
	import com.xingcloud.users.AbstractUserProfile;
	import com.xingcloud.users.actions.ActionResult;

	/**
	 * 用于记录用户数据的变更
	 * @author Admin
	 * 
	 */	
	public class AuditChange
	{
		/**
		 *变化的列表 
		 */		
		public var changes:Array=[];
		public var params:Object={};
		/**
		 *缓存哪些对象发生了变更，用于服务器返回数据后的数据更新处理 
		 */		
		public var changeField:Object={};
		/**
		 * 是否已发送
		 */		
		public var sended:Boolean=false;
		private static var nextID:int=-1;
		protected var _success:Boolean=false;
		
		
		/**
		 * auditChange，非外部使用
		 * */
		public function AuditChange(params:Object=null)
		{
			this.params=params;
		}
	
		
		/**
		 *是否发送成功 
		 */		
		public function get success():Boolean
		{
			return _success;
		}
		public var onSuccess:Function = null;
		public var onFail:Function = null;
		/**
		 * 统一处理返回数据，如果result为成功，detail可能会有错误，分别判断
		 * */
		public function handleDataBack(detail:Array=null):void
		{
			if(detail==null) detail=[];
			var success:Boolean=true;
			for each(var result:Object in detail)
			{
				if(result.code==200)
				{
					updateAuditChangeData(result.data);
				}
				else
				{
					success=false;
				}
			}
			if(success)
			{
				if(onSuccess!=null)
					this.onSuccess(detail);
			}
			else
			{
				if(onFail!=null)
					onFail("auditChange failture"+result.code+result.message);
			}
		}
		//统一处理服务器返回的变更
		private function updateAuditChangeData(data:Object):void
		{
			if(data.hasOwnProperty("className")&&changeField[data.className])
			{
				changeField[data.className].parseFromObject(data);
				if(data.className!=XingCloud.userprofile.className)
				{
					var field:String=changeField[data.className].OwnerProperty;
					XingCloud.userprofile[field].updateItemUID(changeField[data.className]);
				}
			}
		}
		private var _name:String;
		/**
		 *返回AuditChange的名称 
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return Reflection.tinyClassName(this);
		}
		private var _id:String;
		/**
		 *audit id
		 * 
		 * @return 
		 * 
		 */		
		public function get id():String
		{
			if(_id) return _id;
			return "Action"+nextID;
		}
	}
}
