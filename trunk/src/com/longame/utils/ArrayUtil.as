/*	CASA Lib for ActionScript 3.0	Copyright (c) 2009, Aaron Clinger & Contributors of CASA Lib	All rights reserved.		Redistribution and use in source and binary forms, with or without	modification, are permitted provided that the following conditions are met:		- Redistributions of source code must retain the above copyright notice,	  this list of conditions and the following disclaimer.		- Redistributions in binary form must reproduce the above copyright notice,	  this list of conditions and the following disclaimer in the documentation	  and/or other materials provided with the distribution.		- Neither the name of the CASA Lib nor the names of its contributors	  may be used to endorse or promote products derived from this software	  without specific prior written permission.		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE	POSSIBILITY OF SUCH DAMAGE.*/package  com.longame.utils{	import flash.geom.Point;
				/**		Utilities for sorting, searching and manipulating Arrays.				@author Aaron Clinger		@author David Nelson		@author Jon Adams		@version 08/05/09	*/	public class ArrayUtil {				public static function getRandom(arr:Array):*		{			var i:int=Math.floor(Math.random()*arr.length);			return arr[i];		}		/**		 * Randomly shuffle the elements in the specified array.		 *		 * @param rando a random number generator to use, or null if you don't care.		 */		public static function shuffle (arr :Array, rando :Random = null) :void		{			var randFunc :Function = (rando != null) ? rando.nextInt :			function (n :int) :int {				return int(Math.random() * n);			};			// starting from the end of the list, repeatedly swap the element in			// question with a random element previous to it up to and including			// itself			for (var ii :int = arr.length - 1; ii > 0; ii--) {				var idx :int = randFunc(ii + 1);				var tmp :Object = arr[idx];				arr[idx] = arr[ii];				arr[ii] = tmp;			}		}		/**			Returns the first element that matches <code>match</code> for the property <code>key</code>.						@param inArray: Array to search for an element with a <code>key</code> that matches <code>match</code>.			@param key: Name of the property to match.			@param match: Value to match against.			@return Returns matched <code>Object</code>; otherwise <code>null</code>.		*/		public static function getItemByKey(inArray:Array, key:String, match:*):* {			for each (var item:* in inArray)				if (item[key] == match)					return item;						return null;		}				/**			Returns every element that matches <code>match</code> for the property <code>key</code>.						@param inArray: Array to search for object with <code>key</code> that matches <code>match</code>.			@param key: Name of the property to match.			@param match: Value to match against.			@return Returns all the matched elements.		*/		public static function getItemsByKey(inArray:Array, key:String, match:*):Array {			var t:Array = new Array();						for each (var item:* in inArray)				if (item[key] == match)					t.push(item);						return t;		}				/**			Returns the first element that is compatible with a specific data type, class, or interface.						@param inArray: Array to search for an element of a specific type.			@param type: The type to compare the elements to.			@return Returns all the matched elements.		*/		public static function getItemByType(inArray:Array, type:Class):* {			for each (var item:* in inArray)				if (item is type)					return item;						return null;		}				/**			Returns every element that is compatible with a specific data type, class, or interface.						@param inArray: Array to search for elements of a specific type.			@param type: The type to compare the elements to.			@return Returns all the matched elements.		*/		public static function getItemsByType(inArray:Array, type:Class):Array {			var t:Array = new Array();						for each (var item:* in inArray)				if (item is type)					t.push(item);						return t;		}				/**			Determines if two Arrays contain the same objects at the same index.						@param first: First Array to compare to the <code>second</code>.			@param second: Second Array to compare to the <code>first</code>.			@return Returns <code>true</code> if Arrays are the same; otherwise <code>false</code>.		*/		public static function equals(first:Array, second:Array):Boolean {			var i:uint = first.length;			if (i != second.length)				return false;						while (i--)				if (first[i] != second[i])					return false;						return true;		}				/**			Modifies original Array by adding all the elements from another Array at a specified position.						@param tarArray: Array to add elements to.			@param items: Array of elements to add.			@param index: Position where the elements should be added.			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.			@example				<code>					var alphabet:Array = new Array("a", "d", "e");					var parts:Array    = new Array("b", "c");										ArrayUtil.addItemsAt(alphabet, parts, 1);										trace(alphabet);				</code>		*/		public static function addItemsAt(tarArray:Array, items:Array, index:int = 0x7FFFFFFF):Boolean {			if (items.length == 0)				return false;						var args:Array = items.concat();			args.splice(0, 0, index, 0);						tarArray.splice.apply(null, args);						return true;		}				/**			Creates new Array composed of only the non-identical elements of passed Array.						@param inArray: Array to remove equivalent items.			@return A new Array composed of only unique elements.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 4, 4, 4, 4, 5);					trace(ArrayUtil.removeDuplicates(numberArray));				</code>		*/		public static function removeDuplicates(inArray:Array):Array {			return inArray.filter(ArrayUtil._removeDuplicatesFilter);		}				protected static function _removeDuplicatesFilter(e:*, i:int, inArray:Array):Boolean {			return (i == 0) ? true : inArray.lastIndexOf(e, i - 1) == -1;		}				/**			Modifies original Array by removing all items that are identical to the specified item.						@param tarArray: Array to remove passed <code>item</code>.			@param item: Element to remove.			@return The amount of removed elements that matched <code>item</code>, if none found returns <code>0</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);					trace("Removed " + ArrayUtil1.removeItem(numberArray, 7) + " items.");					trace(numberArray);				</code>		*/		public static function removeItem(arrayOrVector:*, item:*):uint {			var i:int  =getRealIndex(arrayOrVector,item);			var f:uint = 0;						while (i != -1) {				arrayOrVector.splice(i, 1);								i =getRealIndex(arrayOrVector,item,i);								f++;			}						return f;		}		/**		 * 由于indexOf是用===来搜寻的，那么对于Point或者其他数据类型，可能得不到真正的结果		 * 先解决point，不知还会有其他的数据类型待解决		 * */		public static function getRealIndex(arrayOrVector:*,item:Object,fromIndex:int=0):int		{            if(item is Point){				return getPointIndex(arrayOrVector,item as Point,fromIndex);			} 			return arrayOrVector.indexOf(item,fromIndex);		}		private static function getPointIndex(arrayOrVector:*,item:Point,fromIndex:int=0):int		{			for (var i:int=fromIndex;i<arrayOrVector.length;i++){				var it:Object=arrayOrVector[i];				if(it is Point){					if((it as Point).equals(item)){						return i;					} 				}			}			return -1;		}		/**		 * Point类型的数组克隆，如果直接用array.concat，那么Point仍然是指向原数据，弄不好出错误很蹊跷		 * */		public static  function clonePointArray(arrayOrVector:Object):*		{			var narr:*=(arrayOrVector is Array)?[]:new Vector.<Point>();			var p:Point;			var max:int=arrayOrVector.length;			for(var i:int=0;i<max;i++){				p=arrayOrVector[i] as Point;				narr.push(p.clone());			}			return narr;		}					/**		 * 将元素item的索引位置设置成newIndex		 * @param arrayOrVector:目标数组或者Vector		 * @param item:目标对象，这个对象一般是一个复杂的自定义对象，如果是0,1,2这种数字你设置这个有什么意义？item可以不在数组中		 * @param newIndex:要设置的索引值,<0以0对待		 * 注:为何不会直接改变数组		 * */		public static function setItemIndex(arrayOrVector:Object,item:Object,newIndex:int):*		{			newIndex=Math.max(0,newIndex);			var oldIndex:int=getRealIndex(arrayOrVector,item);			if(newIndex==oldIndex) return arrayOrVector;			var offset:int=0;			if(newIndex>oldIndex) offset=1;			var uppers:*=arrayOrVector.slice(newIndex+offset,arrayOrVector.length);			var lowers:*=arrayOrVector.slice(0,newIndex+offset);			ArrayUtil.removeItem(uppers,item);			ArrayUtil.removeItem(lowers,item);			uppers.unshift(item);			arrayOrVector=lowers.concat(uppers);					return arrayOrVector;		}				/**			Removes only the specified items in an Array.						@param tarArray: Array to remove specified items from.			@param items: Array of elements to remove.			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);					ArrayUtil1.removeItems(numberArray, new Array(1, 3, 7, 5));					trace(numberArray);				</code>		*/		public static function removeItems(tarArray:Array, items:Array):Boolean {			var removed:Boolean = false;			var l:uint          = tarArray.length;						while (l--) {				var index:int=getRealIndex(items,tarArray[l]);				if (index> -1) {					tarArray.splice(l, 1);					removed = true;				}			}						return removed;		}				/**			Retains only the specified items in an Array.						@param tarArray: Array to remove non specified items from.			@param items: Array of elements to keep.			@return Returns <code>true</code> if the Array was changed as a result of the call; otherwise <code>false</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);					ArrayUtil1.retainItems(numberArray, new Array(2, 4));					trace(numberArray);				</code>		*/		public static function retainItems(tarArray:Array, items:Array):Boolean {			var removed:Boolean = false;			var l:uint        = tarArray.length;						while (l--) {				if (getRealIndex(items,tarArray[l]) == -1) {					tarArray.splice(l, 1);					removed = true;				}			}						return removed;		}				/**			Finds out how many instances of <code>item</code> Array contains.						@param inArray: Array to search for <code>item</code> in.			@param item: Object to find.			@return The amount of <code>item</code>'s found; if none were found returns <code>0</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 7, 7, 7, 4, 5);					trace("numberArray contains " + ArrayUtil1.contains(numberArray, 7) + " 7's.");				</code>		*/		public static function contains(inArray:Array, item:*):uint {			var i:int  = getRealIndex(inArray,item);			var t:uint = 0;						while (i != -1) {				i= getRealIndex(inArray,item,i+1);				t++;			}						return t;		}				/**			Determines if Array contains all items.						@param inArray: Array to search for <code>items</code> in.			@param items: Array of elements to search for.			@return Returns <code>true</code> if <code>inArray</code> contains all elements of <code>items</code>; otherwise <code>false</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 4, 5);					trace(ArrayUtil1.containsAll(numberArray, new Array(1, 3, 5)));				</code>		*/		public static function containsAll(inArray:Array, items:Array):Boolean {			var l:uint = items.length;						while (l--)				if (getRealIndex(inArray,items[l]) == -1)						return false;						return true;		}				/**			Determines if Array <code>inArray</code> contains any element of Array <code>items</code>.						@param inArray: Array to search for <code>items</code> in.			@param items: Array of elements to search for.			@return Returns <code>true</code> if <code>inArray</code> contains any element of <code>items</code>; otherwise <code>false</code>.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 4, 5);					trace(ArrayUtil1.containsAny(numberArray, new Array(9, 3, 6)));				</code>		*/		public static function containsAny(inArray:Array, items:Array):Boolean {			var l:uint = items.length;						while (l--)				if (getRealIndex(inArray,items[l]) > -1)						return true;						return false;		}				/**			Compares two Arrays and finds the first index where they differ.						@param first: First Array to compare to the <code>second</code>.			@param second: Second Array to compare to the <code>first</code>.			@param fromIndex: The location in the Arrays from which to start searching for a difference.			@return The first position/index where the Arrays differ; if Arrays are identical returns <code>-1</code>.			@example				<code>					var color:Array     = new Array("Red", "Blue", "Green", "Indigo", "Violet");					var colorsAlt:Array = new Array("Red", "Blue", "Green", "Violet");										trace(ArrayUtil1.getIndexOfDifference(color, colorsAlt)); // Traces 3				</code>		*/		public static function getIndexOfDifference(first:Array, second:Array, fromIndex:uint = 0):int {			var i:int = fromIndex - 1;						while (++i < first.length)				if (first[i] != second[i])					return i;						return -1;		}				/**			Creates new Array composed of passed Array's items in a random order.						@param inArray: Array to create copy of, and randomize.			@return A new Array composed of passed Array's items in a random order.			@example				<code>					var numberArray:Array = new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);					trace(ArrayUtil1.randomize(numberArray));				</code>		*/		public static function randomize(inArray:Array):Array {			var t:Array  = new Array();			var r:Array  = inArray.sort(ArrayUtil._sortRandom, Array.RETURNINDEXEDARRAY);			var i:int = -1;						while (++i < inArray.length)				t.push(inArray[r[i]]);						return t;		}				protected static function _sortRandom(a:*, b:*):int {			return Math.round(0 + (Math.random() * (1 - 0))) ? 1 : -1;								}				/**			Adds all items in <code>inArray</code> and returns the value.						@param inArray: Array composed only of numbers.			@return The total of all numbers in <code>inArray</code> added.			@example				<code>					var numberArray:Array = new Array(2, 3);					trace("Total is: " + ArrayUtil1.sum(numberArray));				</code>		*/		public static function sum(inArray:Array):Number {			var t:Number = 0;			var l:uint = inArray.length;						while (l--)				t += inArray[l];						return t;		}				/**			Averages the values in <code>inArray</code>.						@param inArray: Array composed only of numbers.			@return The average of all numbers in the <code>inArray</code>.			@example				<code>					var numberArray:Array = new Array(2, 3, 8, 3);					trace("Average is: " + ArrayUtil1.average(numberArray));				</code>		*/		public static function average(inArray:Array):Number {			if (inArray.length == 0)				return 0;						return ArrayUtil.sum(inArray) / inArray.length;		}				/**			Finds the lowest value in <code>inArray</code>.						@param inArray: Array composed only of numbers.			@return The lowest value in <code>inArray</code>.			@example				<code>					var numberArray:Array = new Array(2, 1, 5, 4, 3);					trace("The lowest value is: " + ArrayUtil1.getLowestValue(numberArray));				</code>		*/		public static function getLowestValue(inArray:Array):Number {			return inArray[inArray.sort(16|8)[0]];		}				/**			Finds the highest value in <code>inArray</code>.						@param inArray: Array composed only of numbers.			@return The highest value in <code>inArray</code>.			@example				<code>					var numberArray:Array = new Array(2, 1, 5, 4, 3);					trace("The highest value is: " + ArrayUtil1.getHighestValue(numberArray));				</code>		*/		public static function getHighestValue(inArray:Array):Number {			return inArray[inArray.sort(16|8)[inArray.length - 1]];		}	}}