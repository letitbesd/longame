package {

    public class Doodad extends SimpleObject {

        public function Doodad():void{
            gravity = false;
            xVel = -0.2;
            init(10, 10);
            camFact = 0.8;
        }
    }
}
