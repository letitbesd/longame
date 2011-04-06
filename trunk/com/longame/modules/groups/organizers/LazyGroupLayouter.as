	package com.longame.modules.groups.organizers
	{
		import flash.utils.Dictionary;
		import flash.utils.getTimer;
		
		import com.longame.display.core.IDisplayRenderer;
		import com.longame.modules.entities.IDisplayEntity;
		import com.longame.modules.groups.IDisplayGroup;
		
		/**
		 * 这是一个没有优化，遍历场景每个物品而进行的排序，通常只在场景初始化中用此renderer
		 * 具体用GroupLayouter即可
		 */
		public class LazyGroupLayouter extends GroupLayouterBase
		{		
			////////////////////////////////////////////////////
			//	RENDER SCENE
			////////////////////////////////////////////////////
			private var depth:uint;
			private var dependency:Dictionary;
			/**
			 * @inheritDoc
			 */
			override protected function  doUpdate():void
			{
				super.doUpdate();
				var startTime:uint = getTimer();
				dependency = new Dictionary();
				var children:Vector.<IDisplayEntity>=displayGroup.getDisplays();
				children.sort(compareY);
				var max:uint = children.length;
				for (var i:uint = 0; i < max; ++i)
				{
					var behind:Array = [];
					
					var objA:IDisplayEntity = children[i];
					if(objA.includeInLayout==false) continue;
					for (var j:uint = 0; j < max; ++j)
					{
						var objB:IDisplayEntity = children[j];
						if(objB.includeInLayout==false) continue;
						//有啥用呢？to delete
						if (collisionDetectionFunc != null)
							collisionDetectionFunc.call(null, objA, objB);
						
						var inBack:Boolean=this.backCompare(objA,objB);
						if (inBack&&(i !== j))
						{
							behind.push(objB);
						}
					}
					
					dependency[objA] = behind;
				}
				depth = 0;
				for each (var obj:IDisplayEntity in children)
				if ((true !== childVisited[obj])&&(obj.includeInLayout))
					place(obj);
				
				childVisited = new Dictionary();
				// DEBUG OUTPUT
				trace("scene layout render time", getTimer() - startTime, "ms (lazy sort)"+" ,with "+max+" objects!");
			}
			/**
			 * Dependency-ordered depth placement of the given objects and its dependencies.
			 */
			override protected function place(obj:IDisplayEntity):void
			{
				childVisited[obj] = true;
				
				for each(var inner:IDisplayEntity in dependency[obj])
				if(true !== childVisited[inner])
					place(inner);
				(_group as IDisplayGroup).setChildIndex(obj,depth);
				++depth;
			}
			private function compareY(a:IDisplayEntity,b:IDisplayEntity):int
			{
				if(a.y>b.y) return 1;
				else if(a.y<b.y) return -1;
				return 0;
			}
		}
	}
