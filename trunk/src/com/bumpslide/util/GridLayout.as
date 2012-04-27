﻿/** * This code is part of the Bumpslide Library by David Knape * http://bumpslide.com/ *  * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc. *  * Released under the open-source MIT license. * http://www.opensource.org/licenses/mit-license.php * see LICENSE.txt for full license terms */  package com.bumpslide.util {	import com.bumpslide.events.UIEvent;	import com.bumpslide.tween.FTween;	import com.bumpslide.tween.FTweenOptions;	import com.bumpslide.ui.IGridItem;	import com.bumpslide.ui.IResizable;	import com.bumpslide.ui.IScrollable;		import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IEventDispatcher;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.ui.Keyboard;	import flash.utils.Dictionary;	import flash.utils.Timer;
	/**	 * GridLayout is similar in nature to a Repeater, TileGrid, or List component.	 * 	 * GridLayout is not a display object.  You use it to populate a collection of 	 * display objects.  It takes care of attaching and updating the display objects	 * which should implement the IGridItem interface to support the passing in of	 * the 'gridItemData' and index information.	 * 	 * GridLayout needs to know only a few things:	 * 1 - What class of displayObject should be attached for each item in our 	 *     dataset (should implement IGridItem)	 * 2 - What data provider (an array or data provider [fl.data.DataProvider]) will be used to 	 *     populate this grid	 * 3 - How much space should we allocate for each column and row	 * 4 - How much space to we have to fill	 * 	 * Take a look at the gridlayout examples in the examples folder for more usage info.	 * 	 * @code{	 * Example:	 * 	 *   // sample grid item class	 *   package {	 *   import com.bumpslide.ui.GridItem;	 * 	 public class MyGridItemClass extends GridItem {	 * 	   public var label:TextField;	 * 	   override protected function drawGridItem():void {	 * 	     label.text = "Item " + gridItemData.id + ' ' + gridItemData.s;     	 * 	   }		 * 	 }	 * 	 }	 * 	 	 * 	 // then inside your view component, create a holder sprite and fill it with 	 * 	 // MyGridItemClass instances spaced 100px apart inside a space that is 300 x 300	 *   	 *   var gridHolder:Sprite = new Sprite();	 *      	 *   var grid:GridLayout = new GridLayout( gridHolder, MyGridItemClass, 100, 100);	 *   grid.setSize( 300, 300 );	 *   grid.dataProvider = [ {id:1, s:'foo'}, {id:2, s:'bar'}, {id:2, s:'foo'},	 *   					   {id:3, s:'bar'}, {id:4, s:'foo'}, {id:5, s:'bar'},	 *   					   {id:6, s:'foo'}, {id:7, s:'bar'}, {id:8, s:'foo'} ];	 *   					   	 *   addChild( gridHolder );		 *   	 *   //--	 * }	 * 	 * @see com.bumpslide.ui.GridItem	 * @see com.bumpslide.util.IGridItem	 * 	 * @author David Knape	 */	public class GridLayout extends EventDispatcher implements IScrollable, IResizable {
		//--- Events ---		static public const EVENT_CHANGED:String = "onGridLayoutChanged";		static public const EVENT_LAYOUT_COMPLETE:String = "onGridLayoutComplete";		static public const EVENT_MODEL_CHANGED:String = "onGridLayoutModelChanged";		static public const EVENT_ITEM_CLICK:String = "onGridItemClick";
		//--- Layout/Scrolling Modes ---		static public const HORIZONTAL:String = 'horizontal';		static public const VERTICAL:String = 'vertical';
		// whether or not to trace debug messages		public var debugEnabled:Boolean = false;        
		// how we layout clips and the direction we scroll		protected var _orientation:String = VERTICAL;
				// row/column sizes		protected var _rowHeight:Number = 100;		protected var _columnWidth:Number = 100;
		// number of rows and columns		protected var _rows:Number = 9999;		protected var _columns:Number = 9999;
		// target timeline (where holder will be created)		protected var _timeline:Sprite;
		// empty clip that holds items and is re-created every time we redraw		protected var _itemHolder:Sprite;	
		// display object class to attach (must implement IGridItem)		protected var _itemRenderer:Class;
		protected var _itemRendererMCClass:Class;		// dataprovider		protected var _dataProvider:*;	
		// array of all item clips		protected var _itemClips:Array;
		// dictionary of all active clips indexed by 		protected var _activeClips:Dictionary;
		// stack of un-assigned clips (to be recycled)		private var _spareClips:Array;
		// items indexed by value object		private var _itemsByVO:Dictionary;
		// height and width		protected var _width:Number = -1;		protected var _height:Number = -1;		protected var _requestedWidth:Number = 100;		protected var _requestedHeight:Number = 100;
		protected var _spacing:Number = 0;
		// update timer and delay		protected var _updateTimer:Timer;		protected var _updateDelay:Number = 0;
		// offset and scroll state		protected var _offset:Number = 0;		protected var _indexFirst:Number = 0;		protected var _indexLast:Number = 0; 
		// misc flags		protected var _isDrawn:Boolean = false;		protected var _changedWhileSleeping:Boolean = false;		protected var _modelChanged:Boolean = false;		protected var _sleeping:Boolean = false;				protected var _scrollRectDisabled:Boolean =false;				public var indexByValueObject:Boolean = false;
		/**		 * Creates a new grid layout		 */		function GridLayout( inTimeline:Sprite, inItemRendererClass:Class = null, inColumnWidth:Number = 100, inRowHeight:Number = 100, inWidth:Number = -1, inHeight:Number = -1, itemRendererMCClass:Class = null) {			_timeline = inTimeline;			_itemRenderer = inItemRendererClass;			_itemRendererMCClass = itemRendererMCClass;			rowHeight = inRowHeight;			columnWidth = inColumnWidth;            			reset();            			if(inWidth != -1 && inHeight != -1) {				setSize(inWidth, inHeight);			}		}
		/** 		 * Sizes the Grid		 * 		 * this updates the column and row count		 * based on the current rowHeight and columnWidth		 */		public function setSize(w:Number, h:Number):void {		     			_requestedWidth = Math.max( w, 0 );			_requestedHeight = Math.max( h, 0 );                        			if(_width == Math.round(w) && _height == Math.round(h)) return;            			//_sizeChanged = true;			stopTweening();						// remember approximately what we were looking at			var relative_index:Number = _offset / maxOffset;									_width = Math.floor(_requestedWidth);			_height = Math.floor(_requestedHeight); 						_rows = 1;			_columns = 1;						if(!isNaN(rowHeight) && rowHeight > 0) {				_rows = Math.max(1, (_height) / rowHeight); 				}						if(!isNaN(columnWidth) && columnWidth > 0) {				_columns = Math.max(1, (_width) / columnWidth);				}									debug('size set to ' + _width + 'x' + _height + ' rows=' + _rows + ', cols=' + _columns);									// try to match original position, but keep in bounds 			var new_offset:Number = relative_index * maxOffset;			offset = isNaN(new_offset) ? 0 : new_offset;						if(updateDelay > 0) updateNow();                   			// update scrollTarget to match constrained offset			_scrollTarget = _offset;		}
		/**		 * Reset and destroy all children		 */			public function destroy():void {			for each (var mc:IGridItem in _itemClips) {				mc.dispose();//				mc.destroy();			}			dataProvider = null; // triggers reset()		}
		/**		 * Update the grid - non-destructive		 */		protected function draw():void {								// If sleeping, wait until we are awake to redraw			if(_sleeping) {				debug('Updated while sleeping , waiting to wake');				_changedWhileSleeping = true;				return;			}			_changedWhileSleeping = false;						// Make sure we have what we need (data and itemRenderer)			if(dataProvider == null /*|| dataProvider.length == 0*/ || itemRenderer == null || _itemHolder == null) {				return;			}						debug('Updating to offset ' + _offset + ' (showing items ' + indexFirst + '-' + indexLast + ' of ' + length + ') (minOffset:' + minOffset + ', maxOffset:' + maxOffset + ')');									// update scroll rect			var scroll_rect:Rectangle = null;			var fractionalOffset:Number = (_offset - Math.floor(_offset));			if(_width > 0 && _height > 0 && !scrollRectDisabled) {	            				// offset main holder to simulate "scrolling"				scroll_rect = new Rectangle(0, 0, _width, _height);								if(orientation == HORIZONTAL) {	            						scroll_rect.x = Math.round(columnWidth * fractionalOffset); 				} else {					scroll_rect.y = Math.round(rowHeight * fractionalOffset);				}		            				_itemHolder.scrollRect = scroll_rect;			}  else {				_itemHolder.scrollRect = null;			}						// recycle any active clips that are no longer in use			recycleUnusedItems();									var mc:IGridItem;						if(length) for( var n:int = indexFirst;n <= _indexLast; n++) {								//debug('doUpdate item' + n);								// look for MC already assigned to this index and update its position				//mc = mClipMap['_'+n];				mc = _activeClips[n];								if(mc == null) {							// create new grid item (pull from stack of latent clips if there are some)					mc = getItemClip();                    					// update the item with proper data					updateItem(mc, n);						_itemHolder.addChild(mc as DisplayObject);	     						} else {											var pos:Point = calculateItemPosition(n);										// If this was triggered by a model change, check to see if 					// data has changed for this item index							if(_modelChanged) {						var item_data:Object = getDataForItem(n);						if(mc.gridItemData != item_data) {												//debug('updating exisiting clip (' + mc.gridIndex + '->' + n + ')');							updateItem(mc, n);						} else {							//debug('moving exisiting clip (' + mc.gridIndex + ')');							mc.x = pos.x;							mc.y = pos.y;     							if(mc is IResizable) {								(mc as IResizable).setSize(columnWidth - _spacing, rowHeight - _spacing);							}   						}					} else {						//debug('moving exisiting clip (' + mc.gridIndex + ')');						mc.x = pos.x;						mc.y = pos.y;     						if(mc is IResizable) {							(mc as IResizable).setSize(columnWidth - _spacing, rowHeight - _spacing);						}   					}									}			}								if(!_isDrawn) {				_isDrawn = true;				dispatchEvent(new UIEvent(EVENT_LAYOUT_COMPLETE, this));			}						if(_modelChanged) {				_modelChanged = false;				dispatchEvent(new UIEvent(EVENT_MODEL_CHANGED, this));					}						dispatchEvent(new UIEvent(EVENT_CHANGED, this));		}
		/**		 * put grid to sleep, grid won't respond to changes until awakened		 */		public function sleep():void {			debug('sleep');			_sleeping = true;		}
		/**		 * brings grid back to life, updates it if something has changed while we were sleeping		 */		public function wake():void {				debug('wake');			_sleeping = false;			if(_changedWhileSleeping) updateNow();		}
		/**		 * Clear items and reset		 */		public function reset():void {			            			Delegate.cancel(_updateTimer);			stopTweening();			_scrollTarget = 0;			_sleeping = false;			_changedWhileSleeping = false;			_isDrawn = false;            			if( _itemHolder != null && _timeline.contains(_itemHolder)) {				_timeline.removeChild(_itemHolder);				_itemHolder.removeEventListener(MouseEvent.CLICK, handleItemClickOrKeyPress);				_itemHolder.removeEventListener(KeyboardEvent.KEY_DOWN, handleItemClickOrKeyPress);			}			_itemHolder = new Sprite();						_itemHolder.addEventListener(MouseEvent.CLICK, handleItemClickOrKeyPress, false, 0, true);			_itemHolder.addEventListener(KeyboardEvent.KEY_DOWN, handleItemClickOrKeyPress, false, 0, true);			_timeline.addChild(_itemHolder);			_itemClips = new Array();			_spareClips = new Array();   			_activeClips = new Dictionary();					_itemsByVO = new Dictionary();						if(_dataProvider && _dataProvider is IEventDispatcher) {				var ed:IEventDispatcher = dataProvider as IEventDispatcher;				// listen for fl.data.DataProvider and mx.collections.ArrayCollection change events				ed.removeEventListener('dataChange', onDataChange);				ed.removeEventListener('collectionChange', onCollectionChange );			}						_dataProvider = null;			_offset = 0;						invalidate();		}
		public function stopTweening():void {			FTween.stopTweening(this, 'offset');		}
		private function handleItemClickOrKeyPress(event:Event):void {			if(event.target is IGridItem && (!(event is KeyboardEvent) || (event as KeyboardEvent).keyCode==Keyboard.ENTER)) {				var item:IGridItem = event.target as IGridItem;				UIEvent.send(event.target as DisplayObject, EVENT_ITEM_CLICK, item.gridItemData);			}		}				public function updateNow(e:Event = null):void {			Delegate.cancel(_updateTimer);			draw();		}
		/**		 * Returns the display object for the given index or null if it is not rendered		 */		public function getGridItemAt( idx:int ):IGridItem {			var item:IGridItem = _activeClips[idx];			return item;		}
		/**		 * Handles fl.data.DataProvider change events		 * 		 * note, we don't explicity reference the flash dataprovider to keep this code portable		 */		protected function onDataChange(e:Event):void {			_modelChanged = true;			debug('onDataChange ' + e['changeType']);			debug('dataProvider.length=' + dataProvider.length);									// if items are removed from the middle, we want to keep the remaining 			// items bound to the same data.  The problem is that if we just use the 			// normal _activeClips indexes, the clip recycling will simply chop extra 			// ones off the end.  By keeping items indexed by the value object that is 			// inside them, we can move them around and re-index to avoid invalidation 			// on all the grid items			// Problem, of course, is if the same value object is located at more than 			// one index.  For now, we take that risk.  Don't do that.			// Or, at least, don't do fancy data provider stuff when doing that.			if( e['changeType'] == 'remove') {								// get start and end index				var startIndex:uint = e['startIndex'];				var endIndex:uint = e['endIndex'];								// recyle clips (usually just one)				for(var n:uint = startIndex;n <= endIndex; n++) {					recycleItem(n);				}										// re-index exisiting items				if(indexByValueObject) {					_activeClips = new Dictionary();					var len:uint = length;					for( var i:uint = 0;i < len; i++) {						var item:IGridItem = _itemsByVO[ getDataForItem(i) ] as IGridItem;						if(item != null) {							item.gridIndex = i;							_activeClips[i] = item;						}					}				}				}			invalidate();		}				/**		 * Handle ArrayCollection (flex) collection change events		 */		protected function onCollectionChange(e:Event):void {			_modelChanged = true;			invalidate();		}
		/**		 * Schedules an update after a slight delay		 */		protected function invalidate():void {								// constrain offset			_offset = Math.max(minOffset, Math.min(maxOffset, _offset));																//debug('offset constrained to ' + _offset);						var items_per_offset_unit:Number = Math.floor((orientation == VERTICAL) ? columns : rows);			var last_unit:Number = Math.ceil(_offset + offsetUnitsPerPage) + 1;  			// add one for read-ahead / smooth scrolling			_indexFirst = Math.floor(_offset) * items_per_offset_unit;			_indexLast = Math.max(Math.min(last_unit * items_per_offset_unit - 1, length - 1), 0);						// update after delay			Delegate.cancel(_updateTimer);				if(updateDelay > 0) { 				_updateTimer = Delegate.callLater(updateDelay, updateNow);			} else {				updateNow();			}		}
		/**		 * Checks to see if an item instance is used in the current view.  		 * 		 * If no longer needed, the clip is removed from the display list and 		 * added to the list of spare clips where it can be re-used later.		 */		protected function recycleUnusedItems():void {						for each( var item:IGridItem in _activeClips ) {								if(( item.gridIndex < indexFirst || item.gridIndex > indexLast || length == 0 ) ) {					recycleItem(item.gridIndex);				}			}		}
		/**		 * Recycles an individual grid item		 */		protected function recycleItem(idx:uint):void {			var item:IGridItem = _activeClips[ idx ] as IGridItem;			debug('recycling clip ' + item.gridItemData);			delete _activeClips[idx];			delete _itemsByVO[item.gridItemData];			//_activeClips.splice( idx, 1);              			item.gridIndex = Number.NaN;			item.gridItemData = null;			_itemHolder.removeChild(item as DisplayObject);			_spareClips.push(item);		}
		/**		 * Get spare item clip or create a new one		 */		protected function getItemClip():IGridItem {			var item:IGridItem;            			if(itemRenderer == null) {				throw new Error("Unabled to return an item renderer when the itemRendererClass is null");				return null;			}			// If we have some spare, unused clips, use them 			if(!_spareClips.length) { 				if(_itemRendererMCClass){					item = new itemRenderer(new _itemRendererMCClass) as IGridItem;				}else{					item = new itemRenderer() as IGridItem;				}								if(item == null) {					throw new Error("Invalid Item Renderer - " + itemRenderer + " (possibly not an IGridItem)");					return null;				}				debug('created new clip ' + item['name']);				// hold on to this for future use				_itemClips.push(item); 			} else {	                						item = _spareClips.pop() as IGridItem;				debug('re-using old clip ' + item['name']);				}					return item;		}		
		protected function updateItem( item:IGridItem, idx:int ):void {				debug('update item ' + idx + ' ' + item);	                        try {            	item['layout'] = this; // if item needs reference to layout, update it             } catch(e:Error) {};            			item.gridIndex = idx;			item.gridItemData = getDataForItem(idx);                        				var pos:Point = calculateItemPosition(idx);			item.x = pos.x;			item.y = pos.y;		            			if(item is IResizable) {				(item as IResizable).setSize(columnWidth - _spacing, rowHeight - _spacing);			}			//mClipMap['_'+idx] = item;			_activeClips[idx] = item;			if(indexByValueObject) {				_itemsByVO[ item.gridItemData ] = item;			}		}
		protected function getDataForItem(idx:uint):* {			return dataProvider.getItemAt != undefined ? dataProvider.getItemAt(idx) : dataProvider[idx];		}
		/**		 * Calculated the x and y pos for the grid item at index n		 * 		 * @param	i		 * @return x,y location as point		 */		protected function calculateItemPosition( n:Number ):Point {								var i:int = n - indexFirst;			var column:int;			var row:int;								// calculate grid index (column and row)			if(orientation == HORIZONTAL) {				row = i % Math.floor(rows);				column = rows > 0 ? Math.floor(i / Math.floor(rows)) : 0;					} else {				column = i % Math.floor(columns);				row = columns > 0 ? Math.floor(i / Math.floor(columns)) : 0;					}			return new Point(Math.round(columnWidth * column), Math.round(rowHeight * row));		}
		/**		 * Debug/trace		 */		private function debug(s:*):void {			if(debugEnabled) trace('[GridLayout] ' + s);		}
		//-------------------------------------		// GETTERS/SETTERS		//-------------------------------------				/**		 * array of references to all the grid item MovieClips currently being rendered		 * items are sorted by their index position		 */		public function get itemClips():Array {			var a:Array = new Array();			for each (var item:IGridItem in _activeClips) {				a.push(item);			}			a.sortOn('gridIndex', Array.NUMERIC);			return a;
		}
		/**		 * an array of arrays of item clips sorted by row		 */		public function get itemClipsByRow():Array {			var a:Array = new Array();        				for(var n:int = indexFirst;n <= indexLast; n++) {				var row:int = calculateItemPosition(n).y / rowHeight;				if(a[row] == null) a[row] = new Array();				if(_activeClips[n] != null) {					a[row].push(_activeClips[n]);				}			}			return a;		}
		/**		 * an array of arrays of item clips sorted by column		 */		public function get itemClipsByColumn():Array {			var a:Array = new Array();        				for(var n:int = indexFirst;n <= indexLast; n++) {				var col:int = calculateItemPosition(n).x / columnWidth;				if(a[col] == null) a[col] = new Array();				if(_activeClips[n] != null) {					a[col].push(_activeClips[n]);				}			}			return a;		}
		/**		 * An array or fl.data.DataProvider		 * 		 * @return array of item data		 */		public function get dataProvider():* {			return _dataProvider;		}
		/**		 * Sets the data provider for the grid		 *  		 * @param data Array or fl.data.DataProvider		 */		public function set dataProvider( dp:* ):void {        				reset();        				if(dp == null) {				debug('dataProvider is null');				return;			}			_dataProvider = dp;									if(dp is IEventDispatcher) {				var edp:IEventDispatcher = dp as IEventDispatcher;				edp.addEventListener('dataChange', onDataChange);				indexByValueObject = true;			} else {				indexByValueObject = false;			}										debug('setting dataProvider, length=' + dataProvider.length);												invalidate();		}
		/**		 * returns length of the dataprovider (total number of items in grid)		 * @return		 */		public function get length():int {			if(dataProvider != null) return dataProvider.length;			else return 0;		}
		/**		 * returns reference to timeline		 * @return		 */		public function get timeline():DisplayObject {			return _timeline;		}
		/**		 * Where the items are located		 */		public function get itemHolder():Sprite {			return _itemHolder;		}
		/**		 * offset in dataprovider (index of first item in the grid)		 * 		 * @param	n		 */		public function get offset():Number {			return _offset;		}
		/**		 * offset in dataprovider (index of first item in the grid)		 * 		 * @param	n		 */		public function set offset( inOffset:Number ):void {						if(isNaN(inOffset)) {				//throw new Error('Offset cannot be set to ' + inOffset );				//debug('ERROR - offset cannot be set to ' + inOffset);				return;			}					debug('offset set to ' + inOffset);					_offset = inOffset;			               			invalidate();		}
		/**		 * Rows or Columns per page		 */		public function get offsetUnitsPerPage():Number {			if(orientation == VERTICAL) {				return Math.floor(rows);			} else {				return Math.floor(columns);			}		}
		/**		 * Returns the total number of pages 		 * 		 * This is calculated using the  current dataprovider and the number of items per page		 * 		 * This is useful for displaying page info in controls and things like that.		 * 		 * @return		 */		public function get totalPages():Number {					return Math.ceil(length / offsetUnitsPerPage);		}
		/**		 * Minimum scroll offset		 */		public function get minOffset():Number {					return 0;		}
		/**		 * Maximum scroll offset		 */		public function get maxOffset():Number {					if (dataProvider == null || dataProvider.length == 0) {				return 0;			} else {				return totalSize - visibleSize;			}		}
		/**		 * Zero-index page number based on current offset		 */		public function get page():int {			return Math.floor(offset / offsetUnitsPerPage);		}
		/**		 * sets the page number (0 is first page)		 */		public function set page( num:int ):void {					scrollPosition = offsetUnitsPerPage * num;		}
		/**		 * go to the next page		 */		public function pageNext():void {			debug('pageNext()');			scrollPosition += offsetUnitsPerPage;		}
		/**		 * go to the previous page		 */		public function pagePrevious():void {			debug('pagePrevious()');			scrollPosition -= offsetUnitsPerPage;		}
		/**		 * delay before updates		 */		public function get updateDelay():Number {			return _updateDelay;		}
		/**		 * delay before updates		 */		public function set updateDelay(updateDelay:Number):void {			_updateDelay = updateDelay;		}
		/**		 * index of first child item being rendered		 */		public function get indexFirst():Number {			return _indexFirst;		}
		/**		 * index of last child item being rendered		 */		public function get indexLast():Number {			return _indexLast;		}
		/**		 * the class that will be used to construct child items		 */		public function get itemRenderer():Class {			return _itemRenderer;		}
		/**		 * the class that will be used to construct child items		 */		public function set itemRenderer(itemRenderer:Class):void {			debug('Item renderer changed to ' + itemRenderer );			_itemRenderer = itemRenderer;			destroy();			updateNow();		}
		public function get rowHeight():Number {			return _rowHeight;		}
		public function set rowHeight(rowHeight:Number):void {			_rowHeight = rowHeight;			invalidate();		}
		public function get columnWidth():Number {			return _columnWidth;		}
		public function set columnWidth(columnWidth:Number):void {			_columnWidth = columnWidth;			invalidate();		}
		public function get orientation():String {			return _orientation;		}
		public function set orientation(direction:String):void {			_orientation = direction;			invalidate();			// invalidate size			//setSize(_requestedWidth, _requestedHeight);		}
		public function get rows():Number {			return _rows;		}
		public function set rows(rows:Number):void {			_rows = rows;		}
		public function get columns():Number {			return _columns;		}
		public function set columns(columns:Number):void {			_columns = columns;		}
		public function get spacing():Number {			return _spacing;		}
		public function set spacing(spacing:Number):void {			_spacing = spacing;			//setSize(_requestedWidth, _requestedHeight);		}
		//----------------------------		// IScrollable Implementation		//----------------------------		private var _scrollTarget:Number = 0;
		public var tweeningEnabled:Boolean = true;
		public var scrollTweenEaseFactor:Number = .3;
		// total size - measured in terms of rows or columns		public function get totalSize():Number {			if(length == 0) return 0;			if(orientation == VERTICAL) {				// total number of rows (round up to show whole row)				return Math.ceil(length / columns) - spacing / rowHeight;			} else {				// total number of columns (round up to show whole column)				return Math.ceil(length / rows) - spacing / columnWidth;			}		}
		public function get visibleSize():Number {			return (orientation == VERTICAL) ? rows : columns;		}
		public function get scrollPosition():Number {			return _scrollTarget;		}
		/**		 * Scroll position indexed by row or column (oritentation vert, horiz respectively)		 */		public var ftOptions:FTweenOptions;		public function tweenUpdate(completeFun:Function, updateFun:Function = null):void		{			ftOptions = new FTweenOptions(0,.01,.01,30,false,false,completeFun,updateFun);		}		public function set scrollPosition(scrollOffset:Number):void {						// instant updates if we are scrolling			updateDelay = 0;						_scrollTarget = Math.max(Math.min(scrollOffset, maxOffset), minOffset);						if(tweeningEnabled) {				FTween.ease(this, 'offset', _scrollTarget, scrollTweenEaseFactor, ftOptions);			} else {				stopTweening();				offset = _scrollTarget;			}		}
		
		public function get scrollRectDisabled():Boolean {			return _scrollRectDisabled;
		}
		
		public function set scrollRectDisabled(scrollRectDisabled:Boolean):void {			_scrollRectDisabled = scrollRectDisabled;			invalidate();
		}	}}