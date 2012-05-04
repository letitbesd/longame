﻿ /**
 * This code is part of the Bumpslide Library maintained by David Knape
 * Fork me at http://github.com/tkdave/bumpslide_as3
 * 
 * Copyright (c) 2010 by Bumpslide, Inc. 
 * http://www.bumpslide.com/
 *
 * This code is released under the open-source MIT license.
 * See LICENSE.txt for full license terms.
 * More info at http://www.opensource.org/licenses/mit-license.php
 */

package com.bumpslide.util 
	 * 
	 * @see com.bumpslide.ui.Grid
		protected var _scrollRectOffset:Number = 0;
				setSize( 100, 100 );
			}
			
			var items_per_offset_unit:Number = Math.floor((orientation == VERTICAL) ? columns : rows);
			
			var last_unit:Number;
			
			// render in batches (experimental, not always a good idea)
			if(renderInBatches) {
				var page_size:Number = Math.ceil( offsetUnitsPerPage * renderBatchPageCount );
				var first_unit:Number = Math.floor( _offset / page_size ) * page_size;
				last_unit = first_unit + page_size + offsetUnitsPerPage + 1;
				_indexFirst = first_unit * items_per_offset_unit;
				_indexLast = last_unit * items_per_offset_unit - 1;
			} else {
				// render on demand one at a time
				// (add one so fractionally visible items are included)
				last_unit = Math.ceil( _offset + offsetUnitsPerPage + 1);
				_indexFirst = Math.floor(_offset) * items_per_offset_unit;
				_indexLast = last_unit * items_per_offset_unit - 1;
			}	
			
			_indexFirst = Math.max(Math.min(_indexFirst, length - 1), 0);
			_indexLast = Math.max(Math.min(_indexLast, length - 1), 0);
			
			debug('Updating to offset ' + _offset + ' (showing items ' + indexFirst + '-' + indexLast + ' of ' + length + ') (minOffset:' + minOffset + ', maxOffset:' + maxOffset + ')');
			// there is a limit to how high x can be (int.MAX_VALUE/20)
			// we need to shift the scrollRect and move items accordingly
			
			// When this happens, all active clips are moved and the scrollRect is shifted
			// this causes rollover states and mouse hand cursors to flciker when items are buttons
			// it also makes for a stutter in animation. 
			
			// This is how often (in pixels) the scrollRect offset will change
			var max_x:Number = 1E6;
			var px_per_offset:Number = (orientation == HORIZONTAL) ? columnWidth : rowHeight;
			var offset_page_size:Number = Math.floor( max_x / px_per_offset );
			
			_scrollRectOffset = Math.floor( _offset / offset_page_size ) * offset_page_size;
			
			
						positionItem(mc, n);
						    
			
			_sizeChanged = false;
			//_itemHolder.cacheAsBitmap = true;	// we are better off bitmap caching individual cells	
			_scrollRectOffset = 0;
				if(captureClickEvents) event.stopPropagation();
			
			// constrain offset
			_offset = Math.max(minOffset, Math.min(maxOffset, _offset));
													
			//debug('offset constrained to ' + _offset);
			
			
			
			
			// fl.events.DataChangeType.REMOVE
				// items from startIndex to endIndex (inclusive) should be removed
				// any items that come after those should have their offset index adjusted
				
				// get start and end index from the change event 
				// This should be an event of type DataChangeType.REMOVE
				
				
				// since we are removing items, update affected indexes before we invalidate 
				// so that item data stays tied to the same items
				var altered_items:Array = [];
				var item:IGridItem;
				for each (item in _activeClips) {
					var i:Number = item.gridIndex;
					if(i>endIndex) {
						item = _activeClips[i] as IGridItem;
						//trace('moving item from index ' + i + ' to index ' + (item.gridIndex-count));
						delete _activeClips[item.gridIndex];
						item.gridIndex -= count;
						altered_items.push( item );
					}
				}
				
				for each (item in altered_items) {
					_activeClips[item.gridIndex] = item;
				}
			if(item==null || ! _itemHolder.contains(item as DisplayObject)) return;
		
		protected function positionItem( item:IGridItem, idx:Number ):void {
			if(disablePositioning) return;
			var pos:Point = calculateItemPosition(idx);
			item.x = pos.x;
			item.y = pos.y;
		}
				ed.addEventListener('collectionChange', onCollectionChange );		
		 * 
		 * Note that this may or may not be visible.
			_rowHeight = rowHeight;
			_sizeChanged = true;
			if(columnWidth==_columnWidth) return;
			_sizeChanged = true;
		}
		