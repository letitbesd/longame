package com.longame.model.geom{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	public class Line {
		//判断误差
		public static  var WU_CHA:Number=0.1;
		protected var $p:Point;
		protected var $slope:Number;
		//记录是垂直线或水平线
		protected var $vLine:Boolean;
		protected var $hLine:Boolean;
		//已知一个点和斜率的直线方程,或者两个点求直线方程
		public function Line(p:Point,slopeOrP:*) {
			$p=p;
			var type:String=getQualifiedClassName(slopeOrP);
			//trace(type);
			if(type=="flash.geom::Point") $slope=LineUtil.getSlope($p,slopeOrP);
			else if((type=="Number")||(type=="int")) $slope=slopeOrP;
			else throw new Error("第二个参数只能为Point/Number/int");
			$vLine=(Math.abs($slope)==Infinity);
			$hLine=($slope==0);
		}
		public function get slope():Number{
			return($slope);
		}
		//获取直线类型，垂直线，水平线或一般直线
		public function get vLine():Boolean{
			return($vLine);
		}
		public function get hLine():Boolean{
			return($hLine);
		}
		//通过直线x坐标获取y值,若是垂直线将返回Infinity或-Infinity
		public function getY(x:Number):Number {
			return ($slope * (x - $p.x) + $p.y);
		}
		//通过直线y坐标获取x值,若是水平线将返回Infinity或-Infinity
		public function getX(y:Number):Number {
			//if($slope==0) throw new Error("水平线无法获取x值！");
			return ((y - $p.y )/ $slope + $p.x);
		}
		//判断一个点是否在直线上
		public function onLine(pp:Point):Boolean {
			//若是垂直线
			if ($vLine) {
				return(Math.abs(pp.x-$p.x)<=WU_CHA)
			}
			//其它
			var yo:Number=getY(pp.x);
			return(Math.abs(pp.y-yo)<=WU_CHA);
			
		}
		//判断一个点在y轴的正方向或负方向，分别返回1，-1,或者在直线上返回0
		//特殊的，垂直线若PP不在其上，将返回Infinity，垂直线怎有y轴正负方向呢。。。
		public function upLine(pp:Point):int {
			var l:int;
			//若是垂直线
			if ($vLine) {
				if (Math.abs(pp.x-$p.x)<=WU_CHA) {
					l=0;
					return 0;
				}else{
					l=Infinity;
					return l;
				}
			}
			//不是垂直线
			var yo:Number=getY(pp.x);
			if (Math.abs(pp.y-yo)<=WU_CHA) {
				l=0;
				return 0;
			}
			if ((pp.y-yo)>WU_CHA) {
				l=1;
				return 1;
			}
			if ((pp.y-yo)<-WU_CHA) {
				l=-1;
				return -1;
			}
			return l;
		}
		
	}
}