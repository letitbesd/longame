package com.funkypear.game
{
	import flash.display.DisplayObject;

    public class Cam extends Object
    {
        public var posX:Number = 0;
        public var posY:Number = 0;
        public var targetY:Number = 0;
        public var targetX:Number = 0;

        public function Cam()
        {
            posX = 0;
            posY = 0;
            targetX = 0;
            targetY = 0;
            return;
        }// end function

        public function setTarget(param1:DisplayObject, param2:int, param3:int, param4:int, param5:int)
        {
            if (param1)
            {
                if (param1.x < param2 || param1.x > param4)
                {
                    if (param1.x < param2)
                    {
                        targetX = 50 - param1.x;
                    }
                    else if (param1.x > param4)
                    {
                        targetX = 650 - param1.x;
                    }
                }
                else
                {
                    targetX = 350 - param1.x;
                    if (param1.x - param2 < 350)
                    {
                        targetX = 50 - param2;
                    }// end if
                    if (param4 - param1.x < 350)
                    {
                        targetX = 650 - param4;
                    }// end if
                }// end else if
                if (param1.y < param3 || param1.y > param5)
                {
                    if (param1.y < param3)
                    {
                        targetY = 50 - param1.y;
                    }
                    else if (param1.y > param5)
                    {
                        targetY = 450 - param1.y;
                    }// end else if
                }
                else
                {
                    targetY = 250 - param1.y;
                    if (param1.y - param3 < 250)
                    {
                        targetY = 50 - param3;
                    }// end if
                    if (param5 - param1.y < 250)
                    {
                        targetY = 450 - param5;
                    }// end if
                }// end if
            }// end else if
            return;
        }// end function

        public function doMove():void
        {
            posX = (posX + targetX) / 2;
            posY = (posY + targetY) / 2;
            return;
        }// end function

    }
}
