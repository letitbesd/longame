package 
{
    import com.longame.managers.AssetsLibrary;
    import com.time.EnterFrame;
    
    import flash.display.*;
    import flash.text.*;

    public class HealthDisplay extends Sprite implements IFrameObject
    {
        public var unitname:TextField;
        private var shown:Boolean = true;
        public var healthNum:MovieClip;
		private var healthFloat:MovieClip;
        private var _colors:Array=[0xFFFFFF,0xff0000, 0x0099ff, 0x99cc00, 0xffcc00];
		private var color:uint;
		private var _hpNum:int;
		private var _currenthp:int;
        public function HealthDisplay(index:int)
        {
			healthNum=AssetsLibrary.getMovieClip("health");
			healthFloat=AssetsLibrary.getMovieClip("healthfloat");
			color=this._colors[index];
			var tf:TextFormat = new TextFormat(null,16,color,true);
			healthNum.num.defaultTextFormat=tf;
			this.hpNum=25;
//			this._currenthp=this.hpNum;
			this.addChild(healthNum);
            shown = true;
        }

        public function hideHealth():void
        {
            if (shown)
            {
//                num.alpha = 0;
                shown = false;
            }
            return;
        }

        private function updateDisplay():void
        {
			if(color==0x0099ff) trace("blue");
			this.addChild(healthFloat);
			this.healthFloat.play();
			EnterFrame.addObject(this);   
		}
        public function onFrame():void
		{
		 if(healthFloat.currentFrame==healthFloat.totalFrames){
			 healthFloat.stop();
			EnterFrame.removeObject(this);
		 }
		}
        public function showHealth():void
        {
            if (!shown)
            {
//                num.alpha = 1;
                shown = true;
            }
            return;
        }

		public function get hpNum():int
		{
			return _hpNum;
		}

		public function set hpNum(value:int):void
		{
			_hpNum = value;
			healthNum.num.text=String(value);
			this.updateDisplay();
		}


    }
}
