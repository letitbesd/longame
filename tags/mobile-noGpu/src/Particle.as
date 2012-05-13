package {
    import com.longame.game.entity.DisplayEntity;
    import com.longame.game.entity.SpriteEntity;
    
    import flash.display.*;
    
    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.textures.Texture;

    public class Particle extends DisplayEntity {

        private var decayTime:uint;
        private var decayTimeMax:uint;
        private var xVel:Number;
        private var yVel:Number;
        private var xA:int;
        private var yA:int;

        public function Particle(_arg1:BitmapData, _arg2:Number=0, _arg3:Number=0, _arg4:uint=60, _arg5:int=0, _arg6:int=0, addBlendMode:Boolean=false, _arg8:Boolean=true):void{
            super();
			var img:Image=new Image(Texture.fromBitmapData(_arg1));
			this.container.addChild(img);
            this.xVel = _arg2;
            this.yVel = _arg3;
            this.xA = _arg5;
            this.yA = _arg6;
            this.decayTimeMax = (this.decayTime = _arg4);
            if (_arg8){
                scaleX = (scaleY = (0.5 + (Math.random() * 2)));
            }
            if (addBlendMode){
				this.container.blendMode=starling.display.BlendMode.ADD;
            }
        }
		override protected function doRender():void
		{
			x = (x + this.xVel);
			y = (y + this.yVel);
			this.xVel = (this.xVel + (this.xA / 100));
			this.yVel = (this.yVel + (this.yA / 100));
			super.doRender();
			if (this.decayTime > 0){
				this.container.alpha = (this.decayTime / this.decayTimeMax);
				this.decayTime--;
			} else {
				this.dispose();
			}
		}
		override protected function whenDispose():void
		{
			super.whenDispose();
			//TODO
//			_gD.killPar(this);
//			clearMe();
		}
    }
}
