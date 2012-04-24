package com.bumpslide.ui
{
	import com.bumpslide.ui.BaseClip;
	import com.bumpslide.ui.LabelButton;
	import com.longame.utils.Reflection;
	import com.longame.utils.debug.Logger;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 翻页组建
	 * maxPages,itemsInPage分别是页数和每页的单元数，要设，另外单元格用item0,item1...的形式命名
	 * */
	public class PageComponent extends BaseClip
	{
		[Child]
		public var pageTxt:TextField;
		[Child]
		public var prevButton:LabelButton;
		[Child]
		public var nextButton:LabelButton;
		[Child]
		public var firstButton:LabelButton;
		[Child]
		public var lastButton:LabelButton;
		
		public var  itemsInPage:int;
		/**
		 * 根据data的长度自动计算最大页数
		 * */
		protected var autoCalMaxPages:Boolean=true;
		/**
		 *当页面数据不存在时，自动加载数据
		 * */
		protected var autoLoadPage:Boolean=false;
		
		public function PageComponent(itemsInPage:int,maxPages:int=int.MAX_VALUE)
		{
			super();
			this.itemsInPage=itemsInPage;
			this.maxPages=maxPages;
		}
		override protected function whenSkinned():void
		{
			super.whenSkinned();
			if(pageTxt){
				pageTxt.selectable=false;
				pageTxt.mouseEnabled=false;
			}
			if(prevButton) prevButton.addEventListener(MouseEvent.CLICK,prevPage);
			if(nextButton) nextButton.addEventListener(MouseEvent.CLICK,nextPage);
			if(firstButton) firstButton.addEventListener(MouseEvent.CLICK,firstPage);
			if(lastButton) lastButton.addEventListener(MouseEvent.CLICK,lastPage);
			this.addEventListener(MouseEvent.CLICK,checkItemClick);
		}
		override protected function whenDataChanged():void
		{
			if(autoCalMaxPages&&_data&&_data.hasOwnProperty("length")){
				this._maxPages=Math.ceil(_data.length/this.itemsInPage);
			}
			if(this._currentPage>-1) this.refreshPage();
		}
		override protected function doDestroy():void
		{
			if(prevButton)	prevButton.removeEventListener(MouseEvent.CLICK,prevPage);
			if(nextButton)	nextButton.removeEventListener(MouseEvent.CLICK,nextPage);
			if(firstButton) firstButton.removeEventListener(MouseEvent.CLICK,firstPage);
			if(lastButton) lastButton.removeEventListener(MouseEvent.CLICK,lastPage);
			this.removeEventListener(MouseEvent.CLICK,checkItemClick);
			super.doDestroy();
		}
		protected var  _maxPages:int=0;
		public function get maxPages():int
		{
			return _maxPages;
		}
		public function set maxPages(value:int):void
		{
			if(_maxPages==value) return;
			_maxPages=value;
			if(pageTxt) pageTxt.text=_currentPage+"/"+_maxPages;
			this.updateButtonState();
		}
		protected function prevPage(event:MouseEvent):void
		{
			this.currentPage--;
		}
		protected function nextPage(event:MouseEvent):void
		{
			this.currentPage++;
		}
		protected function lastPage(event:MouseEvent):void
		{
			this.currentPage=1;
		}
		protected function firstPage(event:MouseEvent):void
		{
			this.currentPage=this._maxPages;
		}
		protected var _currentPage:int=0;
		public function get currentPage():int
		{
			return _currentPage;
		}
		public function set currentPage(value:int):void
		{
			value=Math.max(1,value);
			value=Math.min(_maxPages,value);
			if(_currentPage==value) return;
			_currentPage=value;
			if(pageTxt) pageTxt.text=_currentPage+"/"+_maxPages;
			this.updateButtonState();
			this.updatePage();
		}
		public function refreshPage():void
		{
			var cp:int=this._currentPage;
			_currentPage=cp-1;
			this.currentPage=cp;
		}
		protected function updateButtonState():void
		{
			if(this.disposed) return;
			if(prevButton) prevButton.enabled=(_currentPage>1);
			if(nextButton) nextButton.enabled=(_currentPage<_maxPages);
			if(firstButton) firstButton.enabled=(_currentPage>1);
			if(lastButton) lastButton.enabled=(_currentPage<_maxPages);
		}
		protected function updatePage():void
		{
			//当前页还没加载呢
			if(autoLoadPage&&((this.data==null)||(this.data[getItemIndex(0)]==null))){
				this.loadPage();
				return;
			}
			for(var i:int=0;i<itemsInPage;i++){
				this.updateItem(this["item"+i],i,getItemIndex(i));
			}
		}
		/**
		 * 动态加载当前页，注意加载完毕设置data就ok了，自动刷新当前页
		 * */
		protected function loadPage():void
		{
			Logger.info(this,"loadPage","The page: "+this._currentPage+" data is null, try to load...");
		}
		/**
		 * 检查是否有item被点击
		 * */
		private function checkItemClick(event:MouseEvent):void
		{
			var obj:DisplayObject=event.target as DisplayObject;
			while(obj){
				if(obj is itemClass){
					this.whenItemClicked(obj);
					break;
				}
				if(obj==this) break;
				obj=obj.parent;
			}
		}
		/**
		 * 处理item被点击事件
		 * */
		protected function whenItemClicked(item:*):void
		{
			
		}
		protected var _itemClass:Class;
		public function get itemClass():Class
		{
			if(_itemClass) return _itemClass;
			_itemClass=Reflection.getClass(this["item0"]);
			return _itemClass;
		}
		/**
		 * 根据item0中的0序号获取其在总item中是第几号，从0开始，比如第一页的第二个是1，第二页的第一个是多少呢
		 * */
		protected function getItemIndex(i:int):int
		{
			return (currentPage-1)*itemsInPage+i;
		}
		/**
		 * 更新item也就是Child标签定义的item
		 * @param item 对象
		 * @param indexInPage 对象在当前页的索引
		 * @param indexInData 对象在整个数据链中的索引
		 * */
		protected function updateItem(item:*,indexInPage:int,indexInData:int):void
		{
			if(item.hasOwnProperty("index")){
				item.index=indexInPage;
			}
			if(this.data) item.data=this.data[indexInData];
			else item.data=null;
		}
	}
}