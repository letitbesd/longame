package {
    import com.longame.display.core.RenderManager;
    import com.longame.game.entity.AnimatorEntity;
    
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;

    public class PlusNumUp extends AnimatorEntity 
	{
        private var stayTime:uint= 40
        private var xVel:Number= 0
        private var xAccel:Number= -0.32
        private var scaler:Number= 1
        private var gf:GlowFilter;
        private var ctr:ColorTransform;
        private var ctrOS:Number= 0xFF

        public function PlusNumUp(source:String):void{
            this.gf = new GlowFilter();
            this.ctr = new ColorTransform();
            super();
			//TODO,BonusNum,WindNum的时候，这两个素材本身是MC，看怎么搞一下
			this.source=source;
        }
		override protected function whenSourceLoaded():void
		{
			super.whenSourceLoaded();
			scaleX = scaleY = 1 + this.scaler;
			this.ctr.redOffset = this.ctr.blueOffset = this.ctr.greenOffset = this.ctrOS;
			this._sourceDisplay.transform.colorTransform = this.ctr;
			this._sourceDisplay.filters = [this.gf];
			this.gf.blurX = 5;
			this.gf.blurY = 5;
			this.gf.strength = 1;
			this.gf.color = 0xFFFFFF;
		}
		override protected function renderTexture(extraId:String=null):void
		{
			super.renderTexture(""+stayTime);
		}
		override protected function doRender():void
		{
			super.doRender();
			if (this.scaler > 0.01){
				this.scaler = this.scaler - 0.2;
				this.gf.blurX = this.gf.blurX - 1;
				this.gf.blurY = this.gf.blurY - 1;
				this.gf.strength =this.gf.strength - 0.2;
				this.ctrOS = this.ctrOS - (0xFF / 5);
				this.ctr.redOffset = this.ctr.blueOffset = this.ctr.greenOffset = this.ctrOS;
				this._sourceDisplay.transform.colorTransform = this.ctr;
				this._sourceDisplay.filters = [this.gf];
				scaleX = scaleY = 1 + this.scaler;
			}
			this.xVel = (this.xVel + this.xAccel);
			x +=this.xVel;
			this.stayTime--;
			if (this.stayTime < 30){
				this._sourceDisplay.alpha -= 0.03;
			}
			if (this.stayTime == 0){
				this.dispose();
			}else{
				this._frameInvalidated=true;
			}
		}
    }
}
