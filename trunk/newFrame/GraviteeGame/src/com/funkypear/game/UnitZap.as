package com.funkypear.game
{
    import flash.display.*;

    public class UnitZap extends Explosion
    {
        public var leftfoot:MovieClip;
        public var lefthand:MovieClip;
        public var team:int = 0;
        public var rightfoot:MovieClip;
        public var righthand:MovieClip;
        public var body:MovieClip;
        public var head:MovieClip;

        public function UnitZap()
        {
            team = 0;
            addFrameScript(1, frame2);
            return;
        }// end function

        function frame2()
        {
            head.col.gotoAndStop(team + 2);
            body.col.gotoAndStop(team + 2);
            lefthand.col.gotoAndStop(team + 2);
            righthand.col.gotoAndStop(team + 2);
            leftfoot.col.gotoAndStop(team + 2);
            rightfoot.col.gotoAndStop(team + 2);
            return;
        }// end function

    }
}
