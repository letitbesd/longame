package com.longame.utils
{
    import com.adobe.utils.DateUtil;
    import com.longame.model.consts.Colors;
    import com.longame.utils.debug.Logger;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    import flash.utils.Dictionary;
    
    public class StringParser
    {

        public static const STRING:String = "string";

        public static const NUMBER:String = "number";

        public static const BOOLEAN:String = "boolean";

        public static const ARRAY:String = "array";

        public static const DICTIONARY:String = "flash.utils::dictionary";

        public static const OBJECT:String = "object";

        public static const UINT:String = "uint";

        public static const RECTANGLE:String = "flash.geom::rectangle";

        public static const POINT:String = "flash.geom::point";

        public static const STYLE_SHEET:String = "flash.text::stylesheet";

        public static const URL_REQUEST:String = "flash.net::urlrequest";

        /**
         *
         */
        private static const FUNCTION_MAP:Object = new Object();
    {
        FUNCTION_MAP[BOOLEAN] = toBoolean,FUNCTION_MAP[ARRAY] = toArray,FUNCTION_MAP[DICTIONARY] = toDictionary,FUNCTION_MAP[OBJECT] = toObject,FUNCTION_MAP[RECTANGLE] = toRectangle,FUNCTION_MAP[POINT] = toPoint,FUNCTION_MAP[STYLE_SHEET] = toStyleSheet,FUNCTION_MAP[URL_REQUEST] = toUrlRequest;
    }

        /**
         * <p>This method allows you to register other functions to handle types
         * this utility is not set up to convert.</p>
         */
        public static function registerFunction(name:String, funct:Function):void
        {
            FUNCTION_MAP[name] = funct;
        }

        /**
         *
         */
        public static function removeFunction(name:String):void
        {
            delete FUNCTION_MAP[name];
        }

        /**
         * <p>This function handles converting the data into the supplied type.</p>
         *
         *    <p>This function also has a special default function call when
         *    unknown_type_handler is set. To use this supply a function to call
         *    when the helper class doesn't know what to convert the data to.</p>
         *
         *    <p>The unknown_type_handler should accept data and type. This allows
         *    you to customize the class and extend its functionality on the fly
         *    without having to directly extend and override the main switch logic.</p>
         *
         *    @param data String representing the value that needs to be
         *    converted.
         *    @param type String representing the type the data should be
         *    converted into. Accepts string, number, array, boolean, associate
         *    array, dictionary, object, color and hex color.
         *    @return Converted data typed to supplied type value.
         *
         */
        public static function getType(data:String, type:String):*
        {
            return FUNCTION_MAP[type] ? FUNCTION_MAP[type](data) : data;
        }
		/**
		 * <p>Converts a string into a uint. This function also supports converting
		 * colors into .</p>
		 * //todo
		 */
		public static function toUint(value:String):uint
		{
			// Check to see if it is a registered color
			if (Colors.has(value))
			{
				return Colors.getColor(value);
			}
			else
			{
				value = value.substr(-6, 6);
				var color:uint = Number("0x" + value);
				return color;
			}
		}
        /**
         * By default this method is set up to convert CSS style arrays delimited by ",",isNumber=true will return an Array in Number type;
         */
        public static function toArray(value:String,isNumber:Boolean=false, delimiter:String = ","):Array
        {
            var arr:Array= value.split(delimiter);
			if(!isNumber) return arr;
			var arr1:Array=[];
			var len:uint=arr.length;
			for(var i:int=0;i<len;i++){
				arr1[i]=Number(arr[i]);
			}
			return arr1;
        }
        /**
		 * 将形如  "Point('10','12')" 的字符串转成Point，一般不用之
		 * */
//        public static function splitTypeFromSource(value:String):Object
//        {
//            var obj:Object = new Object();
//            // Pattern to strip out ',", and ) from the string;
//            var pattern:RegExp = RegExp(/[\'\)\"]/g); // this fixes a color highlight issue in FDT --> '
//            // Fine type and source
//            var split:Array = value.split("(");
//            //
//            obj.type = split[0];
//            obj.source = split[1].replace(pattern, "");
//
//            return obj;
//        }

        /**
         *
         */
        public static function toDictionary(value:String):Dictionary
        {
            return toComplexArray(value, DICTIONARY);
        }

        public static function toObject(value:String):Object
        {
            return toComplexArray(value, OBJECT);
        }

        /**
         * <p>This function parses out a complex array and puts it into an Associate
         * Array, Dictionary, or Object. Use this function to split up the array base
         * on the dataDelimiter (default ",") and the propDelimiter (default ":").</p>
         *
         * <p>Example of a data: "up:play,over:playO,down:playO,off_up:pause,off_over:pauseO,off_down:pauseO"</p>
         *
         */
        protected static function toComplexArray(data:String, returnType:String, dataDelimiter:String = ",", propDelimiter:String = ":"):*
        {

            var dataContainer:*;

            // Determine what type of object to return
            switch (returnType)
            {
                case DICTIONARY:
                    dataContainer = new Dictionary();
                    break;
                case OBJECT:
                    dataContainer = {}
                    break;
                default:
                    dataContainer = [];
            }

            var list:Array = data.split(dataDelimiter);
            var total:Number = list.length;

            for (var i:Number = 0; i < total; i++)
            {
                var prop:Array = list[i].split(propDelimiter);
                dataContainer[prop[0]] = prop[1];
            }

            return dataContainer;
        }

        /**
         * <p>Converts a string to a boolean.</p>
         */
        public static function toBoolean(value:String):Boolean
        {
			if(value==null) return false;
			value=value.toLowerCase();
			if((value=="true")||(value=="yes")||(value=="on")||(value=="1")) return true;
			if((value=="false")||(value=="no")||(value=="off")||(value=="0"))return false;
			return value&&value.length;
        }

        /**
         * convert "1,2,3,4" style string to a Rectangle
         * @param value
         * @param delimiter
         * @return
         *
         */
        public static function toRectangle(value:String, delimiter:String = ","):Rectangle
        {
            var coords:Array =value.split(delimiter,4) ;//splitTypeFromSource(value).source.split(delimiter, 4);

            if ((value == "") || (coords.length != 4))
            {
                return null;
            }
            else
            {
                return new Rectangle(Number(coords[0]),Number(coords[1]), Number(coords[2]), Number(coords[3]));
            }
        }

        /**
         *
         * @param value
         * @param delimiter
         * @return
         *
         */
        public static function toPoint(value:String, delimiter:String = ","):Point
        {
            var coords:Array =value.split(delimiter,2);// splitTypeFromSource(value).source.split(delimiter, 2);
			var p:Point=new Point();
			if(coords[0]) p.x=Number(coords[0]);
			if(coords[1]) p.y=Number(coords[1]);
			return p;
        }
		public static function toVector3D(value:String, delimiter:String = ","):Vector3D
		{
			var coords:Array = value.split(delimiter,3);//splitTypeFromSource(value).source.split(delimiter, 2);
			var p:Vector3D=new Vector3D();
			if(coords[0]) p.x=Number(coords[0]);
			if(coords[1]) p.y=Number(coords[1]);
			if(coords[2]) p.z=Number(coords[2]);
			return p;
		}
        /**
         *
         * @param value
         * @return
         *
         */
        public static function toStyleSheet(value:String):StyleSheet
        {

            var styleSheet:StyleSheet = new StyleSheet();
            styleSheet.parseCSS(value);
            return styleSheet;
        }

        public static function toUrlRequest(value:String):URLRequest
        {
            return new URLRequest(value);//splitTypeFromSource(value).source);
        }
		public static function toDate(value:String):Date
		{
			return DateUtil.parseW3CDTF(value);
		}
		/**
		 * 将字符串解析到taret的key属性上，会自动根据target的key属性类型类进行解析
		 * */
		public static function toTarget(target:*,key:String,val:String):void
		{
			try{
				var p:* = target[key];
				if(p is int)
					target[key] =parseInt(val);
				else if(p is uint)
					target[key]= StringParser.toUint(val);
				else if (p is Number)
					target[key] =Number(val);
				else if (p is Boolean)
					target[key] =StringParser.toBoolean(val);
				else if (p is Array)
					target[key] = StringParser.toArray(val);
				else if(p is Point)
					target[key] = StringParser.toPoint(val);
				else if(p is Vector3D)
					target[key]= StringParser.toVector3D(val);
				else if (p is Dictionary)
					target[key]=StringParser.toDictionary(val);
				else if(p is Rectangle)
					target[key]=StringParser.toRectangle(val);
				else if(p is Date)
					target[key]=StringParser.toDate(val);
				else if((p is Object)&& !(p is String))
					target[key] =StringParser.toObject(val);
				else
					target[key]=val;
			}catch(e:Error){
//				Logger.warn("StringParser","toTarget","error when parse property"+key+","+e.message);
			}
		} 
    }
}

