package com.longame.modules.groups.organizers
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import com.longame.modules.scenes.GameScene;
	import com.longame.display.core.IDisplayRenderer;
	import com.longame.model.consts.Registration;
	import com.longame.modules.entities.IDisplayEntity;
	import com.longame.modules.groups.IDisplayGroup;
	import com.longame.modules.scenes.SceneManager;

	/**
	 * 层次排序基础类
	 * */
	public class GroupLayouterBase extends AbstractGroupOrganizer
	{
		// It's faster to make class variables & a method, rather than to do a local function closure
		protected var childVisited:Dictionary = new Dictionary(true);
		
		public function GroupLayouterBase()
		{
			super();
		}
		/**
		 * 确定child的层次
		 * */
		protected function place(child:IDisplayEntity):void
		{
			//to be inherited
		}
		protected function get displayGroup():IDisplayGroup
		{
			return group as IDisplayGroup;
		}
		/////////////////////////////////////////////////////////////////
		//	COLLISION DETECTION
		/////////////////////////////////////////////////////////////////
		
		protected var collisionDetectionFunc:Function = null;
		
		/**
		 * @inheritDoc
		 */
		public function get collisionDetection ():Function
		{
			return collisionDetectionFunc;
		}
		
		/**
		 * @private
		 */
		public function set collisionDetection (value:Function):void
		{
			collisionDetectionFunc = value;
		}	
		/**
		 * 比较objB是否应该放在objA的后面，2D和2.5D有所不同
		 * 在场景特别大循环特别多时，好像是直接在renderScene里面算这些数会快些，to think
		 * */
		protected function backCompare(objA:IDisplayEntity,objB:IDisplayEntity):Boolean
		{
			var edgeA:Vector3D=getEdge(objA);
			var edgeB:Vector3D=getEdge(objB);
			if(SceneManager.sceneType==SceneManager.D2){
				//2d比较y即可  
				//return (objB.y<objA.y);
				if(edgeB.y==edgeA.y){
                    //如果前边缘重合，那么面积大的放下面
					return objB.width*objB.length>objA.width*objA.length;
				}
				return edgeB.y<edgeA.y;
			}else{
				//暂时这样，由左向上的方向，当人物走动时会闪动，估计和设置depth的频率有关系，todo
				//看看是否只处理方格发生变化的对象，这种处理解决了闪现的问题，但层次排序还是有点问题，todo
				return ((objB.x < edgeA.x) && (objB.y < edgeA.y) && (objB.z < edgeA.z));
				
				if((edgeB.x==edgeA.x)&&(edgeB.y==edgeA.y)){
				    //如果前边缘重合，那么面积大的放下面
					return objB.width*objB.length>objA.width*objA.length;
				}
				return (edgeB.x<edgeA.x)||(edgeB.y<edgeA.y);
			}
		}
		//内部函数比引用obj.isoBounds要快？
		private function getEdge(obj:IDisplayEntity):Vector3D
		{
			var offset:Number=(obj.registration==Registration.CENTER)?0.5:1;
			var right:Number = obj.x + obj.width*offset;
			var front:Number = obj.y + obj.length*offset;
			var top:Number=obj.z+obj.height;
			return new Vector3D(right,front,top);
		}
	}
}