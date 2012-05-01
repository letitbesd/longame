//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.geom.*;

    public class objectGen {

        private static const lowestZone:Number = 200;

        public static function FGZ(_arg1:Boolean=true):Point{
            var _local3:int;
            var _local4:Number;
            var _local5:Number;
            var _local2:Number = _gD.camPoint.y;
            if (_g.P.yVel > 0){
                _local2 = (_local2 + _g.sh2);
            } else {
                _local2 = (_local2 - _g.sh2);
            };
            if (((((_local2 + (2 * _g.sh2)) > lowestZone)) && (_arg1))){
                _local2 = (100 - (2 * _g.sh2));
            };
            if (_g.P.xVel > 0){
                _local3 = 1;
                _local4 = 100;
            } else {
                _local3 = -1;
                _local4 = -100;
            };
            _local2 = (_local2 - (_g.sh2 * 2));
            _local2 = (_local2 + ((Math.random() * _g.sh2) * 4));
            if (_local3 == 1){
                _local5 = (_gD.camPoint.x - _g.sw2);
            } else {
                _local5 = (_gD.camPoint.x - (_g.sw2 * 3));
            };
            if ((((_local2 > (_gD.camPoint.y - (_g.sh2 + 100)))) && ((_local2 < (_gD.camPoint.y + (_g.sh2 + 100)))))){
                if (_local3 == 1){
                    _local5 = (_gD.camPoint.x + _g.sw2);
                };
                _local5 = (_local5 + (Math.random() * (_g.sw2 * 2)));
            } else {
                _local5 = (_local5 + (Math.random() * (_g.sw2 * 4)));
            };
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
        private static function findZoneEasy(_arg1:Boolean=false):Point{
            var _local2:Number;
            var _local3:Number;
            if (!_arg1){
                _local3 = (_gD.camPoint.x + 400);
            } else {
                _local3 = (250 + (Math.random() * 350));
            };
            if (_gD.camPoint.y < 0){
                _local2 = _gD.camPoint.y;
            } else {
                _local2 = 0;
            };
            if (!_arg1){
                _local2 = (_local2 + (-400 + (Math.random() * 800)));
            } else {
                _local2 = (_local2 + (Math.random() * 400));
            };
            return (new Point(_local3, _local2));
        }
        public static function generateCollect(_arg1:Boolean=false, _arg2:uint=0):void{
            var _local3:Point = findZoneEasy(_arg1);
            var _local4:CollectObject = new CollectObject(_arg2);
            _gP.physicalCollect.push(_local4);
            _gD.put(_local4, _gD.UG);
            _local4.ax = (_local4.x = _local3.x);
            if (_arg2 == 2){
                _local4.xVel = Math.round((4 + (Math.random() * 16)));
                _local4.yVel = Math.round((2 + (Math.random() * -4)));
            };
            if (_arg2 == 1){
                _local4.x = (_local4.x + 1200);
                _local4.ax = _local4.x;
                _local4.xVel = 23;
                _local4.rota = true;
            };
            if (_arg2 == 3){
                _local4.ay = (_local4.y = _gP.ground);
            } else {
                _local4.ay = (_local4.y = _local3.y);
            };
        }

    }
}//package 
