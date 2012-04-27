package com.longame.model.consts
{
	import flash.utils.Dictionary;

    /**
     * @author jessefreeman
     */
    public class Colors
    {
        /**
         * <p>Looks up the property type and confirms that it exists.</p>
         *
         * @param property
         */
        public static function has(colorName:String):Boolean
        {
            return (COLORS.hasOwnProperty(colorName));
        }

        /**
         *
         * @param name
         * @param value
         */
        public static function getColor(colorName:String):uint
        {
            return COLORS.hasOwnProperty(colorName) ? COLORS[colorName] : 0x000000;
        }

        public static function register(name:String, color:uint):void
        {
            COLORS[name] = color;
        }

        public static function unregister(name:String):void
        {
            delete COLORS[name];
        }

        private static const COLORS:Dictionary = new Dictionary();
    {
        COLORS["black"] = 0x000000;
        COLORS["blue"] = 0x0000FF;
        COLORS["green"] = 0x008000;
        COLORS["gray"] = 0x808080;
        COLORS["silver"] = 0xC0C0C0;
        COLORS["lime"] = 0x00FF00;
        COLORS["olive"] = 0x808000;
        COLORS["white"] = 0xFFFFFF;
        COLORS["yellow"] = 0xFFFF00;
        COLORS["maroon"] = 0x800000;
        COLORS["navy"] = 0x000080;
        COLORS["red"] = 0xFF0000;
        COLORS["purple"] = 0x800080;
        COLORS["teal"] = 0x008080;
        COLORS["fuchsia"] = 0xFF00FF;
        COLORS["aqua"] = 0x00FFFF;
        COLORS["magenta"] = 0xFF00FF;
        COLORS["cyan"] = 0x00FFFF;
    }


    }
}

