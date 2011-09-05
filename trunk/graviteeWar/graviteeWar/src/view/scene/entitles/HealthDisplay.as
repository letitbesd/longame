package view.scene.entitles 
{
	/**
	 * 人物血条，名字
	 * */
    import com.longame.managers.AssetsLibrary;
    
    import flash.display.*;
    import flash.events.Event;
    import flash.text.*;

    public class HealthDisplay extends Sprite implements IFrameObject
    {
        public var unitname:TextField;
        private var shown:Boolean = true;
        public var healthMc:MovieClip;
		private var healthFloat:MovieClip;
        private var _colors:Array=[0xFFFFFF,0xff0000, 0x0099ff, 0x99cc00, 0xffcc00];
		private var color:uint;
		private var _hurtNum:int;
		private var _currenthp:int;
		public var unitHp:int=25;
		private var tf:TextFormat;	
		private var remainHp:int;
		private var isUpdate:Boolean;
		private var isPlayFloat:Boolean;
        public function HealthDisplay(colorIndex:int,heroName:String)
        {
			healthMc=AssetsLibrary.getMovieClip("health");
			healthFloat=AssetsLibrary.getMovieClip("healthfloat");
			color=this._colors[colorIndex];
			tf = new TextFormat(null,16,color,true);
			healthMc.num.defaultTextFormat=tf;
			healthMc.num.text=String(unitHp);
			healthMc.unitname.defaultTextFormat=tf;
			healthMc.unitname.text=heroName;
			healthMc.unitname.visible=false;
			this._currenthp=this.unitHp;
			this.addChild(healthMc);
        }
        private function playFloat(hurt:int):void
        {
			healthFloat.float.num.defaultTextFormat=tf;
			healthFloat.float.num.text=String(hurt);
			this.addChild(healthFloat);
			this.healthFloat.play();
		}
		
		public function onFrame():void
		{
		  if(isPlayFloat==true){
		  
			  if(healthFloat.currentFrame==healthFloat.totalFrames)
			  {
				  healthFloat.stop();
				  isPlayFloat=false;
//				  EnterFrame.removeObject(this);
			  }
		  }
		  if(isUpdate==true){
		  	this.updateHp();
		  }
		}
		
		public function get hurtNum():int
		{
			return _hurtNum;
		}
		
		private function updateHp():void
		{
			if(this._currenthp>remainHp)
			{
		      --this._currenthp;
			 healthMc.num.text=String(this._currenthp);
			 isUpdate=true;
			}
			if(this._currenthp==remainHp){
			 this.playFloat(this._hurtNum);
			 isUpdate=false;
			 isPlayFloat=true;
			}
		}
		
		public function set hurtNum(value:int):void
		{
			_hurtNum = value;
			remainHp=this._currenthp-value;
			isUpdate=true;
//			EnterFrame.addObject(this);
		}
    }
}
