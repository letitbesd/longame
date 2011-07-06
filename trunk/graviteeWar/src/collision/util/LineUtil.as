package collision.util{
	import flash.geom.Point;
	public class LineUtil {

		//求两点连线的斜率
		public static function getSlope(p1:Point,p2:Point):Number {
			var dx:Number=p1.x-p2.x;
			var dy:Number=p1.y-p2.y;
			return dy / dx;
		}
		//以弧度返回两点连线和X轴正向的夹角
		public static function getAngleX(p1:Point,p2:Point):Number {
			var slope:Number=getSlope(p1,p2);
			return (Math.atan(slope));
		}
		//求两点连线的中垂线斜率
		public static function zhongChui(p1:Point,p2:Point):Line {
			//中分点
			var harfP:Point=Point.interpolate(p1,p2,0.5);
			var slope:Number=-1/getSlope(p1,p2);
			//return(slope);
			var line1:Line=new Line(harfP,slope);
			return line1;
		}
		//判断点p是否在p1,p2构成线段的中间(与p1,p2点重合也算)
		public static function betweenPoints(p:Point,p1:Point,p2:Point):Boolean {
			if (!onPointsLine(p,p1,p2)){
				return(false);
			}else{
				var totalDis:Number=Point.distance(p1,p2);
				var p_p1:Number=Point.distance(p,p1);
				var p_p2:Number=Point.distance(p,p2);
				var between:Boolean=((p_p1<=totalDis)&&(p_p2<=totalDis));
				return(between);
			}
									
		}
		//判断点p是否在p1,p2构成的直线上
		public static function onPointsLine(p:Point,p1:Point,p2:Point):Boolean{
			var line:Line=new Line(p1,p2);
			return(line.onLine(p));
		}
		//判断一个点p是否在以p1,p2为对角的矩形区域内(包括边界)
		public static function inSquare(p:Point,p1:Point,p2:Point):Boolean {
			var xMin:Number=Math.min(p1.x,p2.x);
			var xMax:Number=Math.max(p1.x,p2.x);
			var yMin:Number=Math.min(p1.y,p2.y);
			var yMax:Number=Math.max(p1.y,p2.y);
			var inX:Boolean=((p.x>=xMin)&&(p.x<=xMax));
			var inY:Boolean=((p.y>=yMin)&&(p.y<=yMax));
			if (inX&&inY) {
				return true;
			} else {
				return false;
			}
		}
		//弧度到角度
		public static function toDegree(a:Number):Number {
			return 180 * a / Math.PI;
		}
		//角度到弧度
		public static function toRadian(a:Number):Number {
			return Math.PI * a / 180;
		}
	}
}