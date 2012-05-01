package {

    public class TipObject {

        public var tipName:String;
        public var tipCostM:uint;
        public var tipCostP:uint;
        public var tipCostE:uint;
        public var tipDesc:String;
        public var tipCostI:uint;

        public function TipObject(_arg1:String="", _arg2:String="", _arg3:uint=0, _arg4:uint=0, _arg5:uint=0, _arg6:uint=0):void{
            this.tipName = _arg1;
            this.tipDesc = _arg2;
            this.tipCostM = _arg3;
            this.tipCostP = _arg4;
            this.tipCostE = _arg5;
            this.tipCostI = _arg6;
        }
    }
}
