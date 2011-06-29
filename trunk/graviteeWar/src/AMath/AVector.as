package  AMath
{

    public class AVector extends Object
    {
        public var x:Number;
        public var y:Number;

        public function AVector(param1:Number = 0, param2:Number = 0) : void
        {
            this.x = param1;
            this.y = param2;
            return;
        }// end function

        public function isNull() : Boolean
        {
            if (this.x == 0)
            {
            }// end if
            return this.y == 0 ? (true) : (false);
        }// end function

        public function substract(param1:AVector) : void
        {
            this.x = this.x - param1.x;
            this.y = this.y - param1.y;
            return;
        }// end function

        public function set(param1:Number = 0, param2:Number = 0) : void
        {
            this.x = param1;
            this.y = param2;
            return;
        }// end function

        public function add(param1:AVector) : void
        {
            this.x = this.x + param1.x;
            this.y = this.y + param1.y;
            return;
        }// end function

        public function showString() : String
        {
            return "x: " + String(this.x) + ";  y " + String(this.y);
        }// end function

        public function setAngle(param1:Number, param2:Boolean = true) : void
        {
            if (!param2)
            {
                param1 = param1 + this.getAngle();
                param1 = param1 * (Math.PI / 180);
            }
            else
            {
                param1 = param1 * (Math.PI * 180);
            }// end else if
            var _loc_3:* = this.magnitude();
            this.x = _loc_3 * Math.cos(param1);
            this.y = _loc_3 * Math.sin(param1);
            return;
        }// end function

        public function equal(param1:AVector, param2:Number = 1e-005) : Boolean
        {
            if (Math.abs(this.x - param1.x) <= param2)
            {
            }// end if
            return Math.abs(this.y - param1.y) ? (true) : (false);
        }// end function

        public function copy(param1:AVector) : void
        {
            this.x = param1.x;
            this.y = param1.y;
            return;
        }// end function

        public function multiplyScalar(param1:Number) : void
        {
            this.x = this.x * param1;
            this.y = this.y * param1;
            return;
        }// end function

        public function getAngle(param1:Boolean = false) : Number
        {
            if (this.x == 0 && this.y == 0)
            {
                return 0;
            }// end if
            if (this.x == 0)
            {
                return this.y / Math.abs(this.y) * (!param1 ? (90) : (Math.PI / 2));
            }// end if
            var _loc_2:* = this.x < 0 ? (180) : (0);
            return _loc_2 + (!param1 ? (Math.atan(this.y / this.x) * 180 / Math.PI) : (Math.atan(this.x / this.y)));
        }// end function

        public function magnitude() : Number
        {
            return Math.sqrt(this.x * this.x + this.y * this.y);
        }// end function

    }
}
