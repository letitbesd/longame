package com.funkypear.game
{

    public class TeamInfo extends Object
    {
        public var unitNames:Array;
        public var teamName:String = "Your Team";
        public var wepCount:Array;
        public var unitHealths:Array;
        public var unitAccuracy:Array;

        public function TeamInfo()
        {
            unitNames = ["Name 1", "Name 2", "Name 3", "Name 4", "Name 5", "Name 6"];
            unitHealths = [3, 3, 0, 0, 0, 0];
            unitAccuracy = [3, 3, 0, 0, 0, 0];
            wepCount = [-1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
            teamName = "Your Team";
            return;
        }// end function

    }
}
