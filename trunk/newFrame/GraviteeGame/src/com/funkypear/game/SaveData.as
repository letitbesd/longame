package com.funkypear.game
{
    import flash.net.*;
    import flash.utils.*;

    public class SaveData extends Object
    {
        public var _112e:Object;

        public function SaveData(param1)
        {
            _112e = param1;
            return;
        }// end function

        public function loadData()
        {
            var _loc_1:SharedObject;
            _loc_1 = SharedObject.getLocal("GraviteeWarsData");
            if (_loc_1.data.levelsUnlocked)
            {
                _112e.money = _loc_1.data.money;
                _112e.moneyTally = _loc_1.data.moneyTally;
                _112e.teamInfo.unitNames = _loc_1.data.unitNames;
                _112e.teamInfo.teamName = _loc_1.data.teamName;
                _112e.teamInfo.unitHealths = _loc_1.data.unitHealths;
                _112e.teamInfo.unitAccuracy = _loc_1.data.unitAccuracy;
                _112e.teamInfo.wepCount = _loc_1.data.wepCount;
                _112e.achievementsInfo.levelsUnlocked = _loc_1.data.levelsUnlocked;
                _112e.achievementsInfo.levelLows = _loc_1.data.levelLows;
                _112e.achievementsInfo.levelMedals = _loc_1.data.levelMedals;
                _112e.achievementsInfo.awarded = _loc_1.data.awards;
                _112e.achievementsInfo.rewardsDisplayed = _loc_1.data.rewardsDisplayed;
                _112e.achievementsInfo.wepsUnlocked = _loc_1.data.wepsUnlocked;
                _112e.achievementsInfo.stats = _loc_1.data.stats;
                _112e.achievementsInfo.secsPlayedStart = _loc_1.data.secsPlayedStart;
                _112e.sfx = _loc_1.data.sfx;
                _112e.music = _loc_1.data.music;
                _112e.tutorialsDone = _loc_1.data.tutorialsDone;
            }
            else
            {
                saveData();
            }// end else if
            return;
        }// end function

        public function saveData()
        {
            var _loc_1:SharedObject;
            _loc_1 = SharedObject.getLocal("GraviteeWarsData");
            _loc_1.data.money = _112e.money;
            _loc_1.data.moneyTally = _112e.moneyTally;
            _loc_1.data.teamName = _112e.teamInfo.teamName;
            _loc_1.data.unitNames = _112e.teamInfo.unitNames;
            _loc_1.data.unitHealths = _112e.teamInfo.unitHealths;
            _loc_1.data.unitAccuracy = _112e.teamInfo.unitAccuracy;
            _loc_1.data.wepCount = _112e.teamInfo.wepCount;
            _loc_1.data.levelsUnlocked = _112e.achievementsInfo.levelsUnlocked;
            _loc_1.data.levelMedals = _112e.achievementsInfo.levelMedals;
            _loc_1.data.levelLows = _112e.achievementsInfo.levelLows;
            _loc_1.data.rewardsDisplayed = _112e.achievementsInfo.rewardsDisplayed;
            _loc_1.data.awards = _112e.achievementsInfo.awarded;
            _loc_1.data.wepsUnlocked = _112e.achievementsInfo.wepsUnlocked;
            _loc_1.data.stats = _112e.achievementsInfo.stats;
            _loc_1.data.secsPlayedStart = _112e.achievementsInfo.secsPlayedStart + Math.round(getTimer() / 1000);
            _loc_1.data.sfx = _112e.sfx;
            _loc_1.data.music = _112e.music;
            _loc_1.data.tutorialsDone = _112e.tutorialsDone;
            _loc_1.flush();
            return;
        }// end function

    }
}
