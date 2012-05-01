package {
    import flash.events.*;
    import flash.display.*;
    import flash.filters.*;

    public class PostBox extends Sprite {

        private const midPos:uint = 360;
        private const outPos:uint = 900;
        private const factor:uint = 4;
        private const Ac:Number = 45;
        private const Vc:Number = 25;
        private const Tc:Number = 90;

        private var m:Breakdown;
        private var alreadyProceed:Boolean= true
        private var moveTar:uint;
        private var scoreMoney:Number;
        private var greyMat:Array;
        private var colorGreyMat:ColorMatrixFilter;
        private var gf:GlowFilter;

        public function PostBox():void{
            this.m = new Breakdown();
            this.greyMat = [0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0.3086, 0.6094, 0.082, 0, -30, 0, 0, 0, 1, 0];
            this.colorGreyMat = new ColorMatrixFilter(this.greyMat);
            this.gf = new GlowFilter(0, 1, 4, 4, 10);
            super();
            addChild(this.m);
            this.m.y = 240;
            this.m.x = 900;
            visible = false;
            this.m.b.addEventListener(MouseEvent.CLICK, this.proceed, false, 0, true);
            this.m.b2.addEventListener(MouseEvent.CLICK, this.submitScore, false, 0, true);
        }
        private function submitScore(_arg1:MouseEvent):void{
            trace("PB Sub Score");
            this.m.b2.mouseEnabled = false;
            this.m.b2.filters = [this.colorGreyMat];
			//TODO
//            _g.ROOT.agi.showScoreboardSubmit(this.scoreMoney, null, "Throw Score", _g.ROOT.scoreTypes);
        }
        public function moveIn():void{
            trace("PB Move In");
            visible = true;
            this.moveTar = this.midPos;
            this.alreadyProceed = true;
            this.m.b2.mouseEnabled = true;
            this.m.b2.filters = [this.gf];
            addEventListener(Event.ENTER_FRAME, this.runMove, false, 0, true);
        }
        public function moveOut():void{
            this.moveTar = this.outPos;
            this.alreadyProceed = false;
            addEventListener(Event.ENTER_FRAME, this.runMove, false, 0, true);
        }
        public function hide():void{
            visible = false;
            this.m.x = this.outPos;
        }
        private function proceed(_arg1:MouseEvent=null):void{
            this.moveOut();
        }
        public function calculate():void{
            var _local1:Number = ((_g.P.useD / 2.5) + (_g.starsGathered * 5));
            var _local2:Number = 1;
            var _local3:Number = (0.2 * (_g.P.useA / this.Ac));
            if (_local3 > 0.2){
                _local3 = 0.2;
            };
            _local2 = (_local2 + _local3);
            _local3 = (0.2 * ((_g.P.flightTime / 30) / this.Tc));
            if (_local3 > 0.2){
                _local3 = 0.2;
            };
            _local2 = (_local2 + _local3);
            _local3 = (0.2 * (_g.P.useV / this.Vc));
            if (_local3 > 0.2){
                _local3 = 0.2;
            };
            _local2 = (_local2 + _local3);
            _local1 = (_local1 * _local2);
            var _local4:Number = Math.round(_local1);
            var _local5:Number = _local4;
            this.scoreMoney = _local5;
            var _local6:* = ("$" + _local5.toFixed(2));
            _g.playerData.stats[3] = (_g.playerData.stats[3] + _local5);
            if (_g.playerData.stats[3] > 99999){
                _g.playerData.stats[3] = 99999;
            };
            _g.save();
            this.m.t_money.text = _local6;
            if (_local5 > 500){
                AchieveMents.putA(3);
            };
            if (_local5 > 3000){
                AchieveMents.putA(17);
            };
            this.m.t_mc1.text = new String(("$" + (_g.starsGathered * 5)));
            this.m.t_mc2.text = new String(("$" + (_g.P.useD / 2.5).toFixed(2)));
            this.m.t_mc3.text = new String((("+ " + Math.round((100 * (_local2 - 1)))) + "%"));
            this.m.t_vd1.text = new String(_g.starsGathered);
            this.m.t_vd2.text = new String((_g.P.useD.toFixed(2) + "m"));
        }
        private function runMove(_arg1:Event=null):void{
            var _local2:Number = ((this.moveTar - this.m.x) / this.factor);
            if (Math.abs(_local2) < 1){
                removeEventListener(Event.ENTER_FRAME, this.runMove);
            } else {
                this.m.x = (this.m.x + _local2);
                if (!this.alreadyProceed){
                    if (Math.abs(_local2) < 70){
                        this.alreadyProceed = true;
                        _gP.killDoodads();
                        _g.proceed();
                        var _local3 = _g.playerData.stats;
                        var _local4 = 4;
                        var _local5 = (_local3[_local4] + 1);
                        _local3[_local4] = _local5;
                    };
                };
            };
        }

    }
}
