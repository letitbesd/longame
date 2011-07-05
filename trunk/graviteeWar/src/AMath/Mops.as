package  AMath
{

    public class Mops extends Object
    {

        public function Mops()
        {
			
            return;
        }// end function

        public static function inRange(param1:Number, param2:Number, param3:Number) : Boolean
        {
            var _loc_5:*;
            var _loc_4:Boolean;
            if (param2 > param3)
            {
                _loc_5 = param2;
                param2 = param3;
                param3 = param2;
                _loc_5 = null;
            }
            if (param1 <= param3 && param1 >= param2)
            {
                _loc_4 = true;
            }// end if
            return _loc_4;
        }// end function

        public static function angleToX(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return Math.atan((param4 - param2) / (param3 - param1));
        }// end function

        public static function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
        }// end function

    }
}
