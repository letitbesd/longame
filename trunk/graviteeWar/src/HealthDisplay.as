package 
{
    import flash.display.*;
    import flash.text.*;

    public class HealthDisplay extends Sprite
    {
        public var unitname:TextField;
        private var shown:Boolean = true;
        public var num:TextField;
        private var _colors:Array;

        public function HealthDisplay()
        {
			num = new TextField();
			num.width = 40;
			num.height = 20;
			var tf:TextFormat = new TextFormat();
			num.defaultTextFormat = tf;
			this.addChild(num);
			
            _colors = [0xff0000, 0x0099ff, 0x99cc00, 0xffcc00];
            shown = true;
        }

        public function hideHealth()
        {
            if (shown)
            {
                num.alpha = 0;
                shown = false;
            }
            return;
        }

        public function updateDisplay(healthNum:int, team:int)
        {
            num.text = healthNum.toString();
            num.textColor = _colors[team];
            return;
        }

        public function showHealth()
        {
            if (!shown)
            {
                num.alpha = 1;
                shown = true;
            }
            return;
        }

    }
}
