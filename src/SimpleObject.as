package {

    public class SimpleObject extends SimpleGraphic {

        public var mass:Number= 1
        public var aero:Number= 1
        public var gravity:Boolean= true
        public var wind:Boolean= true
        public var chaos:Boolean= true
        public var held:Boolean= false
        public var xVel:Number= 0
        public var yVel:Number= 0
        public var xForce:Number= 0
        public var yForce:Number= 0
        public var ax:Number= 0
        public var ay:Number= 0
        public var camFact:Number= 1
        public var rota:Boolean= false
        public var bounceMode:Boolean= false

        public function init(mass:Number, aero:Number):void{
            this.mass = mass;
            this.aero = aero;
        }

    }
}
