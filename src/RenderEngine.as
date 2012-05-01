//Created by Action Script Viewer - http://www.buraks.com/asv
package {
    import flash.display.*;

    public class RenderEngine {

        public static var backBGRender:Array = [];
        public static var midBGRender:Array = [];
        public static var frontBGRender:Array = [];
        public static var planeRender:Array = [];
        public static var skyBG:Array = [];
        public static var cloudBG:Array = [];
        public static var spaceBG:Array = [];
        public static var particles:Array = [];

        public static function renderBGs():void{
            render(new _g_Space(), spaceBG);
            render(new _g_Mountain_London(), backBGRender, 1000, 378);
            render(new _g_Hill_London(), midBGRender, 1000, 170);
            render(new _g_Ground_London(), frontBGRender, 720, 84);
            render(new _g_Sky_London(), skyBG);
            render(new _g_Cloud_London(), cloudBG, 1000, 480);
            render(new _g_Mountain_Paris(), backBGRender, 1000, 378);
            render(new _g_Hill_Paris(), midBGRender, 1000, 170);
            render(new _g_Ground_Paris(), frontBGRender, 720, 84);
            render(new _g_Sky_Paris(), skyBG);
            render(new _g_Cloud_Paris(), cloudBG, 1000, 480);
            render(new _g_Mountain_Egypt(), backBGRender, 1000, 378);
            render(new _g_Hill_Egypt(), midBGRender, 1000, 170);
            render(new _g_Ground_Egypt(), frontBGRender, 720, 84);
            render(new _g_Sky_Egypt(), skyBG);
            render(new _g_Cloud_Egypt(), cloudBG, 1000, 480);
            render(new _g_Mountain_Africa(), backBGRender, 1000, 378);
            render(new _g_Hill_Africa(), midBGRender, 1000, 170);
            render(new _g_Ground_Africa(), frontBGRender, 720, 84);
            render(new _g_Sky_Africa(), skyBG);
            render(new _g_Cloud_Africa(), cloudBG, 1000, 480);
            render(new _g_Mountain_Japan(), backBGRender, 1000, 378);
            render(new _g_Hill_Japan(), midBGRender, 1000, 170);
            render(new _g_Ground_Japan(), frontBGRender, 720, 84);
            render(new _g_Sky_Japan(), skyBG);
            render(new _g_Cloud_Japan(), cloudBG, 1000, 480);
        }
        public static function renderAll():void{
            simpleStaticRender(new ParticleHolder(), particles);
        }
        public static function simpleStaticRender(_arg1, _arg2, _arg3:Number=0):void{
            var _local4:* = 0;
            while (_local4 < _arg1.numChildren) {
                render(_arg1.getChildAt(_local4), _arg2, _arg3, _arg3);
                _local4++;
            };
        }
        public static function renderPlane():void{
            planeRender = [];
            var _local1:MovieClip = new PRS_1();
        }
        private static function render(_arg1:DisplayObject=null, _arg2:Array=null, _arg3:Number=0, _arg4:Number=0):void{
            var _local6:Number;
            var _local7:Number;
            if (_arg3 == 0){
                _local6 = _arg1.height;
                _local7 = _arg1.width;
            } else {
                _local7 = _arg3;
                _local6 = _arg4;
            };
            var _local5:BitmapData = new BitmapData(_local7, _local6, true, 0);
            _local5.draw(_arg1);
            _arg2.push(_local5);
        }

    }
}//package 
