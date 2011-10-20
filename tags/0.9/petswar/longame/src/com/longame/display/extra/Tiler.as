package com.longame.display.extra
{
	import com.longame.utils.debug.Logger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import com.longame.utils.DisplayObjectUtil;

	public class Tiler extends Bitmap
	{
		protected var target:DisplayObjectContainer;
		protected var tileSample:DisplayObject;
		protected var tileW:Number;
		protected var tileH:Number;
		protected var sizeX:int;
		protected var sizeY:int;
		
		protected var bmd:BitmapData
		
		public function Tiler(tileImage:DisplayObject,target:DisplayObjectContainer,autoAdd:Boolean=true)
		{
			super(null,"auto",true);
			this.tileSample=tileImage;
			this.target=target;
			if(autoAdd) {
				target.addChild(this);
				if(target.width*target.height>0) this.update();
			}
		}
        protected var _isDisposed:Boolean=false;
        public function dispose():void
		{
			if(_isDisposed) return;
			_isDisposed=true;
			if(this.parent&&(this.parent.contains(this))){
				this.parent.removeChild(this);
				if(this.bitmapData) this.bitmapData.dispose();
			}
		}
		public function update(rect:Rectangle=null,tileWidth:Number=NaN,tileHeight:Number=NaN):void
		{
			
			this.tileW=tileWidth;
			this.tileH=tileHeight;
			if(isNaN(this.tileW)) this.tileW=tileSample.width;
			if(isNaN(this.tileH)) this.tileH=tileSample.height;
			
			if(rect==null) rect=target.getBounds(target);
			
			
			if(this.bitmapData) this.bitmapData.dispose();
			try{
				this.bitmapData=new BitmapData(rect.width,rect.height,true,0x0);
			}catch(e:Error){
				Logger.error(this,"update","The container rectangle is not validated!");
				return;
			}
			
			
			sizeX=Math.floor(rect.width/tileW);
			sizeY=Math.floor(rect.height/tileH);
			var widthLeft:Number=rect.width-sizeX*tileW;
			var heightLeft:Number=rect.height-sizeY*tileH;
			if(widthLeft>1) {
				sizeX++;
			}
			if(heightLeft>1) {
				sizeY++;
			}
			this.bitmapData.lock();
			var offx:Number;
			var offy:Number;
			for (var i:int=0;i<sizeX;i++){
				offx=i*tileW;
				for(var j:int=0;j<sizeY;j++){
					offy=j*tileH;
					var mat:Matrix=new Matrix();
					var cropW:Number=((widthLeft>1)&&(i==sizeX-1))?widthLeft:tileW;
					var cropH:Number=((heightLeft>1)&&(j==sizeY-1))?heightLeft:tileH;
					var crop:Rectangle=new Rectangle(0,0,cropW,cropH);
					mat.translate(offx,offy);
					this.bitmapData.draw(tileSample,mat);//,null,null,crop,true);
				}
			}
			this.bitmapData.unlock();
		}
	}
}