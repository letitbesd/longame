package {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;

    public class ToolTip extends Sprite {

        private static const offSetX:uint = 13;
        private static const offSetSize:uint = 190;

        private static var t_name:TextField = new TextField();
        private static var t_cost_m:TextField = new TextField();
        private static var t_cost_p:TextField = new TextField();
        private static var t_cost_e:TextField = new TextField();
        private static var t_desc:TextField = new TextField();
        private static var b_name:Sprite = new Sprite();
        private static var b_desc:Sprite = new Sprite();
        private static var tf:TextFormat = new TextFormat();
        private static var tf2:TextFormat = new TextFormat();
        private static var tipState:Boolean = false;
        private static var tip_t:TipObject;
        private static var tip_g:uint;
        private static var killTime:uint = 0;
        public static var errorTip:Boolean;
        private static var theStage:Stage;
        private static var theRoot:Object;
//        private static var FONT:ActionMan = new ActionMan();
        private static var T:Sprite = new Sprite();
        private static var osNum:Number = new Number();

        public function ToolTip(stage:Stage, root:Object):void{
            errorTip = false;
            theStage = stage;
            theRoot = root;
            filters = [new DropShadowFilter(3, 45, 0, 0.7, 4, 4, 1, 2)];
//            tf.font = FONT.fontName;
            tf.size = 18;
            tf.color = 0;
            tf.leftMargin = 2;
            tf.rightMargin = 2;
//            tf2.font = FONT.fontName;
            tf2.size = 18;
            tf2.color = 0x888888;
            tf2.leftMargin = 2;
            tf2.rightMargin = 2;
            T.addChild(b_name);
            T.addChild(b_desc);
            T.addChild(t_name);
            T.addChild(t_desc);
            addChild(T);
            t_name.text = "Name Plate";
            t_name.selectable = false;
            t_name.width = offSetSize;
            t_name.y = -15;
            b_name.y = -17;
//            t_name.embedFonts = true;
            t_name.autoSize = TextFieldAutoSize.LEFT;
            t_name.multiline = true;
            t_name.wordWrap = true;
            t_name.setTextFormat(tf);
            t_desc.text = "Text Plate";
            t_desc.selectable = false;
            t_desc.width = offSetSize;
//            t_desc.embedFonts = true;
            t_desc.autoSize = TextFieldAutoSize.LEFT;
            t_desc.multiline = true;
            t_desc.wordWrap = true;
            t_desc.setTextFormat(tf2);
            t_name.visible = false;
            t_desc.visible = false;
        }
        public function killEvents():void{
            theStage.removeEventListener(Event.ENTER_FRAME, cd_killTip);
        }

        public static function tip(_arg1:TipObject, _arg2:uint=0):void{
            var _local7:Array;
            tip_t = _arg1;
            tip_g = _arg2;
            tipState = true;
            theStage.addEventListener(Event.ENTER_FRAME, correctTip, false, 0, true);
            b_name.graphics.clear();
            b_desc.graphics.clear();
            b_name.graphics.lineStyle(1, 0);
            b_desc.graphics.lineStyle(1, 0);
            var _local3:String = GradientType.LINEAR;
            var _local4:Array = [100, 100];
            var _local5:String = SpreadMethod.PAD;
            var _local6:Array = [0, 0xFF];
            _local7 = [14148334, 0xFFFFFF];
            var _local8:Matrix = new Matrix();
            var _local9:Array = [1644829, 2302759];
            var _local10:Matrix = new Matrix();
            _local10.createGradientBox(5, 35, 1.57079633);
            b_desc.graphics.beginGradientFill(_local3, _local9, _local4, _local6, _local10, _local5);
            if (_arg2 == 1){
            } else {
                if (_arg1.tipName == null){
                    t_desc.setTextFormat(tf2);
                    t_desc.text = (t_desc.htmlText = _arg1.tipDesc);
                    b_desc.visible = true;
                    t_desc.visible = true;
                    b_desc.graphics.drawRect(0, 0, offSetSize, (t_desc.height + 4));
                    osNum = b_desc.height;
                    setOffset();
                    b_desc.y = b_name.y;
                    t_desc.y = (b_desc.y + 2);
                } else {
                    t_name.htmlText = _arg1.tipName;
                    t_desc.htmlText = _arg1.tipDesc;
                    t_name.setTextFormat(tf);
                    t_desc.setTextFormat(tf2);
                    t_name.visible = true;
                    b_name.visible = true;
                    t_desc.visible = true;
                    b_desc.visible = true;
                    _local8.createGradientBox(5, 20, 1.57079633);
                    b_name.graphics.beginGradientFill(_local3, _local7, _local4, _local6, _local8, _local5);
                    b_name.graphics.drawRect(0, 0, offSetSize, (t_name.height + 4));
                    b_desc.graphics.drawRect(0, 0, offSetSize, (t_desc.height + 4));
                    osNum = (b_name.height + b_desc.height);
                    setOffset();
                    b_desc.y = (b_name.y + b_name.height);
                    t_desc.y = (b_desc.y + 2);
                }
            }
        }
        public static function unTip():void{
            errorTip = false;
            tipState = true;
            t_name.visible = false;
            t_desc.visible = false;
            b_name.visible = false;
            b_desc.visible = false;
            b_name.graphics.clear();
            b_desc.graphics.clear();
            theStage.removeEventListener(Event.ENTER_FRAME, correctTip);
        }
        public static function giveError(_arg1:String, _arg2:String):void{
            var _local3:String;
            var _local4:Array;
            var _local5:String;
            var _local6:Array;
            var _local7:Array;
            var _local8:Matrix;
            var _local9:Array;
            var _local10:Matrix;
            if (t_name.visible){
                b_name.graphics.clear();
                b_desc.graphics.clear();
                b_name.graphics.lineStyle(1, 0);
                b_desc.graphics.lineStyle(1, 0);
                _local3 = GradientType.LINEAR;
                _local4 = [100, 100];
                _local5 = SpreadMethod.PAD;
                _local6 = [0, 0xFF];
                _local7 = [14148334, 0xFFFFFF];
                _local8 = new Matrix();
                _local9 = [1644829, 2302759];
                _local10 = new Matrix();
                _local10.createGradientBox(5, 35, 1.57079633);
                b_desc.graphics.beginGradientFill(_local3, _local9, _local4, _local6, _local10, _local5);
                errorTip = true;
                t_name.htmlText = _arg1;
                t_desc.htmlText = _arg2;
                t_name.setTextFormat(tf);
                t_desc.setTextFormat(tf2);
                t_name.visible = true;
                b_name.visible = true;
                t_desc.visible = true;
                b_desc.visible = true;
                _local8.createGradientBox(5, 20, 1.57079633);
                b_name.graphics.beginGradientFill(_local3, _local7, _local4, _local6, _local8, _local5);
                b_name.graphics.drawRect(0, 0, offSetSize, (t_name.height + 4));
                b_desc.graphics.drawRect(0, 0, offSetSize, (t_desc.height + 4));
                osNum = (b_name.height + b_desc.height);
                setOffset();
                b_desc.y = (b_name.y + b_name.height);
                t_desc.y = (b_desc.y + 2);
                theStage.addEventListener(Event.ENTER_FRAME, cd_killTip);
                killTime = 0;
            }
        }
        private static function cd_killTip(_arg1:Event):void{
            killTime++;
            if (killTime == 75){
                errorTip = false;
                theStage.removeEventListener(Event.ENTER_FRAME, cd_killTip);
                if (t_desc.visible){
                    tip(tip_t, tip_g);
                }
            }
        }
        private static function correctTip(_arg1:Event):void{
            setOffset();
        }
        public static function setOffset():void{
            if ((theStage.mouseY + osNum) > theStage.stageHeight){
                T.y = -((osNum - (theStage.stageHeight - theStage.mouseY)));
            } else {
                if (theStage.mouseY < 40){
                    T.y = 15;
                } else {
                    T.y = 0;
                }
            }
            if (theStage.mouseX > 520){
                T.x = -((offSetX + offSetSize));
            } else {
                T.x = offSetX;
            }
        }

    }
}
