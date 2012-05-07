package {
    import flash.events.*;

    public class FEvent extends Event {

        public var f:Number= 1
        public var u:uint;
        public var obj:Object;
        public var sender:String;

        public static const TICK:String = "tick";

        public function FEvent(type:String, f:Number=1, data:Object=null, u:uint=99, sender:String=null, bubble:Boolean=false, weakref:Boolean=true){
            super(type, bubble, weakref);
            this.f = f;
            this.obj = data;
            this.u = u;
            this.sender = sender;
        }
    }
} 
