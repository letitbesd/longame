package com.longame.model
{
	import com.longame.modules.scenes.SceneManager;
	
	import flash.geom.Point;
	
    /**
	 * 游戏中经常用到的八方向模型
	 * */
	public class Direction
	{
		public static const states:Array=["up","down","left","right","leftup","rightdown","rightup","leftdown"];
//		public static const states:Array=["n","s","w","e","wn","es","en","ws"];
		//正右方为0度，顺时针。。。
		public static const degrees:Array=[270,90,180,0,225,45,315,135];
//		public static const allDirections:Array=[0,1,2,3,4,5,6,7];
		//对应x，y方向上的速度方向
		public  static const dx:Array=[0,0,-1,1,-1,1,1,-1];
		public  static const dy:Array=[-1,1,0,0,-1,1,-1,1];	
		
		public static const maxDirection:int=(dx.length-1);
		public static const UP:int=0;
		public static const DOWN:int=1;
		public static const LEFT:int=2;
		public static const RIGHT:int=3;
		public static const LEFT_UP:int=4;
		public static const RIGHT_DOWN:int=5;
		public static const RIGHT_UP:int=6;
		public static const LEFT_DOWN:int=7;
		
//		public static const DEFAUTL:int=UP;
		
		
		public function Direction()
		{
		}
		/**
		 * 方向对应的角度，正右方为0度，顺时针。。，45度一个间隔
		 * */
		public static function getDegree(direct:int):Number
		{
			if(!isValideDirection(direct)) throw new Error(direct+" is not a valide direction!");
			return degrees[direct];
		}
		/**
		 * 获取和角度方向角n最近的方向值，如46度返回5，就是rightdown方向
		 * */
		public static function getByDegree(n:Number):int
		{
			//如果是规范的角度，直接返回
			var result:int=degrees.indexOf(int(n));
			if(result>-1) {
				return result;
			}
			//否则找到最相近的角度
			//将角度弄到0-360度
			n=n%360;
			if(n<0) n+=360;
			var dist:Number=360;
			var td:Number;
			for(var i:int=0;i<8;i++){
				td=Math.abs(degrees[i]-n);
				if(td<dist){
					dist=td;
					result=i;
				}
			}
			return result;
		}
		public static function getByLabel(label:String):int
		{
			return states.indexOf(label.toLowerCase());
		}
		public static function getLabel(d:int):String
		{
			return states[d];
		}
		/**
		 * d是否一个倾斜的方向，除了上下左右，其它均是倾斜方向
		 * */
		public static function isDiagonalDirection(d:int):Boolean
		{
			return (d>3);
		}
		public static function isValideDirection(d:int):Boolean
		{
			return ((d>=0)&&(d<=maxDirection));
		}
		/**
		 * tile0到tile1的方向,tile0,tile1均为单元格索引，如果是相同的两个tile，返回-1
		 * */
		public static function getDirectionBetweenTiles(tileX0:int,tileY0:int,tileX1:int,tileY1:int):int
		{
			if((tileX0==tileX1)&&(tileY0==tileY1)) return -1;
			var dxx:int=tileX1-tileX0;
			if(dxx>0) dxx=1;
			else if(dxx<0) dxx=-1;
			var dyy:int=tileY1-tileY0;
			if(dyy>0) dyy=1;
			else if(dyy<0) dyy=-1;
			
			var index:int=dx.indexOf(dxx);
			while(dy[index]!=dyy){
				index=dx.indexOf(dxx,index+1);
			}
			return index;
		}	
		/**
		 * one和two代表的两个tile是否在对角方向,并且相接
		 * */
		public static function isDiagonalTiles(one:Point,two:Point):Boolean
		{
			return Math.abs((one.x-two.x)*(one.y-two.y))==1;
		}
		/**
		 * startPoint到targetPoint的方向是否和direct大致一样
		 * */
		public static function isInTheDirection(startPoint:Point,targetPoint:Point,direct:int):Boolean
		{
			var xin:Boolean=((targetPoint.x-startPoint.x)*Direction.dx[direct]>=0);
			var yin:Boolean=((targetPoint.y-startPoint.y)*Direction.dy[direct]>=0);
			return xin&&yin;		
		}
		/**
		 * 获取和direct相隔最近的那两个方向，如 右，会返回右上和右下， 如上，会返回左上和右上，如果是左上，返回 上和左
		 * */
		public static function getNeighborDirections(direct:int):Array
		{
			var label:String=states[direct];
			if(label==null) return null;
			var ds:Array=[];
			for(var i:int=0;i<maxDirection;i++){
				if(i==direct) continue;
				var label1:String=states[i];
				//只要两个方向有相同的关键字，如up-leftup，leftup-left，他们便是相邻方向
				if((label1.indexOf(label)!=-1)||(label.indexOf(label1)!=-1)){
					ds.push(i);
					if(ds.length==2) break;
				}
			}
			return ds;
		}
		/**
		 * 获取和direct成90度夹角的两个方向
		 * */
		public static function get90DegreeDirections(direct:int):Array
		{
			var degree:Number=degrees[direct];
			if(isNaN(degree)) return null;
			//上下90度各一个
			var d0:Number=degree-90;
			var d1:Number=degree+90;
			d0=getValideDegree(d0);
			d1=getValideDegree(d1);
			
			var ds:Array=[];
			for(var i:int=0;i<maxDirection;i++){
				if(i==direct) continue;
				var degree1:Number=degrees[i];
                if((degree1==d0)||(degree1==d1)){
					ds.push(i);
					if(ds.length==2) break;				
				}
			}
			return ds;			
		}
		/**
		 * 获取direct反方向
		 * */		
		public static function getOppositedDirection(direct:int):int
		{
			if(!isValideDirection(direct)) return -1;
			if(direct%2==0) return direct+1;
			return direct-1;
		}
		/**
		 * 获取direct的镜像，方便翻转显示对象达到转向的目的，如左和右，左下和右下,左上和右上
		 * */		
		public static function getFlippedDirection(direct:int):int
		{
			if(!isValideDirection(direct)) return -1;
			if(SceneManager.sceneType==SceneManager.D2){
				switch(direct){
					case LEFT: return RIGHT;
					case RIGHT:return LEFT;
					case LEFT_UP: return RIGHT_UP;
					case RIGHT_UP: return LEFT_UP;
					case LEFT_DOWN: return RIGHT_DOWN;
					case RIGHT_DOWN: return LEFT_DOWN;
				}
			}else{
				switch(direct){
					case LEFT: return UP;
					case UP:return LEFT;
					case RIGHT: return DOWN;
					case DOWN:  return RIGHT;
					case LEFT_DOWN: return RIGHT_UP;
					case RIGHT_UP: return LEFT_DOWN;
				}
			}
			return -1;
		}
		/**
		 * 获取d1和d2之间的斜角方向,d1和d2只能是上下左右
		 * */
		public static function getDiagonalDirection(d1:int,d2:int):int
		{
			if((d1>3)||(d2>3)) return -1;
			var digonalName:String;
			for(var i:int=4;i<8;i++){
				digonalName=states[i];
				if((digonalName.indexOf(states[d1])>-1)&&(digonalName.indexOf(states[d2])>-1))
					return i;
			}
			return -1;
		}
		/**
		 * 获取0-360度之间的角度
		 * */
		private static function getValideDegree(d:Number):Number
		{
			if(d<0) return 360+d;
			else if(d>=360) return d-360;
			return d;
		}
	}
}