package model {

    public class UpgradeObject {

        public var id:uint;
        public var name:String;
        public var max:uint;
        public var req:uint;
        public var cost:Array;
        public var toolTip:String;
        public var reqTT;
        public var tipVar:Array;
        public var graphics:uint;

        public function UpgradeObject(name:String, id:uint, max:uint, cost:Array, tip:String, tipVar:Array):void{
            this.name = name;
            this.id = id;
            this.max = max;
            this.cost = cost;
            this.toolTip = tip;
            this.tipVar = tipVar;
        }
    }
}
