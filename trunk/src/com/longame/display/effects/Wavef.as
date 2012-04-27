package com.longame.display.effects{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Wavef extends Sprite {
		public var waveWidth:Number=800;
		public var waveHeight:Number=500;
		public var waveColor:uint;
		public var waveAlpha:Number;
		public const NUM:uint=800;//頂点数
		private var MOUSE_DIFF_RATIO:Number;// (0<) 大きい程マウスに反応する--波动的比率
		private var AUTO_INTERVAL:uint;//オート波が起きる間隔 msec
		private var vertexes:Array=[];//頂点
		private var mdlPt:Array=[];//頂点の中点
		//頂点の基本波からの位相差分
		// 0:マウス
		// 1:オート
		private var diffPt:Array=[[],[]];// 鼠标推动后，在原先的位相上所要增加的位相值。
		// 二维数组中，第一个数组存储根据鼠标拖动后产生的位相差，第二个存储自动产生的波动的位相差。
		//波が起こるインデックス
		// 0:マウス
		// 1:オート
		private var startIndex:Array=[0,0];
		private var mouseOldY:int;
		private var mouseNewY:int;
		private var mouseDiff:Number=0;//mouseDiffGoal的缓冲
		private var mouseDiffGoal:Number=0;//鼠标拖动后产生的位相差
		private var autoTimer:Timer;
		private var autoDiff:Number=0;//计时器自动生成的位相差
		/**
		 * 波浪效果，注意，以此sprite坐标原点为准，波浪区域从(waveWidth,waveHeight)为右下点，(0,waveHeight)为左下点，高为waveHeight的范围
		 *要想形成涨潮的效果，注意将此对象做垂直位移
		 *@param waveWidth: 波浪区域宽度
		 *@param waveHeight:波浪区域高度
		 *@param color :波浪颜色
		 *@param alpha: 波浪透明度
		 *@param autoUpdateInterval:波浪自动更新的间隔，毫秒
		 *@mouseDiffRatio  :鼠标互动的强度
		 */
		public function Wavef(waveWidth:Number,waveHeight:Number,color:uint=0x666666,alpha:Number=1,autoUpdateInterval:uint=3000,mouseDiffRatio:Number=1):void {
			this.waveWidth=waveWidth;
			this.waveHeight=waveHeight;
			this.waveColor=color;
			this.waveAlpha=alpha;
			this.AUTO_INTERVAL=autoUpdateInterval;
			this.MOUSE_DIFF_RATIO=mouseDiffRatio;
			for (var i:uint=0; i<NUM; i++) {
				var vertex:Vertex=new Vertex(i,this);
				vertexes.push( vertex );
				//中点作成
				if (i>1) {
					mdlPt.push( new Point( (vertexes[i-1].x+vertexes[i].x)*0.5, (vertexes[i-1].y+vertexes[i].y)*0.5 ) );
				}
				//差分
				diffPt[0].push( 0 );
				diffPt[1].push( 0 );
			}
			mouseNewY=mouseY;
			if (mouseNewY<0) {
				mouseNewY=0;
			} else if (mouseNewY > waveHeight) {
				mouseNewY=waveHeight;
			}
			mouseOldY=mouseNewY;
//			addEventListener(Event.ENTER_FRAME, updateMouseDiff);
//			addEventListener(Event.ENTER_FRAME, updateWave);
			autoTimer=new Timer(AUTO_INTERVAL);
			autoTimer.addEventListener(TimerEvent.TIMER, generateAutoWave);
			autoTimer.start();
		}
		private function generateAutoWave(tEvt:TimerEvent):void {
			autoDiff=200;//自动生成100的位相差
			startIndex[1] = Math.round( Math.random()*(NUM-1) );//在波形的随机位置自动产生波形抖动(产生位相差)
		}
		private var _mouseDiffEnabled:Boolean=false;
		public function set mouseDiffEnabled(e:Boolean):void
		{
			if(_mouseDiffEnabled==e) return;
			_mouseDiffEnabled=e;
			e?addEventListener(Event.ENTER_FRAME, updateMouseDiff):removeEventListener(Event.ENTER_FRAME, updateMouseDiff);
		}
		private var _autoUpdate:Boolean=false;
		public function set autoUpdate(auto:Boolean):void
		{
			if(_autoUpdate==auto) return;
			_autoUpdate=auto;
			auto?addEventListener(Event.ENTER_FRAME, updateWave):removeEventListener(Event.ENTER_FRAME, updateWave);
		}
		//--------------------------------------
		//        マウスY座標の差を計算
		//--------------------------------------
		private function updateMouseDiff(evt:Event):void {
			mouseOldY=mouseNewY;
			mouseNewY=mouseY;
			if (mouseNewY<0) {
				mouseNewY=0;
			} else if (mouseNewY > waveHeight) {
				mouseNewY=waveHeight;
			}
			mouseDiffGoal = (mouseNewY - mouseOldY) * MOUSE_DIFF_RATIO;//根据鼠标前后位移差设置波动起伏的位相差
		}
		//---------------------------------------
		//        各種更新
		//---------------------------------------
		private function updateWave(evt:Event):void {
			graphics.clear();
			//それぞれの波の減衰
			mouseDiff -= (mouseDiff - mouseDiffGoal)*0.3;
			autoDiff-=autoDiff*0.9;//波形自动波动时的速率
			//-------------------------------------
			//波の基点
			//-------------------------------------
			//マウス波
			var mX:int=mouseX;
			if (mX<0) {
				mX=0;
			} else if (mX > waveWidth-2) {
				mX=waveWidth-2;
			}//-2はみ出さないための保険
			startIndex[0] = 1+Math.floor( (NUM-2) * mX / waveWidth );//startIndex[0]表示波形图上，鼠标拖动的那个点,用Math.floor是
			//可以取到NUM个点里面x坐标小于当前鼠标x坐标的最大值
			diffPt[0][startIndex[0]] -= ( diffPt[0][startIndex[0]] - mouseDiff )*0.99;
			//自动波
			diffPt[1][startIndex[1]] -= ( diffPt[1][startIndex[1]] - autoDiff )*0.99;
			var i:int;
			//------------------------------------
			//差分更新
			//-------------------------------------
			//マウス波
			//左側
			var d:uint;
			for (i=startIndex[0]-1; i >=0; i--) {
				d=startIndex[0]-i;
				if (d>15) {
					d=15;
				}
				diffPt[0][i] -= ( diffPt[0][i] - diffPt[0][i+1] )*(1-0.01*d);
			}
			//右側
			for (i=startIndex[0]+1; i < NUM; i++) {
				d=i-startIndex[0];
				if (d>15) {
					d=15;
				}
				diffPt[0][i] -= ( diffPt[0][i] - diffPt[0][i-1] )*(1-0.01*d);
			}
			//オート波
			//左側
			for (i=startIndex[1]-1; i >=0; i--) {
				d=startIndex[1]-i;
				if (d>15) {
					d=15;
				}
				diffPt[1][i] -= ( diffPt[1][i] - diffPt[1][i+1] )*(1-0.01*d);
			}
			//右側
			for (i=startIndex[1]+1; i < NUM; i++) {
				d=i-startIndex[1];
				if (d>15) {
					d=15;
				}
				diffPt[1][i] -= ( diffPt[1][i] - diffPt[1][i-1] )*(1-0.01*d);
			}
			//-------------------------------------
			//各頂点更新
			//-------------------------------------
			for (i=0; i < NUM; i++) {
				vertexes[i].updatePos( diffPt[0][i]+diffPt[1][i]);//更新波形上各点的位相，位相差等于鼠标抖动的和自动产生的，即为diffPt[0][i]+diffPt[1][i]
			}
			//-------------------------------------
			//中点更新
			//-------------------------------------
			for (i=0; i < NUM-2; i++) {
				mdlPt[i].y = (vertexes[i+1].y + vertexes[i+2].y)*0.5;//更新波形图上两点中点的位相，使波形图看起来更流畅
			}
			drawWave();
		}
		//---------------------------------------
		//        描画
		//---------------------------------------
		private function drawWave():void {
			//根据存储的vertexes和mdlPt数组里的各点位相，画贝塞尔曲线
			graphics.beginFill(waveColor, waveAlpha);
			graphics.moveTo(waveWidth, waveHeight);
			graphics.lineTo(0, waveHeight);
			graphics.lineTo( vertexes[0].x, vertexes[0].y);
			graphics.curveTo( vertexes[1].x, vertexes[1].y, mdlPt[0].x, mdlPt[0].y);
			for (var i:uint=2; i<NUM-2; i++) {
				graphics.curveTo( vertexes[i].x, vertexes[i].y, mdlPt[i-1].x, mdlPt[i-1].y);
			}
			graphics.curveTo( vertexes[NUM-2].x, vertexes[NUM-2].y, vertexes[NUM-1].x, vertexes[NUM-1].y);
			graphics.endFill();
		}
	}
}
class Vertex {
	public static const BASE_Y:uint=150;
	public static const BASE_R:uint=10;
	public static const PI:Number=Math.PI;
	public static const FRICTION:Number=0.1;//波形抖动后回复到正常状态的速率指数
	public static const DECELERATION:Number=0.95;
	public static const SPEED_OF_BASE_WAVE:uint=3;
	private var theta:uint=0;
	private var goalY:Number=0;
	private var amp:Number=0;
	public var x:Number;
	public var y:Number;
	public function Vertex(prmID:uint, parent:Object):void {
		theta =  360 * prmID/( parent.NUM-1) ;//角度的弧度值。根据NUM值将舞台上分为NUM块，然后将2π的弧度分配给各块，这样舞台上平静的时候正好是一段完整的波形。
		x = prmID * parent.waveWidth / (parent.NUM-1);
		y=BASE_Y+BASE_R*Math.sin(theta*PI/180);
	}
	//让波形不断波动的函数，不断更新各点的y坐标
	public function updatePos(diffVal:Number):void {
		theta+=SPEED_OF_BASE_WAVE;
		if (theta>=360) {
			theta-=360;
		}
		goalY=BASE_Y+BASE_R*Math.sin(theta*PI/180);
		goalY+=diffVal;
		amp+=goalY-y;
		y+=amp*FRICTION;//y坐标以FRICTION的缓冲速率缓冲到正常状态
		amp*=DECELERATION;
	}
}