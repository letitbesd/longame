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
        public static function simpleStaticRender(container:DisplayObjectContainer, arr:Array, size:Number=0):void{
            var i:int = 0;
            while (i < container.numChildren) {
                render(container.getChildAt(i), arr, size, size);
                i++;
            }
        }
        public static function renderPlane():void{
            planeRender = [];
            var _local1:MovieClip = new PRS_1();
        }
        private static function render(target:DisplayObject=null, pool:Array=null, width:Number=0, height:Number=0):void{
            var h:Number;
            var w:Number;
            if (width == 0){
                h = target.height;
                w = target.width;
            } else {
                w = width;
                h = height;
            }
            var bmd:BitmapData = new BitmapData(w, h, true, 0);
            bmd.draw(target);
            pool.push(bmd);
        }

    }
}
