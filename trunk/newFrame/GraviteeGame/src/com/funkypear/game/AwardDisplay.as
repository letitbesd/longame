package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class AwardDisplay extends MovieClip
    {
        public var toptext:TextField;
        public var _11ea:Array;
        public var shown:Boolean = false;
        public var _11eb:int = 0;
        public var awardicon:MovieClip;
        public var awardname:TextField;

        public function AwardDisplay()
        {
            _11eb = 0;
            shown = false;
            _11ea = [["Weapon Unlocked", "Cluster Rocket"], ["Weapon Unlocked", "Sniper Rifle"], ["Weapon Unlocked", "Poisoned Dart"], ["Animation Unlocked", "Gum"], ["Animation Unlocked", "Head Bang"], ["Animation Unlocked", "Phone"], ["Animation Unlocked", "Hands"], ["Weapon Unlocked", "Land Mine"], ["Weapon Unlocked", "Shield"], ["Weapon Unlocked", "Drill Bomb"], ["Animation Unlocked", "Yo Yo"], ["Animation Unlocked", "The Worm"], ["Animation Unlocked", "Juggle"], ["Animation Unlocked", "Moon Walk"], ["Weapon Unlocked", "Teleport"], ["Weapon Unlocked", "Nuke"], ["Weapon Unlocked", "Meteor Shower"], ["Animation Unlocked", "Music"], ["Animation Unlocked", "YeeHaw"], ["Feature Unlocked", "Classic Graphics"], ["Feature Unlocked", "Infinitee"]];
            addEventListener(Event.ENTER_FRAME, mainLoop);
            return;
        }// end function

        public function showMe()
        {
            shown = true;
            _11eb = 0;
            return;
        }// end function

        public function hideMe()
        {
            shown = false;
            _11eb = 0;
            return;
        }// end function

        public function _11e10(param1, param2)
        {
            var _loc_3:int;
            if (param1 > 50)
            {
                _loc_3 = param1 - 51;
                awardicon.gotoAndStop(2);
                toptext.text = _11ea[_loc_3][0];
                awardname.text = _11ea[_loc_3][1];
            }
            else
            {
                toptext.text = "Award Unlocked";
                awardname.text = param2;
                awardicon.awardnumber.text = param1.toString();
            }// end else if
            return;
        }// end function

        public function mainLoop(param1:Event)
        {
            if (shown && y > 456)
            {
                y = y - 5;
            }
            else if (!shown && y < 506)
            {
                y = y + 5;
                if (y == 506)
                {
                    awardicon.gotoAndStop(1);
                }// end if
            }
            else
            {
                if (!shown && MovieClip(root).achievementsInfo.awardQueue.length > 0)
                {
                    _11e10(MovieClip(root).achievementsInfo.awardQueue[0] + 1, MovieClip(root).achievementsInfo.achievementNames[MovieClip(root).achievementsInfo.awardQueue[0]]);
                    MovieClip(root).achievementsInfo.awardQueue.splice(0, 1);
                    if (MovieClip(root).sfx)
                    {
                        MovieClip(root).soundmanager.sound_award.gotoAndPlay(2);
                    }// end if
                    showMe();
                }// end if
                _11eb++;
                if (shown && _11eb > 60)
                {
                    hideMe();
                }// end else if
            }// end else if
            return;
        }// end function

    }
}
