package com.longame.display.tip
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;
	import com.longame.managers.ProcessManager;
	import com.longame.utils.DisplayObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class InfoBubble extends Sprite
	{
		/**
		 * 出现或消失的时间，0表示立即
		 * */
		public var tweenDuration:Number=0;
		/**
		 * 箭头的方向，-1,0,1,2,3，分别表示不显示箭头/上/下/左/右,默认箭头在下边
		 * 取值见：Direction.LEFT,Direction.RIGHT...
		 * */
		public var direction:int=0;
		//defaults
		protected var _defaultWidth:Number =180;
		//showTime
		protected var _stayTime:int;
		//文字与边框的间距
		protected var _buffer:Number =6;
		protected var _cornerRadius:Number = 12;
		protected var _bgColors:Array = [0xFFFFFF, 0x9C9C9C];
		protected var _autoSize:Boolean = true;
		protected var _hookSize:Number = 10;
		
		//offsets
		protected var _hookPos:Number;
		//objects
		protected var bg:Sprite;
		protected var canvas:Sprite;
		//formats
		protected var _titleFormat:TextFormat;
		protected var _contentFormat:TextFormat;
		
		protected var inShowing:Boolean;
		protected var inHiding:Boolean;
		
		public function InfoBubble()
		{
			super();
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
//			this.cacheAsBitmap=true;
			this.initTextFormat();
		}
		/**
		 * 显示一个气泡
		 * @param tiltle:标题
		 * @param content:显示的内容
		 * @param delay:延迟多少秒显示
		 * @param stayTime:显示多少秒自动关闭
		 * */
		public function show(title:String,content:String=null,icon:DisplayObject=null,delay:int=0,stayTime:int=-1):void
		{
			if(inShowing) return;
			if(inHiding){
				hidingTween.paused=true;
				this.alpha=1;
				inHiding=false;
				this.removeChild(this.canvas);
				this.removeChild(this.bg);
				return;
			}
			inShowing=true;
			bg=new Sprite();
			this.addChild(bg);
			canvas=new Sprite();
			this.addChild(canvas);
			
			this.alpha=0;
			if(delay>0){
				ProcessManager.schedule(delay*1000,this,doShow,[title,content,icon]);
			}else{
				this.doShow(title,content,icon);
			}
			if(stayTime>0) this._stayTime=stayTime*1000;
		}
		/**
		 * 将info显示在目标的边框，根据direction将info的位置移到上部中央，下部中央。。。
		 * */
		public function snapToTarget(target:DisplayObject,direction:int=-1):void
		{
			var bounds:Rectangle=target.getBounds(target.stage);
			this.snapToBounds(bounds,direction);
		}
		/**
		 * 将info显示在某个范围的边框，根据direction将info的位置移到上部中央，下部中央。。。
		 * bounds应该是全局坐标系下的bounds
		 * */
		public function snapToBounds(bounds:Rectangle,direction:int=-1):void
		{
			if(this.direction>-1) this.direction=direction;
			switch(this.direction){
				case 0:
					this.y=bounds.top;
					this.x=(bounds.left+bounds.right)/2;
					break;
				case 1:
					this.y=bounds.bottom;
					this.x=(bounds.left+bounds.right)/2;
					break;
				case 2:
					this.y=(bounds.top+bounds.bottom)/2;
					this.x=bounds.left;
					break;
				case 3:
					this.y=(bounds.top+bounds.bottom)/2;
					this.x=bounds.right;
					break;
			}
		}
		private function doShow(title:String,content:String,icon:DisplayObject):void
		{
			this.addContent(title,content,icon);
			this.drawBg();
			this.bgGlow();
			this.updateTxtPosition();
			if(this._stayTime>0){
				ProcessManager.schedule(this._stayTime,this,hide);
			}
			if(tweenDuration>0) var gt:GTween=GTweener.to(this,tweenDuration,{alpha:1});
			else this.alpha=1;
		}
		private var hidingTween:GTween;
		public function hide():void
		{
			if(!inShowing) return;
			inShowing=false;
			if(inHiding) return;
			inHiding=true;
			if(tweenDuration>0) {
				hidingTween=GTweener.to(this,tweenDuration,{alpha:0});
				hidingTween.onComplete=this.doHide;
			}else{
				this.alpha=0;
				this.doHide();
			}
		}
		protected function doHide(g:GTween=null):void
		{
			inHiding=false;
			if(this.parent) this.parent.removeChild(this);
			this.removeChild(this.canvas);
			this.removeChild(this.bg);
		}
		protected function initTextFormat():void
		{
			//标题格式
			_titleFormat = new TextFormat();
			_titleFormat.font = "_sans";
			_titleFormat.bold = true;
			_titleFormat.size = 14;
			_titleFormat.color = 0x333333;
			//内容格式
			_contentFormat = new TextFormat();
			_contentFormat.font = "_sans";
			_contentFormat.bold = false;
			_contentFormat.size = 12;
			_contentFormat.color = 0x333333;
		}
		private function updateTxtPosition():void
		{
			this.removeChild(this.canvas);
			switch(this.direction){
				case 0:
					this.canvas.x=-this.bounds.width/2;
					this.canvas.y=-this.bounds.height;
					break;
				case 1:
					this.canvas.x=-this.bounds.width/2;
					this.canvas.y=this._hookSize;
					break;
				case 2:
					this.canvas.x=-this.bounds.width;
					this.canvas.y=-this.bounds.height/2;
					break;
				case 3:
					this.canvas.x=this._hookSize;
					this.canvas.y=-this.bounds.height/2;
					break;
			}
			this.addChild(this.canvas);
		}
		
		private var bgWidth:Number;
		private var bgHeight:Number;
		protected function drawBg():void {
			var fillType:String = GradientType.LINEAR;
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			var radians:Number =(this.direction>=2)?0:(90 * Math.PI / 180);
			var bgWidth:Number=(this.direction>=2)?(this.bounds.height+this._buffer*2):this._defaultWidth;
			var bgHeight:Number=(this.direction>=2)?this._defaultWidth:(this.bounds.height+this._buffer*2);
			if(this.direction>=2) 	matr.createGradientBox(this.bounds.height+this._buffer*2, this._defaultWidth, radians, 0, 0);
			else matr.createGradientBox(this._defaultWidth,this.bounds.height+this._buffer*2, radians, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			this.bg.graphics.beginGradientFill(fillType, this._bgColors, alphas, ratios, matr, spreadMethod); 
			
			if(this.direction>-1){
				if(this.direction==2){
					this.bg.rotation=-90;
				}else if(this.direction==3){
					this.bg.rotation=90;
				}else if(this.direction==1){
					this.bg.rotation=180;
				}
				this.bg.graphics.moveTo(0,0);
				this.bg.graphics.lineTo(this._hookSize,-this._hookSize);
				this.bg.graphics.lineTo(bgWidth/2-this._cornerRadius,-this._hookSize);
				this.bg.graphics.curveTo(bgWidth/2,-this._hookSize,bgWidth/2,-this._hookSize-this._cornerRadius);
				this.bg.graphics.lineTo(bgWidth/2,-bgHeight-this._hookSize+this._cornerRadius);
				this.bg.graphics.curveTo(bgWidth/2,-bgHeight-this._hookSize,bgWidth/2-this._cornerRadius,-bgHeight-this._hookSize);
				this.bg.graphics.lineTo(-bgWidth/2+this._cornerRadius,-bgHeight-this._hookSize);
				this.bg.graphics.curveTo(-bgWidth/2,-bgHeight-this._hookSize,-bgWidth/2,-bgHeight-this._hookSize+this._cornerRadius);
				this.bg.graphics.lineTo(-bgWidth/2,-this._hookSize-this._cornerRadius);
				this.bg.graphics.curveTo(-bgWidth/2,-this._hookSize,-bgWidth/2+this._cornerRadius,-this._hookSize);
				this.bg.graphics.lineTo(-this._hookSize,-this._hookSize);
				this.bg.graphics.lineTo(0,0);
				this.bg.graphics.endFill();
			}else{
				this.bg.graphics.drawRoundRect( 0, 0, bgWidth, bgHeight, this._cornerRadius );
			}
		}
		protected function addContent( title:String, content:String,icon:DisplayObject):void {
			var titleIsDevice:Boolean = this.isDeviceFont(  _titleFormat );
			//添加标题
			var tf:TextField = this.createField( titleIsDevice ); 
			tf.htmlText = title;
			tf.setTextFormat( this._titleFormat, 0, title.length );
			if( this._autoSize ){
				this._defaultWidth = tf.textWidth + 4 + ( _buffer * 2 );
			}else{
				tf.width = this._defaultWidth - ( _buffer * 2 );
			}
			
			tf.x = tf.y = this._buffer;
			this.textGlow( tf );
			this.canvas.addChild( tf );
			//添加图示
			if(icon!=null){
				var cp:Point=DisplayObjectUtil.getCenter(icon);
				icon.x=this._buffer+icon.width/2-cp.x
				icon.y=this.canvas.height+5+icon.height/2-cp.y
				this.canvas.addChild(icon)
			}
			//添加内容
			if( content != null ){
				//check for device font
				var contentIsDevice:Boolean = this.isDeviceFont(  _contentFormat );
				var cf:TextField = this.createField( contentIsDevice );
				cf.htmlText = content;
				
				cf.x = this._buffer;
				cf.y = this.canvas.height + 5;
				this.textGlow( cf );
				cf.setTextFormat( this._contentFormat );
				if( this._autoSize ){
					var cfWidth:Number = cf.textWidth + 4 + ( _buffer * 2 )
					this._defaultWidth = cfWidth > this._defaultWidth ? cfWidth : this._defaultWidth;
				}else{
					cf.width = this._defaultWidth - ( _buffer * 2 );
				}
				this.canvas.addChild( cf );	
			}
		}
		protected function createField( deviceFont:Boolean ):TextField {
			var tf:TextField = new TextField();
			tf.embedFonts = ! deviceFont;
			tf.gridFitType = "pixel";
			//tf.border = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			if( ! this._autoSize ){
				tf.multiline = true;
				tf.wordWrap = true;
			}
			return tf;
		}
		/* Cosmetic */
		
		protected function textGlow( field:TextField ):void {
			var color:Number = 0x000000;
			var alpha:Number = 0.35;
			var blurX:Number = 2;
			var blurY:Number = 2;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			field.filters = myFilters;
		}
		
		protected function bgGlow():void {
			var color:Number = 0x000000;
			var alpha:Number = 0.20;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;
		}
		protected function isDeviceFont( format:TextFormat ):Boolean {
			var font:String = format.font;
			var device:String = "_sans _serif _typewriter";
			return device.indexOf( font ) > -1;
		}
		
		/** Getters / Setters */
		
		public function set tipWidth( value:Number ):void {
			this._defaultWidth = value;
		}
		
		public function set titleFormat( tf:TextFormat ):void {
			this._titleFormat = tf;
			if( this._titleFormat.font == null ){
				this._titleFormat.font = "_sans";
			}
		}
		public function get titleFormat():TextFormat
		{
			return this._titleFormat
		}
		public function set contentFormat( tf:TextFormat ):void {
			this._contentFormat = tf;
			if( this._contentFormat.font == null ){
				this._contentFormat.font = "_sans";
			}
		}
		public function get contentFormat():TextFormat
		{
			return this._contentFormat
		}		
		public function set hookSize( value:Number ):void {
			this._hookSize = value;
		}
		
		public function set cornerRadius( value:Number ):void {
			this._cornerRadius = value;
		}
		
		public function set bgColors( colArray:Array ):void {
			this._bgColors = colArray;
		}
		/***
		 * 如果设为true，则是单行模式，false会根据defaultWidth来自动autowrap
		 * */
		public function set autoSize( value:Boolean ):void {
			this._autoSize = value;
		}
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		protected function get bounds():Rectangle
		{
			return this.getBounds( this )
		}
	}
}