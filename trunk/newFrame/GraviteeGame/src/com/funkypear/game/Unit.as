package com.funkypear.game
{
    import flash.display.*;

    public class Unit extends MovieClip
    {
        public var danceID:int = 0;
        public var healthShown:int = 25;
        public var positionPlanet:int = 0;
        public var unitName:String = "";
        public var health:int = 25;
        public var team:int = -1;
        public var killReg:int = -1;
        public var timeSince:int = 0;
        public var damageTaken:int = 0;
        public var positionElementYTeleTo:Number = -1;
        public var hitarea:MovieClip;
        public var healthDisplay:HealthDisplay;
        public var maxHealth:int = 25;
        public var graphic:MovieClip;
        public var isWalking:Boolean = false;
        public var accuracy:int = 1;
        public var animState:String = "bob";
        public var poison:MovieClip;
        public var positionElementX:Number = 0;
        public var positionElementY:Number = 0;
        public var positionElementTeleTo:int = -1;
        public var removeMe:Boolean = false;
        public var positionPlanetTeleTo:int = -1;
        public var positionElementXTeleTo:Number = -1;
        public var positionPlace:Number = 0;
        public var positionElement:int = 0;
        public var poisoned:Boolean = false;
        public var positionShapeTeleTo:int = -1;
        public var positionShape:int = 0;

        public function Unit()
        {
            healthDisplay = new HealthDisplay();
            addFrameScript(0, frame1, 9, frame10, 19, frame20, 29, frame30, 39, frame40, 49, frame50, 59, frame60, 69, frame70, 79, frame80, 89, frame90, 99, frame100, 109, frame110, 119, frame120, 129, frame130, 139, frame140, 149, frame150, 159, frame160, 169, frame170, 179, frame180, 189, _12bf, 199, _12d4, 209, _12d8, 219, _12da, 229, frame230, 239, _12d10, 249, _12e5, 259, _12ea, 269, _12ed, 279, _12b7, 289, frame290, 299, _12c8, 309, _12cf, 319, _12d2, 329, _12d6, 339, _12db, 349, _12dd, 359, _12df, 369, _12e4, 379, _12e9, 389, _12ec, 399, _12c3, 409, _12c5, 419, _12c7, 429, _12ce, 439, _12d1, 449, _12d5, 459, _12dc);
            return;
        }// end function

        function _12b7()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame160()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame290()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame170()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame10()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame180()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame1()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12bf()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame20()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame30()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame40()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12c3()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12c5()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame50()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12c7()
        {
            stop();
            updateCol();
            graphic.bubble.qmark.scaleX = scaleX;
            return;
        }// end function

        function _12c8()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame60()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12ce()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12cf()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame70()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d1()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d2()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame80()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d4()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d5()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d6()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame90()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d8()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12da()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame100()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12db()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12dc()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12dd()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame230()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame110()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12df()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12d10()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame120()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame130()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12e4()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12e5()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame140()
        {
            stop();
            updateCol();
            return;
        }// end function

        public function changeAnim(param1)
        {
            animState = param1;
            gotoAndStop(param1);
            return;
        }// end function

        function _12e9()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12ea()
        {
            stop();
            updateCol();
            return;
        }// end function

        public function updateCol()
        {
            graphic.head.col.gotoAndStop(team + 2);
            graphic.body.col.gotoAndStop(team + 2);
            graphic.lefthand.col.gotoAndStop(team + 2);
            graphic.righthand.col.gotoAndStop(team + 2);
            graphic.leftfoot.col.gotoAndStop(team + 2);
            graphic.rightfoot.col.gotoAndStop(team + 2);
            return;
        }// end function

        function _12ec()
        {
            stop();
            updateCol();
            return;
        }// end function

        function _12ed()
        {
            stop();
            updateCol();
            return;
        }// end function

        function frame150()
        {
            stop();
            updateCol();
            return;
        }// end function

    }
}
