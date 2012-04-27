package com.longame.game.core.bounds
{
	import com.longame.core.long_internal;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.display.screen.IScreen;
	import com.longame.game.core.IComponent;
	import com.longame.game.entity.IDisplayEntity;
	import com.longame.game.entity.display.primitive.LGGrid;
	import com.longame.game.entity.display.primitive.LGRectangle;
	import com.longame.game.group.DisplayGroup;
	import com.longame.game.group.IDisplayGroup;
	import com.longame.game.scene.IScene;
	import com.longame.game.scene.SceneManager;
	
	import flash.geom.Vector3D;

	use namespace long_internal;

	/**
	 * DisplayGroup的bounds定义，注意DisplayGroup总是以左上角为注册点，切记，所有加在其中的entity都得注意这个问题，另外，DisplayGroup的left和back边界总是其x，y所决定，所有子对象都应当加在其x，y都为正的扇形范围内
	 * */
	public class GroupBounds extends Bounds implements IBounds
	{
		private var _target:IDisplayGroup;
		private var i:int=0;
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		/**
		 * 正好处于left,right,back,front,bottom,top六个边界处的子元素
		 * */
		private var edgeChildren:Array=new Array(6);
		/**
		 * 六个边界对应的属性名，用于子元素移动时判断是否需要全局更新
		 * */
		private static const edgesName:Array=["left","right","back","front","bottom","top"];
		/**
		 * Constructor
		 */
		public function GroupBounds (target:IDisplayGroup)
		{
			this._target = target;
//			_left=_target.x;
//			_back=_target.y;
			resetEdgeChildren();
		}
		override public function get left ():Number
		{
			return _target.x;
		}
		override public function get back ():Number
		{
			return _target.y;
		}
		override public function get right():Number
		{
			return _target.x+_right;
		}
		override public function get front():Number
		{
			return _target.y+_front;
		}
		override public function get bottom():Number
		{
			return _target.z+_bottom;
		}
		override public function get top():Number
		{
			return _target.z+_top;
		}
		public function destroy():void
		{
			_target=null;
			edgeChildren=null;
		}
		/**
		 * 当有子物品添加，移动，尺寸变化时，更新group的边界
		 * @param child: 变化的子对象
		 * @param isRemove:子对象是否被删除，如果是，处理方法略有不同
		 * */
		public function update (child:IDisplayEntity=null,isRemove:Boolean=false):Boolean
		{
			//对于不应该影响边界的物品忽略
			if(!child.includeInBounds) return false;
            return isRemove?this.updateWhenChildRemove(child):this.updateWhenChildChange(child);
		}
		/**
		 * child的某一面是否在bounds的边界上
		 * */
		public function isEdgeChild(child:IDisplayEntity):Boolean
		{
			if(edgeChildren[0]==null) return true;
			for(i=0;i<6;i++){
				if(edgeChildren[i].indexOf(child)>=0) return true;
			}
			return false;
		}
		private function updateWhenChildChange(child:IDisplayEntity):Boolean
		{
			if(child){
				//如果child超出了边界，根据这个child更新一次就可以了
				if(!this.containsBounds(child.bounds)) {
					var updated:Boolean= this.updateFromChild(child);
					//将可能不再是边界的物品也更新下
					this.updateOldEdgeChildren();
					//再更新目标物品
					this.updateEdgeChild(child);
					return updated;
				}
				//如果child没有超出边界，而且这个child不是目前的边界子元素之一，那么不需要任何更新
				if(!ifChildChangeTheEdge(child)) return false;
			}
			//如果非上述情况，那么得进行全体更新
			this.updateFromAll();
			return true;
		}
		/**
		 * child被删除时，更新group的边界
		 * */
		private function updateWhenChildRemove(child:IDisplayEntity):Boolean
		{
			//如果要删除的对象是某个边界的唯一支撑，才需要整体更新，否则不做任何更新
			var needUpdate:Boolean=this.isTheOnlyEdgeChild(child);
			if(needUpdate) this.updateFromAll();
			return needUpdate;
		}
		/**
		 * 全局遍历更新
		 * */
		private function updateFromAll():void
		{
			//先将所有数值设为极限，这样可以保证计算的尺寸是真实的子元素所覆盖的边界尺寸
			this.resetBounds();
			//遍历所有物品，找出边界
			_target.foreachDisplay(this.updateFromChild,true);
			//特殊情况下，可能没有引起尺寸变化的子元素，但各个边界又不能为极限值，全部恢复为0
			this.validateBounds();
			//更新边界物品
			this.updateEdges();
		}
		/**
		 * 更新边界物品
		 * */
		private function updateEdges():void
		{
			//首先清空所有边界物品，这种情况出现的机会少，运算量大
			this.resetEdgeChildren();
			//然后找出处于边界处的物品
			_target.foreachDisplay(this.updateEdgeChild,true);
		}
		/**
		 * 将旧的边界物品更新下，有的可能不再是
		 * */
		private function updateOldEdgeChildren():void
		{
			var edges:Array;
			var ch:IDisplayEntity;
			var arr:Array=[];
			for(i=0;i<6;i++){
				edges=edgeChildren[i];
				for each(ch in edges){
					arr.push(ch);
				}
			}
			for each(ch in arr){
				this.updateEdgeChild(ch);
			}
		}
		/**
		 * 如果child被删除，只有child是某个边界上的唯一物品，才需要更新group的边界
		 * */
		private function isTheOnlyEdgeChild(child:IDisplayEntity):Boolean
		{
			if(edgeChildren[0]==null) return true;
			for(i=0;i<6;i++){
				if(edgeChildren[i].indexOf(child)>=0){
					if(edgeChildren[i].length==1) return true;
				}
			}
			return false;
		}
		/**
		 * 如果child可能引起bounds变化，则首先检查child是否边界物品，如果是再检查其是否改变了对应的边界，如果全是，则需要进行整体更新
		 * */
		private function ifChildChangeTheEdge(child:IDisplayEntity):Boolean
		{
			if(edgeChildren[0]==null) return true;
			var edgeName:String;
			for(i=0;i<6;i++){
				edgeName=edgesName[i];
				if(edgeChildren[i].indexOf(child)>=0) {
					if(this[edgeName]!=child.bounds[edgeName]){
						return true;
					} 
				}
			}
			return false;
		}
		/***
		 * 从child的bounds判断其是否影响了group的边界
		 * 
		 * */
		private function updateFromChild(child: IDisplayEntity):Boolean
		{
			if(!child.includeInBounds) return false;
			var updated:Boolean=false;
//			if (child.bounds.left < _left){
//				_left = child.bounds.left;
//				updated=true;
//			}
			if (child.bounds.right> _right)
			{
				_right =child.bounds.right;
				updated=true;
			}
//			if (child.bounds.back< _back)
//			{
//				_back = child.bounds.back;
//				updated=true;
//			}
			if (child.bounds.front> _front)
			{
				_front =child.bounds.front;
				updated=true;
			}
			if (child.bounds.bottom< _bottom)
			{
				_bottom = child.bounds.bottom;
				updated=true;
			}
			if (child.bounds.top> _top)
			{
				_top = child.bounds.top;
				updated=true;
			}
			return updated;
		}
		/**
		 * 根据child的bounds是否在边界上，将其从edgeChildren中添加或删除
		 * */
		private function updateEdgeChild(child:IDisplayEntity):void
		{
			if(!child.includeInBounds) return;
			var edges:Array;
			//左
			edges=edgeChildren[0];
			i=edges.indexOf(child);
			if(child.bounds.left<=left) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
			//右
			edges=edgeChildren[1];
			i=edges.indexOf(child);
			if(child.bounds.right>=_right) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
			//后
			edges=edgeChildren[2];
			i=edges.indexOf(child);
			if(child.bounds.back<=back) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
			//前
			edges=edgeChildren[3];
			i=edges.indexOf(child);
			if(child.bounds.front>=_front) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
			//下
			edges=edgeChildren[4];
			i=edges.indexOf(child);
			if(child.bounds.bottom<=_bottom) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
			//上
			edges=edgeChildren[5];
			i=edges.indexOf(child);
			if(child.bounds.top>=_top) if(i==-1) edges.push(child);
			else if(i>=0) edges.splice(i,1);
		}
		private function resetBounds():void
		{
//			_left=Number.MAX_VALUE;
//			_back=Number.MAX_VALUE;
			_bottom=Number.MAX_VALUE;
			_right=Number.MIN_VALUE;
			_front=Number.MIN_VALUE;
			_top=Number.MIN_VALUE;
		}
		private function validateBounds():void
		{
//			if(_left==Number.MAX_VALUE) _left=0;
//			if(_back==Number.MAX_VALUE) _back=0;
			if(_bottom==Number.MAX_VALUE) _bottom=0;
			if(_right==Number.MIN_VALUE) _right=0;
			if(_front==Number.MIN_VALUE) _front=0;
			if(_top==Number.MIN_VALUE) _top=0;
		}
		private function resetEdgeChildren():void
		{
			for(i=0;i<6;i++){
				edgeChildren[i]=[];
			}
		}
	}
}