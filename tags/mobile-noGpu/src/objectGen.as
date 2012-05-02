package {
    import flash.geom.*;

    public class objectGen {

        private static const lowestZone:Number = 200;

        private static function FGZ(low:Boolean=true):Point{
            var _local3:int;
            var _local4:Number;
            var _local5:Number;
            var _local2:Number = _gD.camPoint.y;
            if (_g.P.yVel > 0){
                _local2 = (_local2 + _g.sh2);
            } else {
                _local2 = (_local2 - _g.sh2);
            }
            if (((((_local2 + (2 * _g.sh2)) > lowestZone)) && (low))){
                _local2 = (100 - (2 * _g.sh2));
            }
            if (_g.P.xVel > 0){
                _local3 = 1;
                _local4 = 100;
            } else {
                _local3 = -1;
                _local4 = -100;
            }
            _local2 = (_local2 - (_g.sh2 * 2));
            _local2 = (_local2 + ((Math.random() * _g.sh2) * 4));
            if (_local3 == 1){
                _local5 = (_gD.camPoint.x - _g.sw2);
            } else {
                _local5 = (_gD.camPoint.x - (_g.sw2 * 3));
            }
            if ((((_local2 > (_gD.camPoint.y - (_g.sh2 + 100)))) && ((_local2 < (_gD.camPoint.y + (_g.sh2 + 100)))))){
                if (_local3 == 1){
                    _local5 = (_gD.camPoint.x + _g.sw2);
                }
                _local5 = (_local5 + (Math.random() * (_g.sw2 * 2)));
            } else {
                _local5 = (_local5 + (Math.random() * (_g.sw2 * 4)));
            }
            return (new Point(_local5, _local2));
        }
        public static function generateObject():void{
            var _local1:Point = FGZ();
            var _local2:Doodad = new Doodad();
            _gP.physicalDoodads.push(_local2);
            _gD.put(_local2, _gD.G4);
            _local2.ax = (_local2.x = _local1.x);
            _local2.ay = (_local2.y = _local1.y);
        }
        private static function findZoneEasy(fixPos:Boolean=false):Point{
            var _local2:Number;
            var _local3:Number;
            if (!fixPos){
                _local3 = (_gD.camPoint.x + 400);
            } else {
                _local3 = (250 + (Math.random() * 350));
            }
            if (_gD.camPoint.y < 0){
                _local2 = _gD.camPoint.y;
            } else {
                _local2 = 0;
            }
            if (!fixPos){
                _local2 = (_local2 + (-400 + (Math.random() * 800)));
            } else {
                _local2 = (_local2 + (Math.random() * 400));
            }
            return new Point(_local3, _local2);
        }
        public static function generateCollect(fixPos:Boolean=false, type:uint=0):void{
            var pos:Point = findZoneEasy(fixPos);
            var obj:CollectObject = new CollectObject(type);
            _gP.physicalCollect.push(obj);
            _gD.put(obj, _gD.UG);
            obj.ax = (obj.x = pos.x);
            if (type == 2){
                obj.xVel = Math.round((4 + (Math.random() * 16)));
                obj.yVel = Math.round((2 + (Math.random() * -4)));
            }
            if (type == 1){
                obj.x = (obj.x + 1200);
                obj.ax = obj.x;
                obj.xVel = 23;
                obj.rota = true;
            }
            if (type == 3){
                obj.ay = (obj.y = _gP.ground);
            } else {
                obj.ay = (obj.y = pos.y);
            }
        }

    }
}
