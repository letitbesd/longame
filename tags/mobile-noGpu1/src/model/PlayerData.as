package model {
	import flash.net.SharedObject;

    public class PlayerData {

        public var upgrades:Array=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        public var achievements:Array=[];
        public var customize:Array= [15851976, 0, 0xFF0000];
		//stats[3]是金钱
        public var stats:Array= ["PlaneName", 0, 0,0, 1];
        public var tut:Array=[];

        public static var upgradeData:Array = new Array();
        public static var currentId:uint = 0;
        public static var uo:UpgradeObject;
		//一共5个场景,5个级别,好像飞行距离到了就可以升级到下一个场景
        public static var zoneLimits:Array = [1000, 2200, 3500, 4600, 5700];
        private static var saveGame1:SharedObject = SharedObject.getLocal("Flight1");
        private static var saveGame2:SharedObject = SharedObject.getLocal("Flight2");
        private static var saveGame3:SharedObject = SharedObject.getLocal("Flight3");
		public static const zoneMax:uint = (zoneLimits.length - 1);
		
        public function PlayerData():void{
            super();
            for (var ach:* in AchieveMents.LIST) {
                this.achievements[ach] = false;
            }
        }
        public static function init():void
		{
            make("Better Model", 4, [260, 820, 1900, 2830], "Improves the plane in general, and gives you additional fuel.");
            make("Lightweight", 5, [30, 120, 360, 950, 2140], "Your plane becomes lighter, and falls slower.");
            make("Aerodynamic", 5, [40, 170, 480, 1260, 2750], "Your plane retains its velocity for longer.");
            make("Rudder Control", 3, [80, 290, 650], "You are able to control your plane at the cost of fuel. Higher levels give you better control.");
            make("Throwing Power", 5, [90, 180, 430, 900, 1200], "The initial power of throwing the plane is increased by @ percent.", ["10", "20", "30", "40", "50", "50"]);
            make("Fire Engine", 3, [130, 480, 1490], "Hold SPACEBAR to activate your @.", ["engine", "better engine", "SUPER engine", "SUPER engine"]);
            make("Crane Booster", 1, [485], "Cranes now also give you a boost.");
            make("Lucky Star", 3, [150, 375, 1450], "Normal stars have an additional @ percent chance to spawn as a gold star.", ["2", "4", "6", "6"]);
            make("Green Fuel", 3, [180, 590, 1350], "Reduces fuel consumption by @ percent.", ["10", "20", "30", "30"]);
            make("Hurricane", 3, [160, 310, 890], "Your plane resists negative wind effects, and gain greater boost from windmills.");
            make("Emergency Booster", 1, [400], "Whenever you stall, you are given a chance to restart your engines.");
            make("Rainbow Stars", 1, [1750], "Once per flight, you can turn all stars into rainbow-stars for 10 seconds.");
            make("Crane Duration", 2, [325, 1250], "Increases the duration of the Crane Bonus by @.", ["1 second", "2 seconds", "2 seconds"]);
            make("Wind Detector", 1, [500], "Jetstream warnings last 1 second longer.");
            make("Mystery Upgrade", 1, [3000], "A mysterious and impractical upgrade that is probably not worth the cost.");
        }
        private static function make(name:String="Untitled", max:uint=0, cost:Array=null, tip:String="Unavailable", tipVar:Array=null):void{
            uo = new UpgradeObject(name, currentId, max, cost, tip, tipVar);
            currentId++;
            upgradeData.push(uo);
        }
        public static function saveGame(slot:uint):void{
            var saved:SharedObject= PlayerData[("saveGame" + slot)];
            var data:PlayerData = _g.playerData;
            saved.data.upgrades = data.upgrades;
            saved.data.achievements = data.achievements;
            saved.data.customize = data.customize;
            saved.data.stats = data.stats;
            saved.data.tut = data.tut;
            saved.data.saved = true;
            saved.flush();
        }
        public static function mirrorGame(slot:uint=1):PlayerData{
            var saved:SharedObject= PlayerData[("saveGame" + slot)];
            var data:PlayerData = new PlayerData();
            if (saved.data.saved != null){
                data.upgrades = saved.data.upgrades;
                data.achievements = saved.data.achievements;
                data.customize = saved.data.customize;
                data.stats = saved.data.stats;
                data.tut = saved.data.tut;
            }
            return data;
        }
        public static function loadGame(_arg1:uint=1):void{
            var saved:SharedObject = PlayerData[("saveGame" + _arg1)];
            var data:PlayerData = _g.playerData;
            if (saved.data.saved != null){
                data.upgrades = saved.data.upgrades;
                data.achievements = saved.data.achievements;
                data.customize = saved.data.customize;
                data.stats = saved.data.stats;
                data.tut = saved.data.tut;
            }
        }
    }
}
