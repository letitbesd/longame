package screens
{
	import com.longame.core.IAnimatedObject;
	import com.longame.display.screen.McScreen;
	import com.longame.managers.ProcessManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import model.PlayerData;
	
	public class PostScreen extends McScreen implements IAnimatedObject
	{
		[Child]	public var pc1:MovieClip;
		[Child] public var pc2:MovieClip;
		[Child] public var nav:MovieClip;
		[Child] public var dayText:TextField;
		[Child] public var t_now:TextField;
		[Child] public var t_max:TextField;
		
		private var levelUp:levelUpSign;

		private var tweenMax:Number;
		private var tweenNow:Number;
		private var tweenEnds:Number;
		private var tweenSect:Number;
		private var navStart:Number;
		private var navEnd:Number;
		private var distNow:Number;
		private var distAdd:Number;
		private var distMax:Number;
		private var distDisplay:Number;
		private var distUp:Number;
		
		public function PostScreen()
		{
			super("Post.swf@content");
		}
		public function onFrame(time:Number):void
		{
			//TODO
//			trace((skin as MovieClip).currentFrame);
			if((skin as MovieClip).currentFrame==(skin as MovieClip).totalFrames)
			{
				Engine.showScreen(UpgradeScreen);
				ProcessManager.removeAnimatedObject(this);
			}
			if(levelUp){
				if(levelUp.currentFrame==levelUp.totalFrames){
					levelUp.parent.removeChild(levelUp);
					levelUp=null;
					Engine.showScreen(StoryScreen);
//					this.ref.sceneTrans(1, "CutScene");
				}
			}
		}
		override protected function initSkinParts():void
		{
			super.initSkinParts();
			pc1.stop();
			pc2.stop();
			
			ProcessManager.addAnimatedObject(this);
			
			addEventListener(KeyboardEvent.KEY_DOWN, this.skipThis);
			this.tweenMax = 70;
			this.tweenNow = 0;
			this.tweenEnds = 20;
			this.tweenSect = (this.tweenMax - (this.tweenEnds * 2));
			this.navStart = 188;
			this.navEnd = 527;
			this.distNow = _g.playerData.stats[2];
			this.distAdd = _g.adder;
			this.distMax = PlayerData.zoneLimits[_g.playerData.stats[1]];
			this.distDisplay = this.distNow;
			this.distUp = (_g.adder / this.tweenSect);
			this.nav.x = (this.navStart + ((this.navEnd - this.navStart) * (this.distNow / this.distMax)));
			soundKon.playMusic(0);
			this.t_now.text = (new String(Math.round(this.distDisplay)) + "m");
			this.t_max.text = (new String(this.distMax) + "m");
			this.dayText.text = new String((_g.playerData.stats[4] - 1));
			_g.playerData.stats[2] = (_g.playerData.stats[2] + _g.adder);
			if (_g.changeLevel){
				_g.changeLevel = false;
				this.pc1.gotoAndStop(_g.playerData.stats[1]);
				this.pc2.gotoAndStop((1 + _g.playerData.stats[1]));
				(skin as MovieClip).play();
			} else {
				this.pc1.gotoAndStop((1 + _g.playerData.stats[1]));
				this.pc2.stop();
				addEventListener(Event.ENTER_FRAME, this.runTweener, false, 0, true);
			}
			_g.justLeveled = false;
			stage.focus = this;
		}
		public function skipThis(_arg1:KeyboardEvent):void
		{
			if (_arg1.keyCode == Keyboard.SPACE){
				if (!_g.justLeveled){
					this.distDisplay = (this.distNow + _g.adder);
					//升级
					if (this.distDisplay >= this.distMax){
						this.distDisplay = this.distMax;
						_g.justLeveled = true;
						this.levelUpStage();
					} else {
						Engine.showScreen(UpgradeScreen);
					}
				} else {
					Engine.showScreen(UpgradeScreen);
				}
				removeEventListener(KeyboardEvent.KEY_DOWN, this.skipThis);
				removeEventListener(Event.ENTER_FRAME, this.runTweener);
				this.t_now.text = (new String(Math.round(this.distDisplay)) + "m");
				this.nav.x = (this.navStart + ((this.navEnd - this.navStart) * (this.distDisplay / this.distMax)));
			}
		}
		public function runTweener(_arg1:Event=null):void{
			this.tweenNow++;
			if ((((this.tweenNow >= this.tweenEnds)) && ((this.tweenNow < (this.tweenMax - this.tweenEnds))))){
				this.distDisplay = (this.distDisplay + this.distUp);
				this.nav.x = (this.navStart + ((this.navEnd - this.navStart) * (this.distDisplay / this.distMax)));
				this.t_now.text = (new String(Math.round(this.distDisplay)) + "m");
				//升级
				if (this.distDisplay >= this.distMax){
					this.distDisplay = this.distMax;
					this.t_now.text = (new String(Math.round(this.distDisplay)) + "m");
					_g.justLeveled = true;
					this.levelUpStage();
					removeEventListener(Event.ENTER_FRAME, this.runTweener);
					removeEventListener(KeyboardEvent.KEY_DOWN, this.skipThis);
				}
			}
			if (!_g.justLeveled){
				if (this.tweenNow == this.tweenMax){
					removeEventListener(Event.ENTER_FRAME, this.runTweener);
					removeEventListener(KeyboardEvent.KEY_DOWN, this.skipThis);
					Engine.showScreen(UpgradeScreen);
				}
			}
		}
		public function levelUpStage():void{
			if (_g.playerData.stats[1] == 0){
				if ((_g.playerData.stats[4] - 1) <= 8){
					AchieveMents.putA(12);
				}
			}
			if (_g.playerData.stats[1] == 1){
				if ((_g.playerData.stats[4] - 1) <= 16){
					AchieveMents.putA(13);
				}
			}
			if (_g.playerData.stats[1] == 2){
				if ((_g.playerData.stats[4] - 1) <= 21){
					AchieveMents.putA(14);
				}
			}
			if (_g.playerData.stats[1] == 3){
				if ((_g.playerData.stats[4] - 1) <= 26){
					AchieveMents.putA(15);
				}
			}
			if (_g.playerData.stats[1] == 4){
				if ((_g.playerData.stats[4] - 1) <= 30){
					AchieveMents.putA(16);
				}
			}
			_g.playerData.stats[1] = _g.playerData.stats[1] + 1;
			_g.playerData.stats[2] = 0;
			levelUp = new levelUpSign();
			addChild(levelUp);
			levelUp.ref = this;
			levelUp.x = 360;
			levelUp.y = 240;
			levelUp.play();
		}
		override protected function doDispose():void
		{
			ProcessManager.removeAnimatedObject(this);
			super.doDispose();
		}
	}
}