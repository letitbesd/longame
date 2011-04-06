package com.longame.display.tip
{
	import com.gskinner.motion.GTween;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import com.longame.utils.DisplayObjectUtil;
	
	import mx.effects.easing.Exponential;
	
	/**
	 * Public Setters:
	 
	 *		tipWidth 					Number				Set the width of the tooltip
	 *		titleFormat					TextFormat		Format for the title of the tooltip
	 *		contentFormat			TextFormat		Format for the bodycopy of the tooltip
	 *		align							String				left, right, center
	 *		delay							Number				Time in milliseconds to delay the display of the tooltip
	 *		hook							Boolean				Displays a hook on the bottom of the tooltip
	 *		hookSize					Number				Size of the hook
	 *		cornerRadius				Number				Corner radius of the tooltip, same for all 4 sides
	 *		colors						Array					Array of 2 color values ( [0xXXXXXX, 0xXXXXXX] ); 
	 *		autoSize					Boolean				Will autosize the fields and size of the tip with no wrapping or multi-line capabilities, helpful with 1 word items like "Play" or "Pause"
	 *
	 * Example:
	 
	 		var tf:TextFormat = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.color = 0xff0000;
			
			var tt:ToolTip = new ToolTip();
			tt.hook = true;
			tt.hookSize = 20;
			tt.cornerRadius = 20;
			tt.align = "center";
			tt.titleFormat = tf;
			tt.show( DisplayObject, "Title Of This ToolTip", "Some Copy that would go below the ToolTip Title" );
	 *
	 *
	 * @author Duncan Reid, www.hy-brid.com
	 * @date October 17, 2008
	 * @version 1.1
	 */
	 
	public class InfoBubble extends Sprite {
		
		//true:信息框跟随鼠标移动
		//false：信息框跟随对象移动
		public var followMouse:Boolean=false
        //信息框的位置微调,offsetX>0表示往右调，offsetY>0表示往下调
        public var offsetX:int=0
        public var offsetY:int=-10
        //固定显示多久时间,秒
        public var showTime:int=-1
		//objects
		protected var _stage:Stage;
		protected var _target:DisplayObject;
		protected var _tf:TextField;  // title field
		protected var _cf:TextField;  //content field
		protected var _icon:DisplayObject
		protected var _tween:GTween;
		
		//formats
		protected var _titleFormat:TextFormat;
		protected var _contentFormat:TextFormat;
		
		/* check for format override */
		protected var _titleOverride:Boolean = false;
		protected var _contentOverride:Boolean = false;
		
		//defaults
		protected var _defaultWidth:Number = 200;
		//文字与边框的间距
		protected var _buffer:Number =6;
		protected var _align:String = "center"
		protected var _cornerRadius:Number = 12;
		protected var _bgColors:Array = [0xFFFFFF, 0x9C9C9C];
		protected var _autoSize:Boolean = true;
		protected var _hookEnabled:Boolean = true;
		protected var _delay:Number = 0;  //millilseconds
		protected var _hookSize:Number = 10;
		
		//offsets
		protected var _offSet:Number;
		protected var _hookOffSet:Number;
		
		//delay
		protected var _timer:Timer;
		
        //上一次显示消失完毕才能再显示
        protected var canShow:Boolean=true
        //开始显示的时间点
        protected var startTime:int
	
		public function InfoBubble():void {
			//do not disturb parent display object mouse events
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
			this.cacheAsBitmap=true
			//初始化文字格式
			this.initTextFormat()
			//setup delay timer
			_timer = new Timer(this._delay, 1);
            _timer.addEventListener("timer", timerHandler);
		}		
		/**
		 * 显示一个气泡
		 * @param target:要显示气泡的对象，会在其图形的上边缘中央显示气泡
		 * @param title :标题
		 * @param icon  :可以显示一个图片icon，当然MovieClip等任何DisplayObject都可以
		 * @param content:正文内容
		 * 注意：气泡会加到target所在的stage上。
		 * */
		public function show( target:DisplayObject, title:String,icon:DisplayObject=null,content:String=null):Boolean {
			//get the stage from the parent
			if(!this.canShow){
				return	false
			} 
			this.startTime=getTimer()
			this._stage = target.stage;
			this._target = target;
			this._icon=icon
			this.addCopy( title, content );
			this.setOffset();
			this.drawBG();
			this.bgGlow();
			
			//initialize coordinates
			var sp:Point
			//跟随鼠标
			if(this.followMouse){
				sp =new Point(this._stage.mouseX,this._stage.mouseY)
			//跟随对象
			}else{
				sp=this.targetCenterTop
			}
			
			this.x = sp.x + this._offSet+this.offsetX;
			this.y = sp.y - this.height+this.offsetY;
			
			this.alpha = 0;
			this._stage.addChild( this );
//			(this._target as DisplayObjectContainer).addChild( this );
			
			this.follow( true );
            _timer.start();
            return true
		}
		
		public function hide():void {
			this.canShow=false
			this.animate( false );
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
		protected function timerHandler( event:TimerEvent ):void {
			this.animate(true);
		}

		protected function follow( value:Boolean ):void {
			if( value ){
				addEventListener( Event.ENTER_FRAME, this.tick );
			}else{
				removeEventListener( Event.ENTER_FRAME, this.tick );
			}
		}
		
		protected function tick( event:Event ):void {
			//todo
			//this.setPosition();
			if((this.showTime>0)&&((getTimer()-this.startTime)>this.showTime*1000)){
				this.hide()
			}
		}
		
		protected function setPosition():void {
			var speed:Number = 3;
			var pn:Point 
			if(this.followMouse) {
				pn=new Point(this._stage.mouseX,this._stage.mouseY)
			}else{
				pn=this.targetCenterTop
			}
			var xp:Number = pn.x + this._offSet+this.offsetX;
			var yp:Number = pn.y - this.height +this.offsetY;
			
			var overhangRight:Number = this._defaultWidth + xp;
			if( overhangRight > stage.stageWidth ){
				xp =  stage.stageWidth -  this._defaultWidth;
			}
			if( xp < 0 ) {
				xp = 0;
			}
			if( yp < 0 ){
				yp = 0;
			}
			this.x += ( xp - this.x ) / speed;
			this.y += ( yp - this.y ) / speed;
		}
		
		protected function addCopy( title:String, content:String ):void {
//			if( ! this._titleOverride ){
//				this.initTitleFormat();
//			}
			var titleIsDevice:Boolean = this.isDeviceFont(  _titleFormat );
			//添加标题
			this._tf = this.createField( titleIsDevice ); 
			this._tf.htmlText = title;
			this._tf.setTextFormat( this._titleFormat, 0, title.length );
			if( this._autoSize ){
				this._defaultWidth = this._tf.textWidth + 4 + ( _buffer * 2 );
			}else{
				this._tf.width = this._defaultWidth - ( _buffer * 2 );
			}
			
			this._tf.x = this._tf.y = this._buffer;
			this.textGlow( this._tf );
			addChild( this._tf );
			//添加图示
			if(this._icon!=null){
				//this._icon.width=this.bounds.width-2*this._buffer
				//this._icon.scaleY=this._icon.scaleX
				var cp:Point=DisplayObjectUtil.getCenter(this._icon)
				this._icon.x=this._buffer+this._icon.width/2-cp.x
				this._icon.y=this.bounds.height+5+this._icon.height/2-cp.y
				addChild(this._icon)
			}
			//添加内容
			if( content != null ){
//				if( ! this._contentOverride ){
//					this.initContentFormat();
//				}
				//check for device font
				var contentIsDevice:Boolean = this.isDeviceFont(  _contentFormat );
				this._cf = this.createField( contentIsDevice );
				this._cf.htmlText = content;

				this._cf.x = this._buffer;
				this._cf.y = this.bounds.height + 5;
				this.textGlow( this._cf );
				this._cf.setTextFormat( this._contentFormat );
				if( this._autoSize ){
					var cfWidth:Number = this._cf.textWidth + 4 + ( _buffer * 2 )
					this._defaultWidth = cfWidth > this._defaultWidth ? cfWidth : this._defaultWidth;
				}else{
					this._cf.width = this._defaultWidth - ( _buffer * 2 );
				}
				addChild( this._cf );	
			}
		}
		
		//create field, if not device font, set embed to true
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
		//对象的顶部中间点作为信息框的显示基点
		protected function get targetCenterTop():Point
		{
			var rect:Rectangle=_target.getBounds(_stage);
			return new Point((rect.left+rect.right)/2,rect.top);
		}
		protected function get bounds():Rectangle
		{
			return this.getBounds( this )
		}
		
		//draw background, use drawing api if we need a hook
		protected function drawBG():void {
			var fillType:String = GradientType.LINEAR;
		   	//var colors:Array = [0xFFFFFF, 0x9C9C9C];
		   	var alphas:Array = [1, 1];
		   	var ratios:Array = [0x00, 0xFF];
		   	var matr:Matrix = new Matrix();
			var radians:Number = 90 * Math.PI / 180;
		  	matr.createGradientBox(this._defaultWidth, this.bounds.height + ( this._buffer * 2 ), radians, 0, 0);
		  	var spreadMethod:String = SpreadMethod.PAD;
		  	this.graphics.beginGradientFill(fillType, this._bgColors, alphas, ratios, matr, spreadMethod); 
			if( this._hookEnabled ){
				var xp:Number = 0; var yp:Number = 0; var w:Number = this._defaultWidth; var h:Number = this.bounds.height + ( this._buffer * 2 );
				this.graphics.moveTo ( xp + this._cornerRadius, yp );
				this.graphics.lineTo ( xp + w - this._cornerRadius, yp );
				this.graphics.curveTo ( xp + w, yp, xp + w, yp + this._cornerRadius );
				this.graphics.lineTo ( xp + w, yp + h - this._cornerRadius );
				this.graphics.curveTo ( xp + w, yp + h, xp + w - this._cornerRadius, yp + h );
				
				//hook
				this.graphics.lineTo ( xp + this._hookOffSet + this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._hookOffSet , yp + h + this._hookSize );
				this.graphics.lineTo ( xp + this._hookOffSet - this._hookSize, yp + h );
				this.graphics.lineTo ( xp + this._cornerRadius, yp + h );
				
				this.graphics.curveTo ( xp, yp + h, xp, yp + h - this._cornerRadius );
				this.graphics.lineTo ( xp, yp + this._cornerRadius );
				this.graphics.curveTo ( xp, yp, xp + this._cornerRadius, yp );
				this.graphics.endFill();
			}else{
				this.graphics.drawRoundRect( 0, 0, this._defaultWidth, this.bounds.height + ( this._buffer * 2 ), this._cornerRadius );
			}
		}

		
		
		
		/* Fade In / Out */
		
		protected function animate( show:Boolean ):void {
			var end:int = show == true ? 1 : 0;
			_tween=new GTween(this,.5,{alpha:end});//,{ease:Exponential.easeOut})
			if( ! show ){
				_tween.onComplete=onComplete
				_timer.reset();
			}
		}
		
		protected function onComplete( e:GTween ):void {
			this.cleanUp();
			this.canShow=true
		}
	
		/* End Fade */
		
		
		

		/** Getters / Setters */
		
		public function set tipWidth( value:Number ):void {
			this._defaultWidth = value;
		}
		
		public function set titleFormat( tf:TextFormat ):void {
			this._titleFormat = tf;
			if( this._titleFormat.font == null ){
				this._titleFormat.font = "_sans";
			}
			this._titleOverride = true;
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
			this._contentOverride = true;
		}
		public function get contentFormat():TextFormat
		{
			return this._contentFormat
		}		
		public function set align( value:String ):void {
			var a:String = value.toLowerCase();
			var values:String = "right left center";
			if( values.indexOf( value ) == -1 ){
				throw new Error( this + " : Invalid Align Property, options are: 'right', 'left' & 'center'" );
			}else{
				this._align = a;
			}
		}
		
		public function set delay( value:Number ):void {
			this._delay = value;
			this._timer.delay = value;
		}
		
		public function set hook( value:Boolean ):void {
			this._hookEnabled = value;
		}
		
		public function set hookSize( value:Number ):void {
			this._hookSize = value;
		}
		
		public function set cornerRadius( value:Number ):void {
			this._cornerRadius = value;
		}
		
		public function set colors( colArray:Array ):void {
			this._bgColors = colArray;
		}
		
		public function set autoSize( value:Boolean ):void {
			this._autoSize = value;
		}
		
		
		/* End Getters / Setters */
		
		
		
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
		
//		protected function initTitleFormat():void {
//			_titleFormat = new TextFormat();
//			_titleFormat.font = "_sans";
//			_titleFormat.bold = true;
//			_titleFormat.size = 14;
//			_titleFormat.color = 0x333333;
//		}
//		
//		protected function initContentFormat():void {
//			_contentFormat = new TextFormat();
//			_contentFormat.font = "_sans";
//			_contentFormat.bold = false;
//			_contentFormat.size = 12;
//			_contentFormat.color = 0x333333;
//		}
	
		/* End Cosmetic */
	
	
		
		/* Helpers */
		
		/* Check if font is a device font */
		protected function isDeviceFont( format:TextFormat ):Boolean {
			var font:String = format.font;
			var device:String = "_sans _serif _typewriter";
			return device.indexOf( font ) > -1;
			//_sans
			//_serif
			//_typewriter
		}
		
		protected function setOffset():void {
			switch( this._align ){
				case "left":
					this._offSet = - _defaultWidth +  ( _buffer * 3 ) + this._hookSize; 
					this._hookOffSet = this._defaultWidth - ( _buffer * 3 ) - this._hookSize; 
				break;
				
				case "right":
					this._offSet = 0 - ( _buffer * 3 ) - this._hookSize;
					this._hookOffSet =  _buffer * 3 + this._hookSize;
				break;
				
				case "center":
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );
				break;
				
				default:
					this._offSet = - ( _defaultWidth / 2 );
					this._hookOffSet =  ( _defaultWidth / 2 );;
				break;
			}
		}
		
		/* End Helpers */
		
		
		
		/* Clean */
		
		protected function cleanUp():void {
			this.follow( false );
			this.filters = [];
            this.cleanTxt()
			this.graphics.clear();
			if(this._icon!=null){
				this.removeChild(this._icon)
				this._icon=null
			}
			if(parent) parent.removeChild( this );
		}
		protected function cleanTxt():void
		{
			if(this._tf!=null){
				this._tf.filters = [];
				removeChild( this._tf );
				this._tf = null;				
			}
			if( this._cf != null ){
				this._cf.filters = []
				removeChild( this._cf );
				this._cf=null
			}			
		}
		
		/* End Clean */
		
		
	}
}
