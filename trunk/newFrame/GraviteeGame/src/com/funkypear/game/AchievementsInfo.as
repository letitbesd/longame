package com.funkypear.game
{
    import flash.utils.*;

    public class AchievementsInfo extends Object
    {
        public var levelMedals:Array;
        public var levelLows:Array;
        public var _113d:Array;
        public var infAmmo:Boolean = false;
        public var achievementDescs:Object;
        public var wepsUnlocked:Array;
        public var achievementNames:Object;
        public var rewardsDisplayed:Array;
        public var stats:Array;
        public var _114a:int = 0;
        public var secsPlayedStart:int = 0;
        public var aCount:int = 0;
        public var awardQueue:Array;
        public var levelsUnlocked:int = 1;
        public var _11410:Array;
        public var awarded:Array;

        public function AchievementsInfo()
        {
            awardQueue = new Array();
            _114a = 0;
            infAmmo = false;
            aCount = 0;
            levelMedals = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            levelLows = [999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999, 999];
            awarded = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
            achievementNames = ["Sector Specter", "Sector\'d", "Bo Sector", "Sector Smasher", "Sectacular", "Going for Gold", "Pieces o\' Eight", "Gold Run", "Gold Star", "Alchemist", "Starting Out", "Early Days", "One More Go", "44 Minutes", "War Addict", "Pocket Change", "Second Income", "Big Earner", "Loaded", "Retirement Fund", "Trainee Hitman", "Hitman", "Ninja", "Dr. Death", "Mega Deaths", "Drain", "Health Plan", "Unhealthy Option", "Damage Plan", "Plague", "Outta Here", "Home Run", "Sun Stroke", "Sunburn", "Zapped", "Fried", "Juiced", "20/20", "Locked & Loaded", "Its All Mine!", "Bouncer", "Weapon Master", "Double Bubble", "Triple Pain", "Quadruple Damage", "Meanie", "Old Skool", "Credit Due", "Halfway House", "Full House"];
            achievementDescs = ["Won All Battles in Sector 1", "Won All Battles in Sector 2", "Won All Battles in Sector 3", "Won All Battles in Sector 4", "Won All Battles in Sector 5", "Got a Gold Score on 5 Battles", "Got a Gold Score on 10 Battles", "Got a Gold Score on 15 Battles", "Got a Gold Score on 20 Battles", "Got a Gold Score on 25 Battles", "Played for 10 Minutes", "Played for 20 Minutes", "Played for 30 Minutes", "Played for 44 Minutes", "Played for 90 Minutes", "Earned 10,000 Credits", "Earned 50,000 Credits", "Earned 100,000 Credits", "Earned 150,000 Credits", "Earned 250,000 Credits", "Killed 20 Enemy Units", "Killed 50 Enemy Units", "Killed 100 Enemy Units", "Killed 150 Enemy Units", "Killed 200 Enemy Units", "Done 1,000 Total Damage", "Done 2,500 Total Damage", "Done 5,000 Total Damage", "Done 7,500 Total Damage", "Done 10,000 Total Damage", "Killed 1 Enemy by Knocking it Out of Bounds", "Killed 10 Enemies by Knocking them Out of Bounds", "Killed 1 Enemy by Knocking it in a Sun", "Killed 10 Enemies by Knocking them in a Sun", "Killed 1 Enemy by Knocking it in a Shield", "Killed 10 Enemies by Knocking them in a Shield", "Maxed out a Full Team\'s Health", "Maxed out a Full Team\'s Accuracy", "Bought Everything You Can from the Weapon Shop", "Upgrade your Team Completely", "Hit an Enemy with a Shot Bounced Off a Shield", "Killed an enemy with every weapon (see stats page)", "Scored a hit with a 2X Multiplier", "Scored a hit with a 3X Multiplier", "Scored a hit with a 4X Multiplier", "You made the units on the title screen cry! ", "Completed a round with the Gravitee 1 graphics", "Viewed the developer credits", "Earned 25 awards", "Earned all other awards"];
            _11410 = ["highestSectorCompleted", "highestSectorCompleted", "highestSectorCompleted", "highestSectorCompleted", "highestSectorCompleted", "goldsEarned", "goldsEarned", "goldsEarned", "goldsEarned", "goldsEarned", "secsPlayed", "secsPlayed", "secsPlayed", "secsPlayed", "secsPlayed", "moneyEarned", "moneyEarned", "moneyEarned", "moneyEarned", "moneyEarned", "enemyKills", "enemyKills", "enemyKills", "enemyKills", "enemyKills", "damageDone", "damageDone", "damageDone", "damageDone", "damageDone", "enemiesOOB", "enemiesOOB", "enemiesSun", "enemiesSun", "enemiesShield", "enemiesShield", "totalHealth", "totalAccuracy", "totalWeps", "totalMax", "shieldRebounds", "wepsUsedToKill", "highestMulti", "highestMulti", "highestMulti", "botheredUnits", "originalGFX", "creditsViewed", "awardCount", "awardCount"];
            _113d = [1, 2, 3, 4, 5, 5, 10, 15, 20, 25, 600, 1200, 1800, 2640, 5400, 10000, 50000, 100000, 150000, 250000, 20, 50, 100, 150, 200, 1000, 2500, 5000, 7500, 10000, 1, 10, 1, 10, 1, 10, 120, 120, 45, 285, 1, 1, 2, 3, 4, 1, 1, 1, 25, 49];
            stats = new Array();
            rewardsDisplayed = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
            wepsUnlocked = [null, true, false, false, false, false, false, false, false, false, false];
            levelsUnlocked = 1;
            secsPlayedStart = 0;
            resetStats();
            return;
        }// end function

        public function _113e(param1)
        {
            _1148(50 + param1);
            rewardsDisplayed[param1] = true;
            return;
        }// end function

        public function checkWepsUnlocked()
        {
            if (levelsUnlocked >= 3 && !wepsUnlocked[2])
            {
                _1149(2);
                _113e(0);
            }// end if
            if (levelsUnlocked >= 5 && !wepsUnlocked[4])
            {
                _1149(4);
                _113e(1);
            }// end if
            if (levelsUnlocked >= 6 && !wepsUnlocked[6])
            {
                _1149(6);
                _113e(2);
            }// end if
            if (levelsUnlocked >= 7 && !wepsUnlocked[8])
            {
                _1149(8);
                _113e(7);
            }// end if
            if (levelsUnlocked >= 8 && !wepsUnlocked[9])
            {
                _1149(9);
                _113e(8);
            }// end if
            if (levelsUnlocked >= 9 && !wepsUnlocked[5])
            {
                _1149(5);
                _113e(9);
            }// end if
            if (levelsUnlocked >= 11 && !wepsUnlocked[10])
            {
                _1149(10);
                _113e(14);
            }// end if
            if (levelsUnlocked >= 13 && !wepsUnlocked[7])
            {
                _1149(7);
                _113e(15);
            }// end if
            if (levelsUnlocked >= 15 && !wepsUnlocked[3])
            {
                _1149(3);
                _113e(16);
            }// end if
            return;
        }// end function

        public function checkAchievements()
        {
            var _loc_1:Boolean;
            var _loc_2:*;
            var _loc_3:*;
            var _loc_4:int;
            var _loc_5:Boolean;
            _loc_1 = false;
            stats["secsPlayed"] = Math.floor(getTimer() / 1000) + secsPlayedStart;
            _loc_2 = Math.floor(stats["secsPlayed"] / 60);
            if (_loc_2 > _114a)
            {
                _loc_1 = true;
                _114a = _loc_2;
            }// end if
            if (stats["wep1Kills"] > 0 && stats["wep2Kills"] > 0 && stats["wep3Kills"] > 0 && stats["wep4Kills"] > 0 && stats["wep5Kills"] > 0 && stats["wep6Kills"] > 0 && stats["wep7Kills"] > 0 && stats["wep8Kills"] > 0)
            {
                stats["wepsUsedToKill"] = 1;
            }// end if
            _loc_3 = aCount;
            aCount = 0;
            _loc_4 = 0;
            while (_loc_4 < 50)
            {
                // label
                if (!awarded[_loc_4])
                {
                    if (stats[_11410[_loc_4]] >= _113d[_loc_4])
                    {
                        awarded[_loc_4] = true;
                        _1148(_loc_4);
                        aCount++;
                        _loc_1 = true;
                    }// end if
                }
                else
                {
                    aCount++;
                }// end else if
                _loc_4++;
            }// end while
            stats["awardCount"] = aCount;
            _loc_5 = _114e(aCount);
            if (_loc_5)
            {
                _loc_1 = true;
            }// end if
            if (aCount == 50)
            {
                infAmmo = true;
            }// end if
            if (_loc_1)
            {
                return true;
            }// end if
            return false;
        }// end function

        public function resetStats()
        {
            stats["highestSectorCompleted"] = 0;
            stats["goldsEarned"] = 0;
            stats["secsPlayed"] = 0;
            stats["moneyEarned"] = 0;
            stats["enemyKills"] = 0;
            stats["friendlyKills"] = 0;
            stats["longestShot"] = 0;
            stats["damageDone"] = 0;
            stats["enemiesOOB"] = 0;
            stats["enemiesSun"] = 0;
            stats["enemiesShield"] = 0;
            stats["totalMax"] = 0;
            stats["totalHealth"] = 0;
            stats["totalAccuracy"] = 0;
            stats["totalWeps"] = 0;
            stats["shieldRebounds"] = 0;
            stats["wepsUsedToKill"] = 0;
            stats["highestMulti"] = 0;
            stats["brokenSpeakers"] = 0;
            stats["botheredUnits"] = 0;
            stats["creditsViewed"] = 0;
            stats["originalGFX"] = 0;
            stats["maxedTeam"] = 0;
            stats["awardCount"] = 0;
            stats["wep1Kills"] = 0;
            stats["wep2Kills"] = 0;
            stats["wep3Kills"] = 0;
            stats["wep4Kills"] = 0;
            stats["wep5Kills"] = 0;
            stats["wep6Kills"] = 0;
            stats["wep7Kills"] = 0;
            stats["wep8Kills"] = 0;
            return;
        }// end function

        public function _1148(param1)
        {
            awardQueue.push(param1);
            return;
        }// end function

        public function _1149(param1)
        {
            wepsUnlocked[param1] = true;
            return;
        }// end function

        public function _114e(param1)
        {
            var _loc_2:Boolean;
            _loc_2 = false;
            if (param1 >= 4 && !rewardsDisplayed[3])
            {
                _113e(3);
                _loc_2 = true;
            }// end if
            if (param1 >= 8 && !rewardsDisplayed[4])
            {
                _113e(4);
                _loc_2 = true;
            }// end if
            if (param1 >= 12 && !rewardsDisplayed[5])
            {
                _113e(5);
                _loc_2 = true;
            }// end if
            if (param1 >= 16 && !rewardsDisplayed[6])
            {
                _113e(6);
                _loc_2 = true;
            }// end if
            if (param1 >= 20 && !rewardsDisplayed[10])
            {
                _113e(10);
                _loc_2 = true;
            }// end if
            if (param1 >= 24 && !rewardsDisplayed[11])
            {
                _113e(11);
                _loc_2 = true;
            }// end if
            if (param1 >= 28 && !rewardsDisplayed[12])
            {
                _113e(12);
                _loc_2 = true;
            }// end if
            if (param1 >= 32 && !rewardsDisplayed[13])
            {
                _113e(13);
                _loc_2 = true;
            }// end if
            if (param1 >= 36 && !rewardsDisplayed[17])
            {
                _113e(17);
                _loc_2 = true;
            }// end if
            if (param1 >= 40 && !rewardsDisplayed[18])
            {
                _113e(18);
                _loc_2 = true;
            }// end if
            if (param1 >= 30 && !rewardsDisplayed[19])
            {
                _113e(19);
                _loc_2 = true;
            }// end if
            if (param1 >= 50 && !rewardsDisplayed[20])
            {
                _113e(20);
                _loc_2 = true;
            }// end if
            return _loc_2;
        }// end function

    }
}
