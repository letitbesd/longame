package {

    public class AchieveMents {

        public static var LIST:Array = [];
        public static var places:Array = [false, false, false, false];

        public static function init():void{
            LIST = [];
            make(0, "Easy Gliding", "Travel 300m without using any fuel during your flight.");
            make(1, "Second Wind", "Get boosted by 3 Windmills in a single flight.");
            make(2, "Swan Dive", "Fly straight downwards at terminal velocity.");
            make(3, "Profit", "Collect $500 in a single flight.");
            make(4, "Bird Hunter", "Reach 5x Crane Bonus.");
            make(5, "All Star", "Collect all the available types of stars in a single flight.");
            make(6, "Flying Low", "Travel for 300m without exceeding 3m altitude.");
            make(7, "Close Call", "Escape from a stall at less than 3m altitude.");
            make(8, "Long Haul", "Travel 1000m in a single flight.");
            make(9, "Icarus", "Collect 30 Space Stars in a single flight.");
            make(10, "Galaxy", "Collect 100 stars in a single flight.");
            make(11, "Supersonic", "Reach a velocity of 25 m/s.");
            make(12, "Royal Mail", "Clear England in 8 days or under.");
            make(13, "Borbonne-Le-Bonne", "Clear France in 15 days or under.");
            make(14, "The Prophecy", "Clear Egypt in 21 days or under.");
            make(15, "To Be a Bird ", "Clear Kenya in 26 days or under.");
            make(16, "Efficiency", "Clear Japan in under 30 days.");
            make(17, "Big Money", "Collect $3000 in a single flight.");
            make(18, "Daredevil", "Successfully escape from stalling three times in a single flight.");
            make(19, "What Happen?", "Bounce along for another 100m after making contact with the ground.");
            make(20, "20 Stars", "Collect 20 Stars.");
            make(21, "High Flyer", "Reach an altitude of 15m.");
            make(22, "Lift Off", "Travel 200m in a single flight.");
            make(23, "Hourglass", "Be flying for 1 minute.");
        }
        private static function make(id:uint, name:String, description:String):void{
            LIST[id] = {t:name, desc:description}
        }
        public static function putA(id:uint):void{
            var _local2:Boolean;
            var _local3:*;
            if (_g.playerData.achievements[id] == false){
                _g.playerData.achievements[id] = true;
                _local2 = false;
                _local3 = 0;
                while (_local3 < 4) {
                    if (!_local2){
                        if (places[_local3] == false){
                            places[_local3] = true;
                            _g.getAch(new aHolder(id, _local3));
                            _local2 = true;
                        }
                    }
                    _local3++;
                }
            }
        }
        public static function killA(id:uint):void{
            places[id] = false;
        }

    }
}
